Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbaJBPEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 11:04:53 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:43227 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaJBPEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 11:04:52 -0400
Message-ID: <542D6981.3080405@oracle.com>
Date: Thu, 02 Oct 2014 11:04:33 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Michel Lespinasse <walken@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: pipe/page fault oddness.
References: <20140930033327.GA14558@redhat.com>	<CA+55aFwmo7ot=h7tpUYhSC49CHKBK2KfGaDJ_fwB0=VNqvTPBQ@mail.gmail.com>	<20140930043309.GA16196@redhat.com>	<CA+55aFwxdOBKHwwp7Zq1k19mHCyHYmYqigCVt59AtB-P7Zva1w@mail.gmail.com>	<CA+55aFynr-Abo_JY1=GGOf9e2tjJvexbX2kVTgD0bkq7BXacJw@mail.gmail.com>	<20140930160510.GA15903@redhat.com>	<CA+55aFzTEXxxh_4_BwVydw1UgCu-NRF95OrzVhj=cievXFTJTg@mail.gmail.com>	<20140930162201.GC15903@redhat.com>	<20140930164047.GA18354@redhat.com>	<CA+55aFzKgJ41Mp=Ub8Kq_uFDHYzkHo3zhO3MHOJo_O2iExdYmQ@mail.gmail.com>	<20140930182059.GA24431@redhat.com>	<CA+55aFzfvXHd2LUhQ5OiV1H1Oq2y3PL8hX_Hrv-C907PyDNugA@mail.gmail.com>	<alpine.LSU.2.11.1410010031070.1902@eggly.anvils>	<CA+55aFyJ09+iv2HX1nfAaDi0-7=L3KxKi11CACbM8K_Coo6kzg@mail.gmail.com>	<CA+55aFzHgemAV7igyG=0pmctTaV7cZfO4fdqukhrCc8VXTrZuw@mail.gmail.com>	<CA+55aFzisEwtcBA93Xo74RM-6X9V=_go=YhN7eFJOHLeHs3HEQ@mail.gmail.com>	<542C7B5E.2020000@oracle.com> <CA+55aFy7Y+pmhyEHTJg=K8gLKzLHxzz6j9FBJMt7_Fazfong6g@mail.gm!
 ail.com>
