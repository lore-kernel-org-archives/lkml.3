Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab3E1Knp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 06:43:45 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48790 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755737Ab3E1Kno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 06:43:44 -0400
Date: Tue, 28 May 2013 11:42:50 +0100
From: Will Deacon <will.deacon@arm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "vgupta@synopsys.com" <vgupta@synopsys.com>,
        Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2] arch: arm64: kernel: sprintf(), 'str' needs
 additional 1 byte for failure processing
Message-ID: <20130528104250.GE10474@mudshark.cambridge.arm.com>
References: <51A1E3B3.4060901@asianux.com>
 <51A2BE2C.2000004@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A2BE2C.2000004@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, May 27, 2013 at 03:00:12AM +0100, Chen Gang wrote:
> 
> When failure occurs at the last looping cycle (when 'i == 0'), it will
> print "bad PC value" instead of "(%08x) ", which needs additional 1
> byte.
> 
> If not add 1 byte, the 'str' may be memory overflow.
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/arm64/kernel/traps.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index 61d7dd2..c2f68d2 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -100,7 +100,7 @@ static void dump_instr(const char *lvl, struct pt_regs *regs)
>  {
>  	unsigned long addr = instruction_pointer(regs);
>  	mm_segment_t fs;
> -	char str[sizeof("00000000 ") * 5 + 2 + 1], *p = str;
> +	char str[sizeof("00000000 ") * 5 + 2 + 1 + 1], *p = str;
>  	int i;

Whilst this code is difficult to follow, I don't think it's incorrect.
The size of the str array is:

	sizeof("00000000 ") = 8 ('0's) + 1 (space) + 1 (NUL) = 10 bytes
	*5 = 50 bytes
	+2 (for the two brackets when i == 0) = 52 bytes
	+1 (this is for the "bad PC value") = 53 bytes

In the worst case (when the PC is bad) we print:

	"%08x " x4 = (8 + 1 + 1) *4 = 40 bytes
	"bad PC value" = 12 + 1 = 13 bytes

so again, 53 bytes.

... or have I missed a character somewhere?

Will
