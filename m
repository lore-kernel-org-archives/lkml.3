Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbbAMMUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 07:20:24 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39166 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbAMMUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 07:20:23 -0500
Message-ID: <54B50D7F.2050604@hitachi.com>
Date: Tue, 13 Jan 2015 21:20:15 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH 3.19 v2 3/3] x86: Enforce MAX_INSN_SIZE in the instruction
 decoder
References: <cover.1421103159.git.luto@amacapital.net> <71a49f266444c8f918b895ecd70c91a6e59b011f.1421103159.git.luto@amacapital.net>
In-Reply-To: <71a49f266444c8f918b895ecd70c91a6e59b011f.1421103159.git.luto@amacapital.net>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/13 8:04), Andy Lutomirski wrote:
> The instruction decoder used to assume that the input buffer was
> exactly MAX_INSN_SIZE bytes long.  Now that the input buffer has
> variable length, even if the input buffer is longer than
> MAX_INSN_SIZE, we should still reject instructions longer than
> MAX_INSN_SIZE, since a real CPU will reject them even if they're
> otherwise valid.
> 
> Other than potentially confusing some of the decoder sanity checks,
> I'm not aware of any actual problems that omitting this check would
> cause.
> 
> It's worth noting that MAX_INSN_SIZE is incorrectly set to 16.  This
> patch doesn't change that.  I'll submit a fix for that later.

Hm, this patch logic is OK, but the comment is a bit odd.
As you said, if the current code incorrectly set MAX_INSN_SIZE to 16,
the comment should not say "15" without changing MAX_INSN_SIZE itself.

Others are OK for me.

> 
> Fixes: 6ba48ff46f76 x86: Remove arbitrary instruction size limit in instruction decoder
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
> 
> Arguably, the limit could be hard-coded as 15 instead of relying on the
> macro.
> 
> arch/x86/lib/insn.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/arch/x86/lib/insn.c b/arch/x86/lib/insn.c
> index 1313ae6b478b..c5912d7a4a15 100644
> --- a/arch/x86/lib/insn.c
> +++ b/arch/x86/lib/insn.c
> @@ -52,6 +52,13 @@
>   */
>  void insn_init(struct insn *insn, const void *kaddr, int buf_len, int x86_64)
>  {
> +	/*
> +	 * Instructions longer than 15 bytes are invalid even if the

I meant you'd better use MAX_INSN_SIZE instead of "15 bytes" here.

Thank you,

> +	 * input buffer is long enough to hold them.
> +	 */
> +	if (buf_len > MAX_INSN_SIZE)
> +		buf_len = MAX_INSN_SIZE;
> +
>  	memset(insn, 0, sizeof(*insn));
>  	insn->kaddr = kaddr;
>  	insn->end_kaddr = kaddr + buf_len;
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


