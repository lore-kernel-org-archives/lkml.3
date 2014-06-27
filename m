Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782AbaF0T5q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 15:57:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65381 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbaF0T5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 15:57:43 -0400
Date: Fri, 27 Jun 2014 21:55:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Daniel Borkmann <dborkman@redhat.com>, Will Drewry <wad@chromium.org>,
        Julien Tinnes <jln@chromium.org>, David Drysdale <drysdale@google.com>,
        Linux API <linux-api@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-mips@linux-mips.org, linux-arch <linux-arch@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v8 5/9] seccomp: split mode set routines
Message-ID: <20140627195559.GA31661@redhat.com>
References: <CAGXu5j+J11zJnuFR8bYKAXizAHhCx4R+uJE_QH6zC3q2udkpaQ@mail.gmail.com> <CALCETrVrs8sb19+UUqyFEpAFzTih5dkAwn-WpQjfgPcPJMpP5g@mail.gmail.com> <20140625173245.GA17695@redhat.com> <CALCETrUc65H+fn6dtMdYnB_xR39wcmgDdTbdR3fFRjyrndJhgA@mail.gmail.com> <20140625175136.GA18185@redhat.com> <CAGXu5jL17k6=GXju6x+eLU20FMwBHhnuRiHoQD1Bzj_EmpiKjg@mail.gmail.com> <CALCETrVNwhWSPNiBiZmgP1nD9zLJPTk6cH0yo=85rbxTPTYFRg@mail.gmail.com> <CAGXu5jLavA8FJD8m-1y4wO0uzh3qvvMmajAg0Lrr1Cn_Om3a3w@mail.gmail.com> <20140627192753.GA30752@redhat.com> <CALCETrVbJqfG6oBaZEjj7H3pPa1oVJx6QXAYc5zZ6o-niV=WKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVbJqfG6oBaZEjj7H3pPa1oVJx6QXAYc5zZ6o-niV=WKQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27, Andy Lutomirski wrote:
>
> On Fri, Jun 27, 2014 at 12:27 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 06/27, Kees Cook wrote:
> >>
> >> It looks like SMP ARM issues dsb for rmb, which seems a bit expensive.
> >> http://infocenter.arm.com/help/index.jsp?topic=/com.arm.doc.dui0204g/CIHJFGFE.htm
> >>
> >> ...
> >>
> >> I really want to avoid adding anything to the secure_computing()
> >> execution path. :(
> >
> > I must have missed something but I do not understand your concerns.
> >
> > __secure_computing() is not trivial, and we are going to execute the
> > filters. Do you really think rmb() can add the noticeable difference?
> >
> > Not to mention that we can only get here if we take the slow syscall
> > enter path due to TIF_SECCOMP...
> >
>
> On my box, with my fancy multi-phase seccomp patches, the total
> seccomp overhead for a very short filter is about 13ns.  Adding a full
> barrier would add several ns, I think.

I am just curious, does this 13ns overhead include the penalty from the
slow syscall enter path triggered by TIF_SECCOMP ?

> Admittedly, this is x86, not ARM, so comparisons here are completely
> bogus.  And that read memory barrier doesn't even need an instruction
> on x86.  But still, let's try to keep this fast.

Well, I am not going to insist...

But imo it would be better to make it correct in a most simple way, then
we can optimize this code and see if there is a noticeable difference.

Not only we can change the ordering, we can remove the BUG_ON's and just
accept the fact the __secure_computing() can race with sys_seccomp() from
another thread.

If nothing else, it would be much simpler to discuss this patch if it comes
as a separate change.

Oleg.

