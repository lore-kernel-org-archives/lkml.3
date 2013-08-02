Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab3HBKT3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:19:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37735 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab3HBKTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:19:25 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [ 32/39] md/raid10: remove use-after-free bug.
Date: Fri,  2 Aug 2013 18:18:42 +0800
Message-Id: <20130802101501.306574019@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802101456.800497005@linuxfoundation.org>
References: <20130802101456.800497005@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid10.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2029,12 +2029,18 @@ static void recovery_request_write(struc
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


