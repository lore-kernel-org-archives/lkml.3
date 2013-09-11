Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab3IKFVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:21:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13847 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3IKE53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:29 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=xj2iYR5zRmMA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=4IVwp-sJ0kEA:10 a=VwQbUJbxAAAA:8 a=CZFccM69sVItBrhf7NQA:9 a=0kPLrQdw3YYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042909.118010453@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:28:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
Subject: [101/251] md/raid10: remove use-after-free bug.
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0101-md-raid10-remove-use-after-free-bug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 0eb25bb027a100f5a9df8991f2f628e7d851bc1e ]

We always need to be careful when calling generic_make_request, as it
can start a chain of events which might free something that we are
using.

Here is one place I wasn't careful enough.  If the wbio2 is not in
use, then it might get freed at the first generic_make_request call.
So perform all necessary tests first.

This bug was introduced in 3.3-rc3 (24afd80d99) and can cause an
oops, so fix is suitable for any -stable since then.

Cc: stable@vger.kernel.org (3.3+)
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/md/raid10.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e2d5778..f40decb 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2155,12 +2155,18 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
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
1.7.10.4


