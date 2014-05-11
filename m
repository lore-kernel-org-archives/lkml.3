Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934300AbaEKTbv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:31:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932825AbaEKT0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:26:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Gopesh Kumar Chaudhary <gopchaud@in.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 3.4 05/22] virtio_balloon: dont softlockup on huge balloon changes.
Date: Sun, 11 May 2014 21:21:13 +0200
Message-Id: <20140511192104.479001331@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511192103.733723493@linuxfoundation.org>
References: <20140511192103.733723493@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/virtio/virtio_balloon.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -305,6 +305,12 @@ static int balloon(void *_vballoon)
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


