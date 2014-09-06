Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbaIEXZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 19:25:09 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:48103
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbaIEXZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 19:25:07 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 1/1] Drivers: hv: vmbus: Enable interrupt driven flow control
Date: Fri,  5 Sep 2014 17:29:12 -0700
Message-Id: <1409963352-2193-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In win8 we have a feature that allows for interrupt driven flow management
for host/guest communication. For instance, if the host were blocked because
there was no space available in the ringbuffer, the host could request that the
guest send an interrupt when space becomes available in the ringbuffer (when
the guest drains the ringbuffer).

While this feature was implemented in the guest a while ago, we had not
advertised that the guest supported this feature. This patch advertises
the support to the host.

For pre-win8 hosts, this has no effect since the size of the ringbuffer
control structure has not changed and all changes have been backward
compatible - unused/reserved space has been used to implement this
feature.

In this version of the patch I have cleaned up the commit log based on
feedback from Greg KH.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/ring_buffer.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/hv/ring_buffer.c b/drivers/hv/ring_buffer.c
index 15db66b..6361d12 100644
--- a/drivers/hv/ring_buffer.c
+++ b/drivers/hv/ring_buffer.c
@@ -361,6 +361,11 @@ int hv_ringbuffer_init(struct hv_ring_buffer_info *ring_info,
 	ring_info->ring_buffer->read_index =
 		ring_info->ring_buffer->write_index = 0;
 
+	/*
+	 * Set the feature bit for enabling flow control.
+	 */
+	ring_info->ring_buffer->feature_bits.value = 1;
+
 	ring_info->ring_size = buflen;
 	ring_info->ring_datasize = buflen - sizeof(struct hv_ring_buffer);
 
-- 
1.7.4.1

