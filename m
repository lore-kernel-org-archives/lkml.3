Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896AbaLEXGd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:06:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbaLEW4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:56:20 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Alex Tabachnik <alext@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 54/73] Target/iser: Fix a wrong dereference in case discovery session is over iser
Date: Fri,  5 Dec 2014 14:45:00 -0800
Message-Id: <20141205224435.553762207@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205224433.921659956@linuxfoundation.org>
References: <20141205224433.921659956@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/infiniband/ulp/isert/ib_isert.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -985,7 +985,8 @@ isert_put_login_tx(struct iscsi_conn *co
 	}
 	if (!login->login_failed) {
 		if (login->login_complete) {
-			if (isert_conn->conn_device->use_fastreg) {
+			if (!conn->sess->sess_ops->SessionType &&
+			    isert_conn->conn_device->use_fastreg) {
 				ret = isert_conn_create_fastreg_pool(isert_conn);
 				if (ret) {
 					pr_err("Conn: %p failed to create"


