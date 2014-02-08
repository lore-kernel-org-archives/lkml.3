Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaBHHvc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 02:51:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:13482 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaBHHv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 02:51:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="480008251"
From: Andi Kleen <ak@linux.intel.com>
To: mmarek@suse.cz
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/6] kbuild: Don't include const variable in kallsyms with !KALLSYMS_ALL
Date: Sat,  8 Feb 2014 08:50:37 +0100
Message-Id: <1391845840-28514-3-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391845840-28514-1-git-send-email-ak@linux.intel.com>
References: <1391845840-28514-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

const variables are put into the text segment, so !KALLSYMS_ALL
includes them into the kallsyms section. Remove them to make
the kallsyms smaller. This also avoids some problems with LTO.
The way LTO generates the first pass kallsyms cannot handle
variables currently, so if we don't filter them out the
first and second level pass differ too much.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/kallsyms.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index ceef756..d79027e 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -151,6 +151,11 @@ static int read_symbol(FILE *in, struct sym_entry *s)
 	/* exclude debugging symbols */
 	else if (stype == 'N')
 		return -1;
+	/* Don't include const symbols in the text section
+	 * unless --all-symbols is specified.
+	 */
+	else if (toupper(stype) != 'T' && !all_symbols)
+		return -1;
 
 	/* include the type field in the symbol name, so that it gets
 	 * compressed together */
-- 
1.8.5.2