In-Reply-To: <CA+55aFy7Y+pmhyEHTJg=K8gLKzLHxzz6j9FBJMt7_Fazfong6g@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 06:42 PM, Linus Torvalds wrote:
> On Wed, Oct 1, 2014 at 3:08 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> >
>> > I've tried this patch on the same configuration that was triggering
>> > the VM_BUG_ON that Hugh mentioned previously. Surprisingly enough it
>> > ran fine for ~20 minutes before exploding with:
> Well, that's somewhat encouraging. I didn't expect it to be perfect.
> 
> That said, "ran fine" isn't necessarily the same thing as "worked".
> Who knows how buggy it was without showing overt symptoms until the
> BUG_ON() triggered. But hey, I'll be optimistic.
> 
>> > [ 2781.566206] kernel BUG at mm/huge_memory.c:1293!
> So that's
> 
>         BUG_ON(is_huge_zero_page(page));
> 
> and the reason is trivial: the old code used to have a magical special
> case for the zero-page hugepage (see change_huge_pmd()) and I got rid
> of that (because now it's just about setting protections, and the
> zero-page hugepage is in no way special.
> 
> So I think the solution is equally trivial: just accept that the
> zero-page can happen, and ignore it (just un-numa it).
> 
> Appended is a incremental diff on top of the previous one. Even less
> tested than the last case, but I think you get the idea if it doesn't
> work as-is.

I have a new one for you. I know it doesn't say "numa" anywhere, but I
haven't ever seen that trace before so I'll just go ahead and blame it
on your patch...

[ 2838.403382] BUG: unable to handle kernel paging request at 000000055d996e80
[ 2838.405740] IP: task_curr (kernel/sched/core.c:1010)
[ 2838.407076] PGD dba2c6067 PUD 0
[ 2838.407926] Thread overran stack, or stack corrupted
[ 2838.409093] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[ 2838.411454] Dumping ftrace buffer:
[ 2838.412602]    (ftrace buffer empty)
[ 2838.413187] Modules linked in:
[ 2838.413187] CPU: 38 PID: 9342 Comm: trinity-c38 Not tainted 3.17.0-rc7-sasha-00041-g6c9c81b #1260
[ 2838.413187] task: ffff880dba2f0000 ti: ffff880dba2ec000 task.ti: ffff880dba2ec000
[ 2838.413187] RIP: task_curr (kernel/sched/core.c:1010)
[ 2838.413187] RSP: 0018:ffff880dba2ebf48  EFLAGS: 00010046
[ 2838.413187] RAX: 000000000000f080 RBX: ffff880dba2f0000 RCX: 000000000000000a
[ 2838.413187] RDX: 00000000ba1a9560 RSI: ffff880dba2f0000 RDI: ffff880dba2f0000
[ 2838.413187] RBP: ffff880dba2ebf98 R08: 000000000004862a R09: 0000000000000000
[ 2838.413187] R10: 0000000000000038 R11: 000000000000001f R12: ffff880dba2f0000
[ 2838.413187] R13: ffff880dd5420740 R14: 000000000000000b R15: ffffffff8cc92000
[ 2838.413187] FS:  00007f05f3dbc700(0000) GS:ffff880701e00000(0000) knlGS:0000000000000000
[ 2838.413187] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2838.413187] CR2: 000000055d996e80 CR3: 0000000dba2c5000 CR4: 00000000000006a0
[ 2838.413187] DR0: 00000000006ee000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2838.413187] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000090602
[ 2838.413187] Stack:
[ 2838.413187]  ffffffff8816218b 0000000000000000 ffff880d0000000a 000000000000000b
[ 2838.413187]  0000000000000082 ffff880dba2f0000 000000000000000b ffff880dba2ec070
[ 2838.413187]  0000000000000000 ffffffff8cc92000 ffff880dba2ebff8 ffffffff88162a84
[ 2838.413187] Call Trace:
[ 2838.413187]  <UNK>
[ 2838.413187] Code: 87 60 09 00 00 01 e8 8d ee ff ff 5d c3 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 57 08 55 48 c7 c0 80 f0 00 00 48 89 e5 5d 8b 52 18 <48> 8b 14 d5 80 c3 c4 8c 48 39 bc 10 68 09 00 00 0f 94 c0 0f b6
All code
========
   0:	87 60 09             	xchg   %esp,0x9(%rax)
   3:	00 00                	add    %al,(%rax)
   5:	01 e8                	add    %ebp,%eax
   7:	8d                   	(bad)
   8:	ee                   	out    %al,(%dx)
   9:	ff                   	(bad)
   a:	ff 5d c3             	lcallq *-0x3d(%rbp)
   d:	66 66 2e 0f 1f 84 00 	data32 nopw %cs:0x0(%rax,%rax,1)
  14:	00 00 00 00
  18:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1c:	55                   	push   %rbp
  1d:	48 c7 c0 80 f0 00 00 	mov    $0xf080,%rax
  24:	48 89 e5             	mov    %rsp,%rbp
  27:	5d                   	pop    %rbp
  28:	8b 52 18             	mov    0x18(%rdx),%edx
  2b:*	48 8b 14 d5 80 c3 c4 	mov    -0x733b3c80(,%rdx,8),%rdx		<-- trapping instruction
  32:	8c
  33:	48 39 bc 10 68 09 00 	cmp    %rdi,0x968(%rax,%rdx,1)
  3a:	00
  3b:	0f 94 c0             	sete   %al
  3e:	0f b6 00             	movzbl (%rax),%eax

Code starting with the faulting instruction
===========================================
   0:	48 8b 14 d5 80 c3 c4 	mov    -0x733b3c80(,%rdx,8),%rdx
   7:	8c
   8:	48 39 bc 10 68 09 00 	cmp    %rdi,0x968(%rax,%rdx,1)
   f:	00
  10:	0f 94 c0             	sete   %al
  13:	0f b6 00             	movzbl (%rax),%eax
[ 2838.413187] RIP task_curr (kernel/sched/core.c:1010)
[ 2838.413187]  RSP <ffff880dba2ebf48>
[ 2838.413187] CR2: 000000055d996e80


Thanks,
Sasha
