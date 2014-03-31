Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbaCaPXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:23:24 -0400
Received: from relay1.sgi.com ([192.48.179.29]:33989 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130AbaCaPXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:23:21 -0400
Date: Mon, 31 Mar 2014 10:23:20 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86/UV: Fix conditional in gru_exit
Message-ID: <20140331152320.GA31495@sgi.com>
References: <20140320203646.GA603@sgi.com>
 <20140321075549.GB23556@gmail.com>
 <20140321161342.GA17081@sgi.com>
 <20140331072505.GA2004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140331072505.GA2004@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 09:25:05AM +0200, Ingo Molnar wrote:
> * Dimitri Sivanich <sivanich@sgi.com> wrote:
> 
> > +static int gru_unsupported(void)
> > +{
> > +	return !is_uv_system() || (is_uvx_hub() && !is_uv2_hub());
> > +}
> 
> So the usual pattern is to introduce simple patterns, without logic 
> operations in their name. I.e. "gru_supported()" would be more natural 
> than "gru_not_supported()" or gru_unsupported()".
>

OK.  Here's a revised version.



Fix supported system conditional in gru_exit.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 drivers/misc/sgi-gru/grufile.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c
+++ linux/drivers/misc/sgi-gru/grufile.c
@@ -6,7 +6,7 @@
  * This file supports the user system call for file open, close, mmap, etc.
  * This also incudes the driver initialization code.
  *
- *  Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+ *  Copyright (c) 2008-2014 Silicon Graphics, Inc.  All Rights Reserved.
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -58,6 +58,11 @@ static int max_user_cbrs, max_user_dsr_b
 
 static struct miscdevice gru_miscdev;
 
+static int gru_supported(void)
+{
+	return is_uv_system() &&
+		(uv_hub_info->hub_revision < UV3_HUB_REVISION_BASE);
+}
 
 /*
  * gru_vma_close
@@ -518,7 +523,7 @@ static int __init gru_init(void)
 {
 	int ret;
 
-	if (!is_uv_system() || (is_uvx_hub() && !is_uv2_hub()))
+	if (!gru_supported())
 		return 0;
 
 #if defined CONFIG_IA64
@@ -573,7 +578,7 @@ exit0:
 
 static void __exit gru_exit(void)
 {
-	if (!is_uv_system())
+	if (!gru_supported())
 		return;
 
 	gru_teardown_tlb_irqs();
