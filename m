Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab3GLFo2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 01:44:28 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:38780 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab3GLFo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 01:44:27 -0400
Message-ID: <51DF97B8.2010009@hitachi.com>
Date: Fri, 12 Jul 2013 14:44:24 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@akamai.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] x86: make jump_label use int3-based patching
References: <alpine.LNX.2.00.1307102213140.25858@pobox.suse.cz> <alpine.LNX.2.00.1307112225060.29788@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1307112225060.29788@pobox.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/07/12 5:26), Jiri Kosina wrote:
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

BTW, if the poker is NULL or text_poke_early, I think it doesn't need to
pass it to __jump_label_transform, does it?

Thank you,
-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


