Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbaEEMxc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:53:32 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41015 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932292AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        stable@kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 19/50] virtio_balloon: don't softlockup on huge balloon changes.
Date: Mon,  5 May 2014 14:43:01 +0200
Message-Id: <fa8c40b770e8746d1f2e9737068e54098fc9e8dd.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1f74ef0f2d7d692fcd615621e0e734c3e7771413 upstream.

When adding or removing 100G from a balloon:

    BUG: soft lockup - CPU#0 stuck for 22s! [vballoon:367]

We have a wait_event_interruptible(), but the condition is always true
(more ballooning to do) so we don't ever sleep.  We also have a
wait_event() for the host to ack, but that is also always true as QEMU
is synchronous for balloon operations.

Reported-by: Gopesh Kumar Chaudhary <gopchaud@in.ibm.com>
Cc: stable@kernel.org
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/virtio/virtio_balloon.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 1f572c00a1be..cfda0a6c07a7 100644
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
1.9.2

