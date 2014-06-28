Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbaF1Svp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:51:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53319 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755123AbaF1RtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:49:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.14 034/110] idr: fix overflow bug during maximum ID calculation at maximum height
Date: Sat, 28 Jun 2014 10:46:31 -0700
Message-Id: <20140628174547.210444031@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

commit 3afb69cb5572b3c8c898c00880803cf1a49852c4 upstream.

idr_replace() open-codes the logic to calculate the maximum valid ID
given the height of the idr tree; unfortunately, the open-coded logic
doesn't account for the fact that the top layer may have unused slots
and over-shifts the limit to zero when the tree is at its maximum
height.

The following test code shows it fails to replace the value for
id=((1<<27)+42):

  static void test5(void)
  {
        int id;
        DEFINE_IDR(test_idr);
  #define TEST5_START ((1<<27)+42) /* use the highest layer */

        printk(KERN_INFO "Start test5\n");
        id = idr_alloc(&test_idr, (void *)1, TEST5_START, 0, GFP_KERNEL);
        BUG_ON(id != TEST5_START);
        TEST_BUG_ON(idr_replace(&test_idr, (void *)2, TEST5_START) != (void *)1);
        idr_destroy(&test_idr);
        printk(KERN_INFO "End of test5\n");
  }

Fix the bug by using idr_max() which correctly takes into account the
maximum allowed shift.

sub_alloc() shares the same problem and may incorrectly fail with
-EAGAIN; however, this bug doesn't affect correct operation because
idr_get_empty_slot(), which already uses idr_max(), retries with the
increased @id in such cases.

[tj@kernel.org: Updated patch description.]
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 lib/idr.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/lib/idr.c
+++ b/lib/idr.c
@@ -250,7 +250,7 @@ static int sub_alloc(struct idr *idp, in
 			id = (id | ((1 << (IDR_BITS * l)) - 1)) + 1;
 
 			/* if already at the top layer, we need to grow */
-			if (id >= 1 << (idp->layers * IDR_BITS)) {
+			if (id > idr_max(idp->layers)) {
 				*starting_id = id;
 				return -EAGAIN;
 			}
@@ -827,12 +827,10 @@ void *idr_replace(struct idr *idp, void
 	if (!p)
 		return ERR_PTR(-EINVAL);
 
-	n = (p->layer+1) * IDR_BITS;
-
-	if (id >= (1 << n))
+	if (id > idr_max(p->layer + 1))
 		return ERR_PTR(-EINVAL);
 
-	n -= IDR_BITS;
+	n = p->layer * IDR_BITS;
 	while ((n > 0) && p) {
 		p = p->ary[(id >> n) & IDR_MASK];
 		n -= IDR_BITS;


