Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758722Ab3APKOq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 05:14:46 -0500
Received: from csamuel.org ([74.50.50.137]:51061 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758365Ab3APKOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 05:14:42 -0500
Message-ID: <50F67D75.9080508@csamuel.org>
Date: Wed, 16 Jan 2013 21:14:13 +1100
From: Chris Samuel <chris@csamuel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        dhowells@redhat.com, Josh Boyer <jwboyer@gmail.com>
Subject: [PATCH] MODSIGN: Warn when module signature checking fails
Content-Type: multipart/mixed;
 boundary="------------010700070607010007060900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010700070607010007060900
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

/* Please CC me, I'm not on LKML */

* Reworked from the original patch based on feedback from Josh Boyer
* (putting the code in load_module()) and Rusty Russel (use
* KERN_NOTICE).  Extended to cover the other failure modes.

Currently if a signature check fails on module load for any reason no
feedback is given, except if the failure is due to either not having
the appropriate key or the signature is missing (both -ENOKEY) *and*
we are not doing strict checking (module.sig_enforce is not set). In
that situation only a contextless kernel taint message appears:

Disabling lock debugging due to kernel taint

This patch:

a) Reports the reason why a module has failed to load (either one of
    the explicit failures or an error propagated back from the crypto
    infrastructure) if it is going to be a hard failure (err is set).

b) causes a single warning to be emitted to explain why the kernel
    is being tainted, before the above taint warning is output, when
    the error is -ENOKEY (implicit in err=0 and sig_ok not being true)
    and module.sig_enforce is not set.

Found whilst trying to work out why all the 3.8 development kernels
I was building and testing were warning about taints and why all modules
were listed as forced load (F) in /proc/modules.

It would be really nice to be able to work out what the name of the
module is, but that doesn't appear to be possible from the information
load_module() has access to, plus my kernel-fu is not great.

Signed-off-by: Christopher Samuel <chris@csamuel.org>
---
  kernel/module.c |   21 +++++++++++++++++++--
  1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 250092c..ec789d3 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -3099,8 +3099,23 @@ static int load_module(struct load_info *info, 
const char __user *uargs,
  	long err;
   	err = module_sig_check(info);
-	if (err)
+	if (err) {
+		switch (err) {
+		case -EBADMSG:
+			printk(KERN_NOTICE "Module verification failed: module signature 
corrupt or unrecognised - not loading\n");
+			break;
+		case -ENOPKG:
+			printk(KERN_NOTICE "Module verification failed: requisite algorithm 
unavailable - not loading\n");
+			break;
+		case -ENOKEY:
+			printk(KERN_NOTICE "Module verification failed: signature and/or 
required key missing - not loading\n");
+			break;
+		default:
+			printk(KERN_NOTICE "Module verification failed: supporting code 
reported failure %ld - not loading\n",err);
+			break;
+		}
  		goto free_copy;
+	}
   	err = elf_header_check(info);
  	if (err)
@@ -3115,8 +3130,10 @@ static int load_module(struct load_info *info, 
const char __user *uargs,
   #ifdef CONFIG_MODULE_SIG
  	mod->sig_ok = info->sig_ok;
-	if (!mod->sig_ok)
+	if (!mod->sig_ok) {
+		printk_once(KERN_NOTICE "Module verification failed: signature and/or 
required key missing - tainting kernel\n");
  		add_taint_module(mod, TAINT_FORCED_MODULE);
+	}
  #endif
   	/* Now module is in final location, initialize linked lists, etc. */
-- 
1.7.10.4


--------------010700070607010007060900
Content-Type: text/plain; charset=UTF-8;
 name="Attached Message Part"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="Attached Message Part"


--------------010700070607010007060900--
