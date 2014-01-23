Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbaAWSjL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:39:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34662 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbaAWSjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:39:07 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vijaya Kumar K <Vijaya.Kumar@caviumnetworks.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        l00221744 <sdu.liu@huawei.com>
Subject: [PATCH 3.10 01/23] ARM: 7815/1: kexec: offline non panic CPUs on Kdump panic
Date: Thu, 23 Jan 2014 10:39:34 -0800
Message-Id: <20140123183859.901907909@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140123183859.635713053@linuxfoundation.org>
References: <20140123183859.635713053@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijaya Kumar K <vijay.kilari@gmail.com>

commit 4f9b4fb7a2091eec339413a460b1665758401828 upstream.

In case of normal kexec kernel load, all cpu's are offlined
before calling machine_kexec().But in case crash panic cpus
are relaxed in machine_crash_nonpanic_core() SMP function
but not offlined.

When crash kernel is loaded with kexec and on panic trigger
machine_kexec() checks for number of cpus online.
If more than one cpu is online machine_kexec() fails to load
with below error

kexec: error: multiple CPUs still online

In machine_crash_nonpanic_core() SMP function, offline CPU
before cpu_relax

Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@caviumnetworks.com>
Acked-by: Stephen Warren <swarren@wwwdotorg.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: l00221744 <sdu.liu@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/machine_kexec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm/kernel/machine_kexec.c
+++ b/arch/arm/kernel/machine_kexec.c
@@ -73,6 +73,7 @@ void machine_crash_nonpanic_core(void *u
 	crash_save_cpu(&regs, smp_processor_id());
 	flush_cache_all();
 
+	set_cpu_online(smp_processor_id(), false);
 	atomic_dec(&waiting_for_crash_ipi);
 	while (1)
 		cpu_relax();


