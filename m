Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab3HPWk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:40:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51839 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023Ab3HPWkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:40:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: NeilBrown <neilb@suse.de>, Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 031/133] md/raid10: remove use-after-free bug.
Date: Fri, 16 Aug 2013 15:32:53 -0700
Message-Id: <1376692475-28413-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376692475-28413-1-git-send-email-kamal@canonical.com>
References: <1376692475-28413-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 0eb25bb027a100f5a9df8991f2f628e7d851bc1e upstream.

We always need to be careful when calling generic_make_request, as it
can start a chain of events which might free something that we are
using.

Here is one place I wasn't careful enough.  If the wbio2 is not in
use, then it might get freed at the first generic_make_request call.
So perform all necessary tests first.

This bug was introduced in 3.3-rc3 (24afd80d99) and can cause an
oops, so fix is suitable for any -stable since then.

Signed-off-by: NeilBrown <neilb@suse.de>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/md/raid10.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7187dbd..92858ab 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2221,12 +2221,18 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	d = r10_bio->devs[1].devnum;
 	wbio = r10_bio->devs[1].bio;
 	wbio2 = r10_bio->devs[1].repl_bio;
+	/* Need to test wbio2->bi_end_io before we call
+	 * generic_make_request as if the former is NULL,
+	 * the latter is free to free wbio2.
+	 */
+	if (wbio2 && !wbio2->bi_end_io)
+		wbio2 = NULL;
 	if (wbio->bi_end_io) {
 		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
 		md_sync_acct(conf->mirrors[d].rdev->bdev, wbio->bi_size >> 9);
 		generic_make_request(wbio);
 	}
-	if (wbio2 && wbio2->bi_end_io) {
+	if (wbio2) {
 		atomic_inc(&conf->mirrors[d].replacement->nr_pending);
 		md_sync_acct(conf->mirrors[d].replacement->bdev,
 			     wbio2->bi_size >> 9);
-- 
1.8.1.2

