Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030199AbaEQQAE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 12:00:04 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:45209 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030183AbaEQQAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 12:00:01 -0400
Message-ID: <5377877A.2070205@hitachi.com>
Date: Sun, 18 May 2014 00:59:54 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Frank Ch. Eigler" <fche@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/2] x86: insn decoder: create artificial 3rd byte for
 2-byte VEX
References: <1400265279-22503-1-git-send-email-dvlasenk@redhat.com>
In-Reply-To: <1400265279-22503-1-git-send-email-dvlasenk@redhat.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/05/17 3:34), Denys Vlasenko wrote:
> Before this patch, users need to do this to fetch vex.vvvv:
> 
>         if (insn->vex_prefix.nbytes == 2) {
>                 vex_vvvv = ((insn->vex_prefix.bytes[1] >> 3) & 0xf) ^ 0xf;
>         }
>         if (insn->vex_prefix.nbytes == 3) {
>                 vex_vvvv = ((insn->vex_prefix.bytes[2] >> 3) & 0xf) ^ 0xf;
>         }
> 
> Make it so that insn->vex_prefix.bytes[2] always contains vex.wvvvvLpp bits.

I like this hack :)
If you don't mind, please add inline functions to get such vex bits from
struct insn too?

Thank you,

> 
> Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Frank Ch. Eigler <fche@redhat.com>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/lib/insn.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
> index 54fcffe..829ca4c 100644
> --- a/arch/x86/lib/insn.c
> +++ b/arch/x86/lib/insn.c
> @@ -163,6 +163,12 @@ found:
>  				/* VEX.W overrides opnd_size */
>  				insn->opnd_bytes = 8;
>  		} else {
> +			/*
> +			 * For VEX2, fake VEX3-like byte#2.
> +			 * Makes it easier to decode vex.W, vex.vvvv,
> +			 * vex.L and vex.pp. Masking with 0x7f sets vex.W == 0.
> +			 */
> +			insn->vex_prefix.bytes[2] = b2 & 0x7f;
>  			insn->vex_prefix.nbytes = 2;
>  			insn->next_byte += 2;
>  		}
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


