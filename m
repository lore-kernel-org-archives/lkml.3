Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaBHHw1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:52:27 -0500
Received: from mga01.intel.com ([192.55.52.88]:63847 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaBHHv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:51:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="477987218"
From: Andi Kleen <ak@linux.intel.com>
To: mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 6/6] kbuild: Remove .dot postfixes in kallsyms
Date: Sat,  8 Feb 2014 08:50:40 +0100
Message-Id: <1391845840-28514-6-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391845840-28514-1-git-send-email-ak@linux.intel.com>
References: <1391845840-28514-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For static and some LTO symbols gcc generates .XXXX postfixes.
Remove those from the kallsyms, as they are not useful to the user
and makes it much larger. This also avoids some issues with LTO.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/kallsyms.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index c874304..d0e2b56 100644
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

