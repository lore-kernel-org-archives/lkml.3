Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846AbaDJRMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 13:12:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46839 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbaDJRMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 13:12:42 -0400
Date: Thu, 10 Apr 2014 19:00:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/6] uprobes/x86: Emulate rip-relative call's
Message-ID: <20140410170023.GA31165@redhat.com>
References: <20140406201628.GA507@redhat.com> <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com> <20140409154346.GB18486@redhat.com> <53469F95.1030709@redhat.com> <5346A362.9010802@hitachi.com> <20140410142820.GA24720@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140410142820.GA24720@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Oleg Nesterov wrote:
>
> On 04/10, Masami Hiramatsu wrote:
> >
> > (2014/04/10 22:41), Denys Vlasenko wrote:
> > > There is this monstrosity, "16-bit override for branches" in 64-mode:
> > >
> > > 66 e8 nn nn       callw   <offset16>
> > >
> > > Nobody sane uses it because it truncates instruction pointer.
> >
> > No problem, insn.c can handle that too. :)
>
> Does it?
>
> 	"callw 1f; 1:\n"
> 	"rep; nop\n"
>
> objdump:
>
> 	66 e8 00 00             callw  485 <_init-0x3ffed3>
> 	f3 90                   pause
>
>
> if we probe this "callw", we copy MAX_INSN_BYTES into auprobe->insn,
> and after insn_get_length() (insn_complete() == T)
>
> 	// this is correct
> 	OPCODE1() == e8
>
> 	// this all looks wrong
> 	insn->length == 6
> 	insn->immediate.value == -1863122944
> 	insn->immediate.nbytes == 4
>
> so it seems that lib/insn.c treats the next "pause" insn as the high
> 16 bits of address.

Or perhaps lib/insn.c is fine but objdump is wrong? And everything
should work correctly? Although in this case I do not understand what
this "callw" actually does.

	int main(void)
	{
		asm (
			"nop\n"

			"callw 1f; 1:\n"
			".byte 0\n"
			".byte 0\n"
		);

		return 0;
	}

this runs just fine. With or without gdb. And gdb shows that ->ip is
incremented by 6 after "callw".

	int main(void)
	{
		asm (
			"nop\n"

			"callw 1f; 1:\n"
			".byte 10\n"
			".byte 20\n"
		);

		return 0;
	}

objdump:

	000000000040047c <main>:
	  40047c:       55                      push   %rbp
	  40047d:       48 89 e5                mov    %rsp,%rbp
	  400480:       90                      nop
	  400481:       66 e8 00 00             callw  485 <_init-0x3ffed3>
	  400485:       0a 14 b8                or     (%rax,%rdi,4),%dl
	  400488:       00 00                   add    %al,(%rax)
	  40048a:       00 00                   add    %al,(%rax)
	  40048c:       c9                      leaveq
	  40048d:       c3                      retq

run:

	$ ./t
	Segmentation fault (core dumped)

	$ gdb ./t core.*
	...
	#0  0x00000000144a0487 in ?? ()

0x144a0487 - 0x400481 == 0x140a0006, this matches the additional 2 .bytes treated
as offset.

So I am totally confused.

Oleg.

