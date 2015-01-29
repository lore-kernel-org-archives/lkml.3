Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbbA2JtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:49:12 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:53061
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325AbbA2JtG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:49:06 -0500
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, kys@microsoft.com
Cc: haiyangz@microsoft.com
Subject: [PATCH 1/3] hv: hv_util: move vmbus_open() to a later place
Date: Thu, 29 Jan 2015 03:02:27 -0800
Message-Id: <1422529347-28192-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before the line vmbus_open() returns, srv->util_cb can be already running
and the variablies, like util_fw_version, are needed by the srv->util_cb.

So we have to make sure the variables are initialized before the vmbus_open().

CC: "K. Y. Srinivasan" <kys@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/hv/hv_util.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 3b9c9ef..c5be773 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -340,12 +340,8 @@ static int util_probe(struct hv_device *dev,
 
 	set_channel_read_state(dev->channel, false);
 
-	ret = vmbus_open(dev->channel, 4 * PAGE_SIZE, 4 * PAGE_SIZE, NULL, 0,
-			srv->util_cb, dev->channel);
-	if (ret)
-		goto error;
-
 	hv_set_drvdata(dev, srv);
+
 	/*
 	 * Based on the host; initialize the framework and
 	 * service version numbers we will negotiate.
@@ -365,6 +361,11 @@ static int util_probe(struct hv_device *dev,
 		hb_srv_version = HB_VERSION;
 	}
 
+	ret = vmbus_open(dev->channel, 4 * PAGE_SIZE, 4 * PAGE_SIZE, NULL, 0,
+			srv->util_cb, dev->channel);
+	if (ret)
+		goto error;
+
 	return 0;
 
 error:
-- 
1.9.1

