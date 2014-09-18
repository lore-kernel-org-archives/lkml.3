Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbaIRMjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 08:39:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449AbaIRMiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 08:38:20 -0400
From: Amos Kong <akong@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org, herbert@gondor.apana.org.au, m@bues.ch,
        mpm@selenic.com, amit.shah@redhat.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/6] hw_random: fix unregister race.
Date: Thu, 18 Sep 2014 20:37:45 +0800
Message-Id: <1411043867-21109-5-git-send-email-akong@redhat.com>
In-Reply-To: <1411043867-21109-1-git-send-email-akong@redhat.com>
References: <1411043867-21109-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

The previous patch added one potential problem: we can still be
reading from a hwrng when it's unregistered.  Add a wait for zero
in the hwrng_unregister path.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 drivers/char/hw_random/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index ee9e504..9f6f5bb 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -60,6 +60,7 @@ static DEFINE_MUTEX(rng_mutex);
 static DEFINE_MUTEX(reading_mutex);
 static int data_avail;
 static u8 *rng_buffer, *rng_fillbuf;
+static DECLARE_WAIT_QUEUE_HEAD(rng_done);
 static unsigned short current_quality;
 static unsigned short default_quality; /* = 0; default to "off" */
 
@@ -98,6 +99,7 @@ static inline void cleanup_rng(struct kref *kref)
 
 	if (rng->cleanup)
 		rng->cleanup(rng);
+	wake_up_all(&rng_done);
 }
 
 static void set_current_rng(struct hwrng *rng)
-- 
1.9.3

