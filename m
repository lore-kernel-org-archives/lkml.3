Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936023AbaH0WXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 18:23:05 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:32892
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935942AbaH0WWE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 18:22:04 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, sitsofe@gmail.com, decui@microsoft.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH V2 5/5] Drivers: hv: vmbus: Fix a bug in vmbus_open()
Date: Wed, 27 Aug 2014 16:25:35 -0700
Message-Id: <1409181935-23295-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1409181935-23295-1-git-send-email-kys@microsoft.com>
References: <1409181905-23254-1-git-send-email-kys@microsoft.com>
 <1409181935-23295-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug in vmbus_open() and properly propagate the error. I would
like to thank Dexuan Cui <decui@microsoft.com> for identifying the
issue.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/hv/channel.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 9a6a2c3..19bad59 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -165,8 +165,10 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
 	ret = vmbus_post_msg(open_msg,
 			       sizeof(struct vmbus_channel_open_channel));
 
-	if (ret != 0)
+	if (ret != 0) {
+		err = ret;
 		goto error1;
+	}
 
 	t = wait_for_completion_timeout(&open_info->waitevent, 5*HZ);
 	if (t == 0) {
-- 
1.7.4.1

