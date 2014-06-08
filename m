Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaFHDli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 23:41:38 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36208 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbaFHDlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 23:41:36 -0400
Message-ID: <5393DB61.6060707@oracle.com>
Date: Sat, 07 Jun 2014 23:41:21 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: tracing: NULL ptr deref in ring_buffer_wait
References: <5366DFBF.6090204@oracle.com>	<20140505104712.11c63a5d@gandalf.local.home>	<5367B248.2010804@oracle.com>	<536BA35D.50807@oracle.com> <20140508121624.4ca87b2c@gandalf.local.home>
In-Reply-To: <20140508121624.4ca87b2c@gandalf.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 12:16 PM, Steven Rostedt wrote:
> On Thu, 08 May 2014 11:31:41 -0400
> Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> On 05/05/2014 11:46 AM, Sasha Levin wrote:
>>>>>>> [ 3589.407670] vfs_read (fs/read_write.c:430)
>>>>>>> [ 3589.407670] SyS_read (fs/read_write.c:568 fs/read_write.c:560)
>>>>>>> [ 3589.407670] tracesys (arch/x86/kernel/entry_64.S:746)
>>>>>>> [ 3589.407670] Code: 85 cd 0c 00 00 48 c7 c1 5c e1 6d ac 48 c7 c2 af 89 6d ac 31 c0 be fa 0b 00 00 48 c7 c7 16 e1 6d ac e8 3c 68 f9 ff e9 a7 0c 00 00 <49> 81 7d 00 80 81 76 ae b8 00 00 00 00 44 0f 44 c0 eb 07 0f 1f
>>>>>>> [ 3589.407670] RIP __lock_acquire (kernel/locking/lockdep.c:3070 (discriminator 1))
>>>>>>> [ 3589.407670]  RSP <ffff88005c9d1c18>
>>>>>>> [ 3589.407670] CR2: 00000000000001f0
>>>>>
>>>>> Is this easily reproducible?
>>> Nope, only saw it once.
>>
>> And a second time today, I guess I could put a debug patch and see if that
>> helps, if you had something in mind...
>>
> 
> All I can think of is to try this:
> 
> -- Steve
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index c634868..7cacbad 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -558,6 +558,10 @@ void ring_buffer_wait(struct ring_buffer *buffer, int cpu)
>  		work = &buffer->irq_work;
>  	else {
>  		cpu_buffer = buffer->buffers[cpu];
> +		if (unlikely(!cpu_buffer)) {
> +			printk("null cpu buffer, %d\n", cpu);
> +			BUG();
> +		}
>  		work = &cpu_buffer->irq_work;
>  	}
>  
> 

Hi Steven,

Yup, it took me *that* long to reproduce it again, but I can confirm that that
BUG() gets hit (the printk shows cpu 30 like the BUG):

[ 2410.677199] kernel BUG at kernel/trace/ring_buffer.c:563!
[ 2410.679445] can: request_module (can-proto-4) failed.
[ 2410.680298] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 2410.680298] Dumping ftrace buffer:
[ 2410.680298]    (ftrace buffer empty)
[ 2410.680298] Modules linked in:
[ 2410.680298] CPU: 30 PID: 34851 Comm: trinity-c88 Not tainted 3.15.0-rc8-next-20140606-sasha-00021-ga9d3a0b-dirty #596
[ 2410.680298] task: ffff8802c866b000 ti: ffff8802c7724000 task.ti: ffff8802c7724000
[ 2410.680298] RIP: ring_buffer_wait (kernel/trace/ring_buffer.c:563)
[ 2410.680298] RSP: 0018:ffff8802c7727de8  EFLAGS: 00010296
[ 2410.680298] RAX: 0000000000000013 RBX: 0000000000000024 RCX: 0000000000000006
[ 2410.680298] RDX: 0000000000000001 RSI: ffffffffad5030db RDI: ffffffffaa1d8952
[ 2410.711484] RBP: ffff8802c7727e38 R08: 0000000000000000 R09: 0000000000000000
[ 2410.711484] R10: 0000000000000001 R11: 0000000000000000 R12: ffff88003681e900
[ 2410.711484] R13: ffff88006ce7d100 R14: 0000000000000000 R15: ffff8800530090fc
[ 2410.721370] FS:  00007f8c14bad700(0000) GS:ffff8806cae00000(0000) knlGS:0000000000000000
[ 2410.721370] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2410.721370] CR2: 00007f8c11440000 CR3: 000000029dd18000 CR4: 00000000000006a0
[ 2410.721370] DR0: 00000000006d6000 DR1: 00000000006d6000 DR2: 0000000000000000
[ 2410.721370] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000600
[ 2410.721370] Stack:
[ 2410.721370]  ffff880053008028 0000000000000000 ffff8802c866b000 ffffffffaa1bb600
[ 2410.721370]  ffff8802c7727e08 ffff8802c7727e08 ffff880053008000 ffff880053008028
[ 2410.721370]  ffff88006ce7d100 ffff8802c866b000 ffff8802c7727e48 ffffffffaa24af8a
[ 2410.721370] Call Trace:
[ 2410.721370] ? bit_waitqueue (kernel/sched/wait.c:291)
[ 2410.721370] wait_on_pipe (kernel/trace/trace.c:1095)
[ 2410.721370] tracing_wait_pipe.isra.19 (kernel/trace/trace.c:4280)
[ 2410.721370] tracing_read_pipe (kernel/trace/trace.c:4326)
[ 2410.721370] vfs_read (fs/read_write.c:430)
[ 2410.721370] SyS_read (fs/read_write.c:568 fs/read_write.c:560)
[ 2410.721370] tracesys (arch/x86/kernel/entry_64.S:542)
[ 2410.721370] Code: ff ff 85 c0 75 5a eb 5d 66 90 48 8b 87 c8 00 00 00 48 63 d6 4c 8b 34 d0 4d 85 f6 75 15 48 c7 c7 6e 96 6f ae 31 c0 e8 7d 8f 2b 03 <0f> 0b 0f 1f 44 00 00 4d 8d ae d8 01 00 00 ba 01 00 00 00 48 8d
All code
========
   0:	ff                   	(bad)
   1:	ff 85 c0 75 5a eb    	incl   -0x14a58a40(%rbp)
   7:	5d                   	pop    %rbp
   8:	66 90                	xchg   %ax,%ax
   a:	48 8b 87 c8 00 00 00 	mov    0xc8(%rdi),%rax
  11:	48 63 d6             	movslq %esi,%rdx
  14:	4c 8b 34 d0          	mov    (%rax,%rdx,8),%r14
  18:	4d 85 f6             	test   %r14,%r14
  1b:	75 15                	jne    0x32
  1d:	48 c7 c7 6e 96 6f ae 	mov    $0xffffffffae6f966e,%rdi
  24:	31 c0                	xor    %eax,%eax
  26:	e8 7d 8f 2b 03       	callq  0x32b8fa8
  2b:*	0f 0b                	ud2    		<-- trapping instruction
  2d:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  32:	4d 8d ae d8 01 00 00 	lea    0x1d8(%r14),%r13
  39:	ba 01 00 00 00       	mov    $0x1,%edx
  3e:	48 8d 00             	lea    (%rax),%rax

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
   7:	4d 8d ae d8 01 00 00 	lea    0x1d8(%r14),%r13
   e:	ba 01 00 00 00       	mov    $0x1,%edx
  13:	48 8d 00             	lea    (%rax),%rax

Thanks,
Sasha
