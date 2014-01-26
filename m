Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbaAZDG3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 22:06:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbaAZDEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 22:04:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Damian Nowak <spam@nowaker.net>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.4 08/12] md/raid10: fix bug when raid10 recovery fails to recover a block.
Date: Sat, 25 Jan 2014 19:05:11 -0800
Message-Id: <20140126030452.561407193@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2943,10 +2943,6 @@ static sector_t sync_request(struct mdde
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
@@ -2978,6 +2974,10 @@ static sector_t sync_request(struct mdde
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


