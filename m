Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbaDIOrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:47:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932807AbaDIOrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:47:11 -0400
Date: Wed, 9 Apr 2014 16:47:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/6] uprobes/x86: Emulate unconditional
	rip-relative jmp's
Message-ID: <20140409144705.GA18486@redhat.com>
References: <20140406201617.GA493@redhat.com> <1396989411.5056.16.camel@oc7886638347.ibm.com.usor.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396989411.5056.16.camel@oc7886638347.ibm.com.usor.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08, Jim Keniston wrote:
>
> On Sun, 2014-04-06 at 22:16 +0200, Oleg Nesterov wrote:
> > 0xeb and 0xe9. Anything else?
>
> For unconditional rip-relative jumps, yes, I'm pretty sure that's it.

Great, thanks.

> > --- a/arch/x86/include/asm/uprobes.h
> > +++ b/arch/x86/include/asm/uprobes.h
> > @@ -44,9 +44,15 @@ struct arch_uprobe {
> >  	u16				fixups;
> >  	const struct uprobe_xol_ops	*ops;
> >
> > +	union {
> >  #ifdef CONFIG_X86_64
> > -	unsigned long			rip_rela_target_address;
> > +		unsigned long			rip_rela_target_address;
> >  #endif
> > +		struct {
> > +			s32	disp;
> > +			u8	ilen;
> > +		}				ttt;
>
> Are you planning to stick with ttt as the name/prefix for all this
> jump-emulation code?  Seems like you could come up with something more
> descriptive without adding a lot of characters.

Yes sure. How about s/ttt/branch/ ? I agree with any naming. I used
"ttt" because it allows me to change the naming in one step.

> > +static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
> > +{
> > +
> > +	switch (OPCODE1(insn)) {
> > +	case 0xeb:	/* jmp 8 */
> > +	case 0xe9:	/* jmp 32 */
> > +		break;
> > +	default:
> > +		return -ENOSYS;
>
> -ENOSYS looks like an error return, as opposed to what it is, the normal
> return when the probed instruction is something other than a jump.  This
> gets more bewildering as you add patches and this switch grows and gets
> more complicated.  Add a comment here?

OK, I added a short comment above this function,

	/* Returns -ENOSYS if ttt_xol_ops doesn't handle this insn */
	static int ttt_setup_xol_ops(struct arch_uprobe *auprobe, struct insn *insn)
	...

> > +	/* has the side-effect of processing the entire instruction */
> > +	insn_get_length(insn);
> > +	if (WARN_ON_ONCE(!insn_complete(insn)))
> > +		return -ENOEXEC;
> > +
> > +	auprobe->ttt.ilen = insn->length;
> > +	auprobe->ttt.disp = insn->moffset1.value;
> > +	/* so far we assume that it fits into ->moffset1 */
> > +	if (WARN_ON_ONCE(insn->moffset2.nbytes))
> > +		return -ENOEXEC;
>
> s/moffset1/immediate/ -- which you've already addressed.

Yes, dons, and I removed the ->moffset2 check.

> > @@ -483,6 +519,10 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
> >  	if (ret)
> >  		return ret;
> >
> > +	ret = ttt_setup_xol_ops(auprobe, &insn);
> > +	if (ret == 0 || ret != ENOSYS)
>
> This looks wrong in a couple of ways:
> a. I think you intend to compare against -ENOSYS, not ENOSYS.

OOPS! fixed.

> b. Given the (ret != [-]ENOSYS) test, the  (ret == 0) test is
> superfluous.

I thought that the additional "ret == 0" (removed by gcc anyway) could
help the code reader... But yes, you are right, probably it only adds
more confusion.

	-       if (ret == 0 || ret != ENOSYS)
	+       if (ret != -ENOSYS)

Thanks!

Oleg.

