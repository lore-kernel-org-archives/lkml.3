Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab3BEUve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 15:51:34 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:52581 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755583Ab3BEUvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 15:51:33 -0500
Message-ID: <1360097490.14826.23.camel@x61.thuisdomein>
Subject: [PATCH] RDMA/cxgb4: "cookie" can stay in host endianness
From: Paul Bolle <pebolle@tiscali.nl>
To: Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 05 Feb 2013 21:51:30 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 05 Feb 2013 20:51:30.0510 (UTC) FILETIME=[930FC6E0:01CE03E2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Work requests are passed and reflected between the host and the
firmware with a "cookie". This cookie is swapped to big endianness when
passed to the firmware and to host endianness on reflection. This
swapping seems to be implemented incorrectly. Moreover, the byte
swapping triggers GCC warnings on 32 bit:
    drivers/infiniband/hw/cxgb4/cm.c: In function ‘passive_ofld_conn_reply’:
    drivers/infiniband/hw/cxgb4/cm.c:2803:12: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
    drivers/infiniband/hw/cxgb4/cm.c: In function ‘send_fw_pass_open_req’:
    drivers/infiniband/hw/cxgb4/cm.c:2941:16: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
    [...]

But byte swapping isn't needed as the firmware doesn't actually touch
the cookie. Dropping byte swapping makes the warnings go away too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Compile tested only (but on 32 and 64 bit little endian).

1) Please have a careful look at my commit explanation. It's mostly a
bit of creative writing based on my understanding of Steve's feedback. 

 drivers/infiniband/hw/cxgb4/cm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index c13745c..cd072fb 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2800,7 +2800,7 @@ static void passive_ofld_conn_reply(struct c4iw_dev *dev, struct sk_buff *skb,
 	struct cpl_pass_accept_req *cpl;
 	int ret;
 
-	rpl_skb = (struct sk_buff *)cpu_to_be64(req->cookie);
+	rpl_skb = (struct sk_buff *)(unsigned long)req->cookie;
 	BUG_ON(!rpl_skb);
 	if (req->retval) {
 		PDBG("%s passive open failure %d\n", __func__, req->retval);
@@ -2938,7 +2938,7 @@ static void send_fw_pass_open_req(struct c4iw_dev *dev, struct sk_buff *skb,
 	 * TP will ignore any value > 0 for MSS index.
 	 */
 	req->tcb.opt0 = cpu_to_be64(V_MSS_IDX(0xF));
-	req->cookie = cpu_to_be64((u64)skb);
+	req->cookie = (unsigned long)skb;
 
 	set_wr_txq(req_skb, CPL_PRIORITY_CONTROL, port_id);
 	cxgb4_ofld_send(dev->rdev.lldi.ports[0], req_skb);
-- 
1.8.1

