Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268Ab3LTO6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 09:58:44 -0500
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:59662 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751101Ab3LTO6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 09:58:43 -0500
Message-ID: <1387551482.3404.63.camel@linaro1.home>
Subject: Re: [PATCH v4 13/16] ARM: Add an emulate flag to the
 kprobes/uprobes instruction decode functions
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
Date: Fri, 20 Dec 2013 14:58:02 +0000
In-Reply-To: <1387166930-13182-14-git-send-email-dave.long@linaro.org>
References: <1387166930-13182-1-git-send-email-dave.long@linaro.org>
	 <1387166930-13182-14-git-send-email-dave.long@linaro.org>
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
> Add an emulate flag into the instruction interpreter, primarily for uprobes
> support.
> 
> Signed-off-by: David A. Long <dave.long@linaro.org>
> ---
>  arch/arm/kernel/kprobes.c      |  3 ++-
>  arch/arm/kernel/kprobes.h      |  1 +
>  arch/arm/kernel/probes-arm.c   |  4 ++--
>  arch/arm/kernel/probes-arm.h   |  2 +-
>  arch/arm/kernel/probes-thumb.c |  8 ++++----
>  arch/arm/kernel/probes-thumb.h |  4 ++--
>  arch/arm/kernel/probes.c       | 32 +++++++++++++++++++++++---------
>  arch/arm/kernel/probes.h       |  2 +-
>  8 files changed, 36 insertions(+), 20 deletions(-)
> 
> diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
> index 0d9d49b..04690f9 100644
> --- a/arch/arm/kernel/kprobes.c
> +++ b/arch/arm/kernel/kprobes.c
> @@ -87,7 +87,8 @@ int __kprobes arch_prepare_kprobe(struct kprobe *p)
>  	p->opcode = insn;
>  	p->ainsn.insn = tmp_insn;
>  
> -	switch ((*decode_insn)(insn, &p->ainsn, actions)) {
> +	switch ((*decode_insn)(insn, &p->ainsn,
> +			       true, actions)) {

Any reason why the function args need splitting over two lines?

>  	case INSN_REJECTED:	/* not supported */
>  		return -EINVAL;
>  

[...]

> --- a/arch/arm/kernel/probes.c
> +++ b/arch/arm/kernel/probes.c
> @@ -193,7 +193,7 @@ void __kprobes probes_emulate_none(probes_opcode_t opcode,
>   */
>  static probes_opcode_t __kprobes
>  prepare_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
> -								bool thumb)
> +			bool thumb)

Seems like a spurious indentation change.

>  {
>  #ifdef CONFIG_THUMB2_KERNEL
>  	if (thumb) {
> @@ -218,7 +218,7 @@ prepare_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
>   */
>  static void  __kprobes
>  set_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
> -								bool thumb)
> +			bool thumb)

Another spurious whitespace change.

>  {
>  #ifdef CONFIG_THUMB2_KERNEL
>  	if (thumb) {
> @@ -253,7 +253,7 @@ set_emulated_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
>   * non-zero value, the corresponding nibble in pinsn is validated and modified
>   * according to the type.
>   */
> -static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs)
> +static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs, bool modify)
>  {
>  	probes_opcode_t insn = *pinsn;
>  	probes_opcode_t mask = 0xf; /* Start at least significant nibble */
> @@ -317,9 +317,16 @@ static bool __kprobes decode_regs(probes_opcode_t *pinsn, u32 regs)
>  		/* Replace value of nibble with new register number... */
>  		insn &= ~mask;
>  		insn |= new_bits & mask;
> +		if (modify) {
> +			/* Replace value of nibble with new register number */
> +			insn &= ~mask;
> +			insn |= new_bits & mask;
> +		}

Huh? As is, the above addition doesn't do anything because insn has
already been modified. I guess you played with the idea that you needed
to avoid changing insn (you don't) and then didn't undo the experiment
quite right. :-)

>  	}
>  
> -	*pinsn = insn;
> +	if (modify)
> +		*pinsn = insn;
> +
>  	return true;
>  
>  reject:
> @@ -380,14 +387,15 @@ static const int decode_struct_sizes[NUM_DECODE_TYPES] = {
>   */
>  int __kprobes
>  probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
> -				const union decode_item *table, bool thumb,
> -				const union decode_item *actions)
> +		   const union decode_item *table, bool thumb,
> +		   bool emulate, const union decode_item *actions)
>  {
>  	struct decode_header *h = (struct decode_header *)table;
>  	struct decode_header *next;
>  	bool matched = false;
>  
> -	insn = prepare_emulated_insn(insn, asi, thumb);
> +	if (emulate)
> +		insn = prepare_emulated_insn(insn, asi, thumb);
>  
>  	for (;; h = next) {
>  		enum decode_type type = h->type_regs.bits & DECODE_TYPE_MASK;
> @@ -402,7 +410,7 @@ probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
>  		if (!matched && (insn & h->mask.bits) != h->value.bits)
>  			continue;
>  
> -		if (!decode_regs(&insn, regs))
> +		if (!decode_regs(&insn, regs, emulate))
>  			return INSN_REJECTED;
>  
>  		switch (type) {
> @@ -415,7 +423,8 @@ probes_decode_insn(probes_opcode_t insn, struct arch_specific_insn *asi,
>  
>  		case DECODE_TYPE_CUSTOM: {
>  			struct decode_custom *d = (struct decode_custom *)h;
> -			return actions[d->decoder.bits].decoder(insn, asi, h);
> +			return actions[d->decoder.bits].decoder(insn,
> +					asi, h);

No need to split the above line, you haven't changed it and it doesn't
exceed 80 characters anyway.

[Rest of patch cut]

-- 
Tixy

