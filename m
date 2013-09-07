Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750881Ab3IGFMG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 01:12:06 -0400
Received: from relais.videotron.ca ([24.201.245.36]:37156 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3IGFME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 01:12:04 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_6cOKL2j+ZF39l7tNQVU3Fg)"
Date: Sat, 07 Sep 2013 01:12:03 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: behanw@converseincode.com
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Mark Charlebois <charlebm@gmail.com>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/5] arm: LLVMLinux: use current_stack_pointer for percpu
In-reply-to: <1378502899-1241-3-git-send-email-behanw@converseincode.com>
Message-id: <alpine.LFD.2.03.1309070101330.20709@syhkavp.arg>
References: <1378502899-1241-1-git-send-email-behanw@converseincode.com>
 <1378502899-1241-3-git-send-email-behanw@converseincode.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_6cOKL2j+ZF39l7tNQVU3Fg)
Content-type: TEXT/PLAIN; charset=UTF-8
Content-transfer-encoding: 8BIT

On Fri, 6 Sep 2013, behanw@converseincode.com wrote:

> From: Behan Webster <behanw@converseincode.com>
> 
> The existing code uses named registers to get the value of the stack pointer.
> The new current_stack_pointer macro is more readable and allows for a central
> portable implementation of how to get the stack pointer with ASM.  This change
> supports being able to compile the kernel with both gcc and Clang.
> 
> Signed-off-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
> ---
>  arch/arm/include/asm/percpu.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/percpu.h b/arch/arm/include/asm/percpu.h
> index 209e650..629a975 100644
> --- a/arch/arm/include/asm/percpu.h
> +++ b/arch/arm/include/asm/percpu.h
> @@ -30,14 +30,14 @@ static inline void set_my_cpu_offset(unsigned long off)
>  static inline unsigned long __my_cpu_offset(void)
>  {
>  	unsigned long off;
> -	register unsigned long *sp asm ("sp");
> +	unsigned long sp = current_stack_pointer;
>  
>  	/*
>  	 * Read TPIDRPRW.
>  	 * We want to allow caching the value, so avoid using volatile and
>  	 * instead use a fake stack read to hazard against barrier().
>  	 */
> -	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (off) : "Q" (*sp));
> +	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (off) : "Q" (sp));

This change doesn't look to be equivalent.  Previously the *sp implied a 
memory location which doesn't appear to be the case anymore.

this sp trickery was introduced in commit 509eb76ebf97 to solve bad code 
generation (the commit log has the details).  It would be good if Will 
Deacon could confirm that his test case still works fine with your 
change.


Nicolas

--Boundary_(ID_6cOKL2j+ZF39l7tNQVU3Fg)--
