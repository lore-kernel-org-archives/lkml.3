Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbaE3GGt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 02:06:49 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37406 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaE3GGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 02:06:48 -0400
Message-ID: <53881ED1.2040907@linux.vnet.ibm.com>
Date: Fri, 30 May 2014 11:31:53 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, will.deacon@arm.com,
        mark.rutland@arm.com
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] arm64: kernel: initialize broadcast hrtimer based
 clock event device
References: <1401383814-22600-1-git-send-email-lorenzo.pieralisi@arm.com>
In-Reply-To: <1401383814-22600-1-git-send-email-lorenzo.pieralisi@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14053006-6688-0000-0000-00000231CD8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2014 10:46 PM, Lorenzo Pieralisi wrote:
> On platforms implementing CPU power management, the CPUidle subsystem
> can allow CPUs to enter idle states where local timers logic is lost on power
> down. To keep the software timers functional the kernel relies on an
> always-on broadcast timer to be present in the platform to relay the
> interrupt signalling the timer expiries.
> 
> For platforms implementing CPU core gating that do not implement an always-on
> HW timer or implement it in a broken way, this patch adds code to initialize
> the kernel hrtimer based clock event device upon boot (which can be chosen as
> tick broadcast device by the kernel).
> It relies on a dynamically chosen CPU to be always powered-up. This CPU then
> relays the timer interrupt to CPUs in deep-idle states through its HW local
> timer device.
> 
> Having a CPU always-on has implications on power management platform
> capabilities and makes CPUidle suboptimal, since at least a CPU is kept
> always in a shallow idle state by the kernel to relay timer interrupts,
> but at least leaves the kernel with a functional system with some working
> power management capabilities.
> 
> The hrtimer based clock event device is unconditionally registered, but
> has the lowest possible rating such that any broadcast-capable HW clock
> event device present will be chosen in preference as the tick broadcast
> device.
> 
> Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> Acked-by: Will Deacon <will.deacon@arm.com>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> ---
> changes in v2:
> 
> - Reworded the commit log according to reviews
> 
> It should be ready to go.
> 
> Thanks,
> Lorenzo
> 
>  arch/arm64/kernel/time.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
> index 6815987..1a7125c 100644
> --- a/arch/arm64/kernel/time.c
> +++ b/arch/arm64/kernel/time.c
> @@ -18,6 +18,7 @@
>   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>   */
>  
> +#include <linux/clockchips.h>
>  #include <linux/export.h>
>  #include <linux/kernel.h>
>  #include <linux/interrupt.h>
> @@ -69,6 +70,8 @@ void __init time_init(void)
>  	of_clk_init(NULL);
>  	clocksource_of_init();
>  
> +	tick_setup_hrtimer_broadcast();
> +
>  	arch_timer_rate = arch_timer_get_rate();
>  	if (!arch_timer_rate)
>  		panic("Unable to initialise architected timer.\n");
> 
Reviewed-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>

