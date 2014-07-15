Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbaGORM0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:12:26 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:60427 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754AbaGORCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:15 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 55/94] Drivers: hv: vmbus: Fix a bug in the channel callback dispatch code
Date: Tue, 15 Jul 2014 20:01:10 +0300
Message-Id: <1405443709-15288-55-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

Starting with Win8, we have implemented several optimizations to improve the
scalability and performance of the VMBUS transport between the Host and the
Guest. Some of the non-performance critical services cannot leverage these
optimization since they only read and process one message at a time.
Make adjustments to the callback dispatch code to account for the way
non-performance critical drivers handle reading of the channel.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/hv/connection.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index e84f452..ae22e3c 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -339,9 +339,13 @@ static void process_chn_event(u32 relid)
 		 */
 
 		do {
-			hv_begin_read(&channel->inbound);
+			if (read_state)
+				hv_begin_read(&channel->inbound);
 			channel->onchannel_callback(arg);
-			bytes_to_read = hv_end_read(&channel->inbound);
+			if (read_state)
+				bytes_to_read = hv_end_read(&channel->inbound);
+			else
+				bytes_to_read = 0;
 		} while (read_state && (bytes_to_read != 0));
 	} else {
 		pr_err("no channel callback for relid - %u\n", relid);
-- 
1.7.10.4

