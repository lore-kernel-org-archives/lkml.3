Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936687Ab3DIKux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 06:50:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:20347 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934484Ab3DIKuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 06:50:52 -0400
Message-ID: <5163F29D.6080605@oracle.com>
Date: Tue, 09 Apr 2013 18:51:09 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: xen-devel@lists.xensource.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Feng Jin <joe.jin@oracle.com>, ben@guthro.net
Subject: [PATCH] xen: minor fix in apic ipi interface func
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xen_send_IPI_mask_allbutself uses native vector as input other than xen_vector.

xen_send_IPI_one need to be called to pass xen_vector in xen_send_IPI_mask_allbutself.

Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 arch/x86/xen/smp.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 09ea61d..bf27868 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -565,6 +565,10 @@ void xen_send_IPI_mask_allbutself(const struct cpumask *mask,
 {
 	unsigned cpu;
 	unsigned int this_cpu = smp_processor_id();
+	int xen_vector = xen_map_vector(vector);
+
+	if (xen_vector < 0)
+		return;
 
 	if (!(num_online_cpus() > 1))
 		return;
@@ -573,16 +577,13 @@ void xen_send_IPI_mask_allbutself(const struct cpumask *mask,
 		if (this_cpu == cpu)
 			continue;
 
-		xen_smp_send_call_function_single_ipi(cpu);
+		xen_send_IPI_one(cpu, xen_vector);
 	}
 }
 
 void xen_send_IPI_allbutself(int vector)
 {
-	int xen_vector = xen_map_vector(vector);
-
-	if (xen_vector >= 0)
-		xen_send_IPI_mask_allbutself(cpu_online_mask, xen_vector);
+	xen_send_IPI_mask_allbutself(cpu_online_mask, vector);
 }
 
 static irqreturn_t xen_call_function_interrupt(int irq, void *dev_id)
-- 
1.7.3

