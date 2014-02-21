Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbaBUUWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:22:40 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:45895 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbaBUUWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:22:19 -0500
MIME-Version: 1.0
In-Reply-To: <CAHWkzRSO82jU-9dtTEjHaW2FeLcEqdZXxp5Q8cmVTTT9uhZQYw@mail.gmail.com>
References: <CA+55aFwUnRVk6q3VZeYjWfduoHcExW=Pht6jgp=4bBSaLHNPMA@mail.gmail.com>
	<20140218030002.GA15857@linux.vnet.ibm.com>
	<CA+55aFyqLrj4d2TA+2aazRqXnbVsUvs0yaBL2D5rXF1G=Kiu_g@mail.gmail.com>
	<CA+55aFwsq5E8kMoEeHJJ1f2=+QAUCu_HndfPxHNz8fUBprS-jQ@mail.gmail.com>
	<1392740258.18779.7732.camel@triegel.csb>
	<CA+55aFw7QYEMFs0BCxqRJW3Cz=tLbaku-tmN6hLXPKP9jbom7Q@mail.gmail.com>
	<1392752867.18779.8120.camel@triegel.csb>
	<CA+55aFxQPxQ8WOaZL8yAqBA=Y4k2gDn4r4oepMyi0uL6XLzv3w@mail.gmail.com>
	<20140220040102.GM4250@linux.vnet.ibm.com>
	<CA+55aFwwscSzwTr+xRdirtTx7HzugmMY9HrDe0GBqNhn=AuNVA@mail.gmail.com>
	<20140220083032.GN4250@linux.vnet.ibm.com>
	<CA+55aFwfx==u7o1NZ66aPbkOgsvGqW3UscGqrQkGuzOkjSpm6Q@mail.gmail.com>
	<CAHWkzRQZ8+gOGMFNyTKjFNzpUv6d_J1G9KL0x_iCa=YCgvEojQ@mail.gmail.com>
	<CA+55aFyDQ-9mJJUUXqp+XWrpA8JMP0=exKa=JpiaNM9wAAsCrA@mail.gmail.com>
	<CAHWkzRSO82jU-9dtTEjHaW2FeLcEqdZXxp5Q8cmVTTT9uhZQYw@mail.gmail.com>
Date: Fri, 21 Feb 2014 12:22:16 -0800
X-Google-Sender-Auth: LgAIKHCe9vYj7xfFhRv6UHF3gm8
Message-ID: <CA+55aFyp9WRbpHcodOr0M7cXkw+7OHMhfKCUy3q4g0YNYa_2CQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/5] arch: atomic rework
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "p796231 ." <Peter.Sewell@cl.cam.ac.uk>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Torvald Riegel <triegel@redhat.com>, Will Deacon <will.deacon@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ramana Radhakrishnan <Ramana.Radhakrishnan@arm.com>,
        David Howells <dhowells@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>, Mark Batty <mbatty@cantab.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 11:43 AM, Peter Sewell
<Peter.Sewell@cl.cam.ac.uk> wrote:
>
> You have to track dependencies through other assignments, e.g. simple x=y

That is all visible in the SSA form. Variable assignment has been
converted to some use of the SSA node that generated the value. The
use might be a phi node or a cast op, or maybe it's just a memory
store op, but the whole point of SSA is that there is one single node
that creates the data (in this case that would be the "load" op with
the associated consume barrier - that barrier might be part of the
load op itself, or it might be implemented as a separate SSA node that
consumes the result of the load that generates a new pseudo), and the
uses of the result are all visible from that.

And yes, there might be a lot of users. But any complex case you just
punt on - and the difference here is that since "punt" means "leave
the barrier in place", it's never a correctness issue.

So yeah, it could be somewhat expensive, although you can always bound
that expense by just punting. But the dependencies in SSA form are no
more complex than the dependencies the C standard talks about now, and
in SSA form they are at least really easy to follow.  So if they are
complex and expensive in SSA form, I'd expect them to be *worse* in
the current "depends-on" syntax form.

                 Linus
