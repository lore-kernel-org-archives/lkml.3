Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbaDXXay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 19:30:54 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58950 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535AbaDXXaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 19:30:52 -0400
Subject: Re: [PATCH 5/5] uprobes/x86: Move default_xol_ops's data into
 arch_uprobe->def
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140422144753.GA8062@redhat.com>
References: <20140422144753.GA8062@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Apr 2014 16:30:47 -0700
Message-ID: <1398382247.4536.12.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042423-3532-0000-0000-0000014B4178
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-22 at 16:47 +0200, Oleg Nesterov wrote:
> Finally we can move arch_uprobe->fixups/rip_rela_target_address
> into the new "def" struct and place this struct in the union, they
> are only used by default_xol_ops paths.
> 
> The patch also renames rip_rela_target_address to riprel_target just
> to make this name shorter.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

I see a couple of nits in this patch (see below), but the others look
good.

Patches 1-5 of this set:
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>

> ---
>  arch/x86/include/asm/uprobes.h |   12 ++++++----
>  arch/x86/kernel/uprobes.c      |   41 +++++++++++++++++++--------------------
>  2 files changed, 27 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index 93bee7b..72caff7 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -41,18 +41,20 @@ struct arch_uprobe {
>  		u8			ixol[MAX_UINSN_BYTES];
>  	};
> 
> -	u16				fixups;
>  	const struct uprobe_xol_ops	*ops;
> 
>  	union {
> -#ifdef CONFIG_X86_64
> -		unsigned long			rip_rela_target_address;
> -#endif
>  		struct {
>  			s32	offs;
>  			u8	ilen;
>  			u8	opc1;
> -		}				branch;
> +		}			branch;
> +		struct {
> +#ifdef CONFIG_X86_64
> +			long	riprel_target;
> +#endif
> +			u16	fixups;
> +		} 			def;

"def" is kind of ambiguous.  How about "dfault" or some such?

>  	};
>  };
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index e6314a2..69b2d61 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
...
> @@ -636,12 +635,12 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
> 
>  	/*
>  	 * Figure out which fixups arch_uprobe_post_xol() will need to perform,
> -	 * and annotate arch_uprobe->fixups accordingly. To start with, ->fixups
> -	 * is either zero or it reflects rip-related fixups.
> +	 * and annotate def->fixups accordingly. To start with, ->fixups is
> +	 * either zero or it reflects rip-related fixups.

That sentence stopped being true a couple of patch sets ago.
handle_riprel_insn() is called later in this function now.

>  	 */
>  	switch (OPCODE1(&insn)) {
>  	case 0x9d:		/* popf */
> -		auprobe->fixups |= UPROBE_FIX_SETF;
> +		auprobe->def.fixups |= UPROBE_FIX_SETF;
>  		break;
>  	case 0xc3:		/* ret or lret -- ip is correct */
>  	case 0xcb:
> @@ -669,9 +668,9 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe, struct mm_struct *mm,
>  	}
> 
>  	if (fix_ip)
> -		auprobe->fixups |= UPROBE_FIX_IP;
> +		auprobe->def.fixups |= UPROBE_FIX_IP;
>  	if (fix_call)
> -		auprobe->fixups |= UPROBE_FIX_CALL;
> +		auprobe->def.fixups |= UPROBE_FIX_CALL;
> 
>  	auprobe->ops = &default_xol_ops;
>  	return 0;

Jim

