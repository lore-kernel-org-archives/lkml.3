Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbaBNEbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:31:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48183 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbaBNEbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:31:42 -0500
Date: Thu, 13 Feb 2014 20:31:31 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-7d02b490e93c199a15b3c4bce1c393588c1300ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391846481-31491-8-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-8-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] Kbuild, lto:
  Drop .number postfixes in modpost
Git-Commit-ID: 7d02b490e93c199a15b3c4bce1c393588c1300ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 20:31:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7d02b490e93c199a15b3c4bce1c393588c1300ca
Gitweb:     http://git.kernel.org/tip/7d02b490e93c199a15b3c4bce1c393588c1300ca
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 09:01:12 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 20:24:58 -0800

Kbuild, lto: Drop .number postfixes in modpost

LTO turns all global symbols effectively into statics. This
has the side effect that they all have a .NUMBER postfix to make
them unique. In modpost drop this postfix because it confuses
it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391846481-31491-8-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 scripts/mod/modpost.c | 15 ++++++++++++++-
 scripts/mod/modpost.h |  2 +-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 1f1b154..f91dd45 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1684,6 +1684,19 @@ static void check_sec_ref(struct module *mod, const char *modname,
 	}
 }
 
+static char *remove_dot(char *s)
+{
+	char *end;
+	int n = strcspn(s, ".");
+
+	if (n > 0 && s[n] != 0) {
+		strtoul(s + n + 1, &end, 10);
+		if  (end > s + n + 1 && (*end == '.' || *end == 0))
+			s[n] = 0;
+	}
+	return s;
+}
+
 static void read_symbols(char *modname)
 {
 	const char *symname;
@@ -1722,7 +1735,7 @@ static void read_symbols(char *modname)
 	}
 
 	for (sym = info.symtab_start; sym < info.symtab_stop; sym++) {
-		symname = info.strtab + sym->st_name;
+		symname = remove_dot(info.strtab + sym->st_name);
 
 		handle_modversions(mod, &info, sym, symname);
 		handle_moddevtable(mod, &info, sym, symname);
diff --git a/scripts/mod/modpost.h b/scripts/mod/modpost.h
index 51207e4..168b43d 100644
--- a/scripts/mod/modpost.h
+++ b/scripts/mod/modpost.h
@@ -127,7 +127,7 @@ struct elf_info {
 	Elf_Section  export_gpl_sec;
 	Elf_Section  export_unused_gpl_sec;
 	Elf_Section  export_gpl_future_sec;
-	const char   *strtab;
+	char         *strtab;
 	char	     *modinfo;
 	unsigned int modinfo_len;
 
