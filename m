Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482AbaBNEca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:32:30 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48212 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbaBNEc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:32:27 -0500
Date: Thu, 13 Feb 2014 20:32:17 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-ef178f9238b142cc1020265e176b20d27fd02ba9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391846481-31491-13-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-13-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] Kbuild, lto: Handle basic LTO in modpost
Git-Commit-ID: ef178f9238b142cc1020265e176b20d27fd02ba9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 20:32:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef178f9238b142cc1020265e176b20d27fd02ba9
Gitweb:     http://git.kernel.org/tip/ef178f9238b142cc1020265e176b20d27fd02ba9
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 09:01:17 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 20:25:05 -0800

Kbuild, lto: Handle basic LTO in modpost

- Don't warn about LTO marker symbols. modpost runs before
the linker, so the module is not necessarily LTOed yet.
- Don't complain about .gnu.lto* sections

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391846481-31491-13-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 scripts/mod/modpost.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index f91dd45..63804a1 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -623,7 +623,10 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
 
 	switch (sym->st_shndx) {
 	case SHN_COMMON:
-		warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
+		if (!strncmp(symname, "__gnu_lto_", sizeof("__gnu_lto_")-1)) {
+			/* Should warn here, but modpost runs before the linker */
+		} else
+			warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
 		break;
 	case SHN_UNDEF:
 		/* undefined symbol */
@@ -849,6 +852,7 @@ static const char *section_white_list[] =
 	".xt.lit",         /* xtensa */
 	".arcextmap*",			/* arc */
 	".gnu.linkonce.arcext*",	/* arc : modules */
+	".gnu.lto*",
 	NULL
 };
 
