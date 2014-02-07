Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108AbaBGNVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:21:18 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41486 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291AbaBGLsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:09 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 024/233] md/raid5: Fix possible confusion when multiple write errors occur.
Date: Fri,  7 Feb 2014 11:44:03 +0000
Message-Id: <1391773652-25214-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 1cc03eb93245e63b0b7a7832165efdc52e25b4e6 upstream.

commit 5d8c71f9e5fbdd95650be00294d238e27a363b5c
    md: raid5 crash during degradation

Fixed a crash in an overly simplistic way which could leave
R5_WriteError or R5_MadeGood set in the stripe cache for devices
for which it is no longer relevant.
When those devices are removed and spares added the flags are still
set and can cause incorrect behaviour.

commit 14a75d3e07c784c004b4b44b34af996b8e4ac453
    md/raid5: preferentially read from replacement device if possible.

Fixed the same bug if a more effective way, so we can now revert
the original commit.

Reported-and-tested-by: Alexander Lyakas <alex.bolshoy@gmail.com>
Fixes: 5d8c71f9e5fbdd95650be00294d238e27a363b5c
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/md/raid5.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index d825059..dce8be8 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3391,7 +3391,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 			 */
 			set_bit(R5_Insync, &dev->flags);
 
-		if (rdev && test_bit(R5_WriteError, &dev->flags)) {
+		if (test_bit(R5_WriteError, &dev->flags)) {
 			/* This flag does not apply to '.replacement'
 			 * only to .rdev, so make sure to check that*/
 			struct md_rdev *rdev2 = rcu_dereference(
@@ -3404,7 +3404,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
 			} else
 				clear_bit(R5_WriteError, &dev->flags);
 		}
-		if (rdev && test_bit(R5_MadeGood, &dev->flags)) {
+		if (test_bit(R5_MadeGood, &dev->flags)) {
 			/* This flag does not apply to '.replacement'
 			 * only to .rdev, so make sure to check that*/
 			struct md_rdev *rdev2 = rcu_dereference(
-- 
1.8.3.2

