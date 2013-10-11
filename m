Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab3JKKtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:49:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58773 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758038Ab3JKKoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:44:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 085/100] ib_srpt: Destroy cm_id before destroying QP.
Date: Fri, 11 Oct 2013 11:41:55 +0100
Message-Id: <1381488130-30235-86-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 0b41d6ca616ddeb3b6c0a80e8770b6f53cd42806 upstream.

This patch fixes a bug where ib_destroy_cm_id() was incorrectly being called
after srpt_destroy_ch_ib() had destroyed the active QP.

This would result in the following failed SRP_LOGIN_REQ messages:

Received SRP_LOGIN_REQ with i_port_id 0x0:0x2590ffff1762bd, t_port_id 0x2c903009f8f40:0x2c903009f8f40 and it_iu_len 260 on port 1 (guid=0xfe80000000000000:0x2c903009f8f41)
Received SRP_LOGIN_REQ with i_port_id 0x0:0x2590ffff1758f9, t_port_id 0x2c903009f8f40:0x2c903009f8f40 and it_iu_len 260 on port 2 (guid=0xfe80000000000000:0x2c903009f8f42)
Received SRP_LOGIN_REQ with i_port_id 0x0:0x2590ffff175941, t_port_id 0x2c903009f8f40:0x2c903009f8f40 and it_iu_len 260 on port 2 (guid=0xfe80000000000000:0x2c90300a3cfb2)
Received SRP_LOGIN_REQ with i_port_id 0x0:0x2590ffff176299, t_port_id 0x2c903009f8f40:0x2c903009f8f40 and it_iu_len 260 on port 1 (guid=0xfe80000000000000:0x2c90300a3cfb1)
mlx4_core 0000:84:00.0: command 0x19 failed: fw status = 0x9
rejected SRP_LOGIN_REQ because creating a new RDMA channel failed.
Received SRP_LOGIN_REQ with i_port_id 0x0:0x2590ffff176299, t_port_id 0x2c903009f8f40:0x2c903009f8f40 and it_iu_len 260 on port 1 (guid=0xfe80000000000000:0x2c90300a3cfb1)
mlx4_core 0000:84:00.0: command 0x19 failed: fw status = 0x9
rejected SRP_LOGIN_REQ because creating a new RDMA channel failed.
Received SRP_LOGIN_REQ with i_port_id 0x0:0x2590ffff176299, t_port_id 0x2c903009f8f40:0x2c903009f8f40 and it_iu_len 260 on port 1 (guid=0xfe80000000000000:0x2c90300a3cfb1)

Reported-by: Navin Ahuja <navin.ahuja@saratoga-speed.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 5f6b7f6..0ff33b0 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2372,6 +2372,8 @@ static void srpt_release_channel_work(struct work_struct *w)
 	transport_deregister_session(ch->sess);
 	ch->sess = NULL;
 
+	ib_destroy_cm_id(ch->cm_id);
+
 	srpt_destroy_ch_ib(ch);
 
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
@@ -2382,8 +2384,6 @@ static void srpt_release_channel_work(struct work_struct *w)
 	list_del(&ch->list);
 	spin_unlock_irq(&sdev->spinlock);
 
-	ib_destroy_cm_id(ch->cm_id);
-
 	if (ch->release_done)
 		complete(ch->release_done);
 
-- 
1.8.3.2

