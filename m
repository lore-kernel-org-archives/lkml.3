Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbaGZTNl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:13:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270AbaGZTN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Liz Zhang <lizzha@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Dexuan Cui <decui@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3.15 006/109] Drivers: hv: hv_fcopy: fix a race condition for SMP guest
Date: Sat, 26 Jul 2014 12:01:28 -0700
Message-Id: <20140726190224.021742566@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dexuan Cui <decui@microsoft.com>

commit 2ef82d24f445e82f80e235f44eb9d1bc933e3670 upstream.

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
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/hv_fcopy.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hv/hv_fcopy.c
+++ b/drivers/hv/hv_fcopy.c
@@ -246,8 +246,8 @@ void hv_fcopy_onchannelcallback(void *co
 		/*
 		 * Send the information to the user-level daemon.
 		 */
-		fcopy_send_data();
 		schedule_delayed_work(&fcopy_work, 5*HZ);
+		fcopy_send_data();
 		return;
 	}
 	icmsghdr->icflags = ICMSGHDRFLAG_TRANSACTION | ICMSGHDRFLAG_RESPONSE;


