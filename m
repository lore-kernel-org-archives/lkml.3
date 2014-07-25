Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbaGYTKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 15:10:23 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:31046 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758072AbaGYTKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 15:10:22 -0400
Date: Fri, 25 Jul 2014 15:10:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
        Michel =?ISO-8859-1?B?RORuemVy?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140725151011.148db8da@gandalf.local.home>
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
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jul 2014 11:29:06 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, Jul 25, 2014 at 7:02 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > But wouldn't it be rather trivial to run a static analyzer on the final
> > vmlinux to make sure there are no red zones? I mean, you would only need
> > to read each function and check to make sure that the offset of rbp is
> > within the change of rsp, wouldn't you?
> >
> > Almost seems like an objdump -rd into a perl script could do this.
> 
> I'm sure it's possible, but it sounds potentially complicated. It's
> not like the function prologue is fixed, and gcc will create code
> (including conditional branches etc) before the whole frame setup if
> there are simple things that can be done purely with the
> callee-clobbered registers etc.
> 
> Some simple pattern to make sure that the "sub $frame-size,%rsp" comes
> before any accesses to (%rbp) (when frame pointers are enabled)
> *might* work, but it might also end up missing things.
> 
> You want to try?
> 

Yeah, I could write something up. I probably wont get to it for a week
or two, but it shouldn't be too hard.

As you said, it will probably miss the complex cases where gcc finishes
the frame later in the function or with branches and such. But at least
it should be able to catch any totally retard set up. I compiled
Michel's file and I'll make sure that it at least catches that:

    3572:       48 c7 85 78 ff ff ff    movq   $0x0,-0x88(%rbp)
    3579:       00 00 00 00 
                        3579: R_X86_64_32S      load_balance_mask
    357d:       48 81 ec b8 00 00 00    sub    $0xb8,%rsp


-- Steve


