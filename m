Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbbATN7j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 08:59:39 -0500
Received: from www.linutronix.de ([62.245.132.108]:49005 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbbATN7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 08:59:37 -0500
Date: Tue, 20 Jan 2015 14:59:16 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 3.19 v4 1/2] x86, mpx: Short-circuit the instruction
 decoder for unexpected opcodes
In-Reply-To: <44852495d71796ecf690208e2e908a1b25008a73.1421183147.git.luto@amacapital.net>
Message-ID: <alpine.DEB.2.11.1501201450220.5526@nanos>
References: <cover.1421183147.git.luto@amacapital.net> <44852495d71796ecf690208e2e908a1b25008a73.1421183147.git.luto@amacapital.net>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jan 2015, Andy Lutomirski wrote:

> This reduces the degree to which we're exposing the instruction decoder
> to malicious user code at very little complexity cost.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  arch/x86/mm/mpx.c | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/mm/mpx.c b/arch/x86/mm/mpx.c
> index 67ebf5751222..a73004330732 100644
> --- a/arch/x86/mm/mpx.c
> +++ b/arch/x86/mm/mpx.c
> @@ -230,6 +230,22 @@ static int mpx_insn_decode(struct insn *insn,
>  	 */
>  	if (!nr_copied)
>  		return -EFAULT;
> +
> +	/*
> +	 * We only _really_ need to decode bndcl/bndcn/bndcu
> +	 * Error out on anything else.  Check this before decoding the
> +	 * instruction to reduce our exposure to intentionally bad code
> +	 * to some extent.  Note that this shortcut can incorrectly return
> +	 * -EINVAL instead of -EFAULT under some circumstances.  This
> +	 * discrepancy has no effect.
> +	 */
> +	if (nr_copied < 2)
> +		goto bad_opcode;
> +	if (buf[0] != 0x0f)
> +		goto bad_opcode;
> +	if (buf[1] != 0x1a && buf[1] != 0x1b)
> +		goto bad_opcode;

These opcodes can never have a prefix? If so, then we want to add this
to the comment.

Thanks,

	tglx
