Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965183AbaE2OZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:25:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48019 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934862AbaE2OZR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:25:17 -0400
Date: Thu, 29 May 2014 15:25:17 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH] arm64: kernel: initialize broadcast hrtimer based clock
 event device
Message-ID: <20140529142517.GA20798@red-moon>
References: <1401355381-11446-1-git-send-email-lorenzo.pieralisi@arm.com>
 <53871444.3080206@linux.vnet.ibm.com>
MIME-Version: 1.0
In-Reply-To: <53871444.3080206@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 29 May 2014 14:25:11.0948 (UTC) FILETIME=[CD0464C0:01CF7B49]
X-MC-Unique: 114052915251412501
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Preeti,

On Thu, May 29, 2014 at 12:04:36PM +0100, Preeti U Murthy wrote:
> Hi Lorenzo,
> 
> On 05/29/2014 02:53 PM, Lorenzo Pieralisi wrote:
> > On platforms implementing CPU power management, the CPUidle subsystem
> > can allow CPUs to enter idle states where local timers logic is lost on power
> > down. To keep the software timers functional the kernel relies on an
> > always-on broadcast timer to be present in the platform to relay the
> > interrupt signalling the timer expiries.
> > 
> > For platforms implementing CPU core gating that do not implement an always-on
> > HW timer or implement it in a broken way, this patch adds code to initialize
> > the kernel software broadcast hrtimer upon boot. It relies on a dynamically
> 
> It would be best to use the term "hrtimer based broadcast device"
> throughout the changelog for uniformity and to avoid confusion instead
> of mixing it with "software broadcast".

Agreed.

> > chosen CPU to be always powered-up. This CPU then relays the timer interrupt
> > to CPUs in deep-idle states through its HW local timer device.
> > 
> > On systems with power management capabilities but no functional HW broadcast
> > tick device, the hrtimer based clock event device allows the kernel to
> > enter high-resolution timer mode, which improves system latencies and saves
> > dynamic power.
> 
> Sorry but I do not understand the above paragraph. What do you mean by
> "allows the kernel to enter high resolution timer mode" ? And how does
> it improve system latency? I understand that the hrtimer based
> clockevent device saves dynamic power since it provides a mechanism in
> which cpus can enter deeper idle states.

See Mark's reply, I have nothing to add. I will remove this paragraph anyway.

> > The side effect of having a CPU always-on has implications on power management
> > platform capabilities and makes CPUidle suboptimal, since at least a CPU is
> > kept always in a shallow idle state by the kernel to relay timer interrupts,
> > but at least leaves the kernel with a functional system with some working power
> > management capabilities.
> > 
> > The hrtimer based clock event device has lowest possible rating so that,
> > if a platform contains a functional HW clock event device with broadcast
> > capabilities, that device is always chosen as a tick broadcast device instead
> > of the software based one, now present by default.
> 
> I think this statement "instead of the software based one, now present
> by default" is incorrect. The hrtimer based clock event device will come
> into picture only when the arch calls tick_setup_hrtimer_broadcast()
> explicitly. Otherwise either the arch should register a real clock
> device which does broadcast or should disable deep idle states where the
> local timers stop. So I would suggest skipping the last paragraph as it
> is not conveying anything in specific. The fact that a clock device with
> the highest rating will be chosen is already known and need not be
> mentioned explicitly IMHO.
> 
> > 
> > Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> > Cc: Will Deacon <will.deacon@arm.com>
> > Acked-by: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> > ---
> >  arch/arm64/kernel/time.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
> > index 29c39d5..3d43900 100644
> > --- a/arch/arm64/kernel/time.c
> > +++ b/arch/arm64/kernel/time.c
> > @@ -18,6 +18,7 @@
> >   * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> >   */
> >  
> > +#include <linux/clockchips.h>
> >  #include <linux/export.h>
> >  #include <linux/kernel.h>
> >  #include <linux/interrupt.h>
> > @@ -67,6 +68,8 @@ void __init time_init(void)
> >  
> >  	clocksource_of_init();
> >  
> > +	tick_setup_hrtimer_broadcast();
> > +
> >  	arch_timer_rate = arch_timer_get_rate();
> >  	if (!arch_timer_rate)
> >  		panic("Unable to initialise architected timer.\n");
> > 
> 
> You have defined flag "CPUIDLE_FLAG_TIMER_STOP" for your deep idle
> states in which timer stops right?

Yes, I would have noticed otherwise =)

Thanks,
Lorenzo

