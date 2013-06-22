Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932334Ab3FVLeK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 07:34:10 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:56083 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab3FVLeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 07:34:08 -0400
Message-ID: <51C58B8A.2080808@hds.com>
Date: Sat, 22 Jun 2013 07:33:30 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: x86@kernel.org, linux-kernel@vger.kernel.org, hpa@zytor.com
CC: mingo@elte.hu, tglx@linutronix.de, rostedt@goodmis.org
Subject: [PATCH -tip] trace,x86: Add config option checking to definitions
 of mce handlers
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-22_04:2013-06-21,2013-06-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.997215366458519 urlsuspect_oldscore=0.997215366458519
 suspectscore=8 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=0 rbsscore=0.997215366458519
 spamscore=0 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1306220075
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case CONFIG_X86_MCE_THRESHOLD and CONFIG_X86_THERMAL_VECTOR are disabled,
kernel build fails as follows.

   arch/x86/built-in.o: In function `trace_threshold_interrupt':
   (.entry.text+0x122b): undefined reference to `smp_trace_threshold_interrupt'
   arch/x86/built-in.o: In function `trace_thermal_interrupt':
   (.entry.text+0x132b): undefined reference to `smp_trace_thermal_interrupt'

In this case, trace_threshold_interrupt/trace_thermal_interrupt are not needed
to define.
So, add config option checking to their definitions in entry_64.S.

Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 arch/x86/kernel/entry_64.S |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 11eef43..53d6398 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1188,10 +1188,15 @@ apicinterrupt3 POSTED_INTR_VECTOR \
 	kvm_posted_intr_ipi smp_kvm_posted_intr_ipi
 #endif
 
+#ifdef CONFIG_X86_MCE_THRESHOLD
 apicinterrupt THRESHOLD_APIC_VECTOR \
 	threshold_interrupt smp_threshold_interrupt
+#endif
+
+#ifdef CONFIG_X86_THERMAL_VECTOR
 apicinterrupt THERMAL_APIC_VECTOR \
 	thermal_interrupt smp_thermal_interrupt
+#endif
 
 #ifdef CONFIG_SMP
 apicinterrupt CALL_FUNCTION_SINGLE_VECTOR \
-- 
1.7.1

