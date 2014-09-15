Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbaIOU7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:59:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbaIOT1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:27:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Sagi Grimberg <sagig@mellanox.com>, David Dillow <dave@thedillows.org>,
        Roland Dreier <roland@purestorage.com>
Subject: [PATCH 3.16 057/158] scsi_transport_srp: Fix fast_io_fail_tmo=dev_loss_tmo=off behavior
Date: Mon, 15 Sep 2014 12:24:56 -0700
Message-Id: <20140915192544.605701395@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit cd53eb686d2418eda938aad3c9da42b7dfa9351f upstream.

If scsi_remove_host() is called while an rport is in the blocked state
then scsi_remove_host() will only finish if the rport is unblocked
from inside a timer function. Make sure that an rport only enters the
blocked state if a timer will be started that will unblock it. This
avoids that unloading the ib_srp kernel module after having
disconnected the initiator from the target system results in a
deadlock if both the fast_io_fail_tmo and dev_loss_tmo parameters have
been set to "off".

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Reviewed-by: David Dillow <dave@thedillows.org>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_transport_srp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -473,7 +473,8 @@ static void __srp_start_tl_fail_timers(s
 	if (delay > 0)
 		queue_delayed_work(system_long_wq, &rport->reconnect_work,
 				   1UL * delay * HZ);
-	if (srp_rport_set_state(rport, SRP_RPORT_BLOCKED) == 0) {
+	if ((fast_io_fail_tmo >= 0 || dev_loss_tmo >= 0) &&
+	    srp_rport_set_state(rport, SRP_RPORT_BLOCKED) == 0) {
 		pr_debug("%s new state: %d\n", dev_name(&shost->shost_gendev),
 			 rport->state);
 		scsi_target_block(&shost->shost_gendev);


