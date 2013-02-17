Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab3BQW6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:58:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45828 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756388Ab3BQWzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:45 -0500
Message-Id: <20130217225006.283437239@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:41 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, T Makphaibulchoke <tmac@hp.com>,
        Ram Pai <linuxram@us.ibm.com>,
        Paul Gortmaker <paul.gortmaker@gmail.com>,
        Wei Yang <weiyang@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 40/66] kernel/resource.c: fix stack overflow in
 __reserve_region_with_split()
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/resource.c |   50 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 38 insertions(+), 12 deletions(-)

diff --git a/kernel/resource.c b/kernel/resource.c
index 34d4588..73f35d4 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -763,6 +763,7 @@ static void __init __reserve_region_with_split(struct resource *root,
 	struct resource *parent = root;
 	struct resource *conflict;
 	struct resource *res = kzalloc(sizeof(*res), GFP_ATOMIC);
+	struct resource *next_res = NULL;
 
 	if (!res)
 		return;
@@ -772,21 +773,46 @@ static void __init __reserve_region_with_split(struct resource *root,
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


