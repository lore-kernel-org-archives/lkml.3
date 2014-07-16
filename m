Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934484AbaGPF76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 01:59:58 -0400
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:53154
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934442AbaGPF74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 01:59:56 -0400
x-originating-ip: 72.167.245.219
From: Dexuan Cui <decui@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com
Cc: kys@microsoft.com, haiyangz@microsoft.com
Subject: [PATCH] Drivers: hv: hv_fcopy: fix a race condition for SMP guest
Date: Wed, 16 Jul 2014 00:00:45 -0700
Message-Id: <1405494045-11548-1-git-send-email-decui@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should schedule the 5s "timer work" before starting the data transfer,
otherwise, the data transfer code may finish so fast on another
virtual cpu that when the code(fcopy_write()) trying to cancel the 5s
"timer work" can occasionally fail because the "timer work" may haven't
been scheduled yet and as a result the fcopy process will be aborted
wrongly by fcopy_work_func() in 5s.

Thank Liz Zhang <lizzha@microsoft.com> for the initial investigation
on the bug.

This addresses https://bugzilla.redhat.com/show_bug.cgi?id=1118123

Tested-by: Liz Zhang <lizzha@microsoft.com>
Cc: K. Y. Srinivasan <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 drivers/hv/hv_fcopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hv/hv_fcopy.c b/drivers/hv/hv_fcopy.c
index eaaa3d8..23b2ce2 100644
--- a/drivers/hv/hv_fcopy.c
+++ b/drivers/hv/hv_fcopy.c
@@ -246,8 +246,8 @@ void hv_fcopy_onchannelcallback(void *context)
 		/*
 		 * Send the information to the user-level daemon.
 		 */
-		fcopy_send_data();
 		schedule_delayed_work(&fcopy_work, 5*HZ);
+		fcopy_send_data();
 		return;
 	}
 	icmsghdr->icflags = ICMSGHDRFLAG_TRANSACTION | ICMSGHDRFLAG_RESPONSE;
-- 
1.9.1

