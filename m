Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006AbaE2O3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:29:09 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60906 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaE2O3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:29:07 -0400
Date: Thu, 29 May 2014 15:29:12 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: [PATCH] arm64: kernel: initialize broadcast hrtimer based clock
 event device
Message-ID: <20140529142912.GB20798@red-moon>
References: <1401355381-11446-1-git-send-email-lorenzo.pieralisi@arm.com>
 <53871444.3080206@linux.vnet.ibm.com>
 <20140529123929.GF24233@leverpostej>
MIME-Version: 1.0
In-Reply-To: <20140529123929.GF24233@leverpostej>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 29 May 2014 14:29:05.0059 (UTC) FILETIME=[57F64F30:01CF7B4A]
X-MC-Unique: 114052915290521201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 01:39:29PM +0100, Mark Rutland wrote:

[...]

> > > The side effect of having a CPU always-on has implications on power management
> > > platform capabilities and makes CPUidle suboptimal, since at least a CPU is
> > > kept always in a shallow idle state by the kernel to relay timer interrupts,
> > > but at least leaves the kernel with a functional system with some working power
> > > management capabilities.
> > > 
> > > The hrtimer based clock event device has lowest possible rating so that,
> > > if a platform contains a functional HW clock event device with broadcast
> > > capabilities, that device is always chosen as a tick broadcast device instead
> > > of the software based one, now present by default.
> > 
> > I think this statement "instead of the software based one, now present
> > by default" is incorrect. The hrtimer based clock event device will come
> > into picture only when the arch calls tick_setup_hrtimer_broadcast()
> > explicitly. Otherwise either the arch should register a real clock
> > device which does broadcast or should disable deep idle states where the
> > local timers stop. So I would suggest skipping the last paragraph as it
> > is not conveying anything in specific. The fact that a clock device with
> > the highest rating will be chosen is already known and need not be
> > mentioned explicitly IMHO.
> 
> I think it is worth keeping the paragraph to allay anyone's fear that
> the hrtimer based broadcast device might be selected in preference to a
> real suitable clock. I would otherwise not be aware that the hrtimer
> based broadcast device had the lowest rating (and would have to go and
> look that up separately).
> 
> As the arch code has delegated timer registration to
> clocksoruce_of_init, it doesn't know whether any of the real devices
> that may have been registered are suitable as a broadcast source for
> oneshot events. So we can't conditionally register the hrtimer based
> broadcast device.
> 
> Perhaps we could replace "now present by default" with "which is
> unconditionally registered in case no suitable hardware device is
> present"?

How about this:

-- >8 --
Subject: [PATCH] arm64: kernel: initialize broadcast hrtimer based clock event
 device

On platforms implementing CPU power management, the CPUidle subsystem
can allow CPUs to enter idle states where local timers logic is lost on power
down. To keep the software timers functional the kernel relies on an
always-on broadcast timer to be present in the platform to relay the
interrupt signalling the timer expiries.

For platforms implementing CPU core gating that do not implement an always-on
HW timer or implement it in a broken way, this patch adds code to initialize
the kernel hrtimer based clock event device upon boot (which can be chosen as
tick broadcast device by the kernel).
It relies on a dynamically chosen CPU to be always powered-up. This CPU then
relays the timer interrupt to CPUs in deep-idle states through its HW local
timer device.

The side effect of having a CPU always-on has implications on power management
platform capabilities and makes CPUidle suboptimal, since at least a CPU is
kept always in a shallow idle state by the kernel to relay timer interrupts,
but at least leaves the kernel with a functional system with some working power
management capabilities.

The hrtimer based clock event device has lowest possible rating so that,
if a platform contains a functional HW clock event device with broadcast
capabilities, that device is always chosen as a tick broadcast device instead
of the hrtimer based one, which is unconditionally registered in case no
suitable hardware clock event device is present.

Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
---
 arch/arm64/kernel/time.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index 6815987..1a7125c 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -18,6 +18,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/clockchips.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
@@ -69,6 +70,8 @@ void __init time_init(void)
 	of_clk_init(NULL);
 	clocksource_of_init();
 
+	tick_setup_hrtimer_broadcast();
+
 	arch_timer_rate = arch_timer_get_rate();
 	if (!arch_timer_rate)
 		panic("Unable to initialise architected timer.\n");
-- 
1.8.4


