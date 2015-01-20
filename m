Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbbATW2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 17:28:31 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:47138 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbbATW23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 17:28:29 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1501201450220.5526@nanos>
References: <cover.1421183147.git.luto@amacapital.net> <44852495d71796ecf690208e2e908a1b25008a73.1421183147.git.luto@amacapital.net>
 <alpine.DEB.2.11.1501201450220.5526@nanos>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 20 Jan 2015 14:28:07 -0800
Message-ID: <CALCETrX0jY6XkK5824hVLtgBeN49P0a=id+YxR9L=c-R=43_BA@mail.gmail.com>
Subject: Re: [PATCH 3.19 v4 1/2] x86, mpx: Short-circuit the instruction
 decoder for unexpected opcodes
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 20, 2015 5:59 AM, "Thomas Gleixner" <tglx@linutronix.de> wrote:
>
> On Tue, 13 Jan 2015, Andy Lutomirski wrote:
>
> > This reduces the degree to which we're exposing the instruction decoder
> > to malicious user code at very little complexity cost.
> >
> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> > ---
> >  arch/x86/mm/mpx.c | 25 ++++++++++++++++---------
> >  1 file changed, 16 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/x86/mm/mpx.c b/arch/x86/mm/mpx.c
> > index 67ebf5751222..a73004330732 100644
> > --- a/arch/x86/mm/mpx.c
> > +++ b/arch/x86/mm/mpx.c
> > @@ -230,6 +230,22 @@ static int mpx_insn_decode(struct insn *insn,
> >        */
> >       if (!nr_copied)
> >               return -EFAULT;
> > +
> > +     /*
> > +      * We only _really_ need to decode bndcl/bndcn/bndcu
> > +      * Error out on anything else.  Check this before decoding the
> > +      * instruction to reduce our exposure to intentionally bad code
> > +      * to some extent.  Note that this shortcut can incorrectly return
> > +      * -EINVAL instead of -EFAULT under some circumstances.  This
> > +      * discrepancy has no effect.
> > +      */
> > +     if (nr_copied < 2)
> > +             goto bad_opcode;
> > +     if (buf[0] != 0x0f)
> > +             goto bad_opcode;
> > +     if (buf[1] != 0x1a && buf[1] != 0x1b)
> > +             goto bad_opcode;
>
> These opcodes can never have a prefix? If so, then we want to add this
> to the comment.

No, I think I just misunderstood the original code.  Please disregard
this patch.

--Andy

>
> Thanks,
>
>         tglx
