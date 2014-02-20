Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbaBTUox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 15:44:53 -0500
Received: from mail-qc0-f170.google.com ([209.85.216.170]:58106 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaBTUou (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 15:44:50 -0500
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 8/9] staging/fwserial: don't use PREPARE_WORK
Date: Thu, 20 Feb 2014 15:44:30 -0500
Message-Id: <1392929071-16555-9-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1392929071-16555-1-git-send-email-tj@kernel.org>
References: <1392929071-16555-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PREPARE_[DELAYED_]WORK() are being phased out.  They have few users
and a nasty surprise in terms of reentrancy guarantee as workqueue
considers work items to be different if they don't have the same work
function.

fwtty_peer->work is multiplexed with multiple work functions.
Introduce fwserial_peer_workfn() which invokes fwtty_peer->workfn and
always use it as the work function and update the users to set the
->workfn field instead of overriding the work function using
PREPARE_WORK().

It would probably be best to route this with other related updates
through the workqueue tree.

Compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 13 ++++++++++---
 drivers/staging/fwserial/fwserial.h |  1 +
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 8af136e..b22142e 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -2036,6 +2036,13 @@ static void fwserial_auto_connect(struct work_struct *work)
 		schedule_delayed_work(&peer->connect, CONNECT_RETRY_DELAY);
 }
 
+static void fwserial_peer_workfn(struct work_struct *work)
+{
+	struct fwtty_peer *peer = to_peer(work, work);
+
+	peer->workfn(work);
+}
+
 /**
  * fwserial_add_peer - add a newly probed 'serial' unit device as a 'peer'
  * @serial: aggregate representing the specific fw_card to add the peer to
@@ -2100,7 +2107,7 @@ static int fwserial_add_peer(struct fw_serial *serial, struct fw_unit *unit)
 	peer->port = NULL;
 
 	init_timer(&peer->timer);
-	INIT_WORK(&peer->work, NULL);
+	INIT_WORK(&peer->work, fwserial_peer_workfn);
 	INIT_DELAYED_WORK(&peer->connect, fwserial_auto_connect);
 
 	/* associate peer with specific fw_card */
@@ -2702,7 +2709,7 @@ static int fwserial_parse_mgmt_write(struct fwtty_peer *peer,
 
 		} else {
 			peer->work_params.plug_req = pkt->plug_req;
-			PREPARE_WORK(&peer->work, fwserial_handle_plug_req);
+			peer->workfn = fwserial_handle_plug_req;
 			queue_work(system_unbound_wq, &peer->work);
 		}
 		break;
@@ -2731,7 +2738,7 @@ static int fwserial_parse_mgmt_write(struct fwtty_peer *peer,
 			fwtty_err(&peer->unit, "unplug req: busy\n");
 			rcode = RCODE_CONFLICT_ERROR;
 		} else {
-			PREPARE_WORK(&peer->work, fwserial_handle_unplug_req);
+			peer->workfn = fwserial_handle_unplug_req;
 			queue_work(system_unbound_wq, &peer->work);
 		}
 		break;
diff --git a/drivers/staging/fwserial/fwserial.h b/drivers/staging/fwserial/fwserial.h
index 54f7f9b..98b853d 100644
--- a/drivers/staging/fwserial/fwserial.h
+++ b/drivers/staging/fwserial/fwserial.h
@@ -91,6 +91,7 @@ struct fwtty_peer {
 	struct rcu_head		rcu;
 
 	spinlock_t		lock;
+	work_func_t		workfn;
 	struct work_struct	work;
 	struct peer_work_params work_params;
 	struct timer_list	timer;
-- 
1.8.5.3

