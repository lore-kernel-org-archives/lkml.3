Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbaDXLgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:36:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46447 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753670AbaDXIw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:52:59 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 045/182] virtio_balloon: don't softlockup on huge balloon changes.
Date: Thu, 24 Apr 2014 09:49:30 +0100
Message-Id: <1398329507-5911-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit 1f74ef0f2d7d692fcd615621e0e734c3e7771413 upstream.

When adding or removing 100G from a balloon:

    BUG: soft lockup - CPU#0 stuck for 22s! [vballoon:367]

We have a wait_event_interruptible(), but the condition is always true
(more ballooning to do) so we don't ever sleep.  We also have a
wait_event() for the host to ack, but that is also always true as QEMU
is synchronous for balloon operations.

Reported-by: Gopesh Kumar Chaudhary <gopchaud@in.ibm.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/virtio/virtio_balloon.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 1f572c0..cfda0a6 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -312,6 +312,12 @@ static int balloon(void *_vballoon)
 		else if (diff < 0)
 			leak_balloon(vb, -diff);
 		update_balloon_size(vb);
+
+		/*
+		 * For large balloon changes, we could spend a lot of time
+		 * and always have work to do.  Be nice if preempt disabled.
+		 */
+		cond_resched();
 	}
 	return 0;
 }
-- 
1.9.1

