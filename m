Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbaAPBmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 20:42:50 -0500
Received: from mail.fpasia.hk ([202.130.89.98]:44961 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbaAPBmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 20:42:45 -0500
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
To: cjb@laptop.org
Cc: s.hauer@pengutronix.de, agust@denx.de, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Ruehl <chris.ruehl@gtsys.com.hk>
Subject: [PATCH 2/2] mxcmmc: Internal error: Oops: 17 [#1] ARM from sg->offset
Date: Thu, 16 Jan 2014 09:42:48 +0800
Message-Id: <1389836568-14864-1-git-send-email-chris.ruehl@gtsys.com.hk>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function mxcmci_request() throw an exception on a imx27 cpu.
This patch fix the problem by test the pointer before access it.

[  516.783407] Unable to handle kernel NULL pointer dereference at virtual address 00000004
[  516.791639] pgd = c0004000
[  516.794445] [00000004] *pgd=00000000
[  516.798088] Internal error: Oops: 17 [#1] ARM
[  516.802472] Modules linked in:
[  516.805593] CPU: 0 PID: 569 Comm: mmcqd/0 Not tainted 3.13.0-rc1-next-20131125-00006-g5f6bb77-dirty #66
[  516.815027] task: cfb8a2a0 ti: cfb88000 task.ti: cfb88000
[  516.820484] PC is at mxcmci_request+0xd0/0x2f8
[  516.824974] LR is at mxcmci_request+0xf8/0x2f8
[  516.829466] pc : [<c02b6048>]    lr : [<c02b6070>]    psr: 00000013
[  516.829466] sp : cfb89dd0  ip : cfb89dd0  fp : cfb89e1c
[  516.840988] r10: 000001ff  r9 : 00000002  r8 : cfa10620
[  516.846250] r7 : 00000200  r6 : cfa0f02c  r5 : cfa0f0ec  r4 : cfa10400
[  516.852812] r3 : a0000013  r2 : cfa0f410  r1 : 00040000  r0 : 00000000
[  516.859376] Flags: nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
[  516.866723] Control: 0005317f  Table: afa74000  DAC: 00000017
[  516.872503] Process mmcqd/0 (pid: 569, stack limit = 0xcfb881c0)
[  516.878543] Stack: (0xcfb89dd0 to 0xcfb8a000)

(gdb) list *(mxcmci_request+0xd0)
0xcac is at drivers/mmc/host/mxcmmc.c:350.
345
346        if (!mxcmci_use_dma(host))
347            return 0;
348
349        for_each_sg(data->sg, sg, data->sg_len, i) {
350            if (sg->offset & 3 || sg->length & 3 || sg->length < 512) {
351                host->do_dma = 0;
352                return 0;
353            }
354        }

Signed-off-by: Chris Ruehl <chris.ruehl@gtsys.com.hk>
---
 drivers/mmc/host/mxcmmc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
index f7199c8..8645d6a 100644
--- a/drivers/mmc/host/mxcmmc.c
+++ b/drivers/mmc/host/mxcmmc.c
@@ -347,7 +347,7 @@ static int mxcmci_setup_data(struct mxcmci_host *host, struct mmc_data *data)
 		return 0;
 
 	for_each_sg(data->sg, sg, data->sg_len, i) {
-		if (sg->offset & 3 || sg->length & 3 || sg->length < 512) {
+		if (sg && (sg->offset & 3 || sg->length & 3 || sg->length < 512)) {
 			host->do_dma = 0;
 			return 0;
 		}
-- 
1.7.10.4

