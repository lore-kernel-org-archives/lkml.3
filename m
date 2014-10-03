Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228AbaJCWSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:18:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758058AbaJCWQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:16:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tero Kristo <t-kristo@ti.com>, Nishanth Menon <nm@ti.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 3.14 234/238] clk: prevent erronous parsing of children during rate change
Date: Fri,  3 Oct 2014 14:32:29 -0700
Message-Id: <20141003212921.152130552@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tero Kristo <t-kristo@ti.com>

commit 067bb1741c27c8d3b74ac98c0b8fc12b31e67005 upstream.

In some cases, clocks can switch their parent with clk_set_rate, for
example clk_mux can do this in some cases. Current implementation of
clk_change_rate uses un-safe list iteration on the clock children, which
will cause wrong clocks to be parsed in case any of the clock children
change their parents during the change rate operation. Fixed by using
the safe list iterator instead.

The problem was detected due to some divide by zero errors generated
by clock init on dra7-evm board, see discussion under
http://article.gmane.org/gmane.linux.ports.arm.kernel/349180 for details.

Fixes: 71472c0c06cf ("clk: add support for clock reparent on set_rate")
Signed-off-by: Tero Kristo <t-kristo@ti.com>
Reported-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -1487,6 +1487,7 @@ static struct clk *clk_propagate_rate_ch
 static void clk_change_rate(struct clk *clk)
 {
 	struct clk *child;
+	struct hlist_node *tmp;
 	unsigned long old_rate;
 	unsigned long best_parent_rate = 0;
 	bool skip_set_rate = false;
@@ -1525,7 +1526,11 @@ static void clk_change_rate(struct clk *
 	if (clk->notifier_count && old_rate != clk->rate)
 		__clk_notify(clk, POST_RATE_CHANGE, old_rate, clk->rate);
 
-	hlist_for_each_entry(child, &clk->children, child_node) {
+	/*
+	 * Use safe iteration, as change_rate can actually swap parents
+	 * for certain clock types.
+	 */
+	hlist_for_each_entry_safe(child, tmp, &clk->children, child_node) {
 		/* Skip children who will be reparented to another clock */
 		if (child->new_parent && child->new_parent != clk)
 			continue;


