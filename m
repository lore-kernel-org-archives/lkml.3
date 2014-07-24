Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935009AbaGXJyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:54:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55183 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934812AbaGXJtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:49:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 114/128] Drivers: hv: vmbus: Fix a bug in the channel callback dispatch code
Date: Thu, 24 Jul 2014 10:46:03 +0100
Message-Id: <1406195177-8656-115-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit affb1aff300ddee54df307812b38f166e8a865ef upstream.

Starting with Win8, we have implemented several optimizations to improve the
scalability and performance of the VMBUS transport between the Host and the
Guest. Some of the non-performance critical services cannot leverage these
optimization since they only read and process one message at a time.
Make adjustments to the callback dispatch code to account for the way
non-performance critical drivers handle reading of the channel.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hv/connection.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 8e8522d85509..f4ebce7a897e 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -317,9 +317,13 @@ static void process_chn_event(u32 relid)
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
1.9.1

