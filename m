Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab3DLTdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 15:33:22 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:46548 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab3DLTdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 15:33:20 -0400
MIME-Version: 1.0
In-Reply-To: <1365757243.17140.28.camel@laptop>
References: <CA+ydwtrhpd2C3sK6B49qdoWg-k97gBXFDgnKXY2Mcb_wSsMiXQ@mail.gmail.com>
	<1365757243.17140.28.camel@laptop>
Date: Fri, 12 Apr 2013 22:33:19 +0300
Message-ID: <CA+ydwtp_V68B3oqJ-mTioWCEipKenmfkTd3_NPA7of6uQW3+1A@mail.gmail.com>
Subject: Re: sw_perf_event_destroy() oops while fuzzing
From: Tommi Rantala <tt.rantala@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/12 Peter Zijlstra <a.p.zijlstra@chello.nl>:
> On Fri, 2013-04-12 at 08:34 +0300, Tommi Rantala wrote:
>
>> [92759.011005] RIP  [<ffffffff811a7200>] sw_perf_event_destroy+0x30/0x90
>
>> [114607.070003] RIP: 0010:[<ffffffff811a7200>]  [<ffffffff811a7200>]
>> sw_perf_event_destroy+0x30/0x90
>
>> [114607.070003] RIP  [<ffffffff811a7200>] sw_perf_event_destroy+0x30/0x90
>
> Would you have a source line for me that goes with that.. I can't seem
> to poke any holes just by looking.

It is crashing at:
   0xffffffff811a7200 <+48>:    lock decl -0x7c3c9680(,%r12,4)

Matching source line is:
    static_key_slow_dec(&perf_swevent_enabled[event_id]);

-0x7c3c9680 is the address of perf_swevent_enabled[],
and %r12 is 0x00000000ffffff4c in the first oops.

So it looks like event_id is invalid.

(gdb) disassemble sw_perf_event_destroy
Dump of assembler code for function sw_perf_event_destroy:
   0xffffffff811a71d0 <+0>:     push   %rbp
   0xffffffff811a71d1 <+1>:     mov    %rsp,%rbp
   0xffffffff811a71d4 <+4>:     push   %r12
   0xffffffff811a71d6 <+6>:     push   %rbx
   0xffffffff811a71d7 <+7>:     cmpq   $0x0,0x288(%rdi)
   0xffffffff811a71df <+15>:    mov    %rdi,%rbx
   0xffffffff811a71e2 <+18>:    mov    0xa8(%rdi),%r12
   0xffffffff811a71e9 <+25>:    je     0xffffffff811a7200
<sw_perf_event_destroy+48>
   0xffffffff811a71eb <+27>:    mov    $0x14cd,%esi
   0xffffffff811a71f0 <+32>:    mov    $0xffffffff829c3e50,%rdi
   0xffffffff811a71f7 <+39>:    callq  0xffffffff810f0b10 <warn_slowpath_null>
   0xffffffff811a71fc <+44>:    nopl   0x0(%rax)
   0xffffffff811a7200 <+48>:    lock decl -0x7c3c9680(,%r12,4)
   0xffffffff811a7209 <+57>:    mov    0x294(%rbx),%edi
   0xffffffff811a720f <+63>:    cmp    $0xffffffff,%edi
   0xffffffff811a7212 <+66>:    jne    0xffffffff811a7220
<sw_perf_event_destroy+80>
   0xffffffff811a7214 <+68>:    mov    0x127ea5d(%rip),%r12        #
0xffffffff82425c78 <cpu_possible_mask>
   0xffffffff811a721b <+75>:    mov    %edi,%ebx
   0xffffffff811a721d <+77>:    jmp    0xffffffff811a7237
<sw_perf_event_destroy+103>
   0xffffffff811a721f <+79>:    nop
   0xffffffff811a7220 <+80>:    callq  0xffffffff811a7170
<swevent_hlist_put_cpu>
   0xffffffff811a7225 <+85>:    jmp    0xffffffff811a7254
<sw_perf_event_destroy+132>
   0xffffffff811a7227 <+87>:    nopw   0x0(%rax,%rax,1)
   0xffffffff811a7230 <+96>:    mov    %eax,%edi
   0xffffffff811a7232 <+98>:    callq  0xffffffff811a7170
<swevent_hlist_put_cpu>
   0xffffffff811a7237 <+103>:   add    $0x1,%ebx
   0xffffffff811a723a <+106>:   mov    $0x40,%esi
   0xffffffff811a723f <+111>:   mov    %r12,%rdi
   0xffffffff811a7242 <+114>:   movslq %ebx,%rdx
   0xffffffff811a7245 <+117>:   callq  0xffffffff814c63f0
<find_next_bit>
   0xffffffff811a724a <+122>:   cmp    0x1c6d9f4(%rip),%eax        #
0xffffffff82e14c44 <nr_cpu_ids>
   0xffffffff811a7250 <+128>:   mov    %eax,%ebx
   0xffffffff811a7252 <+130>:   jl     0xffffffff811a7230
<sw_perf_event_destroy+96>
   0xffffffff811a7254 <+132>:   pop    %rbx
   0xffffffff811a7255 <+133>:   pop    %r12
   0xffffffff811a7257 <+135>:   pop    %rbp
   0xffffffff811a7258 <+136>:   retq
End of assembler dump.

(gdb) list *0xffffffff811a7200
0xffffffff811a7200 is in sw_perf_event_destroy
(/home/ttrantal/git/linux/arch/x86/include/asm/atomic.h:107).
102      *
103      * Atomically decrements @v by 1.
104      */
105     static inline void atomic_dec(atomic_t *v)
106     {
107             asm volatile(LOCK_PREFIX "decl %0"
108                          : "+m" (v->counter));
109     }
110
111     /**

(gdb) print &perf_swevent_enabled
$2 = (struct static_key (*)[9]) 0xffffffff83c36980 <perf_swevent_enabled>

> perf_swevent_init() only sets event->destroy() (to
> sw_perf_event_destroy) _after_ it increments the static key thing and
> enqueues (and allocates) the hash list stuff.
>
> Obviously something is funny, but I'm not seeing it.

Might this help... ? (untested)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 59412d0..fff6420 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5330,7 +5330,7 @@ static void sw_perf_event_destroy(struct
perf_event *event)

 static int perf_swevent_init(struct perf_event *event)
 {
-       int event_id = event->attr.config;
+       u64 event_id = event->attr.config;

        if (event->attr.type != PERF_TYPE_SOFTWARE)
                return -ENOENT;
