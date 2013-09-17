Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257Ab3IQXIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 19:08:31 -0400
Received: from nm6-vm6.access.bullet.mail.gq1.yahoo.com ([216.39.63.154]:35126
	"EHLO nm6-vm6.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754231Ab3IQXI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 19:08:29 -0400
X-Yahoo-Newman-Id: 697273.3357.bm@smtp117.sbc.mail.gq1.yahoo.com
X-Rocket-Received: from localhost.localdomain (danielfsantos@99.70.244.137 with )
        by smtp117.sbc.mail.gq1.yahoo.com with SMTP; 17 Sep 2013 23:08:28 +0000 UTC
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: sOTvZyEVM1mwWjCWgYzqeyf6.DBxU9mHDwSapnCkvpvMq68
 t60QXGcCIwRX.l5oFuLlQ06oP4Ld65dV8fu5xHJ7gU5cZN_wsx3P58B0mTH6
 .R7xD0t6tQp_lh.feEv1mMprn_zZ7a8HQPoNY6Dq_0KVLRJeLgn3Bdm3ZGOJ
 RBI.Ur6sk6iK4UOUGvrsPihQa1Ce0_KZAkJ184ipOWcAwXHh96ITEfMmtuF1
 kUd_w31VJRk_q8fN2QXGatWSWM3RYyjWad.aJJsq_2tO08Yau1cmZ23Dwn0l
 bHYvao6pEH2i7Ekb.YtCexjgqD0KtH1MrUmNBi5F1yyuagnaBy027EvaTGNH
 g92i.Oto69rRo8iGaCxYbXjfkrKOliu6PfjaEFad7BoDhPRYGu9StqXp5J7z
 nln5rbG8nMtvxZh4P72Y6FgmT_HP5K58ebluZ8iqlUw6lX81hzAJ0iiQUo1e
 lD4o5eNgpeJTNNgPzQ7Fuz1bRcrU2.voonX3Y.6FsuQoi2kYH5SsqGjvDIt.
 1mg4nMWsV2rHi8hGbUvWe84qGchNgUVx4lXu3qqxw7yJj.Ch4p5PxbB4lxWv
 OQo5bZu9S5weKmb94dukMqTUlPWMny4E900RhTao-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: danielfsantos@att.net
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        George Spelvin <linux@horizon.com>
Cc: Daniel Santos <daniel.santos@pobox.com>
Subject: [PATCH 3/5] Makefile: Generate error_strings.h
Date: Tue, 17 Sep 2013 18:08:35 -0500
Message-Id: <1379459317-13046-4-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
References: <1379459317-13046-1-git-send-email-daniel.santos@pobox.com>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an initial attempt and needs improvement.  Ideally,
error_strings.h should only be generated when STRERROR or STRERROR_NAME
are enabled. This implementation also fails to remake error_strings.h
when arch-specific dependencies change.  Also, I've noticed that this
implementation fails to output a message when it's running, so help with
this would be appreciated.

Signed-off-by: Daniel Santos <daniel.santos@pobox.com>
---
 Makefile | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index 8243a23..38049ca 100644
--- a/Makefile
+++ b/Makefile
@@ -835,7 +835,7 @@ endif
 prepare2: prepare3 outputmakefile asm-generic
 
 prepare1: prepare2 $(version_h) include/generated/utsrelease.h \
-                   include/config/auto.conf
+                   include/config/auto.conf include/generated/error_strings.h
 	$(cmd_crmodverdir)
 
 archprepare: archheaders archscripts prepare1 scripts_basic
@@ -873,6 +873,13 @@ $(version_h): $(srctree)/Makefile FORCE
 include/generated/utsrelease.h: include/config/kernel.release FORCE
 	$(call filechk,utsrelease.h)
 
+include/generated/error_strings.h: include/uapi/asm-generic/errno-base.h \
+				   include/uapi/asm-generic/errno.h \
+				   include/uapi/linux/errno.h \
+				   include/linux/errno.h
+	$(shell ARCH=$(ARCH) $(srctree)/scripts/mkstrerror.sh \
+			> $(srctree)/include/generated/error_strings.h)
+
 PHONY += headerdep
 headerdep:
 	$(Q)find $(srctree)/include/ -name '*.h' | xargs --max-args 1 \
-- 
1.8.1.5

