Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760920AbaCUQNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 12:13:45 -0400
Received: from relay3.sgi.com ([192.48.152.1]:54600 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751948AbaCUQNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 12:13:44 -0400
Date: Fri, 21 Mar 2014 11:13:42 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86/UV: Fix conditional in gru_exit
Message-ID: <20140321161342.GA17081@sgi.com>
References: <20140320203646.GA603@sgi.com>
 <20140321075549.GB23556@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140321075549.GB23556@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2014 at 08:55:49AM +0100, Ingo Molnar wrote:
> > -	if (!is_uv_system())
> > +	if (!is_uv_system() || (is_uvx_hub() && !is_uv2_hub()))
> >  		return;
> 
> Such an amalgation of three system specific conditionals is 
> disgusting, please at minimum factor out a helper routine so that such 
> mismatches cannot happen.
>
Agreed.  Here's a new patch.


Fix supported system conditional in gru_exit.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
---
 drivers/misc/sgi-gru/grufile.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux/drivers/misc/sgi-gru/grufile.c
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grufile.c
+++ linux/drivers/misc/sgi-gru/grufile.c
@@ -58,6 +58,10 @@ static int max_user_cbrs, max_user_dsr_b
 
 static struct miscdevice gru_miscdev;
 
+static int gru_unsupported(void)
+{
+	return !is_uv_system() || (is_uvx_hub() && !is_uv2_hub());
+}
 
 /*
  * gru_vma_close
@@ -518,7 +522,7 @@ static int __init gru_init(void)
 {
 	int ret;
 
-	if (!is_uv_system() || (is_uvx_hub() && !is_uv2_hub()))
+	if (gru_unsupported())
 		return 0;
 
 #if defined CONFIG_IA64
@@ -573,7 +577,7 @@ exit0:
 
 static void __exit gru_exit(void)
 {
-	if (!is_uv_system())
+	if (gru_unsupported())
 		return;
 
 	gru_teardown_tlb_irqs();
