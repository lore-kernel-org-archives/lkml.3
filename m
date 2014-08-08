Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371AbaHHU5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:57:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41492 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933214AbaHHUyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:54:18 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 088/259] Drivers: hv: vmbus: Fix a bug in the channel callback dispatch code
Date: Fri,  8 Aug 2014 13:38:31 -0700
Message-Id: <1407530482-4483-89-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hv/connection.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 05827ec..ce5a9f2 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -319,9 +319,13 @@ static void process_chn_event(u32 relid)
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

