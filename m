Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab3KSJJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:09:08 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60564 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3KSJJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:09:04 -0500
Date: Tue, 19 Nov 2013 10:08:59 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: lenb@kernel.org, rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: shaohua.li@intel.com, rui.zhang@intel.com, arjan@linux.intel.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: acpi_pad mwait usage
Message-ID: <20131119090859.GC3694@twins.programming.kicks-ass.net>
References: <20131119090019.GJ3866@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119090019.GJ3866@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 10:00:19AM +0100, Peter Zijlstra wrote:
> Hi Len, Rafeal,
> 
> I stumbled over acpi_pad (yuck! ;-), but noticed that you don't set the
> task in polling mode while using mwait. This means we'll still happily
> send an IPI to wake you up.
> 
> A little something like the below should do; you might even be able to
> remove the smp_mb() but since it is completely undocumented (another
> fail) I couldn't tell if the implied barrier in
> current_set_polling_and_test() suffices to replace it, so I left it.
> 
> If it compiles and works; change it to a proper SOB:
> 
> Maybe-Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Of course one such driver is insufficient and you lot needed a second;
same issue:

---
 drivers/thermal/intel_powerclamp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index 8f181b3f842b..d8111e1ac62e 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -439,8 +439,11 @@ static int clamp_thread(void *arg)
 			local_touch_nmi();
 			stop_critical_timings();
 			__monitor((void *)&current_thread_info()->flags, 0, 0);
-			cpu_relax(); /* allow HT sibling to run */
-			__mwait(eax, ecx);
+			if (!current_set_polling_and_test()) {
+				cpu_relax(); /* allow HT sibling to run */
+				__mwait(eax, ecx);
+				__current_clr_polling();
+			}
 			start_critical_timings();
 			atomic_inc(&idle_wakeup_counter);
 		}
