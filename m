Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845AbaHYPHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:07:07 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:55714 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536AbaHYPHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:07:04 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Benjamin LaHaise <bcrl@kvack.org>, Dan Aloni <dan@kernelim.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mateusz Guzik <mguzik@redhat.com>, Petr Matousek <pmatouse@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jeff Moyer <jmoyer@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: Revert "aio: fix aio request leak when events are reaped by
 user space"
Thread-Topic: Revert "aio: fix aio request leak when events are reaped by
 user space"
Thread-Index: AQHPu8xTWmT82eF+TU66Rrq86aIIJZvYJMQAgAAFsQCAAH5ogIAEJB+AgAAD3wCAAAM0AIAEmnfA
Date: Mon, 25 Aug 2014 15:06:12 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C22133@G9W0745.americas.hpqcorp.net>
References: <cover.1403632276.git.bcrl@kvack.org>
 <f8567a3845ac05bb28f3c1b478ef752762bd39ef.1403632276.git.bcrl@kvack.org>
 <20140819163733.GA10132@gmail.com> <20140819165404.GD13858@kvack.org>
 <20140819171426.GA11811@gmail.com> <20140820004651.GJ13858@kvack.org>
 <20140822160111.GD20391@kvack.org> <20140822161502.GA30392@gmail.com>
 <20140822162630.GF20391@kvack.org>
In-Reply-To: <20140822162630.GF20391@kvack.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Benjamin LaHaise
> Sent: Friday, 22 August, 2014 11:27 AM
...
> Ah, that was missing a hunk then.  Try this version instead.
> 
...
> diff --git a/fs/aio.c b/fs/aio.c
> index ae63587..fbdcc47 100644

Using this version of the patch, I ran into this crash after 36
hours of scsi-mq testing over the weekend.

The test was running heavy traffic to four scsi-mq based devices:
* fio running 4 KiB random reads 
  * ioengine=libaio
  * not using userspace_reap=1
* mkfs.ext4 and e2fsck, generating huge write bursts

io_submit_one triggered an NMI:
[132204.801834] Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0
[132204.804503] CPU: 0 PID: 8998 Comm: fio Tainted: G            E  3.17.0-rc1+ #15
[132204.806998] Hardware name: HP ProLiant DL380p Gen8, BIOS P70 09/08/2013
[132204.809292]  0000000000000000 ffff88043f407bb8 ffffffff815af54f 0000000000000001
[132204.812076]  ffffffff81809fe8 ffff88043f407c38 ffffffff815af2ce 0000000000000010
[132204.814858]  ffff88043f407c48 ffff88043f407be8 0000000000000000 0000000000000000
[132204.817557] Call Trace: 
[132204.818442]  <NMI>  [<ffffffff815af54f>] dump_stack+0x49/0x62
[132204.820538]  [<ffffffff815af2ce>] panic+0xbb/0x1f8
[132204.822284]  [<ffffffff810fa651>] watchdog_overflow_callback+0xb1/0xc0
[132204.824512]  [<ffffffff81133cf8>] __perf_event_overflow+0x98/0x230
[132204.826603]  [<ffffffff811345f4>] perf_event_overflow+0x14/0x20
[132204.828618]  [<ffffffff810219dc>] intel_pmu_handle_irq+0x1ec/0x3c0
[132204.830819]  [<ffffffff81018e04>] perf_event_nmi_handler+0x34/0x60
[132204.832933]  [<ffffffff81007d47>] nmi_handle+0x87/0x120
[132204.834748]  [<ffffffff81007ff4>] default_do_nmi+0x54/0x110
[132204.836670]  [<ffffffff81008140>] do_nmi+0x90/0xe0
[132204.838347]  [<ffffffff815b586a>] end_repeat_nmi+0x1e/0x2e
[132204.840248]  [<ffffffff811e4be4>] ? io_submit_one+0x174/0x4b0
[132204.842293]  [<ffffffff811e4be4>] ? io_submit_one+0x174/0x4b0
[132204.844257]  [<ffffffff811e4be4>] ? io_submit_one+0x174/0x4b0
[132204.846161]  <<EOE>>  [<ffffffff811e505c>] do_io_submit+0x13c/0x200
[132204.848438]  [<ffffffff8108cb53>] ? pick_next_task_fair+0x163/0x220
[132204.850642]  [<ffffffff811e5130>] SyS_io_submit+0x10/0x20
[132204.852519]  [<ffffffff815b3b52>] system_call_fastpath+0x16/0x1b
[132204.854608] Kernel Offset: 0x0 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffff9fffffff)
[132204.857976] ---[ end Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0

io_submit_one+0x174 is offset 0x1f94.  Per objdump -drS aio.o,
that's code from put_reqs_available inlined into refill_reqs_available
inlined into io_submit_one.

...
 * Atomically adds @i to @v.
 */
static inline void atomic_add(int i, atomic_t *v)
{
        asm volatile(LOCK_PREFIX "addl %1,%0"
    1f8c:       41 8b 44 24 78          mov    0x78(%r12),%eax
    1f91:       f0 01 03                lock add %eax,(%rbx)

        local_irq_save(flags);
        kcpu = this_cpu_ptr(ctx->cpu);
        kcpu->reqs_available += nr;

        while (kcpu->reqs_available >= ctx->req_batch * 2) {
    1f94:       8b 01                   mov    (%rcx),%eax
    1f96:       41 8b 54 24 78          mov    0x78(%r12),%edx
    1f9b:       8d 34 12                lea    (%rdx,%rdx,1),%esi
    1f9e:       39 f0                   cmp    %esi,%eax
    1fa0:       73 e6                   jae    1f88 <io_submit_one+0x168>


---
Rob Elliott    HP Server Storage



