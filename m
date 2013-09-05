Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3IENd0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:33:26 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:46105 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab3IENdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:33:24 -0400
Message-ID: <52288824.1060905@linaro.org>
Date: Thu, 05 Sep 2013 08:33:24 -0500
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: only call get_parent if there is one
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In __clk_init(), after a clock is mostly initialized, a scan is done
of the orphan clocks to see if the clock being registered is the
parent of any of them.

This code assumes that any clock that provides a get_parent method
actually has at least one parent, and that's not a valid assumption.

As a result, an orphan clock with no parent can return *something*
as the parent index, and that value is blindly used to dereference
the orphan's parent_names[] array (which will be ZERO_SIZE_PTR or
NULL).

Fix this by ensuring get_parent is only called for orphans with at
least one parent.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/clk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 54a191c..ea8ff15 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1628,7 +1628,7 @@ int __clk_init(struct device *dev, struct clk *clk)
 	 * this clock
 	 */
 	hlist_for_each_entry_safe(orphan, tmp2, &clk_orphan_list, child_node) {
-		if (orphan->ops->get_parent) {
+		if (orphan->num_parents && orphan->ops->get_parent) {
 			i = orphan->ops->get_parent(orphan->hw);
 			if (!strcmp(clk->name, orphan->parent_names[i]))
 				__clk_reparent(orphan, clk);
-- 
1.7.9.5

