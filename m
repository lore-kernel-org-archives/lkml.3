Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab3GJSsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 14:48:45 -0400
Received: from a9-50.smtp-out.amazonses.com ([54.240.9.50]:52498 "EHLO
	a9-50.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754162Ab3GJSsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 14:48:43 -0400
Date: Wed, 10 Jul 2013 18:48:41 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@kernel.org>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the slab tree
In-Reply-To: <51DD06A9.4030605@kernel.org>
Message-ID: <0000013fc9e9f94b-e87067d6-0bb6-41b3-ae83-ed8f110f893f-000000@email.amazonses.com>
References: <20130710125654.dd36f8fb19588697226b99be@canb.auug.org.au> <51DD06A9.4030605@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.07.10-54.240.9.50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Jul 2013, Pekka Enberg wrote:
> Yes, it indeed interacts badly with kmemleak and tracing. I reverted the
> commit.

Here is the fix required. kmemleak.h is weird in that it cannot be
included at the top of slab.h due to its corresponding dependency on
slab.h. Bad situation. kmemleak.h itself should  include "slab.h"...

Why not fold  kmemleak.h into slab.h to avoid future surprises?



Subject: slabs: kmemleak.h needs to be included after constant definitions.

Kmemleak.h depends on the constant defs in slab.h. It was include before
them. Move the include further down.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/include/linux/slab.h
===================================================================
--- linux.orig/include/linux/slab.h	2013-07-10 13:43:36.186641776 -0500
+++ linux/include/linux/slab.h	2013-07-10 13:44:36.735730034 -0500
@@ -14,7 +14,6 @@
 #include <linux/gfp.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
-#include <linux/kmemleak.h>


 /*
@@ -97,6 +96,7 @@
 #define ZERO_OR_NULL_PTR(x) ((unsigned long)(x) <= \
 				(unsigned long)ZERO_SIZE_PTR)

+#include <linux/kmemleak.h>

 struct mem_cgroup;
 /*
