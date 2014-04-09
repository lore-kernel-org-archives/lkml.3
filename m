Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934133AbaDIQmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 12:42:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19346 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100AbaDIQmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 12:42:10 -0400
Date: Wed, 9 Apr 2014 18:42:04 +0200
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
Subject: Re: [RFC PATCH v2 5/6] uprobes/x86: Emulate rip-relative
	conditional "short" jmp's
Message-ID: <20140409164204.GD18486@redhat.com>
References: <20140406201524.GA32694@redhat.com> <20140406201632.GA514@redhat.com> <20140407142723.GA8881@redhat.com> <1396997587.5056.61.camel@oc7886638347.ibm.com.usor.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396997587.5056.61.camel@oc7886638347.ibm.com.usor.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08, Jim Keniston wrote:
>
> On Mon, 2014-04-07 at 16:27 +0200, Oleg Nesterov wrote:
> >
> > +#define CASE_COND					\
> > +	COND(70, 71, XF(OF))				\
> > +	COND(72, 73, XF(CF))				\
> > +	COND(74, 75, XF(ZF))				\
> > +	COND(78, 79, XF(SF))				\
> > +	COND(7a, 7b, XF(PF))				\
> > +	COND(76, 77, XF(CF) || XF(ZF))			\
> > +	COND(7c, 7d, XF(SF) != XF(OF))			\
> > +	COND(7e, 7f, XF(ZF) || XF(SF) != XF(OF))
> > +
> > +#define COND(op_y, op_n, expr)				\
> > +	case 0x ## op_y: DO((expr) != 0)		\
> > +	case 0x ## op_n: DO((expr) == 0)
> > +
> > +#define XF(xf)	(!!(flags & X86_EFLAGS_ ## xf))
>
> All this macro magic seems way more clever than it is legible.

No-no-no, please do not ask me to remove it ;) I understand that this
is subjective, but to me it helps. Please see below.

> Given that you're mapping 0f 8x to 7x (patch #6), is_cond_jmp_opcode()
> could just be
> 	return (0x70 <= opcode && opcode <= 0x7f);

Heh. I blindly copied the opcodes from the manual, I didn't even realize
that the range is continuous.

But gcc is more clever than me, I removed "static" and

	is_cond_jmp_opcode:
		pushq   %rbp    #
		movq    %rsp, %rbp      #,
		call    mcount
		leave
		subl    $112, %edi      #, tmp62
		cmpb    $15, %dil       #, tmp62
		setbe   %al     #, tmp64
		ret

shows that at least this doesn't make the code worse.


> I would keep the XF macro (although the !! operation to convert non-zero
> to 1 isn't strictly needed)

Well, "!!" is commonly used to make clear the fact we need a boolean,
even if this is not strictly needed.

Besides, in this case it is needed for "!=" above, or we would need to do

	- XF(SF) != XF(OF)
	+ !!XF(SF) != !!XF(OF)

> and just do an explicit 16-case switch for
> check_jmp_cond().

I'd prefer to keep these macros. They are only used by is_cond_jmp_opcode()
and check_jmp_cond(), and I really think they make the code more readable.

And more editable. To remind, I am going to add the support for j*cxz/loop
later. Just for completeness, we do not need this to fix the bug. In this
case I will simply add

	case 0xe3: DO(check_rcx(auprobe, regs))

at the end of CASE_COND and that is all.

> >  static bool ttt_emulate_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
> >  {
> >  	unsigned long new_ip = regs->ip += auprobe->ttt.ilen;
> > +	unsigned long disp = auprobe->ttt.disp;
>
> Looks like a negative ttt.disp will get sign-extended like you want, but
> still, making disp unsigned here doesn't seem quite right.

OK. I changed this line

	unsigned long disp = (long)auprobe->ttt.disp;

to make it clear that yes, disp can be negative. Or we could simply use s32,
but then

	regs->ip = new_ip + disp;

could look equally confusing.

Thanks,

Oleg.

