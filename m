Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbaEGTvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 15:51:33 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:54988 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaEGTvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 15:51:31 -0400
X-Google-Original-From: Andy Lutomirski <luto@mit.edu>
Message-ID: <536A8EC0.1070308@mit.edu>
Date: Wed, 07 May 2014 12:51:28 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Sasha Levin <sasha.levin@oracle.com>
CC: Oleg Nesterov <oleg@redhat.com>, roland@redhat.com,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: ptrace: gpf in syscall_trace_enter
References: <53698021.5020108@oracle.com>	<53699F7C.1040308@oracle.com>	<20140507140422.GB17419@redhat.com>	<20140507103109.77063896@gandalf.local.home>	<536A4FF8.4090003@oracle.com> <20140507120627.73dce8e6@gandalf.local.home>
In-Reply-To: <20140507120627.73dce8e6@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 09:06 AM, Steven Rostedt wrote:
> [ adding Mathieu as well, as this is tracepoint code ]
> 
> On Wed, 07 May 2014 11:23:36 -0400
> Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> On 05/07/2014 10:31 AM, Steven Rostedt wrote:
>>> On Wed, 7 May 2014 16:04:22 +0200
>>> Oleg Nesterov <oleg@redhat.com> wrote:
>>>
>>>> On 05/06, Sasha Levin wrote:
>>>>>
>>>>> On 05/06/2014 08:36 PM, Sasha Levin wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> While fuzzing with trinity inside a KVM tools guest running the latest -next
>>>>>> kernel I've stumbled on the following spew:
>>>>>
>>>>> And another similar trace:
>>>>
>>>> Again, this looks like __DO_TRACE() trying to call it_func_ptr->func().
>>>
>>> Really? Can I see an objdump of the location of the crash. Preferably
>>> the entire function.
>>
>> 0000000000002740 <syscall_trace_leave>:
>>     2740:	e8 00 00 00 00       	callq  2745 <syscall_trace_leave+0x5>
>> 			2741: R_X86_64_PC32	__fentry__-0x4
>>     2745:	55                   	push   %rbp
>>     2746:	48 89 e5             	mov    %rsp,%rbp
>>     2749:	48 83 ec 20          	sub    $0x20,%rsp
>>     274d:	48 89 5d e8          	mov    %rbx,-0x18(%rbp)
>>     2751:	48 89 fb             	mov    %rdi,%rbx
>>     2754:	4c 89 65 f0          	mov    %r12,-0x10(%rbp)
>>     2758:	4c 89 6d f8          	mov    %r13,-0x8(%rbp)
>>     275c:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
>>     2761:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
>>     2768:	00 00
>> 			2766: R_X86_64_32S	current_task
>>     276a:	48 83 b8 b8 0b 00 00 	cmpq   $0x0,0xbb8(%rax)
>>     2771:	00
>>     2772:	74 1c                	je     2790 <syscall_trace_leave+0x50>
>>     2774:	48 8b 73 50          	mov    0x50(%rbx),%rsi
>>     2778:	31 ff                	xor    %edi,%edi
>>     277a:	48 81 fe 00 f0 ff ff 	cmp    $0xfffffffffffff000,%rsi
>>     2781:	40 0f 96 c7          	setbe  %dil
>>     2785:	e8 00 00 00 00       	callq  278a <syscall_trace_leave+0x4a>
>> 			2786: R_X86_64_PC32	__audit_syscall_exit-0x4
>>     278a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
>>     2790:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
>>     2797:	00 00
>> 			2795: R_X86_64_32S	kernel_stack
>>     2799:	48 8b 80 38 e0 ff ff 	mov    -0x1fc8(%rax),%rax
>>     27a0:	a9 00 00 00 10       	test   $0x10000000,%eax
>>     27a5:	74 71                	je     2818 <syscall_trace_leave+0xd8>
>>     27a7:	4c 8b 6b 50          	mov    0x50(%rbx),%r13
>>     27ab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
> 
> Here's the static_key branch
> 
>>     27b0:	eb 62                	jmp    2814 <syscall_trace_leave+0xd4>
>>     27b2:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 27b9 <syscall_trace_leave+0x79>
>> 			27b4: R_X86_64_PC32	.data.unlikely-0x4
>>     27b9:	75 28                	jne    27e3 <syscall_trace_leave+0xa3>
>>     27bb:	e8 00 00 00 00       	callq  27c0 <syscall_trace_leave+0x80>
>> 			27bc: R_X86_64_PC32	.text.unlikely-0x4
> 
> Interesting that we have a "callq" to the next instruction.

I think this is just unrelocated output, presumably from objdump -dr
something.o.  objdump -d vmlinux will give better output.

--Andy, who got confused by exactly the same thing while debugging the vdso
