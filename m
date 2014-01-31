Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932782AbaAaRcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:32:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55181 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932460AbaAaRco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:32:44 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 07/14] md/raid10: fix bug when raid10 recovery fails to recover a block.
Date: Fri, 31 Jan 2014 09:32:10 -0800
Message-Id: <1391189537-20777-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391189537-20777-1-git-send-email-kamal@canonical.com>
References: <1391189537-20777-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.17 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit e8b849158508565e0cd6bc80061124afc5879160 upstream.

commit e875ecea266a543e643b19e44cf472f1412708f9
    md/raid10 record bad blocks as needed during recovery.

added code to the "cannot recover this block" path to record a bad
block rather than fail the whole recovery.
Unfortunately this new case was placed *after* r10bio was freed rather
than *before*, yet it still uses r10bio.
This is will crash with a null dereference.

So move the freeing of r10bio down where it is safe.

Fixes: e875ecea266a543e643b19e44cf472f1412708f9
Reported-by: Damian Nowak <spam@nowaker.net>
URL: https://bugzilla.kernel.org/show_bug.cgi?id=68181
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid10.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4b4e094..dfd6eba 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3153,10 +3153,6 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 			if (j == conf->copies) {
 				/* Cannot recover, so abort the recovery or
 				 * record a bad block */
-				put_buf(r10_bio);
-				if (rb2)
-					atomic_dec(&rb2->remaining);
-				r10_bio = rb2;
 				if (any_working) {
 					/* problem is that there are bad blocks
 					 * on other device(s)
@@ -3188,6 +3184,10 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 					mirror->recovery_disabled
 						= mddev->recovery_disabled;
 				}
+				put_buf(r10_bio);
+				if (rb2)
+					atomic_dec(&rb2->remaining);
+				r10_bio = rb2;
 				break;
 			}
 		}
-- 
1.8.3.2

