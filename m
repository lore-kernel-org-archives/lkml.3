Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284AbaFQEBb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 00:01:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:65393 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755219AbaFQEB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 00:01:29 -0400
Date: Tue, 17 Jun 2014 00:01:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Hagen Paul Pfeifer <hagen@jauu.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include: kernel.h: rewrite min3, max3 and clamp using
 min and max
Message-ID: <20140617000126.566a1aa7@gandalf.local.home>
In-Reply-To: <20140616202120.27364ed9@gandalf.local.home>
References: <1402952842-12886-1-git-send-email-mina86@mina86.com>
	<20140616161804.bb06ed842f59371c031d1252@linux-foundation.org>
	<alpine.DEB.2.02.1406161621530.21018@chino.kir.corp.google.com>
	<20140616163525.46933b64320e220a6d806bb4@linux-foundation.org>
	<alpine.DEB.2.02.1406161652490.21018@chino.kir.corp.google.com>
	<20140616202120.27364ed9@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014 20:21:20 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Mon, 16 Jun 2014 16:54:32 -0700 (PDT)
> David Rientjes <rientjes@google.com> wrote:
> 
> > 
> > 
> > On linux-next, allyesconfig has a 0.0001% savings as a result of the 
> > patch, but I'd be worried about the extra temp variable it allocates on 
> > the stack that is evident in the mm/slab.c disassembly unless all cases 
> > can be audited to show that we're not potentially deep.
> 
> A 0.0001% change means it's not worth changing, and we may be able to
> mark this up as a fluke in Michal's results.
> 
> I'll give it a try on my 4.6.3 compiler.
> 
> -- Steve
> 
> > 
> >    text	   data	    bss	    dec	    hex	filename
> > 108573045	23488016	51580928	183641989	af22785	vmlinux.before
> > 108572908	23488016	51580928	183641852	af226fc	vmlinux.after
> 

Here's my results:

   text    data     bss     dec     hex filename
108662851       23470256        51580928        183714035       af340f3 /tmp/vmlinux-orig
108662714       23470224        51580928        183713866	af3404a /tmp/vmlinux-patched

The patched version saved a total of 169 bytes.

Doing a diff on the vmlinux objdumps of do_fault_around, I get this:

  mov    -0x68(%rbp),%rdi
  mov    -0x70(%rbp),%r8d
- jae    ffffffff81302bf5 <do_fault_around+0xbd>
- cmp    %r15,%rax
- mov    %r15,%r14
- cmovbe %rax,%r14
- jmp    ffffffff81302c03 <do_fault_around+0xcb>
- cmp    %r14,%rax
- cmovbe %rax,%r14
- incq   0x8d384b5(%rip)        # ffffffff8a03b0b8 <high_memory+0x14e8>
- mov    0x8d384be(%rip),%rsi        # ffffffff8a03b0c8 <high_memory+0x14f8>
- mov    0x8d384bf(%rip),%rdx        # ffffffff8a03b0d0 <high_memory+0x1500>
- mov    0x8d384a8(%rip),%rax        # ffffffff8a03b0c0 <high_memory+0x14f0>
+ cmp    %rax,%r15
+ cmova  %rax,%r15
+ mov    0x8d384c0(%rip),%rax        # ffffffff8a03b0b8 <high_memory+0x14e8>
+ cmp    %r14,%r15
+ cmovbe %r15,%r14
  sub    %r12,%rsi


So for gcc 4.6.3 it does seem to produce nicer assembly. I haven't
tried it with other versions though (or with clang).

But I'll still give it a:

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve
