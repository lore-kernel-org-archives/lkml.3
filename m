Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaF1GRb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 02:17:31 -0400
Received: from mail-pd0-f202.google.com ([209.85.192.202]:57511 "EHLO
	mail-pd0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbaF1GR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 02:17:28 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] staging: gdm72xx: use int instead of u32 whenever makes sense
Date: Fri, 27 Jun 2014 23:17:26 -0700
Message-Id: <1403936247-24117-3-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1403936247-24117-1-git-send-email-benchan@chromium.org>
References: <1403936247-24117-1-git-send-email-benchan@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch addresses the following issues:
- Use int instead of u32 whenever makes sense
- Turn extract_qos_list() in gdm_qos.c, which previously always returned
  0, into a void function.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reported-by: Michalis Pappas <mpappas@fastmail.fm>
Signed-off-by: Ben Chan <benchan@chromium.org>
---
 drivers/staging/gdm72xx/gdm_qos.c | 15 +++++++--------
 drivers/staging/gdm72xx/gdm_qos.h |  6 +++---
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
index 732f009..a2efc5c 100644
--- a/drivers/staging/gdm72xx/gdm_qos.c
+++ b/drivers/staging/gdm72xx/gdm_qos.c
@@ -142,7 +142,7 @@ void gdm_qos_release_list(void *nic_ptr)
 	free_qos_entry_list(&free_list);
 }
 
-static u32 chk_ipv4_rule(struct gdm_wimax_csr_s *csr, u8 *stream, u8 *port)
+static int chk_ipv4_rule(struct gdm_wimax_csr_s *csr, u8 *stream, u8 *port)
 {
 	int i;
 
@@ -188,9 +188,9 @@ static u32 chk_ipv4_rule(struct gdm_wimax_csr_s *csr, u8 *stream, u8 *port)
 	return 0;
 }
 
-static u32 get_qos_index(struct nic *nic, u8 *iph, u8 *tcpudph)
+static int get_qos_index(struct nic *nic, u8 *iph, u8 *tcpudph)
 {
-	u32 IP_ver, i;
+	int IP_ver, i;
 	struct qos_cb_s *qcb = &nic->qos;
 
 	if (iph == NULL || tcpudph == NULL)
@@ -213,7 +213,7 @@ static u32 get_qos_index(struct nic *nic, u8 *iph, u8 *tcpudph)
 	return -1;
 }
 
-static u32 extract_qos_list(struct nic *nic, struct list_head *head)
+static void extract_qos_list(struct nic *nic, struct list_head *head)
 {
 	struct qos_cb_s *qcb = &nic->qos;
 	struct qos_entry_s *entry;
@@ -238,8 +238,6 @@ static u32 extract_qos_list(struct nic *nic, struct list_head *head)
 		if (!list_empty(&qcb->qos_list[i]))
 			netdev_warn(nic->netdev, "Index(%d) is piled!!\n", i);
 	}
-
-	return 0;
 }
 
 static void send_qos_list(struct nic *nic, struct list_head *head)
@@ -305,7 +303,7 @@ out:
 	return ret;
 }
 
-static u32 get_csr(struct qos_cb_s *qcb, u32 SFID, int mode)
+static int get_csr(struct qos_cb_s *qcb, u32 SFID, int mode)
 {
 	int i;
 
@@ -333,7 +331,8 @@ static u32 get_csr(struct qos_cb_s *qcb, u32 SFID, int mode)
 void gdm_recv_qos_hci_packet(void *nic_ptr, u8 *buf, int size)
 {
 	struct nic *nic = nic_ptr;
-	u32 i, SFID, index, pos;
+	int i, index, pos;
+	u32 SFID;
 	u8 sub_cmd_evt;
 	struct qos_cb_s *qcb = &nic->qos;
 	struct qos_entry_s *entry, *n;
diff --git a/drivers/staging/gdm72xx/gdm_qos.h b/drivers/staging/gdm72xx/gdm_qos.h
index 50aa191..ab03d33 100644
--- a/drivers/staging/gdm72xx/gdm_qos.h
+++ b/drivers/staging/gdm72xx/gdm_qos.h
@@ -59,11 +59,11 @@ struct qos_entry_s {
 
 struct qos_cb_s {
 	struct list_head	qos_list[QOS_MAX];
-	u32			qos_list_cnt;
-	u32			qos_null_idx;
+	int			qos_list_cnt;
+	int			qos_null_idx;
 	struct gdm_wimax_csr_s	csr[QOS_MAX];
 	spinlock_t		qos_lock;
-	u32			qos_limit_size;
+	int			qos_limit_size;
 };
 
 void gdm_qos_init(void *nic_ptr);
-- 
2.0.0.526.g5318336

