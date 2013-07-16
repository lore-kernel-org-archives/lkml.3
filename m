Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab3GPLxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 07:53:19 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51503 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431Ab3GPLxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 07:53:16 -0400
X-Nat-Received: from [202.181.97.72]:51789 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1373975586.28841
To: tim.c.chen@linux.intel.com
Cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org
Subject: [PATCH 3.11-rc1] crypto: Fix boot failure due to module dependency.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201307162053.GBC56724.MFVOJtSLQHFOOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 16 Jul 2013 20:53:02 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 16072013 #10603467, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got below failure.

  [    5.258911] scsi 1:0:0:0: CD-ROM            NECVMWar VMware IDE CDR10 1.00 PQ: 0 ANSI: 5
  [    5.267651] modprobe (156) used greatest stack depth: 4064 bytes left
  [    5.293607] Fusion MPT base driver 3.04.20
  [    5.294416] Copyright (c) 1999-2008 LSI Corporation
  [    5.300109] Fusion MPT SPI Host driver 3.04.20
  [    5.300967] Switched to clocksource tsc
  [    5.310921] mptbase: ioc0: Initiating bringup
  [    5.329480] ioc0: LSI53C1030 B0: Capabilities={Initiator}
  [    5.373136] scsi2 : ioc0: LSI53C1030 B0, FwRev=01032920h, Ports=1, MaxQ=128, IRQ=17
  [    5.406190] scsi 2:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
  [    5.408582] scsi target2:0:0: Beginning Domain Validation
  [    5.415451] scsi target2:0:0: Domain Validation skipping write tests
  [    5.416399] scsi target2:0:0: Ending Domain Validation
  [    5.417445] scsi target2:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
  [    5.419855] scsi 2:0:1:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
  [    5.420404] scsi target2:0:1: Beginning Domain Validation
  [    5.423171] scsi target2:0:1: Domain Validation skipping write tests
  [    5.423363] scsi target2:0:1: Ending Domain Validation
  [    5.424440] scsi target2:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
  [    5.439700] modprobe (211) used greatest stack depth: 3872 bytes left
  [    5.561700] sr0: scsi3-mmc drive: 1x/1x writer dvd-ram cd/rw xa/form2 cdda tray
  [    5.562596] cdrom: Uniform CD-ROM driver Revision: 3.20
  [    5.667330] scsi_id (264) used greatest stack depth: 3568 bytes left
  FATAL: Module scsi_wait_scan not found.
  
  FATAL: Module scsi_wait_scan not found.
  
  FATAL: Module scsi_wait_scan not found.
  (...snipped...)
  [   60.308916] dracut Warning: Boot has failed. To debug this issue add "rdshell" to the kernel command line.
  [   60.311431] dracut Warning: Signal caught!

Kernel config is at http://I-love.SAKURA.ne.jp/tmp/config-3.11-rc1

Bisected to commit 2d31e518 "crypto: crct10dif - Wrap crc_t10dif function all
to use crypto transform framework", and confirmed that changing from
CONFIG_CRYPTO_CRCT10DIF=m to CONFIG_CRYPTO_CRCT10DIF=y solves this problem.
----------
>From ad396f0c049fe6d4ab14793d10367e32227c5991 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 16 Jul 2013 18:33:40 +0900
Subject: [PATCH 3.11-rc1] crypto: Fix boot failure due to module dependency.

Commit 2d31e518 "crypto: crct10dif - Wrap crc_t10dif function all to use crypto
transform framework" was added without updating module dependency, breaking at
least one module which depends on CONFIG_CRYPTO_CRCT10DIF=y.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 crypto/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 69ce573..aa8edba 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -377,7 +377,7 @@ config CRYPTO_CRC32_PCLMUL
 	  and gain better performance as compared with the table implementation.
 
 config CRYPTO_CRCT10DIF
-	tristate "CRCT10DIF algorithm"
+	bool "CRCT10DIF algorithm"
 	select CRYPTO_HASH
 	help
 	  CRC T10 Data Integrity Field computation is being cast as
-- 
1.7.1
