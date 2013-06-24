Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab3FXUXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:23:19 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:49645 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3FXUXR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:23:17 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Fengguang Wu <fengguang.wu@intel.com>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [tip/x86/trace] INFO: suspicious RCU usage.
Thread-Topic: [tip/x86/trace] INFO: suspicious RCU usage.
Thread-Index: AQHOb6mepeVgvdSKsEKindzffMuZBZlFUa0g
Date: Mon, 24 Jun 2013 20:23:00 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443E0948A@USINDEM103.corp.hds.com>
References: <20130623003540.GB7541@localhost>
In-Reply-To: <20130623003540.GB7541@localhost>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-06-24_05:2013-06-24,2013-06-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0
 kscore.is_bulkscore=1.30750943294622e-07 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.99887704765186
 urlsuspect_oldscore=0.99887704765186 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=0 rbsscore=0.99887704765186
 spamscore=0 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1306240198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I just sent the fix below.

[PATCH -tip] x86,trace: Add rcu_irq_enter/exit() in smp_trace_reschedule_interrupt()

> -----Original Message-----
> From: Fengguang Wu [mailto:fengguang.wu@intel.com]
> Sent: Saturday, June 22, 2013 8:36 PM
> To: fengguang.wu@intel.com; Seiji Aguchi
> Cc: H. Peter Anvin; linux-kernel@vger.kernel.org
> Subject: [tip/x86/trace] INFO: suspicious RCU usage.
> 
> Greetings,
> 
> I got the below dmesg and the first bad commit is
> 
> commit cf910e83ae23692fdeefc7e506e504c4c468d38a
> Author: Seiji Aguchi <seiji.aguchi@hds.com>
> Date:   Thu Jun 20 11:46:53 2013 -0400
> 
>     x86, trace: Add irq vector tracepoints
> 
>     [Purpose of this patch]
> 
>     As Vaibhav explained in the thread below, tracepoints for irq vectors
>     are useful.
> 
>     http://www.spinics.net/lists/mm-commits/msg85707.html
> 
>     <snip>
>     The current interrupt traces from irq_handler_entry and irq_handler_exit
>     provide when an interrupt is handled.  They provide good data about when
>     the system has switched to kernel space and how it affects the currently
>     running processes.
> 
>     There are some IRQ vectors which trigger the system into kernel space,
>     which are not handled in generic IRQ handlers.  Tracing such events gives
>     us the information about IRQ interaction with other system events.
> 
>     The trace also tells where the system is spending its time.  We want to
>     know which cores are handling interrupts and how they are affecting other
>     processes in the system.  Also, the trace provides information about when
>     the cores are idle and which interrupts are changing that state.
>     <snip>
> 
>     On the other hand, my usecase is tracing just local timer event and
>     getting a value of instruction pointer.
> 
>     I suggested to add an argument local timer event to get instruction pointer before.
>     But there is another way to get it with external module like systemtap.
>     So, I don't need to add any argument to irq vector tracepoints now.
> 
>     [Patch Description]
> 
>     Vaibhav's patch shared a trace point ,irq_vector_entry/irq_vector_exit, in all events.
>     But there is an above use case to trace specific irq_vector rather than tracing all events.
>     In this case, we are concerned about overhead due to unwanted events.
> 
>     So, add following tracepoints instead of introducing irq_vector_entry/exit.
>     so that we can enable them independently.
>        - local_timer_vector
>        - reschedule_vector
>        - call_function_vector
>        - call_function_single_vector
>        - irq_work_entry_vector
>        - error_apic_vector
>        - thermal_apic_vector
>        - threshold_apic_vector
>        - spurious_apic_vector
>        - x86_platform_ipi_vector
> 
>     Also, introduce a logic switching IDT at enabling/disabling time so that a time penalty
>     makes a zero when tracepoints are disabled. Detailed explanations are as follows.
>      - Create trace irq handlers with entering_irq()/exiting_irq().
>      - Create a new IDT, trace_idt_table, at boot time by adding a logic to
>        _set_gate(). It is just a copy of original idt table.
>      - Register the new handlers for tracpoints to the new IDT by introducing
>        macros to alloc_intr_gate() called at registering time of irq_vector handlers.
>      - Add checking, whether irq vector tracing is on/off, into load_current_idt().
>        This has to be done below debug checking for these reasons.
>        - Switching to debug IDT may be kicked while tracing is enabled.
>        - On the other hands, switching to trace IDT is kicked only when debugging
>          is disabled.
> 
>     In addition, the new IDT is created only when CONFIG_TRACING is enabled to avoid being
>     used for other purposes.
> 
>     Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
>     Link: http://lkml.kernel.org/r/51C323ED.5050708@hds.com
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>     Cc: Steven Rostedt <rostedt@goodmis.org>
> 
> [   50.721349]
> [   50.721502] ===============================
> [   50.721835] [ INFO: suspicious RCU usage. ]
> [   50.722169] 3.10.0-rc6-00004-gcf910e8 #190 Not tainted
> [   50.722582] -------------------------------
> [   50.722915] /c/kernel-tests/src/linux/arch/x86/include/asm/trace/irq_vectors.h:50 suspicious rcu_dereference_check() usage!
> [   50.723770]
> [   50.723770] other info that might help us debug this:
> [   50.723770]
> [   50.724385]
> [   50.724385] RCU used illegally from idle CPU!
> [   50.724385] rcu_scheduler_active = 1, debug_locks = 0
> [   50.725232] RCU used illegally from extended quiescent state!
> [   50.725690] no locks held by swapper/0/0.
> [   50.726010]
> [   50.726010] stack backtrace:
> [   50.726359] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.10.0-rc6-00004-gcf910e8 #190
> [   50.726965] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> 
> [   50.727417]  00000001 00000001 79c53f04 798bd9f9 79c53f2c 79077a70 79b412c6 79b41fd1
> [   50.728159]  00000001 00000000 79c5ef8c 87147c58 00000000 79c55800 79c53f38 79010b65
> [   50.728849]  79c52000 79c53f7c 798c720e 79c52000 79c5ef8c 00000004 00000000 79c55800
> [   50.729532] Call Trace:
> [   50.729730]  [<798bd9f9>] dump_stack+0x16/0x18
> [   50.730072]  [<79077a70>] lockdep_rcu_suspicious+0xf2/0xfa
> [   50.730498]  [<79010b65>] smp_trace_reschedule_interrupt+0x1c8/0x1d0
> [   50.730979]  [<798c720e>] trace_reschedule_interrupt+0x36/0x3c
> [   50.731214]  [<7901875f>] ? native_safe_halt+0x5/0x7
> [   50.731214]  [<790085cc>] default_idle+0xb1/0x1e2
> [   50.731214]  [<79008d05>] arch_cpu_idle+0xe/0x10
> [   50.731214]  [<79069ddf>] cpu_startup_entry+0x1e4/0x2c3
> [   50.731214]  [<798adb34>] rest_init+0x12c/0x132
> [   50.731214]  [<798ada08>] ? __read_lock_failed+0x14/0x14
> [   50.731214]  [<79d309e4>] start_kernel+0x38d/0x393
> [   50.731214]  [<79d30489>] ? repair_env_string+0x51/0x51
> [   50.731214]  [<79d302c3>] i386_start_kernel+0x79/0x7d
> [   50.771947] OK
> [   50.772099] Testing event reschedule_entry: OK
> 
> git bisect start cf910e83ae23692fdeefc7e506e504c4c468d38a v3.9 --
> git bisect good fbcd4836d20a33209843dcf84f83a33b97b74c9a  # 16:16     52+  [SCSI] qla4xxx: Assign values using correct datatype
> git bisect good 91f8575685e35f3bd021286bc82d26397458f5a9  # 17:09     52+  Merge branch 'for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client
> git bisect good c4cc75c3321cad6f20d1e5325293890255c8a663  # 20:03     52+  Merge git://git.infradead.org/users/eparis/audit
> git bisect good 3a5395b3d57b9e3836c755434c88f4590d5ea6f6  # 20:17     52+  net: ethernet: xilinx_emaclite: set protocol selector bits
> when writing ANAR
> git bisect good e6395b68ad09a835f058da31bad0fe23d3882659  # 20:28     52+  Merge tag 'for-linus-v3.10-rc5' of
> git://oss.sgi.com/xfs/xfs
> git bisect good 5402b8047b0d286b6501f9097891cbf1e06daa3a  # 20:40     52+  lib/mpi/mpicoder.c: looping issue, need stop when equal
> to zero, found by 'EXTRA_FLAGS=-W'.
> git bisect good 2dc85bf323515e59e15dfa858d1472bb25cad0fe  # 20:53     52+  packet: packet_getname_spkt: make sure string is always
> 0-terminated
> git bisect good 3ad2e318a24124c53cc6390b5bfbd7613d9c2145  # 21:06     52+  Merge tag 'usb-3.10-rc5' of
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb
> git bisect good 5938930e71affa390c3fa33fa2fda52f58f850e8  # 21:17     52+  Merge branch 'merge' of
> git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc
> git bisect good 323226bbb3d865af12644d66df2b7f161adf51c7  # 21:30     52+  Merge tag 'fixes-3.10-4' of
> git://git.infradead.org/users/jcooper/linux into fixes
> git bisect good dd019897358b815f7828dab90b51d51df4d3658d  # 21:40     52+  net: sh_eth: fix incorrect RX length error if R8A7740
> git bisect good e6694d984adbe8146d2f1e08d500befc1481835e  # 22:02     52+  Merge tag 'fixes-for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
> git bisect good f5abaa1bfc3dbf26d19d3513f39279ca369f8d65  # 22:13     52+  tracing: Add DEFINE_EVENT_FN() macro
> git bisect good 629f4f9d59a27d8e58aa612e886e6a9a63ea7aeb  # 22:24     52+  x86: Rename variables for debugging
> git bisect good 629f4f9d59a27d8e58aa612e886e6a9a63ea7aeb  # 22:31    156+  x86: Rename variables for debugging
> git bisect  bad 83ab85140bc1492f92de263a1c30ea04a0f465f7  # 22:31      0-  trace,x86: Move creation of irq tracepoints from apic.c to
> irq.c
> git bisect good f71194a7d47c1da787555d27aac63973ca72323b  # 22:36    156+  Merge branch 'x86/urgent' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good a92a990789849502897e3e19c2c0e5154888edf7  # 23:55    156+  Merge branch 'perf/core'
> 
> Thanks,
> Fengguang
