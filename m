Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbaEGWzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:55:52 -0400
Received: from mail.efficios.com ([78.47.125.74]:42918 "EHLO mail.efficios.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbaEGWzv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:55:51 -0400
Date: Wed, 7 May 2014 22:55:49 +0000 (UTC)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>, Sasha Levin <sasha.levin@oracle.com>
Cc: Oleg Nesterov <oleg@redhat.com>, roland@redhat.com,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Message-ID: <124614658.12792.1399503349815.JavaMail.zimbra@efficios.com>
In-Reply-To: <20140507120627.73dce8e6@gandalf.local.home>
References: <53698021.5020108@oracle.com> <53699F7C.1040308@oracle.com> <20140507140422.GB17419@redhat.com> <20140507103109.77063896@gandalf.local.home> <536A4FF8.4090003@oracle.com> <20140507120627.73dce8e6@gandalf.local.home>
Subject: Re: ptrace: gpf in syscall_trace_enter
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_12790_1315499542.1399503349814"
X-Originating-IP: [206.248.138.119]
X-Mailer: Zimbra 8.0.5_GA_5839 (ZimbraWebClient - FF29 (Linux)/8.0.5_GA_5839)
Thread-Topic: ptrace: gpf in syscall_trace_enter
Thread-Index: LcgZyj1zfDgl+P5EzRp5DhS16FzirA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_12790_1315499542.1399503349814
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

----- Original Message -----
> From: "Steven Rostedt" <rostedt@goodmis.org>
> To: "Sasha Levin" <sasha.levin@oracle.com>
> Cc: "Oleg Nesterov" <oleg@redhat.com>, roland@redhat.com, "LKML" <linux-kernel@vger.kernel.org>, "Dave Jones"
> <davej@redhat.com>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>
> Sent: Wednesday, May 7, 2014 12:06:27 PM
> Subject: Re: ptrace: gpf in syscall_trace_enter
> 
> [ adding Mathieu as well, as this is tracepoint code ]
> 
> On Wed, 07 May 2014 11:23:36 -0400
> Sasha Levin <sasha.levin@oracle.com> wrote:
> 
> > On 05/07/2014 10:31 AM, Steven Rostedt wrote:
> > > On Wed, 7 May 2014 16:04:22 +0200
> > > Oleg Nesterov <oleg@redhat.com> wrote:
> > > 
> > >> On 05/06, Sasha Levin wrote:
> > >>>
> > >>> On 05/06/2014 08:36 PM, Sasha Levin wrote:
> > >>>> Hi all,
> > >>>>
> > >>>> While fuzzing with trinity inside a KVM tools guest running the latest
> > >>>> -next
> > >>>> kernel I've stumbled on the following spew:
> > >>>
> > >>> And another similar trace:
> > >>
> > >> Again, this looks like __DO_TRACE() trying to call it_func_ptr->func().
> > > 
> > > Really? Can I see an objdump of the location of the crash. Preferably
> > > the entire function.
> > 
> > 0000000000002740 <syscall_trace_leave>:
> >     2740:	e8 00 00 00 00       	callq  2745 <syscall_trace_leave+0x5>
> > 			2741: R_X86_64_PC32	__fentry__-0x4
> >     2745:	55                   	push   %rbp
> >     2746:	48 89 e5             	mov    %rsp,%rbp
> >     2749:	48 83 ec 20          	sub    $0x20,%rsp
> >     274d:	48 89 5d e8          	mov    %rbx,-0x18(%rbp)
> >     2751:	48 89 fb             	mov    %rdi,%rbx
> >     2754:	4c 89 65 f0          	mov    %r12,-0x10(%rbp)
> >     2758:	4c 89 6d f8          	mov    %r13,-0x8(%rbp)
> >     275c:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
> >     2761:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
> >     2768:	00 00
> > 			2766: R_X86_64_32S	current_task
> >     276a:	48 83 b8 b8 0b 00 00 	cmpq   $0x0,0xbb8(%rax)
> >     2771:	00
> >     2772:	74 1c                	je     2790 <syscall_trace_leave+0x50>
> >     2774:	48 8b 73 50          	mov    0x50(%rbx),%rsi
> >     2778:	31 ff                	xor    %edi,%edi
> >     277a:	48 81 fe 00 f0 ff ff 	cmp    $0xfffffffffffff000,%rsi
> >     2781:	40 0f 96 c7          	setbe  %dil
> >     2785:	e8 00 00 00 00       	callq  278a <syscall_trace_leave+0x4a>
> > 			2786: R_X86_64_PC32	__audit_syscall_exit-0x4
> >     278a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
> >     2790:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
> >     2797:	00 00
> > 			2795: R_X86_64_32S	kernel_stack
> >     2799:	48 8b 80 38 e0 ff ff 	mov    -0x1fc8(%rax),%rax
> >     27a0:	a9 00 00 00 10       	test   $0x10000000,%eax
> >     27a5:	74 71                	je     2818 <syscall_trace_leave+0xd8>
> >     27a7:	4c 8b 6b 50          	mov    0x50(%rbx),%r13
> >     27ab:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
> 
> Here's the static_key branch
> 
> >     27b0:	eb 62                	jmp    2814 <syscall_trace_leave+0xd4>
> >     27b2:	80 3d 00 00 00 00 00 	cmpb   $0x0,0x0(%rip)        # 27b9
> >     <syscall_trace_leave+0x79>
> > 			27b4: R_X86_64_PC32	.data.unlikely-0x4
> >     27b9:	75 28                	jne    27e3 <syscall_trace_leave+0xa3>
> >     27bb:	e8 00 00 00 00       	callq  27c0 <syscall_trace_leave+0x80>
> > 			27bc: R_X86_64_PC32	.text.unlikely-0x4
> 
> Interesting that we have a "callq" to the next instruction.
> 
> >     27c0:	85 c0                	test   %eax,%eax
> >     27c2:	75 1f                	jne    27e3 <syscall_trace_leave+0xa3>
> >     27c4:	48 c7 c2 00 00 00 00 	mov    $0x0,%rdx
> > 			27c7: R_X86_64_32S	.rodata.str1.8+0x60
> >     27cb:	be 3e 00 00 00       	mov    $0x3e,%esi
> >     27d0:	48 c7 c7 00 00 00 00 	mov    $0x0,%rdi
> > 			27d3: R_X86_64_32S	.rodata.str1.8+0x90
> >     27d7:	c6 05 00 00 00 00 01 	movb   $0x1,0x0(%rip)        # 27de
> >     <syscall_trace_leave+0x9e>
> > 			27d9: R_X86_64_PC32	.data.unlikely-0x4
> >     27de:	e8 00 00 00 00       	callq  27e3 <syscall_trace_leave+0xa3>
> > 			27df: R_X86_64_PC32	lockdep_rcu_suspicious-0x4
> 
> OK, rcu debugging is on. Not really a factor, just making notes.
> 
> 
> >     27e3:	4d 85 e4             	test   %r12,%r12
> 
> %r12 is the it_func_ptr
> 
> >     27e6:	75 10                	jne    27f8 <syscall_trace_leave+0xb8>
> >     27e8:	65 ff 0c 25 00 00 00 	decl   %gs:0x0
> >     27ef:	00
> > 			27ec: R_X86_64_32S	__preempt_count
> >     27f0:	0f 84 85 00 00 00    	je     287b <syscall_trace_leave+0x13b>
> >     27f6:	eb 1c                	jmp    2814 <syscall_trace_leave+0xd4>
> >     27f8:	49 8b 7c 24 08       	mov    0x8(%r12),%rdi
> >     27fd:	4c 89 ea             	mov    %r13,%rdx
> >     2800:	48 89 de             	mov    %rbx,%rsi
> >     2803:	41 ff 14 24          	callq  *(%r12)
> 
> As I stated, I didn't need the offset that I asked for, but the
> machine code had the information I needed:
> 
> 24 08 4c 89 ea 48 89 de <41> ff 14 24 49 83 c4 10 49
> 
> Which matches 2803.
> 
> From your dump:
> 
>  R10: 0000000000000000 R11: 0000000000000000 R12: 000000000000000c
> 
> Yeah, that's a bad pointer.
> 
> OK, for some reason, funcs got 0xc?

Oh crap, I think I made a stupid mistake there. Calling call_rcu to free
the old func before rcu_assign_pointer publishes the new func. Can you try
the attached patch ? (sorry for no inlining, using a dumb mail client here)

Thanks,

Mathieu

> 
> -- Steve
> 
> 
> >     2807:	49 83 c4 10          	add    $0x10,%r12
> >     280b:	49 83 3c 24 00       	cmpq   $0x0,(%r12)
> >     2810:	75 e6                	jne    27f8 <syscall_trace_leave+0xb8>
> >     2812:	eb d4                	jmp    27e8 <syscall_trace_leave+0xa8>
> >     2814:	0f 1f 40 00          	nopl   0x0(%rax)
> >     2818:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
> >     281f:	00 00
> > 			281d: R_X86_64_32S	kernel_stack
> >     2821:	48 8b 90 38 e0 ff ff 	mov    -0x1fc8(%rax),%rdx
> >     2828:	83 e2 10             	and    $0x10,%edx
> >     282b:	74 5b                	je     2888 <syscall_trace_leave+0x148>
> >     282d:	48 8b 80 38 e0 ff ff 	mov    -0x1fc8(%rax),%rax
> >     2834:	a8 40                	test   $0x40,%al
> >     2836:	75 50                	jne    2888 <syscall_trace_leave+0x148>
> >     2838:	be 01 00 00 00       	mov    $0x1,%esi
> >     283d:	0f 1f 00             	nopl   (%rax)
> >     2840:	48 89 df             	mov    %rbx,%rdi
> >     2843:	e8 f8 fa ff ff       	callq  2340 <tracehook_report_syscall_exit>
> >     2848:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
> >     284d:	eb 56                	jmp    28a5 <syscall_trace_leave+0x165>
> >     284f:	90                   	nop
> >     2850:	e8 00 00 00 00       	callq  2855 <syscall_trace_leave+0x115>
> > 			2851: R_X86_64_PC32	context_tracking_user_exit-0x4
> >     2855:	e9 07 ff ff ff       	jmpq   2761 <syscall_trace_leave+0x21>
> >     285a:	65 ff 04 25 00 00 00 	incl   %gs:0x0
> >     2861:	00
> > 			285e: R_X86_64_32S	__preempt_count
> >     2862:	4c 8b 25 00 00 00 00 	mov    0x0(%rip),%r12        # 2869
> >     <syscall_trace_leave+0x129>
> > 			2865: R_X86_64_PC32	__tracepoint_sys_exit+0x2c
> >     2869:	e8 00 00 00 00       	callq  286e <syscall_trace_leave+0x12e>
> > 			286a: R_X86_64_PC32	debug_lockdep_rcu_enabled-0x4
> >     286e:	85 c0                	test   %eax,%eax
> >     2870:	0f 85 3c ff ff ff    	jne    27b2 <syscall_trace_leave+0x72>
> >     2876:	e9 68 ff ff ff       	jmpq   27e3 <syscall_trace_leave+0xa3>
> >     287b:	e8 00 00 00 00       	callq  2880 <syscall_trace_leave+0x140>
> > 			287c: R_X86_64_PC32	___preempt_schedule_context-0x4
> >     2880:	eb 96                	jmp    2818 <syscall_trace_leave+0xd8>
> >     2882:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)
> >     2888:	65 48 8b 04 25 00 00 	mov    %gs:0x0,%rax
> >     288f:	00 00
> > 			288d: R_X86_64_32S	kernel_stack
> >     2891:	48 8b 80 38 e0 ff ff 	mov    -0x1fc8(%rax),%rax
> >     2898:	31 f6                	xor    %esi,%esi
> >     289a:	a8 01                	test   $0x1,%al
> >     289c:	75 a2                	jne    2840 <syscall_trace_leave+0x100>
> >     289e:	eb a8                	jmp    2848 <syscall_trace_leave+0x108>
> >     28a0:	e8 00 00 00 00       	callq  28a5 <syscall_trace_leave+0x165>
> > 			28a1: R_X86_64_PC32	context_tracking_user_enter-0x4
> >     28a5:	48 8b 5d e8          	mov    -0x18(%rbp),%rbx
> >     28a9:	4c 8b 65 f0          	mov    -0x10(%rbp),%r12
> >     28ad:	4c 8b 6d f8          	mov    -0x8(%rbp),%r13
> >     28b1:	c9                   	leaveq
> >     28b2:	c3                   	retq
> > 
> > 
> > Thanks,
> > Sasha
> 
> 

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

