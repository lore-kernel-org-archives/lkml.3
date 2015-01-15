Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbbAOMh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 07:37:56 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42194 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbbAOMhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:37:54 -0500
Message-ID: <54B7B49C.90003@hitachi.com>
Date: Thu, 15 Jan 2015 21:37:48 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 3.19 v4 2/2] x86: Enforce maximum instruction size
 in the instruction decoder
References: <cover.1421183147.git.luto@amacapital.net> <6ceb805aba0291431f19f72d7f2e765f3a0a9fcf.1421183147.git.luto@amacapital.net>
In-Reply-To: <6ceb805aba0291431f19f72d7f2e765f3a0a9fcf.1421183147.git.luto@amacapital.net>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/14 6:49), Andy Lutomirski wrote:
> x86 instructions cannot exceed 15 bytes, and the instruction decoder
> should enforce that.  Prior to 6ba48ff46f76, the instruction length
> limit was implicitly set to 16, which was an approximation of 15,
> but there is currently no limit at all.
> 
> Fix the decoder to reject instructions that exceed 15 bytes.
> A subsequent patch (targetted for 3.20) will fix MAX_INSN_SIZE.

Hmm, is there any problem to just change MAX_INSN_SIZE to 15?

> Other than potentially confusing some of the decoder sanity checks,
> I'm not aware of any actual problems that omitting this check would
> cause.
> 
> Fixes: 6ba48ff46f76 x86: Remove arbitrary instruction size limit in instruction decoder
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/lib/insn.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
> index 2480978b31cc..7b80745d2c5a 100644
> --- a/arch/x86/lib/insn.c
> +++ b/arch/x86/lib/insn.c
> @@ -52,6 +52,13 @@
>   */
>  void insn_init(struct insn *insn, const void *kaddr, int buf_len, int x86_64)
>  {
> +	/*
> +	 * Instructions longer than 15 bytes are invalid even if the
> +	 * input buffer is long enough to hold them.
> +	 */
> +	if (buf_len > 15)
> +		buf_len = 15;
> +

Without changing the MAX_INSN_SIZE, this looks very odd, since all other
code suppose that the max length of an instruction is 16 (MAX_INSN_SIZE)
except here.

Thank you,

>  	memset(insn, 0, sizeof(*insn));
>  	insn->kaddr = kaddr;
>  	insn->end_kaddr = kaddr + buf_len;
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


