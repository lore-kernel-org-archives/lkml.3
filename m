Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3JVJjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 05:39:11 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37683 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372Ab3JVJjJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 05:39:09 -0400
From: Kosta Zertsekel <konszert@marvell.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Eran Ben-Avi <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Lior Amsalem <alior@marvell.com>
Date: Tue, 22 Oct 2013 12:39:03 +0200
Subject: Enabling CONFIG_HOTPLUG_CPU for CPU that does not have hardware
 support hot-plug
Thread-Topic: Enabling CONFIG_HOTPLUG_CPU for CPU that does not have
 hardware support hot-plug
Thread-Index: Ac7PCfTh3YdqcBJgQJ+PoDBwOJE2Fg==
Message-ID: <BC373419EB4337418B2B595BAEDC155F01605CDD46A1@IL-MB01.marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-22_03:2013-10-22,2013-10-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310220015
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,	

The question
------------------
What are the possible drawbacks of enabling CONFIG_HOTPLUG_CPU for CPU
that does not have hardware support for hot-plug?

The question I'd like to ask is architecture agnostic, but the described behavior
is observed on MPCore Cortex-A9 CPU with Linux 3.4.59.

The issue
-------------
When Linux Kernel compiled in SMP mode, and CONFIG_HOTPLUG_CPU is not set,
and booted on single core CPU, then warning messages 
"... task blocked for more than 120 seconds ..." starts popping up in dmesg log.

For example:
INFO: task ksoftirqd/1:9 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.

To make the message disappear, CONFIG_HOTPLUG_CPU should be enabled.

Following the example of "ksoftirqd", the root cause of the issue is that
there are as many "ksoftirqd" threads created as CONFIG_NR_CPU
(see cpu_present_mask in kernel/cpu.c file). See below some details on
how "ksoftirqd" task is created and why it is not killed.

Now, the "ksoftirqd" task is *not* killed and just stays around in task queue
till the scheduler shouts "... task blocked ...".

	Details:
	----------
	The first "ksoftirqd" task (for CPU[0]) is created as part of executing
	the registered early_initcall function spawn_ksoftirqd() in the below
	flow:

	start_kernel() ---> rest_init() ---> kernel_init() --->
	do_pre_smp_initcalls() ---> spawd_ksoftirqd() --->
	cpu_callback(... CPU_ONLINE ...)

	The "ksoftirqd" tasks for CPU[1 .. N-1] are created in the different flow.
	First of all, cpu_callback() from kernel/softirq.c ("ksoftirqd" task is
	created in this callback) is registered through CPU notifier in
	spawn_ksoftirqd(). Then this callback is called in the below flow:

	start_kernel() ---> rest_init() ---> kernel_init() --->
	smp_init() ---> for_each_present_cpu(cpu) { cpu_up(cpu) --->
	_cpu_up() ---> __cpu_nofity(CPU_UP_PREPARE) (here "ksoftirqd" task
	is created).

	Right after that, CPU[x] is attempted to be enabled (using __cpu_up) and,
	if __cpu_up(cpu) fails, then "ksoftirqd" task is killed using
	__cpu_notify(CPU_UP_CANCELLED) some lines below.

	Now, the code that actually kills the task (using kthread_stop) is wrapped up
	with #ifdef CONFIG_HOTPLUG_CPU (see kernel/softirq.c, function cpu_callback).

The solution
-----------------
The easy solution is to enable CONFIG_HOTPLUG_CPU which enables
the compilation of the code that kills "ksoftirqd" task.
What is the possible drawback of enabling CONFIG_HOTPLUG_CPU for CPU
that does not have hardware support hot-plug?

Thanks,
--- KostaZ
