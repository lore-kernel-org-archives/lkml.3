Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbaHGJM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:12:57 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27791 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755052AbaHGJMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:12:54 -0400
Date: Thu, 7 Aug 2014 17:10:50 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Weird NET_RX softirq behavior
Message-ID: <20140807171050.77819b10@xhacker>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-07_04:2014-08-06,2014-08-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408070121
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

I observed one weird NET_RX softirq behavior:


1. CONFIG_RPS=y in kernel config file.

2. only one netdev in the system: eth0. eth0 only has one interrupt which is
all handled by CPU0. eth0 doesn't support RFS_ACCEL

"cat /proc/interrupts" shows 

~ # cat /proc/interrupts 
           CPU0       CPU1       CPU2       CPU3       
...
 49:         52          0          0          0       GIC  mmc1
 52:         53          0          0          0       GIC  mmc2
 56:     430365          0          0          0       GIC  eth0
 60:         61          0          0          0       GIC  mmc0
...

3. RPS and RFS remains disabled as default.

~ # ls /sys/class/net/eth0/queues/
rx-0  rx-1  rx-2  rx-3  tx-0
~ # cat /sys/class/net/eth0/queues/rx-*/rps_cpus
0
0
0
0
~ # cat /proc/sys/net/core/rps_sock_flow_entries
0
~ # cat /sys/class/net/eth0/queues/rx-*/rps_flow_cnt
0
0
0
0

4. But NET_RX seems abnormal
~ # cat /proc/softirqs 
                    CPU0       CPU1       CPU2       CPU3       
          HI:          0          0          0          0
       TIMER:      92386        767        367        263
      NET_TX:       6338          0          0          1
      NET_RX:     445587        322        983          0
       BLOCK:          0          0          0          0
BLOCK_IOPOLL:          0          0          0          0
     TASKLET:        150          0          0          0
       SCHED:      31414        490        275        179
     HRTIMER:          1          0          0          0
         RCU:      49029        570        285        182

I'm expecting NET_RX under CPU1, 2, 3 should be zero. Any suggestions
about this abnormal behavior?

Thanks in advance,
Jisheng
