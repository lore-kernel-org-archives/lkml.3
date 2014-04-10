Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935654AbaDJO2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 10:28:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935500AbaDJO21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 10:28:27 -0400
Date: Thu, 10 Apr 2014 16:28:20 +0200
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
Message-ID: <20140410142820.GA24720@redhat.com>
References: <20140406201628.GA507@redhat.com> <1396995963.5056.46.camel@oc7886638347.ibm.com.usor.ibm.com> <20140409154346.GB18486@redhat.com> <53469F95.1030709@redhat.com> <5346A362.9010802@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5346A362.9010802@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10, Masami Hiramatsu wrote:
>
> (2014/04/10 22:41), Denys Vlasenko wrote:
> > On 04/09/2014 05:43 PM, Oleg Nesterov wrote:
> >> On 04/08, Jim Keniston wrote:
> >>>
> >>> On Sun, 2014-04-06 at 22:16 +0200, Oleg Nesterov wrote:
> >>>> 0xe8. Anything else?
> >>>
> >>> No, I think e8 is the only call instruction uprobes will see.
> >>
> >> Good.
> >
> > There is this monstrosity, "16-bit override for branches" in 64-mode:
> >
> > 66 e8 nn nn       callw   <offset16>
> >
> > Nobody sane uses it because it truncates instruction pointer.
>
> No problem, insn.c can handle that too. :)

Does it?

	"callw 1f; 1:\n"
	"rep; nop\n"

objdump:

	66 e8 00 00             callw  485 <_init-0x3ffed3>
	f3 90                   pause


if we probe this "callw", we copy MAX_INSN_BYTES into auprobe->insn,
and after insn_get_length() (insn_complete() == T)

	// this is correct
	OPCODE1() == e8	

	// this all looks wrong
	insn->length == 6
	insn->immediate.value == -1863122944
	insn->immediate.nbytes == 4

so it seems that lib/insn.c treats the next "pause" insn as the high
16 bits of address.

Oleg.

