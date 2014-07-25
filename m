Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935125AbaGYUNZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:13:25 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:10851 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932508AbaGYUNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:13:24 -0400
Date: Fri, 25 Jul 2014 16:13:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
        Michel =?ISO-8859-1?B?RORuemVy?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140725161318.3dd77656@gandalf.local.home>
In-Reply-To: <CA+55aFxbWfYPuzCZvhy24zVfWwhN=DcxrCDguZ74cfsOz9U7PQ@mail.gmail.com>
References: <20140723182518.GD3935@laptop>
	<CA+55aFyFT9n5wUNifEHY6+t2bEcD91kL7+dqXuBMSMJvLeDDJQ@mail.gmail.com>
	<20140723184111.GG3935@laptop>
	<CA+55aFwQfwfAP6U77_nD_mSvoygj=cZ09N644hKRtzgLnEqhZQ@mail.gmail.com>
	<20140723190230.GH3935@laptop>
	<CA+55aFyM1wqTLK0m4GQJ28f=z0iZE87=xk+1z-vm+PH1_d8nKw@mail.gmail.com>
	<53D064C7.5050807@daenzer.net>
	<CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
	<53D1B1EF.7030603@daenzer.net>
	<20140725035527.GA30108@pg-vmw-gw1>
	<20140725140237.GB32669@home.goodmis.org>
	<CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
	<CA+55aFxbWfYPuzCZvhy24zVfWwhN=DcxrCDguZ74cfsOz9U7PQ@mail.gmail.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014 13:01:11 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:


> For example, gcc will not create a small stack frame with "sub
> $8,%rsp". No, what gcc does is to use a random "push" instruction.
> Fair enough, but that really makes things much harder to see. Here's
> an example:
> 
>   ffffffff813143a3 <dock_notify>:
>   ffffffff813143a3:       55                      push   %rbp
>   ffffffff813143a4:       48 89 e5                mov    %rsp,%rbp
>   ffffffff813143a7:       41 57                   push   %r15
>   ffffffff813143a9:       41 56                   push   %r14
>   ffffffff813143ab:       49 89 fe                mov    %rdi,%r14
>   ffffffff813143ae:       41 55                   push   %r13
>   ffffffff813143b0:       41 89 f5                mov    %esi,%r13d
>   ffffffff813143b3:       41 54                   push   %r12
>   ffffffff813143b5:       53                      push   %rbx
>   ffffffff813143b6:       51                      push   %rcx
>   ...
>   ffffffff81314501:       48 8b 7e 08             mov    0x8(%rsi),%rdi
>   ffffffff81314505:       48 89 75 d0             mov    %rsi,-0x30(%rbp)
>   ffffffff81314509:       e8 5f d1 ff ff          callq
> ffffffff8131166d <acpi_bus_scan>
>   ffffffff8131450e:       85 c0                   test   %eax,%eax
>   ...
>   ffffffff813145d6:       5a                      pop    %rdx
>   ffffffff813145d7:       5b                      pop    %rbx
>   ffffffff813145d8:       44 89 e0                mov    %r12d,%eax
>   ffffffff813145db:       41 5c                   pop    %r12
>   ffffffff813145dd:       41 5d                   pop    %r13
>   ffffffff813145df:       41 5e                   pop    %r14
>   ffffffff813145e1:       41 5f                   pop    %r15
>   ffffffff813145e3:       5d                      pop    %rbp
>   ffffffff813145e4:       c3                      retq
> 
> note the use (deep down in the function) of -0x30(%rbp), and note how
> it does "pop %rdx" twice to undo the "push %rcx". It was just to
> allocate space.

I don't see a pop %rdx twice. Sure you're not suffering from a little
dyslexia? ;-)  But I do get your point. The rdx is popped where the rcx
was, and both are useless, as rcx and rdx are volatile regs.


> 
> So you definitely have to track the actual stack pointer updates, not
> just the patterns of add/sub to %rsp.

With Perl that would be rather trivial. I'm more concerned with branch
logic. I'll see if I can include some simple branch logic too to
flatten paths. But I wont really know the depth of this until I start
hacking at it.

-- Steve



