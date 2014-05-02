Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaEBQFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:05:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44044 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaEBPnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:43:53 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rusty Russell <rusty@rustcorp.com.au>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 042/151] virtio_balloon: don't softlockup on huge balloon changes.
Date: Fri,  2 May 2014 08:37:10 -0700
Message-Id: <1399045139-4531-43-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/virtio/virtio_balloon.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 5c4a95b..5f8af50 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -310,6 +310,12 @@ static int balloon(void *_vballoon)
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

