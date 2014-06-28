Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964874AbaF1SIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:08:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54317 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024AbaF1Rwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:52:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Slava Shwartsman <valyushash@gmail.com>,
        Sagi Grimberg <sagig@mellanox.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.15 091/139] Target/iser: Gracefully reject T10-PI enabled connect request if not supported
Date: Sat, 28 Jun 2014 10:47:32 -0700
Message-Id: <20140628174609.573743384@linuxfoundation.org>
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

commit 5f80ff8eccba50832dcc640ac89add4c7fced963 upstream.

In case user chose to set T10-PI enable on the target while
the IB device does not support it, gracefully reject the request.

Reported-by: Slava Shwartsman <valyushash@gmail.com>
Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/isert/ib_isert.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -663,8 +663,9 @@ isert_connect_request(struct rdma_cm_id
 
 	pi_support = np->tpg_np->tpg->tpg_attrib.t10_pi;
 	if (pi_support && !device->pi_capable) {
-		pr_err("Protection information requested but not supported\n");
-		ret = -EINVAL;
+		pr_err("Protection information requested but not supported, "
+		       "rejecting connect request\n");
+		ret = rdma_reject(cma_id, NULL, 0);
 		goto out_mr;
 	}
 


