Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756166Ab3IIXUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 19:20:21 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:33350 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755807Ab3IIXUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 19:20:19 -0400
Message-ID: <522E57B7.6010603@linaro.org>
Date: Mon, 09 Sep 2013 18:20:23 -0500
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] clk: clean up everything on debugfs error
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_COMMON_CLK_DEBUG is defined, clk_debug_create_one() is
called to populate a debugfs directory with a few entries that are
common for all clock types.

If an error happens after creating the first one debugfs_remove() is
called on the clock's directory.  The problem with this is that no
cleanup is done on the debugfs files already created in that
directory, so the directory never actually gets removed.   This
problem is silently ignored.

Fix this by calling debugfs_remove_recursive() instead.  Reset the
clk->dentry field to null afterward, to ensure it can't be mistaken
as a valid pointer.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/clk/clk.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 54a191c..727ae7b 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -272,7 +272,8 @@ static int clk_debug_create_one(struct clk *clk,
struct dentry *pdentry)
 	goto out;

 err_out:
-	debugfs_remove(clk->dentry);
+	debugfs_remove_recursive(clk->dentry);
+	clk->dentry = NULL;
 out:
 	return ret;
 }
-- 
1.7.9.5

