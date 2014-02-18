Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912AbaBROZc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:25:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:65322 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084AbaBROZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:25:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="457418389"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 6/6] kbuild: Remove .dot postfixes in kallsyms
Date: Tue, 18 Feb 2014 15:24:30 +0100
Message-Id: <1392733470-8228-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392733470-8228-1-git-send-email-andi@firstfloor.org>
References: <1392733470-8228-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

For static and some LTO symbols gcc generates .XXXX postfixes.
Remove those from the kallsyms, as they are not useful to the user
and makes it much larger. This also avoids some issues with LTO.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/kallsyms.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 566e53e..94e0502 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -122,7 +122,7 @@ static int read_symbol_tr(const char *sym, unsigned long long addr)
 static int read_symbol(FILE *in, struct sym_entry *s)
 {
 	char str[500];
-	char *sym, stype;
+	char *sym, stype, *dot;
 	int rc;
 
 	rc = fscanf(in, "%llx %c %499s\n", &s->addr, &stype, str);
@@ -138,6 +138,11 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 		return -1;
 	}
 
+	/* Drop static .XXXX postfixes */
+	dot = strchr(str, '.');
+	if (dot)
+		*dot = 0;
+
 	sym = str;
 	/* skip prefix char */
 	if (symbol_prefix_char && str[0] == symbol_prefix_char)
-- 
1.8.5.2

