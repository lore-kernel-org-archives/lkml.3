Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbaFHWWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 18:22:19 -0400
Received: from p01c11o141.mxlogic.net ([208.65.144.64]:42609 "EHLO
	p01c11o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbaFHWWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 18:22:08 -0400
X-MXL-Hash: 5394e2106e8185ce-12ed05f1c91391364d3ed5bcc72ea88557542b4f
Date: Sun, 8 Jun 2014 18:22:00 -0400
From: Joe Lawrence <joe.lawrence@stratus.com>
X-X-Sender: jlaw@jlaw-desktop.mno.stratus.com
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>
Subject: docker crashes rcuos in __blkg_release_rcu
Message-ID: <alpine.DEB.2.02.1406081816540.17948@jlaw-desktop.mno.stratus.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [134.111.199.152]
X-AnalysisOut: [v=2.1 cv=AYo/HhnG c=1 sm=1 tr=0 a=VNTQBUOG7PJoPU2GWtE7Ww==]
X-AnalysisOut: [:117 a=VNTQBUOG7PJoPU2GWtE7Ww==:17 a=nXGuE6rTyBAA:10 a=uhH]
X-AnalysisOut: [178Y4_tYA:10 a=_KQqW7t0BisA:10 a=CdzKgOd8jloA:10 a=BLceEmw]
X-AnalysisOut: [cHowA:10 a=kj9zAlcOel0A:10 a=uelBKuKpAAAA:8 a=YlVTAMxIAAAA]
X-AnalysisOut: [:8 a=vTr9H3xdAAAA:8 a=cefaDkQiAAAA:8 a=20KFwNOVAAAA:8 a=XH]
X-AnalysisOut: [VHq_9iHaWiWcRW6UYA:9 a=CjuIK1q_8ugA:10]
X-Spam: [F=0.5000000000; CM=0.500; MH=0.500(2014060809); S=0.200(2014051901)]
X-MAIL-FROM: <joe.lawrence@stratus.com>
X-SOURCE-IP: [134.111.1.17]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun, Vivek,

I came across this crash when attempting to run the 'hello world'
example from the Getting Started section on the docker.io homepage.

Repro kernels:

(upstream linus) 3.15.0
(RHEL7 RC-2)     3.10.0-121.el7.x86_64

To reproduce, boot with slub_debug=FZPU and run the example.

  % # RHEL7 needs docker-io from EPEL
  % yum install http://dl.fedoraproject.org/pub/epel/beta/7/x86_64/epel-release-7-0.1.noarch.rpm
  % rpm -ivh epel-release-7-0.1.noarch.rpm
  % yum install docker-io
  
  % systemctl start docker
  % docker run ubuntu /bin/echo hello world

The host crashes every time with the following stack trace:

general protection fault: 0000 [#1] SMP 
Modules linked in: veth xt_addrtype xt_conntrack iptable_filter ipt_MASQUERADE iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack ip_tables bridge stp llc dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c loop bonding sg x86_pkg_temp_thermal coretemp crct10dif_pclmul crc32_pclmul crc32c_intel igb ixgbe ghash_clmulni_intel aesni_intel nfsd lrw gf128mul glue_helper ablk_helper dm_service_time cryptd pcspkr ptp auth_rpcgss ntb pps_core nfs_acl ses lockd mdio i2c_algo_bit enclosure ipmi_devintf dca ipmi_msghandler i2c_core dm_multipath sunrpc dm_mod ext4 mbcache jbd2 raid1 sd_mod crc_t10dif crct10dif_common sr_mod cdrom qla2xxx mpt3sas mpt2sas scsi_transport_fc usb_storage scsi_tgt raid_class scsi_transport_sas
CPU: 21 PID: 30 Comm: rcuos/21 Not tainted 3.15.0 #1
Hardware name: Stratus ftServer 6400/G7LAZ, BIOS BIOS Version 6.3:57 12/25/2013
task: ffff880854021de0 ti: ffff88085403c000 task.ti: ffff88085403c000
RIP: 0010:[<ffffffff8162e9e5>]  [<ffffffff8162e9e5>] _raw_spin_lock_irq+0x15/0x60
RSP: 0018:ffff88085403fdf0  EFLAGS: 00010086
RAX: 0000000000020000 RBX: 0000000000000010 RCX: 0000000000000000
RDX: 000060ef80008248 RSI: 0000000000000286 RDI: 6b6b6b6b6b6b6b6b
RBP: ffff88085403fdf0 R08: 0000000000000286 R09: 0000000000009f39
R10: 0000000000020001 R11: 0000000000020001 R12: ffff88103c17a130
R13: ffff88103c17a080 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88107fca0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000006e5ab8 CR3: 000000000193d000 CR4: 00000000000407e0
Stack:
 ffff88085403fe18 ffffffff812cbfc2 ffff88103c17a130 0000000000000000
 ffff88103c17a130 ffff88085403fec0 ffffffff810d1d28 ffff880854021de0
 ffff880854021de0 ffff88107fcaec58 ffff88085403fe80 ffff88107fcaec30
Call Trace:
 [<ffffffff812cbfc2>] __blkg_release_rcu+0x72/0x150
 [<ffffffff810d1d28>] rcu_nocb_kthread+0x1e8/0x300
 [<ffffffff810b6a00>] ? abort_exclusive_wait+0xb0/0xb0
 [<ffffffff810d1b40>] ? rcu_start_gp+0x40/0x40
 [<ffffffff81091d81>] kthread+0xe1/0x100
 [<ffffffff81091ca0>] ? kthread_create_on_node+0x1a0/0x1a0
 [<ffffffff8163813c>] ret_from_fork+0x7c/0xb0
 [<ffffffff81091ca0>] ? kthread_create_on_node+0x1a0/0x1a0
Code: ff 47 04 48 8b 7d 08 be 00 02 00 00 e8 55 48 a4 ff 5d c3 0f 1f 00 66 66 66 66 90 55 48 89 e5 fa 66 66 90 66 66 90 b8 00 00 02 00 <f0> 0f c1 07 89 c2 c1 ea 10 66 39 c2 75 02 5d c3 83 e2 fe 0f b7 
RIP  [<ffffffff8162e9e5>] _raw_spin_lock_irq+0x15/0x60
 RSP <ffff88085403fdf0>

crash> dis -l _raw_spin_lock_irq

kernel/locking/spinlock.c: 166
  <_raw_spin_lock_irq>:        data32 data32 data32 xchg %ax,%ax
  <_raw_spin_lock_irq+0x5>:    push   %rbp
  <_raw_spin_lock_irq+0x6>:    mov    %rsp,%rbp
arch/x86/include/asm/paravirt.h: 814
  <_raw_spin_lock_irq+0x9>:    cli    
  <_raw_spin_lock_irq+0xa>:    data32 xchg %ax,%ax
  <_raw_spin_lock_irq+0xd>:    data32 xchg %ax,%ax
arch/x86/include/asm/spinlock.h: 86
  <_raw_spin_lock_irq+0x10>:   mov    $0x20000,%eax
  <_raw_spin_lock_irq+0x15>:   lock xadd %eax,(%rdi)       <<

arch/x86/include/asm/spinlock.h:

 82 static __always_inline void arch_spin_lock(arch_spinlock_t *lock)
 83 {
 84         register struct __raw_tickets inc = { .tail = TICKET_LOCK_INC };
 85 
 86         inc = xadd(&lock->tickets, inc);               <<

.tickets is offset 0 from arch_spinlock_t, so RDI should be the
arch_spinlock_t lock:
RDI: 6b6b6b6b6b6b6b6b

Back up a frame and get bearings...

crash> dis -l __blkg_release_rcu

block/blk-cgroup.c: 402
  <__blkg_release_rcu+0x56>:   cmpq   $0x0,-0x80(%r12)
  <__blkg_release_rcu+0x5c>:   je     0xffffffff812cc001 <__blkg_release_rcu+0xb1>
block/blk-cgroup.c: 403
  <__blkg_release_rcu+0x5e>:   mov    -0xb0(%r12),%rax
include/linux/spinlock.h: 328
  <__blkg_release_rcu+0x66>:   mov    0x460(%rax),%rdi
  <__blkg_release_rcu+0x6d>:   callq  0xffffffff8162e9d0 <_raw_spin_lock_irq>

block/blk-cgroup.c:

 387 void __blkg_release_rcu(struct rcu_head *rcu_head)
 388 {
 ...
 400         /* release the blkcg and parent blkg refs this blkg has been holding */
 401         css_put(&blkg->blkcg->css);
 402         if (blkg->parent) {
 403                 spin_lock_irq(blkg->q->queue_lock);
 404                 blkg_put(blkg->parent);
 405                 spin_unlock_irq(blkg->q->queue_lock);
 406         }

RAX is the struct request_queue*, but has been re-used by
_raw_spin_lock_irq.  How about R12?

crash> struct -o blkcg_gq | grep b0                                                                       
  [0xb0] struct callback_head callback_head;

... and ...

block/blk-cgroup.c: 389
  <__blkg_release_rcu+0xb>:    lea    -0xb0(%rdi),%r13
block/blk-cgroup.c: 388
  <__blkg_release_rcu+0x12>:   push   %r12
  <__blkg_release_rcu+0x14>:   mov    %rdi,%r12

Chances are R12 is struct rcu_head *rcu_head and R13 is struct blkcg_gq*

R13: ffff88103c17a080

crash> p/x 0xffff88103c17a130-0xb0                                                                        
$2 = 0xffff88103c17a080

Yup.

crash> struct blkcg_gq 0xffff88103c17a080 | grep q
struct blkcg_gq {
  q = 0xffff88103fc7df90,

crash> rd 0xffff88103fc7df90 0xee
... all 0x6b's ...

Summary thus far:

R12: ffff88103c17a130 = struct rcu_head *rcu_head 
R13: ffff88103c17a080 = struct blkcg_gq *blkg
     ffff88103fc7df90 = struct request_queue *blkg->q (contains 0x6b
                                                       poison-pattern)

commit 2a4fd070 "blkcg: move bulk of blkcg_gq release operations to the
RCU callback" shuffled around some code in this space, introducing the
the calls to spin_[un]lock_irq(blkg->q->queue_lock).

Tejun -- I still have the vmcore here if you would like further analysis
or test patches you would like me to try.

Vivek -- might slub_debug be a reliable repro for RHBZ-1019584 (closed,
needinfo)?

Regards,

-- Joe

[1] https://www.docker.io/gettingstarted/
[2] https://bugzilla.redhat.com/show_bug.cgi?id=1019584
