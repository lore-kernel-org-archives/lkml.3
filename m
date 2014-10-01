Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751477AbaJAMAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 08:00:14 -0400
Received: from ozlabs.org ([103.22.144.67]:32972 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbaJAMAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 08:00:12 -0400
In-Reply-To: <1412073306-13812-14-git-send-email-mikey@neuling.org>
To: Michael Neuling <mikey@neuling.org>, greg@kroah.com, arnd@arndb.de,
        mpe@ellerman.id.au, benh@kernel.crashing.org
From: Michael Ellerman <mpe@ellerman.id.au>
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 13/17] cxl: Add base builtin support
Message-Id: <20141001120010.A834E140170@ozlabs.org>
Date: Wed,  1 Oct 2014 22:00:10 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-30-09 at 10:35:02 UTC, Michael Neuling wrote:
> This also adds the cxl_ctx_in_use() function for use in the mm code to see if
> any cxl contexts are currently in use.  This is used by the tlbie() to
> determine if it can do local TLB invalidations or not.  This also adds get/put
> calls for the cxl driver module to refcount the active cxl contexts.

> diff --git a/drivers/misc/cxl/base.c b/drivers/misc/cxl/base.c
> new file mode 100644
> index 0000000..f4cbcfb
> --- /dev/null
> +++ b/drivers/misc/cxl/base.c
> @@ -0,0 +1,102 @@
> +/*
> + * Copyright 2014 IBM Corp.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version
> + * 2 of the License, or (at your option) any later version.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/rcupdate.h>
> +#include <asm/errno.h>
> +#include <misc/cxl.h>
> +#include "cxl.h"
> +
> +/* protected by rcu */
> +static struct cxl_calls *cxl_calls;
> +
> +static atomic_t use_count = ATOMIC_INIT(0);
...

> +void cxl_ctx_get(void)
> +{
> +	atomic_inc(&use_count);
> +}
> +EXPORT_SYMBOL(cxl_ctx_get);
> +
> +void cxl_ctx_put(void)
> +{
> +	atomic_dec(&use_count);
> +}
> +EXPORT_SYMBOL(cxl_ctx_put);
> +
> +bool cxl_ctx_in_use(void)
> +{
> +	return (atomic_read(&use_count) != 0);
> +}
> +EXPORT_SYMBOL(cxl_ctx_in_use);

So as written this results in a function call for every tlbie(), even when no
one has ever used a CAPI adapter, or when none are even in the machine.

I think the patch below is a better trade off. It makes the use_count global,
but that's not a biggy. The benefit is that the additional code in tlbie()
becomes:

	ld      r10,-29112(r2)
	lwz     r10,0(r10)
	cmpwi   cr7,r10,0

Which is about as good as it can get.

cheers


diff --git a/drivers/misc/cxl/base.c b/drivers/misc/cxl/base.c
index f4cbcfbd8dbc..4401d1c2dd33 100644
--- a/drivers/misc/cxl/base.c
+++ b/drivers/misc/cxl/base.c
@@ -16,7 +16,7 @@
 /* protected by rcu */
 static struct cxl_calls *cxl_calls;
 
-static atomic_t use_count = ATOMIC_INIT(0);
+atomic_t cxl_use_count = ATOMIC_INIT(0);
 
 #ifdef CONFIG_CXL_MODULE
 
@@ -65,24 +65,6 @@ void cxl_slbia(struct mm_struct *mm)
 }
 EXPORT_SYMBOL(cxl_slbia);
 
-void cxl_ctx_get(void)
-{
-	atomic_inc(&use_count);
-}
-EXPORT_SYMBOL(cxl_ctx_get);
-
-void cxl_ctx_put(void)
-{
-	atomic_dec(&use_count);
-}
-EXPORT_SYMBOL(cxl_ctx_put);
-
-bool cxl_ctx_in_use(void)
-{
-	return (atomic_read(&use_count) != 0);
-}
-EXPORT_SYMBOL(cxl_ctx_in_use);
-
 int register_cxl_calls(struct cxl_calls *calls)
 {
 	if (cxl_calls)
diff --git a/include/misc/cxl.h b/include/misc/cxl.h
index bde46a330881..6e43dca6a792 100644
--- a/include/misc/cxl.h
+++ b/include/misc/cxl.h
@@ -18,12 +18,24 @@ struct cxl_irq_ranges {
 };
 
 #ifdef CONFIG_CXL_BASE
+extern atomic_t cxl_use_count;
 
 void cxl_slbia(struct mm_struct *mm);
-void cxl_ctx_get(void);
-void cxl_ctx_put(void);
-bool cxl_ctx_in_use(void);
 
+static inline bool cxl_ctx_in_use(void)
+{
+	return (atomic_read(&cxl_use_count) != 0);
+}
+
+static inline void cxl_ctx_get(void)
+{
+	atomic_inc(&cxl_use_count);
+}
+
+static inline void cxl_ctx_put(void)
+{
+	atomic_dec(&cxl_use_count);
+}
 #else /* CONFIG_CXL_BASE */
 
 #define cxl_slbia(...) do { } while (0)
