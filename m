Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678AbbAOEZy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 23:25:54 -0500
Received: from ozlabs.org ([103.22.144.67]:41308 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbbAOEZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 23:25:53 -0500
Message-ID: <1421295950.11409.3.camel@ellerman.id.au>
Subject: Re: [PATCH] pseries/le: Fix endiannes issue in RTAS call from xmon
From: Michael Ellerman <mpe@ellerman.id.au>
To: Laurent Dufour <ldufour@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, paulus@samba.org
Date: Thu, 15 Jan 2015 15:25:50 +1100
In-Reply-To: <1416838073-16642-1-git-send-email-ldufour@linux.vnet.ibm.com>
References: <1416838073-16642-1-git-send-email-ldufour@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-24 at 15:07 +0100, Laurent Dufour wrote:
> On pseries system (LPAR) xmon failed to enter when running in LE mode, system
> is hunging. Inititating xmon will lead to such an output on the console:
> 
> SysRq : Entering xmon
> cpu 0x15: Vector: 0  at [c0000003f39ffb10]
>     pc: c00000000007ed7c: sysrq_handle_xmon+0x5c/0x70
>     lr: c00000000007ed7c: sysrq_handle_xmon+0x5c/0x70
>     sp: c0000003f39ffc70
>    msr: 8000000000009033
>   current = 0xc0000003fafa7180
>   paca    = 0xc000000007d75e80	 softe: 0	 irq_happened: 0x01
>     pid   = 14617, comm = bash
> Bad kernel stack pointer fafb4b0 at eca7cc4
> cpu 0x15: Vector: 300 (Data Access) at [c000000007f07d40]
>     pc: 000000000eca7cc4
>     lr: 000000000eca7c44
>     sp: fafb4b0
>    msr: 8000000000001000
>    dar: 10000000
>  dsisr: 42000000
>   current = 0xc0000003fafa7180
>   paca    = 0xc000000007d75e80	 softe: 0	 irq_happened: 0x01
>     pid   = 14617, comm = bash
> cpu 0x15: Exception 300 (Data Access) in xmon, returning to main loop
> xmon: WARNING: bad recursive fault on cpu 0x15
> 
> The root cause is that xmon is calling RTAS to turn off the surveillance
> when entering xmon, and RTAS is requiring big endian parameters.
> 
> This patch is byte swapping the RTAS arguments when running in LE mode.
> 
> Signed-off-by: Laurent Dufour <ldufour@linux.vnet.ibm.com>
> ---
>  arch/powerpc/xmon/xmon.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
> index b988b5addf86..c8efbb37d6e0 100644
> --- a/arch/powerpc/xmon/xmon.c
> +++ b/arch/powerpc/xmon/xmon.c
> @@ -293,10 +293,10 @@ static inline void disable_surveillance(void)
>  	args.token = rtas_token("set-indicator");
>  	if (args.token == RTAS_UNKNOWN_SERVICE)
>  		return;

I just noticed we're not handling the token correctly here. It is be32 also.

cheers


