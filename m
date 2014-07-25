Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189AbaGYUBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 16:01:13 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:38437 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaGYUBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 16:01:12 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
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
Date: Fri, 25 Jul 2014 13:01:11 -0700
X-Google-Sender-Auth: 4z0C0Enbt3AxbbdPZgJ_iTeemuM
Message-ID: <CA+55aFxbWfYPuzCZvhy24zVfWwhN=DcxrCDguZ74cfsOz9U7PQ@mail.gmail.com>
Subject: Re: Random panic in load_balance() with 3.16-rc
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 11:29 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Some simple pattern to make sure that the "sub $frame-size,%rsp" comes
> before any accesses to (%rbp) (when frame pointers are enabled)
> *might* work, but it might also end up missing things.

You're going to have a hard time doing that pattern. Just for fun, I
did something really quick in awk:

    />:/ { state = 0 }
    /%rsp,%rbp/ { state = 1 }
    /\$.*rsp/ { state = 2 }
    /lea/ { next }
    /\(%rbp\)/ { if (state == 1) print "Error: " $0; state = 2; }

which is incomprehensible line noise, but it's a trivial state machine
where "beginning of function" starts state 0, "mov %rsp,%rbp" starts
state 1 ("have frame pointer in function"), sub/add constant of %rsp
starts state 2 ("created frame"), and then we ignore "lea" (because we
don't follow address calculations off %rbp) and error out if we see an
access through %rbp in a function with a frame pointer but without a
frame created.

That thing is excessively stupid, in other words, but hey, it's good
to see "ok, what does that tell us".

And what it tells me is that gcc does some crazy things.

For example, gcc will not create a small stack frame with "sub
$8,%rsp". No, what gcc does is to use a random "push" instruction.
Fair enough, but that really makes things much harder to see. Here's
an example:

  ffffffff813143a3 <dock_notify>:
  ffffffff813143a3:       55                      push   %rbp
  ffffffff813143a4:       48 89 e5                mov    %rsp,%rbp
  ffffffff813143a7:       41 57                   push   %r15
  ffffffff813143a9:       41 56                   push   %r14
  ffffffff813143ab:       49 89 fe                mov    %rdi,%r14
  ffffffff813143ae:       41 55                   push   %r13
  ffffffff813143b0:       41 89 f5                mov    %esi,%r13d
  ffffffff813143b3:       41 54                   push   %r12
  ffffffff813143b5:       53                      push   %rbx
  ffffffff813143b6:       51                      push   %rcx
  ...
  ffffffff81314501:       48 8b 7e 08             mov    0x8(%rsi),%rdi
  ffffffff81314505:       48 89 75 d0             mov    %rsi,-0x30(%rbp)
  ffffffff81314509:       e8 5f d1 ff ff          callq
ffffffff8131166d <acpi_bus_scan>
  ffffffff8131450e:       85 c0                   test   %eax,%eax
  ...
  ffffffff813145d6:       5a                      pop    %rdx
  ffffffff813145d7:       5b                      pop    %rbx
  ffffffff813145d8:       44 89 e0                mov    %r12d,%eax
  ffffffff813145db:       41 5c                   pop    %r12
  ffffffff813145dd:       41 5d                   pop    %r13
  ffffffff813145df:       41 5e                   pop    %r14
  ffffffff813145e1:       41 5f                   pop    %r15
  ffffffff813145e3:       5d                      pop    %rbp
  ffffffff813145e4:       c3                      retq

note the use (deep down in the function) of -0x30(%rbp), and note how
it does "pop %rdx" twice to undo the "push %rcx". It was just to
allocate space.

So you definitely have to track the actual stack pointer updates, not
just the patterns of add/sub to %rsp.

                Linus
