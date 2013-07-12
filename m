Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933297Ab3GLPsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:48:19 -0400
Received: from smtp.opengridcomputing.com ([72.48.136.20]:33220 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933072Ab3GLPsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:48:17 -0400
Message-ID: <51E02545.7080106@opengridcomputing.com>
Date: Fri, 12 Jul 2013 10:48:21 -0500
From: Steve Wise <swise@opengridcomputing.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Oops mystery
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello kernel experts,

I was wondering if someone has any ideas on this Oops.  My analysis must 
be incorrect.  From what I can tell, this shouldn't have caused a bad 
page fault, but it did :).

Here is what I see in the crash dump:

dmesg log shows this:

[ 1053.156266] BUG: unable to handle kernel paging request at 
0000000000040fc0
[ 1053.216620] IP: [<ffffffffa02b202e>] c4iw_ev_handler+0x2e/0x84 [iw_cxgb4]
[ 1053.216638] PGD 8b9877067 PUD 86cd37067 PMD 0
[ 1053.216642] Oops: 0002 [#1] SMP

c4iw_ev_handler+0x2e is:

crash> dis -r c4iw_ev_handler+0x2e
0xffffffffa02b2000 <c4iw_ev_handler>:   push   %rbp
0xffffffffa02b2001 <c4iw_ev_handler+1>: push   %rbx
0xffffffffa02b2002 <c4iw_ev_handler+2>: sub $0x8,%rsp
0xffffffffa02b2006 <c4iw_ev_handler+6>: mov %rdi,%rbp
0xffffffffa02b2009 <c4iw_ev_handler+9>: mov %esi,%ebx
0xffffffffa02b200b <c4iw_ev_handler+11>: lea    0x8a0(%rdi),%rdi
0xffffffffa02b2012 <c4iw_ev_handler+18>: callq  0xffffffff811e1020 
<idr_find>
0xffffffffa02b2017 <c4iw_ev_handler+23>: mov    %rax,%rcx
0xffffffffa02b201a <c4iw_ev_handler+26>: test   %rax,%rax
0xffffffffa02b201d <c4iw_ev_handler+29>: je     0xffffffffa02b203d 
<c4iw_ev_handler+61>
0xffffffffa02b201f <c4iw_ev_handler+31>: movzwl 0x88(%rax),%eax
0xffffffffa02b2026 <c4iw_ev_handler+38>: mov    0x38(%rcx),%rdx
0xffffffffa02b202a <c4iw_ev_handler+42>: shl    $0x6,%rax
0xffffffffa02b202e <c4iw_ev_handler+46>:        movb   $0x0,0xe(%rax,%rdx,1)

Crash shows these regs:

crash> bt
PID: 12915  TASK: ffff8808d50da200  CPU: 4   COMMAND: "DSI_SvrReceiveR"
  #0 [ffff880751c039b0] machine_kexec at ffffffff81020a62
  #1 [ffff880751c03a00] crash_kexec at ffffffff81088780
  #2 [ffff880751c03ad0] oops_end at ffffffff8139efe0
  #3 [ffff880751c03af0] __bad_area_nosemaphore at ffffffff8102ed15
  #4 [ffff880751c03bb0] page_fault at ffffffff8139e25f
     [exception RIP: c4iw_ev_handler+46]
     RIP: ffffffffa02b202e  RSP: ffff880751c03c60  RFLAGS: 00010206
     RAX: 0000000000040fc0 RBX: 0000000000000404  RCX: ffff880c35da9080
     RDX: ffff8808b5500000 RSI: 0000000000000404  RDI: ffff8808d5fabd50
     RBP: ffff880c2e5a4000   R8: 0000000000000000   R9: ffff8808d5fabb30
     R10: 0000000000000110  R11: ffffffff8101f9b0  R12: 0000000000000000
     R13: ffff880c20598230  R14: ffff880c2e5a4000  R15: ffff880c3dbf1480
     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
<snip>

So 'movb   $0x0,0xe(%rax,%rdx,1)' should be storing 0 into the byte 
location:

%rax + 0xe + (%rdx * 1) ==
0x40fc+ 0xe + 0xffff8808b5500000 ==
0xffff8808b5540fce.

That address is readable in the crash dump:

crash> x/8b 0x0000000000040fc0+0xe+0xffff8808b5500000
0xffff8808b5540fce:     0x00    0x00    0x00    0x00    0x00 0x00    
0x00    0x00

And why does the page fault show 0x40fc0 as the faulting address?  It 
should be 0xffff8808b5540fce and it shouldn't have caused a page fault.

What am I missing?

Thanks in advance,

Steve.
