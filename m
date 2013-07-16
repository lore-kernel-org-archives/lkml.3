Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983Ab3GPUkW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 16:40:22 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:38760 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933952Ab3GPUkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 16:40:20 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Jean Delvare <jdelvare@suse.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 2/6] kconfig: avoid multiple calls to strlen
Date: Tue, 16 Jul 2013 22:39:58 +0200
Message-Id: <26e933e3c35624d80281330c4beb17db4cd4960f.1374006854.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1374006854.git.yann.morin.1998@free.fr>
References: <cover.1374006854.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1374006854.git.yann.morin.1998@free.fr>
References: <cover.1374006854.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Calls to strlen are costly, so avoid calling strln as much as we can.

Reported-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Jean Delvare <jdelvare@suse.de>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
---
 scripts/kconfig/symbol.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index d550300..020a0ac 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -967,7 +967,7 @@ static int sym_rel_comp( const void *sym1, const void *sym2 )
 {
 	struct sym_match *s1 = *(struct sym_match **)sym1;
 	struct sym_match *s2 = *(struct sym_match **)sym2;
-	int l1, l2;
+	int exact1, exact2;
 
 	/* Exact match:
 	 * - if matched length on symbol s1 is the length of that symbol,
@@ -978,11 +978,11 @@ static int sym_rel_comp( const void *sym1, const void *sym2 )
 	 * exactly; if this is the case, we can't decide which comes first,
 	 * and we fallback to sorting alphabetically.
 	 */
-	l1 = s1->eo - s1->so;
-	l2 = s2->eo - s2->so;
-	if (l1 == strlen(s1->sym->name) && l2 != strlen(s2->sym->name))
+	exact1 = (s1->eo - s1->so) == strlen(s1->sym->name);
+	exact2 = (s2->eo - s2->so) == strlen(s2->sym->name);
+	if (exact1 && !exact2)
 		return -1;
-	if (l1 != strlen(s1->sym->name) && l2 == strlen(s2->sym->name))
+	if (!exact1 && exact2)
 		return 1;
 
 	/* As a fallback, sort symbols alphabetically */
-- 
1.8.1.2

