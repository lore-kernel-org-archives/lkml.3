Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617AbaEBPEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 11:04:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25046 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752402AbaEBPEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:04:16 -0400
Message-ID: <5363B3E8.6020606@redhat.com>
Date: Fri, 02 May 2014 17:04:08 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] uprobes: fix scratch register selection for rip-relative
 fixups
References: <1398964141-25097-1-git-send-email-dvlasenk@redhat.com> <1398991682.4908.22.camel@oc7886638347.ibm.com.usor.ibm.com>
In-Reply-To: <1398991682.4908.22.camel@oc7886638347.ibm.com.usor.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 02:48 AM, Jim Keniston wrote:
> On Thu, 2014-05-01 at 19:09 +0200, Denys Vlasenko wrote:
>> +#define VEX2_VVVV(insn)		X86_VEX_V((insn)->vex_prefix.bytes[1])
>> +#define VEX3_VVVV(insn)		X86_VEX_V((insn)->vex_prefix.bytes[2])
> 
> I disclaim any knowledge about VEX* stuff.
...
> skipped this next part...
> 
>> +	/* Similar treatment for VEX3 prefix */
>> +	/* TODO: add XOP/EVEX treatment when insn decoder supports them */
>> +	if (insn->vex_prefix.nbytes == 3) {
>> +		/*
>> +		 * vex2:     c5    rvvvvLpp   (has no b bit)
>> +		 * vex3/xop: c4/8f rxbmmmmm wvvvvLpp
>> +		 * evex:     62    rxbR00mm.wvvvv1pp.zllBVaaa
>> +		 *   (evex will need setting of both b and x since
>> +		 *   in non-sib encoding evex.x is 4th bit of MODRM.rm)
>> +		 * Setting VEX3.b (setting because it has inverted meaning):
>> +		 */
>> +		cursor = auprobe->insn + insn_offset_vex_prefix(insn) + 1;
>> +		*cursor |= 0x20;
>>  	}
> 
> ... resumed reviewing here.

I do realize that most people reading this code won't be
aficionados of memorizing x86 insn encoding quirks.

To help them, I added the comment which spells out bit layout
of vex/evex/xop prefixes (see above). Does it help?

> VEX again.  Covering my ears and humming...
> 
>> +	if (insn->vex_prefix.nbytes == 2) {
>> +		reg2 = VEX2_VVVV(insn) ^ 0xf;
>> +	}
>> +	if (insn->vex_prefix.nbytes == 3) {
>> +		reg2 = VEX3_VVVV(insn) ^ 0xf;
>> +	}
>> +	/* TODO: add XOP, EXEV vvvv reading */
>> +

In fact there is room for improvement in this part:
it's better to ignore most-significant bit of this field
(32-bit mode strikes back).

>> +	reg2 = 3; /* BX */
>> +	if (can_use_regs & UPROBE_FIX_RIP_DI)
>> +		reg2 = 7;
>> +	if (can_use_regs & UPROBE_FIX_RIP_SI)
>> +		reg2 = 6;
> 
> It seems more natural to code this as:
> 	if (can_use_regs & UPROBE_FIX_RIP_SI)
> 		reg2 = 6;
> 	else if (can_use_regs & UPROBE_FIX_RIP_DI)
> 		reg2 = 7;
> 	else
> 		reg2 = 3; /* BX */
> ... which is pretty much how you do it in scratch_reg().

Okay.
I can also get rid of "can_use_regs" variable altogether then!
Sending new version in a jiffy.
-- 
vda


