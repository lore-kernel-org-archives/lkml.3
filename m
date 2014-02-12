Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324AbaBLI2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:28:31 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50203 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752080AbaBLIOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:14:03 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Damian Nowak" <spam@nowaker.net>,
        "NeilBrown" <neilb@suse.de>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.381492409@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 70/79] md/raid10: fix bug when raid10 recovery fails
 to recover a block.
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/md/raid10.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2563,10 +2563,6 @@ static sector_t sync_request(struct mdde
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
@@ -2590,6 +2586,10 @@ static sector_t sync_request(struct mdde
 					conf->mirrors[i].recovery_disabled
 						= mddev->recovery_disabled;
 				}
+				put_buf(r10_bio);
+				if (rb2)
+					atomic_dec(&rb2->remaining);
+				r10_bio = rb2;
 				break;
 			}
 		}

