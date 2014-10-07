Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbaJGNE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:04:57 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:55664 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbaJGNE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:04:56 -0400
From: Christophe Leroy <christophe.leroy@c-s.fr>
To: Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH 0/2] net: fs_enet: Remove non NAPI RX and add NAPI for TX
Message-Id: <20141007130454.13EF21AB266@localhost.localdomain>
Date: Tue,  7 Oct 2014 15:04:53 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When using a MPC8xx as a router, 'perf' shows a significant time spent in 
fs_enet_interrupt() and fs_enet_start_xmit().
'perf annotate' shows that the time spent in fs_enet_start_xmit is indeed spent
between spin_unlock_irqrestore() and the following instruction, hence in
interrupt handling. This is due to the TX complete interrupt that fires after
each transmitted packet.
This patchset first remove all non NAPI handling as NAPI has become the only
mode for RX, then adds NAPI for handling TX complete.
This improves NAT TCP throughput by 21% on MPC885 with FEC.

Tested on MPC885 with FEC.

[PATCH 1/2] net: fs_enet: Remove non NAPI RX
[PATCH 2/2] net: fs_enet: Add NAPI TX

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>

---
 .../net/ethernet/freescale/fs_enet/fs_enet-main.c  | 211 ++++++---------------
 .../net/ethernet/freescale/fs_enet/fs_enet.h       |   9 +-
 .../net/ethernet/freescale/fs_enet/mac-fcc.c       |  29 +++
 .../net/ethernet/freescale/fs_enet/mac-fec.c       |  29 +++
 .../net/ethernet/freescale/fs_enet/mac-scc.c       |  29 +++
 linux/include/linux/fs_enet_pd.h                   |   1 -
 6 files changed, 147 insertions(+), 161 deletions(-)
