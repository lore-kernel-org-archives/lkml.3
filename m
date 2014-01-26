Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901AbaAZDEn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 22:04:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52736 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaAZDEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 22:04:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.4 10/12] md/raid5: Fix possible confusion when multiple write errors occur.
Date: Sat, 25 Jan 2014 19:05:13 -0800
Message-Id: <20140126030452.735480357@linuxfoundation.org>
X-Mailer: git-send-email 1.9.rc0.19.gb594c97
In-Reply-To: <20140126030451.934281002@linuxfoundation.org>
References: <20140126030451.934281002@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -3238,7 +3238,7 @@ static void analyse_stripe(struct stripe
 			 */
 			set_bit(R5_Insync, &dev->flags);
 
-		if (rdev && test_bit(R5_WriteError, &dev->flags)) {
+		if (test_bit(R5_WriteError, &dev->flags)) {
 			/* This flag does not apply to '.replacement'
 			 * only to .rdev, so make sure to check that*/
 			struct md_rdev *rdev2 = rcu_dereference(
@@ -3251,7 +3251,7 @@ static void analyse_stripe(struct stripe
 			} else
 				clear_bit(R5_WriteError, &dev->flags);
 		}
-		if (rdev && test_bit(R5_MadeGood, &dev->flags)) {
+		if (test_bit(R5_MadeGood, &dev->flags)) {
 			/* This flag does not apply to '.replacement'
 			 * only to .rdev, so make sure to check that*/
 			struct md_rdev *rdev2 = rcu_dereference(


