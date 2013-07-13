Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab3GMSJG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 14:09:06 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:61456 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758233Ab3GMSIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 14:08:38 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Jean Delvare <jdelvare@suse.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 2/3] kconfig: avoid multiple calls to strlen
Date: Sat, 13 Jul 2013 20:08:24 +0200
Message-Id: <1373738905-23396-3-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373738905-23396-1-git-send-email-yann.morin.1998@free.fr>
References: <1373738905-23396-1-git-send-email-yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

Calls to strlen are costly, so avoid calling strln as much as we can.

Reported-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Jean Delvare <jdelvare@suse.de>
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

