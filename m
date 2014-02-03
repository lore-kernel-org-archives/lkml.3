Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaBCOZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 09:25:40 -0500
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:43965 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751886AbaBCOZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 09:25:38 -0500
Message-ID: <1391437498.3509.11.camel@linaro1.home>
Subject: Re: [PATCH v5 05/16] ARM: use a function table for determining
 instruction interpreter action
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        linux-kernel@vger.kernel.org, Rabin Vincent <rabin@rab.in>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        davem@davemloft.net, Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Date: Mon, 03 Feb 2014 14:24:58 +0000
In-Reply-To: <1390507559-4697-6-git-send-email-dave.long@linaro.org>
References: <1390507559-4697-1-git-send-email-dave.long@linaro.org>
	 <1390507559-4697-6-git-send-email-dave.long@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-23 at 15:05 -0500, David Long wrote:
> From: "David A. Long" <dave.long@linaro.org>
> 
> Make the instruction interpreter call back to semantic action functions
> through a function pointer array provided by the invoker.  The interpreter
> decodes the instructions into groups and uses the group number to index
> into the supplied array.  kprobes and uprobes code will each supply their
> own array of functions.
> 
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---

[...]

> --- a/arch/arm/kernel/probes.c
> +++ b/arch/arm/kernel/probes.c
> @@ -378,10 +378,11 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
>   */
>  int __kprobes
>  kprobe_decode_insn(kprobe_opcode_t insn, struct arch_specific_insn *asi,
> -		   const union decode_item *table, bool thumb)
> +		   const union decode_item *table, bool thumb,
> +		   const union decode_action *actions)
>  {
> -	const struct decode_header *h = (struct decode_header *)table;
> -	const struct decode_header *next;
> +	struct decode_header *h = (struct decode_header *)table;
> +	struct decode_header *next;

The decode tables are fixed structures which nothing should want to
modify, so I think the const's above should be kept. I believe that
you've had to resort to changing them because the following typedef
lacks a 'const' on the final argument....

[...]
> diff --git a/arch/arm/kernel/probes.h b/arch/arm/kernel/probes.h
> index c610fa9..81b6e61 100644
[...]
>  
> +typedef enum kprobe_insn (probes_custom_decode_t)(kprobe_opcode_t,
> +						  struct arch_specific_insn *,
> +						  struct decode_header *);
> +

Adding 'const' above will also have the knock on effect of requiring
const on all the 'custom decode' functions as well.

-- 
Tixy

