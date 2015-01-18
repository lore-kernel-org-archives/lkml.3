Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbbARQzv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 11:55:51 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48166 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141AbbARQzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 11:55:48 -0500
Message-ID: <1421600146.2080.8.camel@HansenPartnership.com>
Subject: module: fix module_refcount() return when running in a module exit
 routine
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Date: Sun, 18 Jan 2015 08:55:46 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <JBottomley@Parallels.com>

After e513cc1 module: Remove stop_machine from module unloading,
module_refcount() is returning (unsigned long)-1 when called from within
a routine that runs in module_exit.  This is confusing the scsi device
put code which is coded to detect a module_refcount() of zero for
running within a module exit routine and not try to do another
module_put.  The fix is to restore the original behaviour of
module_refcount() and return zero if we're running inside an exit
routine.

Fixes: e513cc1c07e2ab93a4514eec9833e031df3e30bb
Reported-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>

---

diff --git a/kernel/module.c b/kernel/module.c
index 3965511..c33a113 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -774,7 +774,12 @@ static int try_stop_module(struct module *mod, int flags, int *forced)
 
 unsigned long module_refcount(struct module *mod)
 {
-	return (unsigned long)atomic_read(&mod->refcnt) - MODULE_REF_BASE;
+	unsigned long ret = atomic_read(&mod->refcnt);
+
+	if (ret == 0)
+		/* ref is already zero (probably in module exit) */
+		return 0;
+	return ret - MODULE_REF_BASE;
 }
 EXPORT_SYMBOL(module_refcount);
 


