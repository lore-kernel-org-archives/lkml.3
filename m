Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbaBNVTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:19:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:52266 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752739AbaBNVR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:17:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,847,1384329600"; 
   d="scan'208";a="475471039"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 3/6] kbuild: Don't include const variable in kallsyms with !KALLSYMS_ALL
Date: Fri, 14 Feb 2014 22:17:06 +0100
Message-Id: <1392412629-25666-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392412629-25666-1-git-send-email-andi@firstfloor.org>
References: <1392412629-25666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

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

