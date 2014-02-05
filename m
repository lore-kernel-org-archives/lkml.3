Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755763AbaBEUvr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:51:47 -0500
Received: from mail1.windriver.com ([147.11.146.13]:48240 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744AbaBEUF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:05:58 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: T Makphaibulchoke <tmac@hp.com>, Paul Gortmaker <paul.gortmaker@gmail.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 092/213] kernel/resource.c: fix stack overflow in __reserve_region_with_split()
Date: Wed, 5 Feb 2014 15:00:47 -0500
Message-ID: <1391630568-49251-93-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: T Makphaibulchoke <tmac@hp.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/resource.c | 50 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 9c358e263534..bb76480a566f 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -613,6 +613,7 @@ static void __init __reserve_region_with_split(struct resource *root,
 	struct resource *parent = root;
 	struct resource *conflict;
 	struct resource *res = kzalloc(sizeof(*res), GFP_ATOMIC);
+	struct resource *next_res = NULL;
 
 	if (!res)
 		return;
@@ -622,21 +623,46 @@ static void __init __reserve_region_with_split(struct resource *root,
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
1.8.5.2

