Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755926Ab3H1VQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:16:27 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:48365
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755747Ab3H1VQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:16:25 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Do not attempt to negoatiate a new version prematurely
Date: Wed, 28 Aug 2013 14:56:54 -0700
Message-Id: <1377727014-21583-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code would attempt to negotiate a different protocol version if
the current negotiation timed out. This triggers an assert in the host (on debug
builds). Avoid this by negotiating a newer version only if the host properly
rejects the current version being negotiated.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/connection.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index ec3b8cd..8f4743a 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -195,7 +195,10 @@ int vmbus_connect(void)
 
 	do {
 		ret = vmbus_negotiate_version(msginfo, version);
-		if (ret == 0)
+		if (ret)
+			goto cleanup;
+
+		if (vmbus_connection.conn_state == CONNECTED)
 			break;
 
 		version = vmbus_get_next_version(version);
-- 
1.7.4.1

