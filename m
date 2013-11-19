Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab3KSJAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 04:00:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60478 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3KSJA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 04:00:29 -0500
Date: Tue, 19 Nov 2013 10:00:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: lenb@kernel.org, rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: shaohua.li@intel.com
Subject: acpi_pad mwait usage
Message-ID: <20131119090019.GJ3866@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Len, Rafeal,

I stumbled over acpi_pad (yuck! ;-), but noticed that you don't set the
task in polling mode while using mwait. This means we'll still happily
send an IPI to wake you up.

A little something like the below should do; you might even be able to
remove the smp_mb() but since it is completely undocumented (another
fail) I couldn't tell if the implied barrier in
current_set_polling_and_test() suffices to replace it, so I left it.

If it compiles and works; change it to a proper SOB:

Maybe-Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 drivers/acpi/acpi_pad.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index fc6008fbce35..e9126efe7786 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -195,8 +195,10 @@ static int power_saving_thread(void *data)
 
 			__monitor((void *)&current_thread_info()->flags, 0, 0);
 			smp_mb();
-			if (!need_resched())
+			if (!current_set_polling_and_test()) {
 				__mwait(power_saving_mwait_eax, 1);
+				__current_clr_polling();
+			}
 
 			start_critical_timings();
 			if (lapic_marked_unstable)
