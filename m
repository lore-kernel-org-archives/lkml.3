Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbaF1SEE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:04:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54412 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbaF1RxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Alex Tabachnik <alext@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.15 095/139] Target/iser: Fix a wrong dereference in case discovery session is over iser
Date: Sat, 28 Jun 2014 10:47:36 -0700
Message-Id: <20140628174609.749881520@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit e0546fc1ba66c90cb38a5764357366267d3e58e4 upstream.

In case the discovery session is carried over iser, we can't
access the assumed network portal since the default portal is
used. In this case we don't really need to allocate the fastreg
pool, just prepare to the text pdu that will follow.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Reported-by: Alex Tabachnik <alext@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -1053,7 +1053,9 @@ isert_put_login_tx(struct iscsi_conn *co
 	}
 	if (!login->login_failed) {
 		if (login->login_complete) {
-			if (isert_conn->conn_device->use_fastreg) {
+			if (!conn->sess->sess_ops->SessionType &&
+			    isert_conn->conn_device->use_fastreg) {
+				/* Normal Session and fastreg is used */
 				u8 pi_support = login->np->tpg_np->tpg->tpg_attrib.t10_pi;
 
 				ret = isert_conn_create_fastreg_pool(isert_conn,


