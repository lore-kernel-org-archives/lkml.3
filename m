Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab3JaQRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 12:17:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42195 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab3JaQRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 12:17:51 -0400
Date: Thu, 31 Oct 2013 16:17:39 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Subject: Re: [PATCH 1/6] arm: zynq: platsmp: Fix CPU presence check
Message-ID: <20131031161739.GE16735@n2100.arm.linux.org.uk>
References: <1383235819-2552-1-git-send-email-soren.brinkmann@xilinx.com> <1383235819-2552-2-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383235819-2552-2-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 09:10:14AM -0700, Soren Brinkmann wrote:
> From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> 
> Fix an off-by-one error in the logic that checks if a CPU is present.
> The ncores variable is a count of cores while the cpu variable is a
> 0 based index. So if ncores == cpu, cpu is out of range. Fix this
> comparison so non-existent CPUs are not probed.
> 
> Signed-off-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

There's another two bugs here.

> ---
>  arch/arm/mach-zynq/platsmp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-zynq/platsmp.c b/arch/arm/mach-zynq/platsmp.c
> index 689fbbc3d9c8..2512624e657d 100644
> --- a/arch/arm/mach-zynq/platsmp.c
> +++ b/arch/arm/mach-zynq/platsmp.c
> @@ -39,7 +39,7 @@ int zynq_cpun_start(u32 address, int cpu)
>  	u32 trampoline_code_size = &zynq_secondary_trampoline_end -
>  						&zynq_secondary_trampoline;
>  
> -	if (cpu > ncores) {
> +	if (cpu >= ncores) {
>  		pr_warn("CPU No. is not available in the system\n");

Much better: pr_warn("CPU%d is not available\n", cpu);

However, if you have set the cpu possible/present masks correctly,
you will never hit this because the generic code already checks that
the CPU being requested is legal.  So actually I'd suggest getting
rid of this entire if() statement and block.

>  		return -1;

The second issue is one of laziness.  -1 as a return code for something
that gets propagated back to userspace.  Do we really mean to return to
userspace -EPERM because of this or other failures in this function?
All those idiotic and lazy (and that's exactly what they are - idiotic
and lazy) "return -1" statements need to be fixed.

Shame on the arm-soc maintainers for not having an automatic filter for
this kind of sloppy programming.
