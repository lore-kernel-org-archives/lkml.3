Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934503Ab3BSTFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:05:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54364 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934239Ab3BSSwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:52:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: T Makphaibulchoke <tmac@hp.com>, Paul Gortmaker <paul.gortmaker@gmail.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 41/81] kernel/resource.c: fix stack overflow in __reserve_region_with_split()
Date: Tue, 19 Feb 2013 15:49:04 -0300
Message-Id: <1361299784-8830-42-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: T Makphaibulchoke <tmac@hp.com>

commit 4965f5667f36a95b41cda6638875bc992bd7d18b upstream.

Using a recursive call add a non-conflicting region in
__reserve_region_with_split() could result in a stack overflow in the case
that the recursive calls are too deep.  Convert the recursive calls to an
iterative loop to avoid the problem.

Tested on a machine containing 135 regions.  The kernel no longer panicked
with stack overflow.

Also tested with code arbitrarily adding regions with no conflict,
embedding two consecutive conflicts and embedding two non-consecutive
conflicts.

Signed-off-by: T Makphaibulchoke <tmac@hp.com>
Reviewed-by: Ram Pai <linuxram@us.ibm.com>
Cc: Paul Gortmaker <paul.gortmaker@gmail.com>
Cc: Wei Yang <weiyang@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/resource.c |   50 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index e1d2b8e..7de982e 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -758,6 +758,7 @@ static void __init __reserve_region_with_split(struct resource *root,
 	struct resource *parent = root;
 	struct resource *conflict;
 	struct resource *res = kzalloc(sizeof(*res), GFP_ATOMIC);
+	struct resource *next_res = NULL;
 
 	if (!res)
 		return;
@@ -767,21 +768,46 @@ static void __init __reserve_region_with_split(struct resource *root,
 	res->end = end;
 	res->flags = IORESOURCE_BUSY;
 
-	conflict = __request_resource(parent, res);
-	if (!conflict)
-		return;
+	while (1) {
 
-	/* failed, split and try again */
-	kfree(res);
+		conflict = __request_resource(parent, res);
+		if (!conflict) {
+			if (!next_res)
+				break;
+			res = next_res;
+			next_res = NULL;
+			continue;
+		}
 
-	/* conflict covered whole area */
-	if (conflict->start <= start && conflict->end >= end)
-		return;
+		/* conflict covered whole area */
+		if (conflict->start <= res->start &&
+				conflict->end >= res->end) {
+			kfree(res);
+			WARN_ON(next_res);
+			break;
+		}
+
+		/* failed, split and try again */
+		if (conflict->start > res->start) {
+			end = res->end;
+			res->end = conflict->start - 1;
+			if (conflict->end < end) {
+				next_res = kzalloc(sizeof(*next_res),
+						GFP_ATOMIC);
+				if (!next_res) {
+					kfree(res);
+					break;
+				}
+				next_res->name = name;
+				next_res->start = conflict->end + 1;
+				next_res->end = end;
+				next_res->flags = IORESOURCE_BUSY;
+			}
+		} else {
+			res->start = conflict->end + 1;
+		}
+	}
 
-	if (conflict->start > start)
-		__reserve_region_with_split(root, start, conflict->start-1, name);
-	if (conflict->end < end)
-		__reserve_region_with_split(root, conflict->end+1, end, name);
 }
 
 void __init reserve_region_with_split(struct resource *root,
-- 
1.7.9.5

