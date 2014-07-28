Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751427AbaG1Q3Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:29:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13043 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751050AbaG1Q3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:29:20 -0400
From: Josef Bacik <jbacik@fb.com>
To: <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
        <a.p.zijlstra@chello.nl>
Subject: [RFC] [PATCH] x86: don't check numa topology when setting up core siblings
Date: Mon, 28 Jul 2014 12:28:39 -0400
Message-ID: <1406564919-19283-1-git-send-email-jbacik@fb.com>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-28_02:2014-07-28,2014-07-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=13.4494265516805
 compositescore=0.997700811770388 urlsuspect_oldscore=0.997700811770388
 suspectscore=8 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997700811770388 spamscore=0
 recipient_to_sender_domain_totalscore=46 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407280191
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have these processors with this Cluster on die feature which shares numa
nodes between cores on different sockets.  When booting up we were getting this
error with COD enabled (this is a 4 socket 12 core per CPU box)

 smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 OK
 ------------[ cut here ]------------
 WARNING: at arch/x86/kernel/smpboot.c:324 topology_sane.isra.2+0x6f/0x82()
 sched: CPU #6's mc-sibling CPU #0 is not on the same node! [node: 1 != 0]. Ignoring dependency.
 smpboot: Booting Node   1, Processors  #6
 Modules linked in:
 CPU: 6 PID: 0 Comm: swapper/6 Not tainted 3.10.39-31_fbk12_01013_ga2de9bf #1
 Hardware name: Quanta Leopard-DDR3/Leopard-DDR3, BIOS F06_3A03.08 05/24/2014
  ffffffff810971d4 ffff8802748d3e48 0000000000000009 ffff8802748d3df8
  ffffffff815bba59 ffff8802748d3e38 ffffffff8103b02b ffff8802748d3e28
  0000000000000001 000000000000b010 0000000000012580 0000000000000000
 Call Trace:
  [<ffffffff810971d4>] ? print_modules+0x54/0xa0
  [<ffffffff815bba59>] dump_stack+0x19/0x1b
  [<ffffffff8103b02b>] warn_slowpath_common+0x6b/0xa0
  [<ffffffff8103b101>] warn_slowpath_fmt+0x41/0x50
  [<ffffffff815ada56>] topology_sane.isra.2+0x6f/0x82
  [<ffffffff815ade23>] set_cpu_sibling_map+0x380/0x42c
  [<ffffffff815adfe7>] start_secondary+0x118/0x19a
 ---[ end trace 755dbfb52f761180 ]---
  #7 #8 #9 #10 #11 OK

and then the /proc/cpuinfo would show "cores: 6" instead of "cores: 12" because
the sibling map doesn't get set right.  This patch fixes this.  Now I realize
this is probably not the correct fix but I'm an FS guy and I don't understand
this stuff.  Looking at the cpuflags with COD on and off there appears to be no
difference.  The only difference I can spot is with it on we have 4 numa nodes
and with it off we have 2, but that seems like a flakey check at best to add.
I'm open to suggestions on how to fix this properly.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---

Sorry I fucked up my original submission, if this resend hits you twice I
apologize.

 arch/x86/kernel/smpboot.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 5492798..091a11c9 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -347,13 +347,7 @@ static bool match_llc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 
 static bool match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
 {
-	if (c->phys_proc_id == o->phys_proc_id) {
-		if (cpu_has(c, X86_FEATURE_AMD_DCM))
-			return true;
-
-		return topology_sane(c, o, "mc");
-	}
-	return false;
+	return (c->phys_proc_id == o->phys_proc_id);
 }
 
 void set_cpu_sibling_map(int cpu)
-- 
2.0.0

