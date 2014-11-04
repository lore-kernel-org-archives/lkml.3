Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaKDI3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 03:29:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:35042 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbaKDI3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 03:29:07 -0500
Date: Tue, 4 Nov 2014 09:29:01 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Maxime COQUELIN <maxime.coquelin@st.com>
Cc: gong.chen@linux.intel.com, Ingo Molnar <mingo@kernel.org>,
        " Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, tytso@mit.edu,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel@stlinux.com, eric.paire@st.com
Subject: Re: [PATCH] bitops: Fix shift overflow in GENMASK macros
Message-ID: <20141104082901.GF10501@worktop.programming.kicks-ass.net>
References: <1415036398-26984-1-git-send-email-maxime.coquelin@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415036398-26984-1-git-send-email-maxime.coquelin@st.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 06:39:58PM +0100, Maxime COQUELIN wrote:
> On some 32 bits architectures, including x86, GENMASK(31, 0) returns 0
> instead of the expected ~0UL.
> 
> This is the same on some 64 bits architectures with GENMASK_ULL(63, 0).
> 
> This is due to an overflow in the shift operand, 1 << 32 for GENMASK,
> 1 << 64 for GENMASK_ULL.
> 
> Fixes: 10ef6b0dffe404bcc54e94cb2ca1a5b18445a66b
> Cc: <stable@vger.kernel.org> #v3.13+
> Reported-by: Eric Paire <eric.paire@st.com>
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> ---
>  include/linux/bitops.h | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/bitops.h b/include/linux/bitops.h
> index be5fd38..81f9725 100644
> --- a/include/linux/bitops.h
> +++ b/include/linux/bitops.h
> @@ -18,8 +18,12 @@
>   * position @h. For example
>   * GENMASK_ULL(39, 21) gives us the 64bit vector 0x000000ffffe00000.
>   */
> -#define GENMASK(h, l)		(((U32_C(1) << ((h) - (l) + 1)) - 1) << (l))
> -#define GENMASK_ULL(h, l)	(((U64_C(1) << ((h) - (l) + 1)) - 1) << (l))
> +#define GENMASK(h, l) \
> +	((~0UL >> ((BITS_PER_LONG - 1) - (h))) & ~((1UL << (l)) - 1))
> +
> +#define GENMASK_ULL(h, l) \
> +	((~0ULL >> ((BITS_PER_LONG_LONG - 1) - (h))) & ~((1ULL << (l)) - 1))
> +

I was not expecting the mask there, but instead something like:

	((~0UL >> (BITS_PER_LONG - (h-l+1))) << l)

which shifts the bits to the desired length and then back to the desired
place. Would that not be more readable?

