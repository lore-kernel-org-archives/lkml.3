Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758070AbaE2RRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 13:17:01 -0400
Received: from service87.mimecast.com ([91.220.42.44]:49888 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757464AbaE2RRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 13:17:00 -0400
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: will.deacon@arm.com, mark.rutland@arm.com,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: [PATCH v2] arm64: kernel: initialize broadcast hrtimer based clock event device
Date: Thu, 29 May 2014 18:16:54 +0100
Message-Id: <1401383814-22600-1-git-send-email-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 1.8.4
X-OriginalArrivalTime: 29 May 2014 17:16:55.0899 (UTC) FILETIME=[CAA68AB0:01CF7B61]
X-MC-Unique: 114052918165800701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s4THH6Yr011332

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

Having a CPU always-on has implications on power management platform
capabilities and makes CPUidle suboptimal, since at least a CPU is kept
always in a shallow idle state by the kernel to relay timer interrupts,
but at least leaves the kernel with a functional system with some working
power management capabilities.

The hrtimer based clock event device is unconditionally registered, but
has the lowest possible rating such that any broadcast-capable HW clock
event device present will be chosen in preference as the tick broadcast
device.

Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Acked-by: Will Deacon <will.deacon@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
---
changes in v2:

- Reworded the commit log according to reviews

It should be ready to go.

Thanks,
Lorenzo

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


