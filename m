Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaAOQlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 11:41:23 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:57563 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaAOQlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 11:41:22 -0500
Message-ID: <52D6BA2F.4050104@linaro.org>
Date: Wed, 15 Jan 2014 11:41:19 -0500
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
CC: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Rabin Vincent <rabin@rab.in>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 04/16] ARM: move generic thumb instruction parsing
 code to new files for use by other feature
References: <1387166930-13182-1-git-send-email-dave.long@linaro.org>  <1387166930-13182-5-git-send-email-dave.long@linaro.org> <1387543562.3404.35.camel@linaro1.home>
In-Reply-To: <1387543562.3404.35.camel@linaro1.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/13 07:46, Jon Medhurst (Tixy) wrote:
> On Sun, 2013-12-15 at 23:08 -0500, David Long wrote:
>> From: "David A. Long" <dave.long@linaro.org>
>>
>> Move the thumb version of the kprobes instruction parsing code into more generic
>> files from where it can be used by uprobes and possibly other subsystems. The
>> symbol names will be made more generic in a subsequent part of this patchset.
>>
>> Signed-off-by: David A. Long <dave.long@linaro.org>
>> ---
>
> I just have two comments about probes-thumb.h ...
>
> [...]
>
>> diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/kernel/probes-thumb.h
>> new file mode 100644
>> index 0000000..3f39210
>> --- /dev/null
>> +++ b/arch/arm/kernel/probes-thumb.h
>> @@ -0,0 +1,136 @@
>> +/*
>> + * arch/arm/kernel/probes-arm.h
>> + *
>> + * Copyright 2013 Linaro Ltd.
>> + * Written by: David A. Long
>> + *
>> + * The code contained herein is licensed under the GNU General Public
>> + * License. You may obtain a copy of the GNU General Public License
>> + * Version 2 or later at the following locations:
>> + *
>> + * http://www.opensource.org/licenses/gpl-license.html
>> + * http://www.gnu.org/copyleft/gpl.html
>> + */
>> +
>> +#ifndef _ARM_KERNEL_PROBES_THUMB_H
>> +#define  _ARM_KERNEL_PROBES_THUMB_H
>> +
>> +/*
>> + * True if current instruction is in an IT block.
>> + */
>> +#define in_it_block(cpsr)	((cpsr & 0x06000c00) != 0x00000000)
>> +
>> +/*
>> + * Return the condition code to check for the currently executing instruction.
>> + * This is in ITSTATE<7:4> which is in CPSR<15:12> but is only valid if
>> + * in_it_block returns true.
>> + */
>> +#define current_cond(cpsr)	((cpsr >> 12) & 0xf)
>
> Looks like you forgot to remove above two #defines from kprobes-thumb.c
> when you moved them to this header file.

Fixed.

> Also...
>
>> +enum probes_t32_action {
>> +	PROBES_T32_EMULATE_NONE,
>> +	PROBES_T32_SIMULATE_NOP,
>> +	PROBES_T32_LDMSTM,
>> +	PROBES_T32_LDRDSTRD,
>> +	PROBES_T32_TABLE_BRANCH,
>> +	PROBES_T32_TST,
>> +	PROBES_T32_CMP,
>> +	PROBES_T32_MOV,
>> +	PROBES_T32_ADDSUB,
>> +	PROBES_T32_LOGICAL,
>> +	PROBES_T32_ADDWSUBW_PC,
>> +	PROBES_T32_ADDWSUBW,
>> +	PROBES_T32_MOVW,
>> +	PROBES_T32_SAT,
>> +	PROBES_T32_BITFIELD,
>> +	PROBES_T32_SEV,
>> +	PROBES_T32_WFE,
>> +	PROBES_T32_MRS,
>> +	PROBES_T32_BRANCH_COND,
>> +	PROBES_T32_BRANCH,
>> +	PROBES_T32_PLDI,
>> +	PROBES_T32_LDR_LIT,
>> +	PROBES_T32_LDRSTR,
>> +	PROBES_T32_SIGN_EXTEND,
>> +	PROBES_T32_MEDIA,
>> +	PROBES_T32_REVERSE,
>> +	PROBES_T32_MUL_ADD,
>> +	PROBES_T32_MUL_ADD2,
>> +	PROBES_T32_MUL_ADD_LONG
>> +};
>> +
>> +enum probes_t16_action {
>> +	PROBES_T16_ADD_SP,
>> +	PROBES_T16_CBZ,
>> +	PROBES_T16_SIGN_EXTEND,
>> +	PROBES_T16_PUSH,
>> +	PROBES_T16_POP,
>> +	PROBES_T16_SEV,
>> +	PROBES_T16_WFE,
>> +	PROBES_T16_IT,
>> +	PROBES_T16_CMP,
>> +	PROBES_T16_ADDSUB,
>> +	PROBES_T16_LOGICAL,
>> +	PROBES_T16_BLX,
>> +	PROBES_T16_HIREGOPS,
>> +	PROBES_T16_LDR_LIT,
>> +	PROBES_T16_LDRHSTRH,
>> +	PROBES_T16_LDRSTR,
>> +	PROBES_T16_ADR,
>> +	PROBES_T16_LDMSTM,
>> +	PROBES_T16_BRANCH_COND,
>> +	PROBES_T16_BRANCH
>> +};
>> +
>

Moved.

-dl


