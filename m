Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab3LBTwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:52:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39483 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab3LBTSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jianpeng Ma <majianpeng@gmail.com>, NeilBrown <neilb@suse.de>
Subject: [PATCH 3.12 145/212] raid5: Use slow_path to release stripe when mddev->thread is null
Date: Mon,  2 Dec 2013 11:15:36 -0800
Message-Id: <20131202191303.386631971@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit ad4068de49862b083ac2a15bc50689bb30ce3e44 upstream.

When release_stripe() is called in grow_one_stripe(), the
mddev->thread is null. So it will omit one wakeup this thread to
release stripe.
For this condition, use slow_path to release stripe.

Bug was introduced in 3.12

Fixes: 773ca82fa1ee58dd1bf88b
Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/raid5.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -340,7 +340,8 @@ static void release_stripe(struct stripe
 	unsigned long flags;
 	bool wakeup;
 
-	if (test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
+	if (unlikely(!conf->mddev->thread) ||
+		test_and_set_bit(STRIPE_ON_RELEASE_LIST, &sh->state))
 		goto slow_path;
 	wakeup = llist_add(&sh->release_list, &conf->released_stripes);
 	if (wakeup)


