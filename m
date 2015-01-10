Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143AbbAJGmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 01:42:40 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:60074
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbbAJGm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 01:42:27 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 5/6] Drivers: hv: vmbus: Fix a bug in vmbus_establish_gpadl()
Date: Fri,  9 Jan 2015 23:54:33 -0800
Message-Id: <1420876474-9205-5-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1420876474-9205-1-git-send-email-kys@microsoft.com>
References: <1420876440-9164-1-git-send-email-kys@microsoft.com>
 <1420876474-9205-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correctly compute the local (gpadl) handle.
I would like to thank Michael Brown <mcb30@ipxe.org> for seeing this bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reported-by: Michael Brown <mcb30@ipxe.org>
---
 drivers/hv/channel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 433f72a..c76ffbe 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -366,8 +366,8 @@ int vmbus_establish_gpadl(struct vmbus_channel *channel, void *kbuffer,
 	unsigned long flags;
 	int ret = 0;
 
-	next_gpadl_handle = atomic_read(&vmbus_connection.next_gpadl_handle);
-	atomic_inc(&vmbus_connection.next_gpadl_handle);
+	next_gpadl_handle =
+		(atomic_inc_return(&vmbus_connection.next_gpadl_handle) - 1);
 
 	ret = create_gpadl_header(kbuffer, size, &msginfo, &msgcount);
 	if (ret)
-- 
1.7.4.1

