Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbaIOQD5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:03:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3412 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754044AbaIOQDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:03:55 -0400
From: Amos Kong <akong@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org, herbert@gondor.apana.org.au, m@bues.ch, mb@bu3sch.de,
        mpm@selenic.com, rusty@rustcorp.com.au, amit.shah@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] virtio-rng cleanup: move some code out of mutex protection
Date: Tue, 16 Sep 2014 00:02:27 +0800
Message-Id: <1410796949-2221-2-git-send-email-akong@redhat.com>
In-Reply-To: <1410796949-2221-1-git-send-email-akong@redhat.com>
References: <1410796949-2221-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It doesn't save too much cpu time as expected, just a cleanup.

Signed-off-by: Amos Kong <akong@redhat.com>
---
 drivers/char/hw_random/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index aa30a25..c591d7e 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -270,8 +270,8 @@ static ssize_t hwrng_attr_current_show(struct device *dev,
 		return -ERESTARTSYS;
 	if (current_rng)
 		name = current_rng->name;
-	ret = snprintf(buf, PAGE_SIZE, "%s\n", name);
 	mutex_unlock(&rng_mutex);
+	ret = snprintf(buf, PAGE_SIZE, "%s\n", name);
 
 	return ret;
 }
@@ -284,19 +284,19 @@ static ssize_t hwrng_attr_available_show(struct device *dev,
 	ssize_t ret = 0;
 	struct hwrng *rng;
 
+	buf[0] = '\0';
 	err = mutex_lock_interruptible(&rng_mutex);
 	if (err)
 		return -ERESTARTSYS;
-	buf[0] = '\0';
 	list_for_each_entry(rng, &rng_list, list) {
 		strncat(buf, rng->name, PAGE_SIZE - ret - 1);
 		ret += strlen(rng->name);
 		strncat(buf, " ", PAGE_SIZE - ret - 1);
 		ret++;
 	}
+	mutex_unlock(&rng_mutex);
 	strncat(buf, "\n", PAGE_SIZE - ret - 1);
 	ret++;
-	mutex_unlock(&rng_mutex);
 
 	return ret;
 }
-- 
1.9.3

