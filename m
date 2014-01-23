Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbaAWTQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:16:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35025 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaAWTGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:06:32 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.12 22/27] md/raid5: Fix possible confusion when multiple write errors occur.
Date: Thu, 23 Jan 2014 11:06:59 -0800
Message-Id: <20140123190650.971999366@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123190648.720195687@linuxfoundation.org>
References: <20140123190648.720195687@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3502,7 +3502,7 @@ static void analyse_stripe(struct stripe
 			 */
 			set_bit(R5_Insync, &dev->flags);
 
-		if (rdev && test_bit(R5_WriteError, &dev->flags)) {
+		if (test_bit(R5_WriteError, &dev->flags)) {
 			/* This flag does not apply to '.replacement'
 			 * only to .rdev, so make sure to check that*/
 			struct md_rdev *rdev2 = rcu_dereference(
@@ -3515,7 +3515,7 @@ static void analyse_stripe(struct stripe
 			} else
 				clear_bit(R5_WriteError, &dev->flags);
 		}
-		if (rdev && test_bit(R5_MadeGood, &dev->flags)) {
+		if (test_bit(R5_MadeGood, &dev->flags)) {
 			/* This flag does not apply to '.replacement'
 			 * only to .rdev, so make sure to check that*/
 			struct md_rdev *rdev2 = rcu_dereference(


