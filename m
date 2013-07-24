Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab3GXOKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:10:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45817 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752286Ab3GXOG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "Jason Wang" <jasowang@redhat.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.860741386@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [26/85] drivers: hv: switch to use mb() instead of smp_mb()
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit 35848f68b07df3f917cb13fc3c134718669f569b upstream.

Even if guest were compiled without SMP support, it could not assume that host
wasn't. So switch to use mb() instead of smp_mb() to force memory barriers for
UP guest.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2:
 - Drop changes to functions that don't exist here
 - hv_ringbuffer_write() has only a write memory barrier]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -383,7 +383,7 @@ int hv_ringbuffer_write(struct hv_ring_b
 					     sizeof(u64));
 
 	/* Make sure we flush all writes before updating the writeIndex */
-	smp_wmb();
+	wmb();
 
 	/* Now, update the write location */
 	hv_set_next_write_location(outring_info, next_write_location);
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -466,7 +466,7 @@ static void vmbus_on_msg_dpc(unsigned lo
 		 * will not deliver any more messages since there is
 		 * no empty slot
 		 */
-		smp_mb();
+		mb();
 
 		if (msg->header.message_flags.msg_pending) {
 			/*

