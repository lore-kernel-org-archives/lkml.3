Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab3EFNFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:05:11 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48668 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab3EFNFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:05:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        stefano.stabellini@eu.citrix.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/4] xen/smp/pvhvm: Don't point per_cpu(xen_vpcu, 33 and larger) to shared_info
Date: Mon,  6 May 2013 09:04:57 -0400
Message-Id: <1367845498-14290-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1367845498-14290-1-git-send-email-konrad.wilk@oracle.com>
References: <1367845498-14290-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As it will point to some data, but not event channel data (the
shared_info has an array limited to 32).

This means that for PVHVM guests with more than 32 VCPUs without
the usage of VCPUOP_register_info any interrupts to VCPUs
larger than 32 would have gone unnoticed during early bootup.

That is OK, as during early bootup, in smp_init we end up calling
the hotplug mechanism (xen_hvm_cpu_notify) which makes the
VCPUOP_register_vcpu_info call for all VCPUs and we can receive
interrupts on VCPUs 33 and further.

This is just a cleanup.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 9b34475..18a4009 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1638,6 +1638,9 @@ void __ref xen_hvm_init_shared_info(void)
 	 * online but xen_hvm_init_shared_info is run at resume time too and
 	 * in that case multiple vcpus might be online. */
 	for_each_online_cpu(cpu) {
+		/* Leave it to be NULL. */
+		if (cpu >= MAX_VIRT_CPUS)
+			continue;
 		per_cpu(xen_vcpu, cpu) = &HYPERVISOR_shared_info->vcpu_info[cpu];
 	}
 }
-- 
1.8.1.4

