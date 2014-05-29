Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231AbaE2JXO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 05:23:14 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33741 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932814AbaE2JXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 05:23:13 -0400
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH] arm64: kernel: initialize broadcast hrtimer based clock event device
Date: Thu, 29 May 2014 10:23:01 +0100
Message-Id: <1401355381-11446-1-git-send-email-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 1.8.4
X-OriginalArrivalTime: 29 May 2014 09:23:08.0079 (UTC) FILETIME=[9A5973F0:01CF7B1F]
X-MC-Unique: 114052910231101601
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s4T9NNd4007718

On platforms implementing CPU power management, the CPUidle subsystem
can allow CPUs to enter idle states where local timers logic is lost on power
down. To keep the software timers functional the kernel relies on an
always-on broadcast timer to be present in the platform to relay the
interrupt signalling the timer expiries.

For platforms implementing CPU core gating that do not implement an always-on
HW timer or implement it in a broken way, this patch adds code to initialize
the kernel software broadcast hrtimer upon boot. It relies on a dynamically
chosen CPU to be always powered-up. This CPU then relays the timer interrupt
to CPUs in deep-idle states through its HW local timer device.

On systems with power management capabilities but no functional HW broadcast
tick device, the hrtimer based clock event device allows the kernel to
enter high-resolution timer mode, which improves system latencies and saves
dynamic power.

The side effect of having a CPU always-on has implications on power management
platform capabilities and makes CPUidle suboptimal, since at least a CPU is
kept always in a shallow idle state by the kernel to relay timer interrupts,
but at least leaves the kernel with a functional system with some working power
management capabilities.

The hrtimer based clock event device has lowest possible rating so that,
if a platform contains a functional HW clock event device with broadcast
capabilities, that device is always chosen as a tick broadcast device instead
of the software based one, now present by default.

Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Will Deacon <will.deacon@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
---
 arch/arm64/kernel/time.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
index 29c39d5..3d43900 100644
--- a/arch/arm64/kernel/time.c
+++ b/arch/arm64/kernel/time.c
@@ -18,6 +18,7 @@
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/clockchips.h>
 #include <linux/export.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
@@ -67,6 +68,8 @@ void __init time_init(void)
 
 	clocksource_of_init();
 
+	tick_setup_hrtimer_broadcast();
+
 	arch_timer_rate = arch_timer_get_rate();
 	if (!arch_timer_rate)
 		panic("Unable to initialise architected timer.\n");
-- 
1.8.4


