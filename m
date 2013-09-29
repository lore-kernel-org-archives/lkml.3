Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396Ab3I2Ajb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 20:39:31 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:63580 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab3I2AjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 20:39:01 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 3/3] clk: Correct lookup logic in clk_fetch_parent_index()
Date: Sun, 29 Sep 2013 02:37:16 +0200
Message-Id: <1380415036-15997-3-git-send-email-tomasz.figa@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1380415036-15997-1-git-send-email-tomasz.figa@gmail.com>
References: <1380415036-15997-1-git-send-email-tomasz.figa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is supposed to iterate over all parents of given child
clock to find the index of given parent clock in its parent list,
using parent cache if possible and falling back to string compare
otherwise. However currently the logic falls back to string compare in
every iteration in which clock cache entry does not match given parent,
due to wrong check conditions.

This patch corrects the logic to continue the loop if parent cache entry
is present and does not match requested parent clock. In addition,
redundant checks for parent cache array presence are removed, because it
is always allocated in the beginning of the function.

Signed-off-by: Tomasz Figa <tomasz.figa@gmail.com>
---
 drivers/clk/clk.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 63f9ac1..32e2fed 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1097,11 +1097,14 @@ static int clk_fetch_parent_index(struct clk *clk, struct clk *parent)
 	 * them now to avoid future calls to __clk_lookup.
 	 */
 	for (i = 0; i < clk->num_parents; i++) {
-		if (clk->parents && clk->parents[i] == parent)
+		if (clk->parents[i] == parent)
 			return i;
-		else if (!strcmp(clk->parent_names[i], parent->name)) {
-			if (clk->parents)
-				clk->parents[i] = __clk_lookup(parent->name);
+
+		if (clk->parents[i])
+			continue;
+
+		if (!strcmp(clk->parent_names[i], parent->name)) {
+			clk->parents[i] = __clk_lookup(parent->name);
 			return i;
 		}
 	}
-- 
1.8.3.2

