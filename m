Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607Ab3GLCMJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 22:12:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15350 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab3GLCMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 22:12:07 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=_govd7qWaBoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ZIb5cOGuYnAA:10 a=PLzQjFQzM9Uk5o6_xP0A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1373595125.17876.78.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2 v3] x86: make jump_label use int3-based patching
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jason Baron <jbaron@akamai.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Date: Thu, 11 Jul 2013 22:12:05 -0400
In-Reply-To: <alpine.LNX.2.00.1307112225060.29788@pobox.suse.cz>
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz>
	 <alpine.LNX.2.00.1307112225060.29788@pobox.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-11 at 22:26 +0200, Jiri Kosina wrote:
> Make jump labels use text_poke_bp() for text patching instead of 
> text_poke_smp(), avoiding the need for stop_machine().
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
> ---
> Changes:
> 
> - unchanged since v1, patch 1/2 is the one being updated
> 
>  arch/x86/kernel/jump_label.c |   16 ++++++++++++++--
>  1 files changed, 14 insertions(+), 2 deletions(-)
> 

Reviewed-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
> index 2889b3d..460f5d9 100644
> --- a/arch/x86/kernel/jump_label.c
> +++ b/arch/x86/kernel/jump_label.c
> @@ -37,7 +37,19 @@ static void __jump_label_transform(struct jump_entry *entry,
>  	} else
>  		memcpy(&code, ideal_nops[NOP_ATOMIC5], JUMP_LABEL_NOP_SIZE);
>  
> -	(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
> +	/*
> +	 * Make text_poke_bp() a default fallback poker.
> +	 *
> +	 * At the time the change is being done, just ignore whether we
> +	 * are doing nop -> jump or jump -> nop transition, and assume
> +	 * always nop being the 'currently valid' instruction
> +	 *
> +	 */
> +	if (poker)
> +		(*poker)((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE);
> +	else
> +		text_poke_bp((void *)entry->code, &code, JUMP_LABEL_NOP_SIZE,
> +			     (void *)entry->code + JUMP_LABEL_NOP_SIZE);
>  }
>  
>  void arch_jump_label_transform(struct jump_entry *entry,
> @@ -45,7 +57,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
>  {
>  	get_online_cpus();
>  	mutex_lock(&text_mutex);
> -	__jump_label_transform(entry, type, text_poke_smp);
> +	__jump_label_transform(entry, type, NULL);
>  	mutex_unlock(&text_mutex);
>  	put_online_cpus();
>  }


