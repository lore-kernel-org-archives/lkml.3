Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720Ab3JORzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 13:55:00 -0400
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:59629 "EHLO
	qmta06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933442Ab3JORyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 13:54:54 -0400
Message-Id: <20131015174745.197380080@linux.com>
User-Agent: quilt/0.60-1
Date: Tue, 15 Oct 2013 12:47:23 -0500
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>, David Miller <davem@davemloft.net>
Subject: [PATCH 1/6] net: ip4_datagram_connect: Use correct form of statistics update
References: <20131015174722.615394057@linux.com>
Content-Disposition: inline; filename=fix_snmp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ip4_datagram_connect is called with BH processing enabled. Therefore
we cannot use IP_INC_STATS_BH but must use IP_INC_STATS which disables
BH handling before incrementing the counter.

The following trace is triggered without this patch:

[ 9293.806634] __this_cpu_add operation in preemptible [00000000] code: ntpd/2150
[ 9293.813894] caller is __this_cpu_preempt_check+0x38/0x60
[ 9293.813896] CPU: 2 PID: 2150 Comm: ntpd Tainted: GF            3.12.0-rc4+ #178
[ 9293.813897] Hardware name: Hewlett-Packard HP Z230 SFF Workstation/1906, BIOS L51 v01.10 07/05/2013
[ 9293.813898]  0000000000000002 ffff8803f33fddc8 ffffffff816d57c4 ffff8803f33fdfd8
[ 9293.813903]  ffff8803f33fddf8 ffffffff8137341c ffff8800366b0380 00000000ffffff9b
[ 9293.813905]  ffff8800366b0680 ffffffffffffff9b ffff8803f33fde38 ffffffff81373478
[ 9293.813916] Call Trace:
[ 9293.813920]  [<ffffffff816d57c4>] dump_stack+0x4e/0x82
[ 9293.813921]  [<ffffffff8137341c>] check_preemption_disabled+0xec/0x110
[ 9293.813923]  [<ffffffff81373478>] __this_cpu_preempt_check+0x38/0x60  
[ 9293.813926]  [<ffffffff8163cd5d>] ip4_datagram_connect+0x2cd/0x2f0    
[ 9293.813929]  [<ffffffff8164b73e>] inet_dgram_connect+0x2e/0x80
[ 9293.813934]  [<ffffffff815c766b>] SYSC_connect+0xdb/0x100
[ 9293.813938]  [<ffffffff81006e6f>] ? mask_8259A+0x2f/0x30 
[ 9293.813940]  [<ffffffff81010505>] ? syscall_trace_enter+0x155/0x270
[ 9293.813942]  [<ffffffff815c7b2e>] SyS_connect+0xe/0x10
[ 9293.813944]  [<ffffffff816e4d13>] tracesys+0xe1/0xe6  

Cc: Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/net/ipv4/datagram.c
===================================================================
--- linux.orig/net/ipv4/datagram.c	2013-08-08 02:55:00.900983548 -0500
+++ linux/net/ipv4/datagram.c	2013-10-09 15:02:51.999123322 -0500
@@ -57,7 +57,7 @@ int ip4_datagram_connect(struct sock *sk
 	if (IS_ERR(rt)) {
 		err = PTR_ERR(rt);
 		if (err == -ENETUNREACH)
-			IP_INC_STATS_BH(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
+			IP_INC_STATS(sock_net(sk), IPSTATS_MIB_OUTNOROUTES);
 		goto out;
 	}
 