------=_Part_12790_1315499542.1399503349814
Content-Type: text/x-patch; name=fix-tp-release-probe.patch
Content-Disposition: attachment; filename=fix-tp-release-probe.patch
Content-Transfer-Encoding: base64

Y29tbWl0IDEzYzhiZGE1MTU0NjY1ZjQ0OTliMzEwMzBkNzQ2NjUyMDcwMjVkMjQKQXV0aG9yOiBN
YXRoaWV1IERlc25veWVycyA8bWF0aGlldS5kZXNub3llcnNAZWZmaWNpb3MuY29tPgpEYXRlOiAg
IFdlZCBNYXkgNyAxODo0ODo1MyAyMDE0IC0wNDAwCgogICAgRml4OiB0cmFjZXBvaW50OiByZWxl
YXNlIG9sZCBwcm9iZSBhZnRlciByY3UgYXNzaWduIHBvaW50ZXIKICAgIAogICAgU2lnbmVkLW9m
Zi1ieTogTWF0aGlldSBEZXNub3llcnMgPG1hdGhpZXUuZGVzbm95ZXJzQGVmZmljaW9zLmNvbT4K
CmRpZmYgLS1naXQgYS9rZXJuZWwvdHJhY2Vwb2ludC5jIGIva2VybmVsL3RyYWNlcG9pbnQuYwpp
bmRleCBhYzViMjNjLi42NjIwZTU4IDEwMDY0NAotLS0gYS9rZXJuZWwvdHJhY2Vwb2ludC5jCisr
KyBiL2tlcm5lbC90cmFjZXBvaW50LmMKQEAgLTE4OCw3ICsxODgsNiBAQCBzdGF0aWMgaW50IHRy
YWNlcG9pbnRfYWRkX2Z1bmMoc3RydWN0IHRyYWNlcG9pbnQgKnRwLAogCQlXQVJOX09OX09OQ0Uo
MSk7CiAJCXJldHVybiBQVFJfRVJSKG9sZCk7CiAJfQotCXJlbGVhc2VfcHJvYmVzKG9sZCk7CiAK
IAkvKgogCSAqIHJjdV9hc3NpZ25fcG9pbnRlciBoYXMgYSBzbXBfd21iKCkgd2hpY2ggbWFrZXMg
c3VyZSB0aGF0IHRoZSBuZXcKQEAgLTIwMCw2ICsxOTksNyBAQCBzdGF0aWMgaW50IHRyYWNlcG9p
bnRfYWRkX2Z1bmMoc3RydWN0IHRyYWNlcG9pbnQgKnRwLAogCXJjdV9hc3NpZ25fcG9pbnRlcih0
cC0+ZnVuY3MsIHRwX2Z1bmNzKTsKIAlpZiAoIXN0YXRpY19rZXlfZW5hYmxlZCgmdHAtPmtleSkp
CiAJCXN0YXRpY19rZXlfc2xvd19pbmMoJnRwLT5rZXkpOworCXJlbGVhc2VfcHJvYmVzKG9sZCk7
CiAJcmV0dXJuIDA7CiB9CiAKQEAgLTIyMSw3ICsyMjEsNiBAQCBzdGF0aWMgaW50IHRyYWNlcG9p
bnRfcmVtb3ZlX2Z1bmMoc3RydWN0IHRyYWNlcG9pbnQgKnRwLAogCQlXQVJOX09OX09OQ0UoMSk7
CiAJCXJldHVybiBQVFJfRVJSKG9sZCk7CiAJfQotCXJlbGVhc2VfcHJvYmVzKG9sZCk7CiAKIAlp
ZiAoIXRwX2Z1bmNzKSB7CiAJCS8qIFJlbW92ZWQgbGFzdCBmdW5jdGlvbiAqLwpAQCAtMjMyLDYg
KzIzMSw3IEBAIHN0YXRpYyBpbnQgdHJhY2Vwb2ludF9yZW1vdmVfZnVuYyhzdHJ1Y3QgdHJhY2Vw
b2ludCAqdHAsCiAJCQlzdGF0aWNfa2V5X3Nsb3dfZGVjKCZ0cC0+a2V5KTsKIAl9CiAJcmN1X2Fz
c2lnbl9wb2ludGVyKHRwLT5mdW5jcywgdHBfZnVuY3MpOworCXJlbGVhc2VfcHJvYmVzKG9sZCk7
CiAJcmV0dXJuIDA7CiB9CiAK
------=_Part_12790_1315499542.1399503349814--
