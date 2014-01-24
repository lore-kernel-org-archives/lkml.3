Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaAXFcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 00:32:13 -0500
Received: from linuxhacker.ru ([217.76.32.60]:44284 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbaAXFbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 00:31:49 -0500
X-Greylist: delayed 2738 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Jan 2014 00:31:40 EST
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>, Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 2/5] staging/lustre/lnet: Fix use after free in ksocknal_send
Date: Thu, 23 Jan 2014 23:45:05 -0500
Message-Id: <1390538708-4120-3-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390538708-4120-1-git-send-email-green@linuxhacker.ru>
References: <1390538708-4120-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call to ksocknal_launch_packet might schedule a callback that
might free the just sent message, and so subsequent access to it
via lntmsg->msg_vmflush goes to freed memory.

Instead we'll just remember if we are in the vmflush thread and
only restore if we happened to set mempressure flag.

Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
Reviewed-on: http://review.whamcloud.com/8667
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4360
Reviewed-by: Liang Zhen <liang.zhen@intel.com>
Reviewed-by: Amir Shehata <amir.shehata@intel.com>
---
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
index 68a4f52..b7b53b5 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_cb.c
@@ -924,7 +924,7 @@ ksocknal_launch_packet (lnet_ni_t *ni, ksock_tx_t *tx, lnet_process_id_t id)
 int
 ksocknal_send(lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg)
 {
-	int	       mpflag = 0;
+	int	       mpflag = 1;
 	int	       type = lntmsg->msg_type;
 	lnet_process_id_t target = lntmsg->msg_target;
 	unsigned int      payload_niov = lntmsg->msg_niov;
@@ -993,8 +993,9 @@ ksocknal_send(lnet_ni_t *ni, void *private, lnet_msg_t *lntmsg)
 
 	/* The first fragment will be set later in pro_pack */
 	rc = ksocknal_launch_packet(ni, tx, target);
-	if (lntmsg->msg_vmflush)
+	if (!mpflag)
 		cfs_memory_pressure_restore(mpflag);
+
 	if (rc == 0)
 		return (0);
 
-- 
1.8.5.3

