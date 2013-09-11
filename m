Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab3IKLnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 07:43:35 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:65483 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab3IKLnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 07:43:33 -0400
X-Nat-Received: from [202.181.97.72]:63235 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1378899800.23782
To: herbert@gondor.hengli.com.au, andr345@gmail.com
Cc: rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: [3.12-rc1] Dependency on module-init-tools >= 3.11 ?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <20130719232459.GA18039@gondor.apana.org.au>
	<1374277033.22432.384.camel@schen9-DESK>
	<1374283864.22432.393.camel@schen9-DESK>
	<20130720053021.GA19689@gondor.apana.org.au>
	<201307201456.JIC35412.VFOMFJOQLOtHFS@I-love.SAKURA.ne.jp>
In-Reply-To: <201307201456.JIC35412.VFOMFJOQLOtHFS@I-love.SAKURA.ne.jp>
Message-Id: <201309112043.HBD04609.FOtLSOFVQHFOJM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Wed, 11 Sep 2013 20:43:19 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 11092013 #11032909, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I'm again having the boot failure problem due to commit 68411521 'Reinstate
"crypto: crct10dif - Wrap crc_t10dif function all to use crypto transform
framework"' in linux.git .

---------- debug start ----------
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -188,7 +188,9 @@ int __request_module(bool wait, const char *fmt, ...)
 
 	trace_module_request(module_name, wait, _RET_IP_);
 
+	printk(KERN_WARNING "request_module(%s) start\n", module_name);
 	ret = call_modprobe(module_name, wait ? UMH_WAIT_PROC : UMH_WAIT_EXEC);
+	printk(KERN_WARNING "request_module(%s) end\n", module_name);
 
 	atomic_dec(&kmod_concurrent);
 	return ret;
---------- debug end ----------

---------- dmesg start ----------
[    5.130608] Fusion MPT base driver 3.04.20
[    5.130625] Copyright (c) 1999-2008 LSI Corporation
[    5.136709] Fusion MPT SPI Host driver 3.04.20
[    5.151422] mptbase: ioc0: Initiating bringup
[    5.169695] ioc0: LSI53C1030 B0: Capabilities={Initiator}
[    5.213380] scsi2 : ioc0: LSI53C1030 B0, FwRev=01032920h, Ports=1, MaxQ=128, IRQ=17
[    5.223811] Switched to clocksource tsc
[    5.247993] scsi 2:0:0:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
[    5.249783] scsi target2:0:0: Beginning Domain Validation
[    5.258664] scsi target2:0:0: Domain Validation skipping write tests
[    5.259592] scsi target2:0:0: Ending Domain Validation
[    5.260933] scsi target2:0:0: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
[    5.263868] scsi 2:0:1:0: Direct-Access     VMware,  VMware Virtual S 1.0  PQ: 0 ANSI: 2
[    5.264627] scsi target2:0:1: Beginning Domain Validation
[    5.270310] scsi target2:0:1: Domain Validation skipping write tests
[    5.270563] scsi target2:0:1: Ending Domain Validation
[    5.271742] scsi target2:0:1: FAST-40 WIDE SCSI 80.0 MB/s ST (25 ns, offset 127)
[    5.423813] sr0: scsi3-mmc drive: 1x/1x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.424805] cdrom: Uniform CD-ROM driver Revision: 3.20
[    5.436731] request_module(crct10dif) start
[    5.441143] request_module(crct10dif) end
[    5.441873] request_module(crct10dif-all) start
[    5.446616] request_module(crct10dif-all) end
[    5.462070] request_module(crct10dif) start
[    5.466579] request_module(crct10dif) end
[    5.466648] request_module(crct10dif-all) start
[    5.470592] request_module(crct10dif-all) end
[    5.544469] scsi_id (268) used greatest stack depth: 3552 bytes left
FATAL: Module scsi_wait_scan not found.
(...snipped...)
FATAL: Module scsi_wait_scan not found.
[   59.306043] dracut Warning: Boot has failed. To debug this issue add "rdshell" to the kernel command line.
[   59.308188] dracut Warning: Signal caught!
---------- dmesg end ----------

In the initramfs, crc-t10dif.ko is included but crct10dif.ko and
crct10dif-pclmul.ko are not included. This is because modules.dep does not
describe that crc-t10dif.ko depends on crct10dif.ko and optionally depends
on crct10dif-pclmul.ko .

---------- dependency start ----------
$ grep t10dif modules.dep
kernel/arch/x86/crypto/crct10dif-pclmul.ko: kernel/crypto/crct10dif.ko
kernel/crypto/crct10dif.ko:
kernel/drivers/scsi/lpfc/lpfc.ko: kernel/drivers/scsi/scsi_transport_fc.ko kernel/drivers/scsi/scsi_tgt.ko kernel/lib/crc-t10dif.ko
kernel/drivers/scsi/sd_mod.ko: kernel/lib/crc-t10dif.ko
kernel/drivers/scsi/scsi_debug.ko: kernel/lib/crc-t10dif.ko
kernel/lib/crc-t10dif.ko:
---------- dependency end ----------

I'm using module-init-tools-3.9-21.el6_4 / binutils-2.20.51.0.2-5.36.el6 /
dracut-004-303.el6 / gcc-4.4.7-3.el6 and there is no modules.softdep file.

Did commit 7cb14ba7 "modules: add support for soft module dependencies"
silently introduced dependency on module-init-tools which can generate
modules.softdep file ( module-init-tools >= 3.11 ) ?

Kernel config is at http://I-love.SAKURA.ne.jp/tmp/config-3.12-rc1-modules .

Regards.
