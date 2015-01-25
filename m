Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbbAYTVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:21:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbbAYSJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michael Turquette <mturquette@linaro.org>
Subject: [PATCH 3.14 40/98] clk: Really fix deadlock with mmap_sem
Date: Sun, 25 Jan 2015 10:06:58 -0800
Message-Id: <20150125180714.619587755@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Boyd <sboyd@codeaurora.org>

commit 89f7e9de59bf3e3cda2e00de12c66db22675a7cf upstream.

Commit 6314b6796e3c (clk: Don't hold prepare_lock across debugfs
creation, 2014-09-04) forgot to update one place where we hold
the prepare_lock while creating debugfs directories. This means
we still have the chance of a deadlock that the commit was trying
to fix. Actually fix it by moving the debugfs creation outside
the prepare_lock.

Reported-by: Russell King <rmk+kernel@arm.linux.org.uk>
Fixes: 6314b6796e3c "clk: Don't hold prepare_lock across debugfs creation"
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Michael Turquette <mturquette@linaro.org>
[mturquette@linaro.org: removed lockdep_assert]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -230,7 +230,6 @@ static const struct file_operations clk_
 	.release	= single_release,
 };
 
-/* caller must hold prepare_lock */
 static int clk_debug_create_one(struct clk *clk, struct dentry *pdentry)
 {
 	struct dentry *d;
@@ -1902,7 +1901,6 @@ int __clk_init(struct device *dev, struc
 	else
 		clk->rate = 0;
 
-	clk_debug_register(clk);
 	/*
 	 * walk the list of orphan clocks and reparent any that are children of
 	 * this clock
@@ -1937,6 +1935,9 @@ int __clk_init(struct device *dev, struc
 out:
 	clk_prepare_unlock();
 
+	if (!ret)
+		clk_debug_register(clk);
+
 	return ret;
 }
 


