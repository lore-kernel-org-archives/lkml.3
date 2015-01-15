Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbbAOPXQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:23:16 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:42559 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbbAOPXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:23:14 -0500
MIME-Version: 1.0
In-Reply-To: <54B7B49C.90003@hitachi.com>
References: <cover.1421183147.git.luto@amacapital.net> <6ceb805aba0291431f19f72d7f2e765f3a0a9fcf.1421183147.git.luto@amacapital.net>
 <54B7B49C.90003@hitachi.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 15 Jan 2015 07:22:53 -0800
Message-ID: <CALCETrXG5wr+aT122O5YY=9TLGtXhJreXc5thFmVYgCj_J04bg@mail.gmail.com>
Subject: Re: [PATCH 3.19 v4 2/2] x86: Enforce maximum instruction size in the
 instruction decoder
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 15, 2015 4:37 AM, "Masami Hiramatsu"
<masami.hiramatsu.pt@hitachi.com> wrote:
>
> (2015/01/14 6:49), Andy Lutomirski wrote:
> > x86 instructions cannot exceed 15 bytes, and the instruction decoder
> > should enforce that.  Prior to 6ba48ff46f76, the instruction length
> > limit was implicitly set to 16, which was an approximation of 15,
> > but there is currently no limit at all.
> >
> > Fix the decoder to reject instructions that exceed 15 bytes.
> > A subsequent patch (targetted for 3.20) will fix MAX_INSN_SIZE.
>
> Hmm, is there any problem to just change MAX_INSN_SIZE to 15?

I don't want to do that for 3.19.  It's kind of late.

>
> > Other than potentially confusing some of the decoder sanity checks,
> > I'm not aware of any actual problems that omitting this check would
> > cause.
> >
> > Fixes: 6ba48ff46f76 x86: Remove arbitrary instruction size limit in instruction decoder
> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> > ---
> >  arch/x86/lib/insn.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
> > index 2480978b31cc..7b80745d2c5a 100644
> > --- a/arch/x86/lib/insn.c
> > +++ b/arch/x86/lib/insn.c
> > @@ -52,6 +52,13 @@
> >   */
> >  void insn_init(struct insn *insn, const void *kaddr, int buf_len, int x86_64)
> >  {
> > +     /*
> > +      * Instructions longer than 15 bytes are invalid even if the
> > +      * input buffer is long enough to hold them.
> > +      */
> > +     if (buf_len > 15)
> > +             buf_len = 15;
> > +
>
> Without changing the MAX_INSN_SIZE, this looks very odd, since all other
> code suppose that the max length of an instruction is 16 (MAX_INSN_SIZE)
> except here.

I thought this was your suggestion.  Did I misunderstand?

If you think the current code is okay for 3.19, I can fold the two
patches together and send for 3.20.

--Andy

>
> Thank you,
>
> >       memset(insn, 0, sizeof(*insn));
> >       insn->kaddr = kaddr;
> >       insn->end_kaddr = kaddr + buf_len;
> >
>
>
> --
> Masami HIRAMATSU
> Software Platform Research Dept. Linux Technology Research Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
>
>
