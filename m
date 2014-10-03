Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029AbaJCWrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 18:47:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47346 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758247AbaJCWYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:24:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.10 087/143] Target/iser: Dont put isert_conn inside disconnected handler
Date: Fri,  3 Oct 2014 14:34:42 -0700
Message-Id: <20141003213317.116121553@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003213314.470709810@linuxfoundation.org>
References: <20141003213314.470709810@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagig@mellanox.com>

commit 0fc4ea701fcf5bc51ace4e288af5be741465f776 upstream.

disconnected_handler is invoked on several CM events (such
as DISCONNECTED, DEVICE_REMOVAL, TIMEWAIT_EXIT...). Since
multiple  events can occur while before isert_free_conn is
invoked, we might put all isert_conn references and free
the connection too early.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -583,7 +583,6 @@ isert_disconnect_work(struct work_struct
 
 wake_up:
 	complete(&isert_conn->conn_wait);
-	isert_put_conn(isert_conn);
 }
 
 static void
@@ -2266,6 +2265,7 @@ static void isert_wait_conn(struct iscsi
 	wait_for_completion(&isert_conn->conn_wait_comp_err);
 
 	wait_for_completion(&isert_conn->conn_wait);
+	isert_put_conn(isert_conn);
 }
 
 static void isert_free_conn(struct iscsi_conn *conn)


