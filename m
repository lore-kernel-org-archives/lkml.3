Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3K0Pjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:39:52 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:52206 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab3K0Pjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:39:51 -0500
Message-ID: <52961245.4010504@linaro.org>
Date: Wed, 27 Nov 2013 09:39:49 -0600
From: Alex Elder <alex.elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH RESEND AGAIN] clk: clean up everything on debugfs error
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Maybe the third time will be the charm. -Alex]

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
index 2cf2ea6..77fcd06 100644
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

