Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab3BUJDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 04:03:06 -0500
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:55765 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752518Ab3BUJDB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 04:03:01 -0500
Message-ID: <1361437377.1341.33.camel@x61.thuisdomein>
Subject: [PATCH v2] IB/mlx4: silence GCC warning
From: Paul Bolle <pebolle@tiscali.nl>
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Date: Thu, 21 Feb 2013 10:02:57 +0100
In-Reply-To: <511B9A1C.6000402@acm.org>
References: <1348836538.3626.21.camel@x61.thuisdomein>
	  <201210100923.43927.jackm@dev.mellanox.co.il>
	 <1351504201.1339.4.camel@x61.thuisdomein> <511B9A1C.6000402@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 21 Feb 2013 09:02:58.0649 (UTC) FILETIME=[3EA09490:01CE1012]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building qp.o (part of the "Mellanox ConnectX HCA support" driver)
triggers this GCC warning:
    drivers/infiniband/hw/mlx4/qp.c: In function ‘mlx4_ib_post_send’:
    drivers/infiniband/hw/mlx4/qp.c:1862:30: warning: ‘vlan’ may be used uninitialized in this function [-Wmaybe-uninitialized]
    drivers/infiniband/hw/mlx4/qp.c:1752:6: note: ‘vlan’ was declared here

Looking at the code it is clear 'vlan' is only set and used if 'is_eth'
is non-zero. But by, basically, initializing 'vlan' to 0xffff, instead
of the equivalent of initializing 'is_vlan' to zero, we can make this
warning go away.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Jack wanted to use uninitialized_var() after I posted the first
version of this trivial patch. I suggested to see what happened with
Ingo's idea to remove uninitialized_var() entirely. Nothing seems to
have happened, so I decided to try a different approach.

1) Still compile tested only, but now against v3.8.

 drivers/infiniband/hw/mlx4/qp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 19e0637..512fde3 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1747,9 +1747,9 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 	int spc;
 	int i;
 	int is_eth;
-	int is_vlan = 0;
+	int is_vlan;
 	int is_grh;
-	u16 vlan;
+	u16 vlan = 0xffff; /* invalid vlan id */
 	int err = 0;
 
 	send_size = 0;
@@ -1778,8 +1778,8 @@ static int build_mlx_header(struct mlx4_ib_sqp *sqp, struct ib_send_wr *wr,
 		}
 
 		vlan = rdma_get_vlan_id(&sgid);
-		is_vlan = vlan < 0x1000;
 	}
+	is_vlan = vlan < 0x1000;
 	ib_ud_header_init(send_size, !is_eth, is_eth, is_vlan, is_grh, 0, &sqp->ud_header);
 
 	if (!is_eth) {
-- 
1.7.11.7

