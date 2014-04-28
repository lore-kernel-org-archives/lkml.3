Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaD1BbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:31:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43022 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796AbaD1B3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:22 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Gopesh Kumar Chaudhary" <gopchaud@in.ibm.com>,
        "Rusty Russell" <rusty@rustcorp.com.au>
Date: Mon, 28 Apr 2014 02:11:22 +0100
Message-ID: <lsq.1398647482.719686308@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 46/94] virtio_balloon: don't softlockup on huge
 balloon changes.
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/virtio/virtio_balloon.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -271,6 +271,12 @@ static int balloon(void *_vballoon)
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

