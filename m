Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab3JVPBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 11:01:45 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59913 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789Ab3JVPBm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 11:01:42 -0400
Subject: [PATCH v4 1/3] x86,
 apic: Don't count the CPU with BP flag from MP table as booting-up
 CPU
To: hpa@linux.intel.com, ebiederm@xmission.com, vgoyal@redhat.com
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, bp@alien8.de,
        akpm@linux-foundation.org, fengguang.wu@intel.com, jingbai.ma@hp.com
Date: Wed, 23 Oct 2013 00:01:24 +0900
Message-ID: <20131022150124.24240.20741.stgit@localhost6.localdomain6>
In-Reply-To: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
References: <20131022150015.24240.39686.stgit@localhost6.localdomain6>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If crash occurs on some AP, then kdump 2nd kernel is booted up on the
AP. Therefore, it is not always correct that the CPU that is currently
booting up the kernel is BSP. It's wrong to reflect BSP information in
MP table as for the current booting up CPU.

Also, boot_cpu_physical_apicid has already been initialized before
reaching here, for example, in register_lapic_address().

This is a preparation for next patch that will introduce a new kernel
parameter to disabls specified CPU where boot_cpu_physical_apicid
needs to have apicid for the currently booting up CPU to identify it
to avoid falsely disabling it.

Signed-off-by: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
---
 arch/x86/kernel/mpparse.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index d2b5648..969bb9f 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -64,7 +64,6 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 
 	if (m->cpuflag & CPU_BOOTPROCESSOR) {
 		bootup_cpu = " (Bootup-CPU)";
-		boot_cpu_physical_apicid = m->apicid;
 	}
 
 	printk(KERN_INFO "Processor #%d%s\n", m->apicid, bootup_cpu);

