Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604Ab3JJPqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:46:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52725 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab3JJPqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:46:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 096/104] ib_srpt: Destroy cm_id before destroying QP.
Date: Thu, 10 Oct 2013 08:42:24 -0700
Message-Id: <1381419752-29733-97-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381419752-29733-1-git-send-email-kamal@canonical.com>
References: <1381419752-29733-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.11 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index b4a76d1..047ebe4 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2358,6 +2358,8 @@ static void srpt_release_channel_work(struct work_struct *w)
 	transport_deregister_session(se_sess);
 	ch->sess = NULL;
 
+	ib_destroy_cm_id(ch->cm_id);
+
 	srpt_destroy_ch_ib(ch);
 
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
@@ -2368,8 +2370,6 @@ static void srpt_release_channel_work(struct work_struct *w)
 	list_del(&ch->list);
 	spin_unlock_irq(&sdev->spinlock);
 
-	ib_destroy_cm_id(ch->cm_id);
-
 	if (ch->release_done)
 		complete(ch->release_done);
 
-- 
1.8.1.2

