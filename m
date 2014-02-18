Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaBROg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:36:57 -0500
Received: from mga02.intel.com ([134.134.136.20]:5554 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755996AbaBRO3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:29:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="457420300"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 09/20] Kbuild, lto: Drop .number postfixes in modpost
Date: Tue, 18 Feb 2014 15:28:47 +0100
Message-Id: <1392733738-8290-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
References: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

LTO turns all global symbols effectively into statics. This
has the side effect that they all have a .NUMBER postfix to make
them unique. In modpost drop this postfix because it confuses
it.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/mod/modpost.c | 15 ++++++++++++++-
 scripts/mod/modpost.h |  2 +-
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index bd06857..d0fc656 100644
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
 
-- 
1.8.5.2

