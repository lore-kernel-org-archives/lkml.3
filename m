Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724Ab3GPNtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 09:49:51 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64211 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab3GPNtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 09:49:50 -0400
X-Nat-Received: from [202.181.97.72]:60180 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1373982578.4466
To: herbert@gondor.hengli.com.au
Cc: tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to moduledependency.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201307162053.GBC56724.MFVOJtSLQHFOOF@I-love.SAKURA.ne.jp>
	<20130716115527.GA1034@gondor.apana.org.au>
In-Reply-To: <20130716115527.GA1034@gondor.apana.org.au>
Message-Id: <201307162249.JEA41532.FFOLHVQJFtOOMS@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 16 Jul 2013 22:49:34 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 16072013 #10604793, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> Looks like a bug in whatever is creating the initrd as it isn't
> including modules necessary for the boot.

It turned out that it is already wrong as of creating modules.dep.

  # grep crc /lib/modules/3.11.0-rc1/modules.dep
  kernel/crypto/crct10dif.ko:
  kernel/drivers/scsi/sd_mod.ko: kernel/lib/crc-t10dif.ko
  kernel/lib/crc-t10dif.ko:

modules.dep says

  (1) sd_mod.ko depends on crc-t10dif.ko
  (2) crc-t10dif.ko does not depend on crct10dif.ko

but commit 2d31e518 made crc-t10dif.ko depend on crct10dif.ko , didn't it?

crct10dif.ko need to be loaded before crc-t10dif.ko is loaded, but doing

diff --git a/lib/Kconfig b/lib/Kconfig
index 35da513..53ee0fd 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -68,6 +68,7 @@ config CRC_T10DIF
 	tristate "CRC calculation for the T10 Data Integrity Field"
 	select CRYPTO
 	select CRYPTO_CRCT10DIF
+	depends on CRYPTO_CRCT10DIF
 	help
 	  This option is only needed if a module that's not in the
 	  kernel tree needs to calculate CRC checks for use with the

causes below warning.

  crypto/Kconfig:379:     symbol CRYPTO_CRCT10DIF is selected by CRC_T10DIF
  warning: (BLK_DEV_SD && SCSI_LPFC && SCSI_DEBUG) selects CRC_T10DIF which has unmet direct dependencies (CRYPTO_CRCT10DIF)
