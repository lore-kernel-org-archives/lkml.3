Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaLEWyd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 17:54:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53996 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbaLEWqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Chris Moore <Chris.Moore@emulex.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.17 033/122] ib_isert: Add max_send_sge=2 minimum for control PDU responses
Date: Fri,  5 Dec 2014 14:43:27 -0800
Message-Id: <20141205223310.458327167@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Or Gerlitz <ogerlitz@mellanox.com>

commit f57915cfa5b2b14c1cffa2e83c034f55e3f0e70d upstream.

This patch adds a max_send_sge=2 minimum in isert_conn_setup_qp()
to ensure outgoing control PDU responses with tx_desc->num_sge=2
are able to function correctly.

This addresses a bug with RDMA hardware using dev_attr.max_sge=3,
that in the original code with the ConnectX-2 work-around would
result in isert_conn->max_sge=1 being negotiated.

Originally reported by Chris with ocrdma driver.

Reported-by: Chris Moore <Chris.Moore@emulex.com>
Tested-by: Chris Moore <Chris.Moore@emulex.com>
Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -115,9 +115,12 @@ isert_conn_setup_qp(struct isert_conn *i
 	attr.cap.max_recv_wr = ISERT_QP_MAX_RECV_DTOS;
 	/*
 	 * FIXME: Use devattr.max_sge - 2 for max_send_sge as
-	 * work-around for RDMA_READ..
+	 * work-around for RDMA_READs with ConnectX-2.
+	 *
+	 * Also, still make sure to have at least two SGEs for
+	 * outgoing control PDU responses.
 	 */
-	attr.cap.max_send_sge = device->dev_attr.max_sge - 2;
+	attr.cap.max_send_sge = max(2, device->dev_attr.max_sge - 2);
 	isert_conn->max_sge = attr.cap.max_send_sge;
 
 	attr.cap.max_recv_sge = 1;


