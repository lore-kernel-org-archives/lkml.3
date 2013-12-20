Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422685Ab3LTMr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 07:47:28 -0500
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:60485 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932321Ab3LTMrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 07:47:03 -0500
Message-ID: <1387543562.3404.35.camel@linaro1.home>
Subject: Re: [PATCH v4 04/16] ARM: move generic thumb instruction parsing
 code to new files for use by other feature
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
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
Date: Fri, 20 Dec 2013 12:46:02 +0000
In-Reply-To: <1387166930-13182-5-git-send-email-dave.long@linaro.org>
References: <1387166930-13182-1-git-send-email-dave.long@linaro.org>
	 <1387166930-13182-5-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-15 at 23:08 -0500, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> Move the thumb version of the kprobes instruction parsing code into more generic
> files from where it can be used by uprobes and possibly other subsystems. The
> symbol names will be made more generic in a subsequent part of this patchset.
> 
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---

I just have two comments about probes-thumb.h ...

[...]

> diff --git a/arch/arm/kernel/probes-thumb.h b/arch/arm/kernel/probes-thumb.h
> new file mode 100644
> index 0000000..3f39210
> --- /dev/null
> +++ b/arch/arm/kernel/probes-thumb.h
> @@ -0,0 +1,136 @@
> +/*
> + * arch/arm/kernel/probes-arm.h
> + *
> + * Copyright 2013 Linaro Ltd.
> + * Written by: David A. Long
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +#ifndef _ARM_KERNEL_PROBES_THUMB_H
> +#define  _ARM_KERNEL_PROBES_THUMB_H
> +
> +/*
> + * True if current instruction is in an IT block.
> + */
> +#define in_it_block(cpsr)	((cpsr & 0x06000c00) != 0x00000000)
> +
> +/*
> + * Return the condition code to check for the currently executing instruction.
> + * This is in ITSTATE<7:4> which is in CPSR<15:12> but is only valid if
> + * in_it_block returns true.
> + */
> +#define current_cond(cpsr)	((cpsr >> 12) & 0xf)

Looks like you forgot to remove above two #defines from kprobes-thumb.c
when you moved them to this header file.

Also...

> +enum probes_t32_action {
> +	PROBES_T32_EMULATE_NONE,
> +	PROBES_T32_SIMULATE_NOP,
> +	PROBES_T32_LDMSTM,
> +	PROBES_T32_LDRDSTRD,
> +	PROBES_T32_TABLE_BRANCH,
> +	PROBES_T32_TST,
> +	PROBES_T32_CMP,
> +	PROBES_T32_MOV,
> +	PROBES_T32_ADDSUB,
> +	PROBES_T32_LOGICAL,
> +	PROBES_T32_ADDWSUBW_PC,
> +	PROBES_T32_ADDWSUBW,
> +	PROBES_T32_MOVW,
> +	PROBES_T32_SAT,
> +	PROBES_T32_BITFIELD,
> +	PROBES_T32_SEV,
> +	PROBES_T32_WFE,
> +	PROBES_T32_MRS,
> +	PROBES_T32_BRANCH_COND,
> +	PROBES_T32_BRANCH,
> +	PROBES_T32_PLDI,
> +	PROBES_T32_LDR_LIT,
> +	PROBES_T32_LDRSTR,
> +	PROBES_T32_SIGN_EXTEND,
> +	PROBES_T32_MEDIA,
> +	PROBES_T32_REVERSE,
> +	PROBES_T32_MUL_ADD,
> +	PROBES_T32_MUL_ADD2,
> +	PROBES_T32_MUL_ADD_LONG
> +};
> +
> +enum probes_t16_action {
> +	PROBES_T16_ADD_SP,
> +	PROBES_T16_CBZ,
> +	PROBES_T16_SIGN_EXTEND,
> +	PROBES_T16_PUSH,
> +	PROBES_T16_POP,
> +	PROBES_T16_SEV,
> +	PROBES_T16_WFE,
> +	PROBES_T16_IT,
> +	PROBES_T16_CMP,
> +	PROBES_T16_ADDSUB,
> +	PROBES_T16_LOGICAL,
> +	PROBES_T16_BLX,
> +	PROBES_T16_HIREGOPS,
> +	PROBES_T16_LDR_LIT,
> +	PROBES_T16_LDRHSTRH,
> +	PROBES_T16_LDRSTR,
> +	PROBES_T16_ADR,
> +	PROBES_T16_LDMSTM,
> +	PROBES_T16_BRANCH_COND,
> +	PROBES_T16_BRANCH
> +};
> +

I think the above two enums belong in the next patch in the series, i.e.
"[PATCH v4 05/16] ARM: use a function table for determining instruction
interpreter actions"

-- 
Tixy


