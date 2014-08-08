Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759733AbaHHWeJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 18:34:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40092 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbaHHUli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:41:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tony Camuso <tcamuso@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 001/259] ACPI / PAD: call schedule() when need_resched() is true
Date: Fri,  8 Aug 2014 13:37:04 -0700
Message-Id: <1407530482-4483-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Camuso <tcamuso@redhat.com>

commit 5b59c69ec54849f23b51d18b0a609c4f793bc35a upstream.

The purpose of the acpi_pad driver is to implement the "processor power
aggregator" device as described in the ACPI 4.0 spec section 8.5. It
takes requests from the BIOS (via ACPI) to put a specified number of
CPUs into idle, in order to save power, until further notice.

It does this by creating high-priority threads that try to keep the CPUs
in a high C-state (using the monitor/mwait CPU instructions). The
mwait() call is in a loop that checks periodically if the thread should
end and a few other things.

It was discovered through testing that the power_saving threads were
causing the system to consume more power than the system was consuming
before the threads were created. A counter in the main loop of
power_saving_thread() revealed that it was spinning. The mwait()
instruction was not keeping the CPU in a high C state very much if at
all.

Here is a simplification of the loop in function power_saving_thread() in
drivers/acpi/acpi_pad.c

    while (!kthread_should_stop()) {
         :
        try_to_freeze()
         :
        while (!need_resched()) {
             :
            if (!need_resched())
                __mwait(power_saving_mwait_eax, 1);
             :
            if (jiffies > expire_time) {
                do_sleep = 1;
                break;
            }
        }
    }

If need_resched() returns true, then mwait() is not called. It was
returning true because of things like timer interrupts, as in the
following sequence.

hrtimer_interrupt->__run_hrtimer->tick_sched_timer-> update_process_times->
rcu_check_callbacks->rcu_pending->__rcu_pending->set_need_resched

Kernels 3.5.0-rc2+ do not exhibit this problem, because a patch to
try_to_freeze() in include/linux/freezer.h introduces a call to
might_sleep(), which ultimately calls schedule() to clear the reschedule
flag and allows the the loop to execute the call to mwait().

However, the changes to try_to_freeze are unrelated to acpi_pad, and it
does not seem like a good idea to rely on an unrelated patch in a
function that could later be changed and reintroduce this bug.

Therefore, it seems better to make an explicit call to schedule() in the
outer loop when the need_resched flag is set.

Reported-and-tested-by: Stuart Hayes <stuart_hayes@dell.com>
Signed-off-by: Tony Camuso <tcamuso@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Leann Ogasawara <leann.ogasawara@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/acpi_pad.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_pad.c b/drivers/acpi/acpi_pad.c
index fc6008f..2c67e59 100644
--- a/drivers/acpi/acpi_pad.c
+++ b/drivers/acpi/acpi_pad.c
@@ -219,8 +219,15 @@ static int power_saving_thread(void *data)
 		 * borrow CPU time from this CPU and cause RT task use > 95%
 		 * CPU time. To make 'avoid starvation' work, takes a nap here.
 		 */
-		if (do_sleep)
+		if (unlikely(do_sleep))
 			schedule_timeout_killable(HZ * idle_pct / 100);
+
+		/* If an external event has set the need_resched flag, then
+		 * we need to deal with it, or this loop will continue to
+		 * spin without calling __mwait().
+		 */
+		if (unlikely(need_resched()))
+			schedule();
 	}
 
 	exit_round_robin(tsk_index);
-- 
1.9.1

