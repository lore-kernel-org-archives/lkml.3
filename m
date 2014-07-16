Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760193AbaGPAom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:44:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:39542 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756785AbaGPAo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:44:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,668,1400050800"; 
   d="scan'208";a="562363574"
From: Andi Kleen <andi@firstfloor.org>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v2] ACPI/EC: Enable storm prevention mechanisms.
References: <cover.1403060601.git.lv.zheng@intel.com>
	<d43c4857af0aef38ba62fd21f62cb69deea888f3.1405407302.git.lv.zheng@intel.com>
Date: Tue, 15 Jul 2014 17:44:25 -0700
In-Reply-To: <d43c4857af0aef38ba62fd21f62cb69deea888f3.1405407302.git.lv.zheng@intel.com>
	(Lv Zheng's message of "Tue, 15 Jul 2014 15:09:01 +0800")
Message-ID: <87pph63zfa.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lv Zheng <lv.zheng@intel.com> writes:

> This patch enables storm prevention mechanisms. After applying this patch,
> when the command/event storms are actually detected, EC driver will be
> switched from the IRQ mode to the polling mode.

It would be far better to fix the root cause of the storms, instead
of just barely curing the symptoms.

The last time I investigated this the main problem was desynchronization
with the EC mailbox protocol because Linux was too fast.

At least on my laptop the old delay patch was fairly successful in
resynchronizing.

[needs some more changes to make the ACPI interrupt threaded]

Author: Andi Kleen <andi@firstfloor.org>
Date:   Fri Nov 11 13:46:22 2011 +0100

    ACPI: EC: Add a limited number of repeats after false EC interrupts
5A    
    My Acer laptop has a large number of false EC interrupts
    (interrupts when the EC indexed data register protocol is in the wrong
    state, expecting input when we should send output or vice versa)
    It seems the hardware triggers the interrupt before it actually
    sets the right status in the register.
    
    With a delay and a repeat it usually works on the second and sometimes
    on the third repeat.
    
    With the threaded interrupt we can do this safely now without
    needing a state machine.
    
    This doesn't completely fix the problem on my system, but makes the
    desynchronizations much less frequent and rare enough that passive
    trips still work.
    
    OPEN: best length of the delay. I picked an arbitary value that may
    be too long.
    
    Signed-off-by: Andi Kleen <ak@linux.intel.com>>

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index e520310..8304cdd 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -88,6 +88,16 @@ static unsigned int ec_delay __read_mostly = ACPI_EC_DELAY;
 module_param(ec_delay, uint, 0644);
 MODULE_PARM_DESC(ec_delay, "Timeout(ms) waited until an EC command completes");
 
+static unsigned int ec_max_repeat __read_mostly = 4;
+module_param(ec_max_repeat, uint, 0644);
+MODULE_PARM_DESC(ec_max_repeat, 
+	"Maximum number of repeats after an false EC interrupt");
+
+static unsigned int ec_repeat_delay __read_mostly = 200;
+module_param(ec_repeat_delay, uint, 0644);
+MODULE_PARM_DESC(ec_repeat_delay,
+	"Delay between each repeat after an false EC interrupt (in us)");
+
 /* If we find an EC via the ECDT, we need to keep a ptr to its context */
 /* External interfaces use first EC only, so remember */
 typedef int (*acpi_ec_query_func) (void *data);
@@ -167,9 +177,13 @@ static void start_transaction(struct acpi_ec *ec)
 	acpi_ec_write_cmd(ec, ec->curr->command);
 }
 
-static void advance_transaction(struct acpi_ec *ec, u8 status)
+static void advance_transaction(struct acpi_ec *ec)
 {
 	unsigned long flags;
+	int repeat = ec_max_repeat;
+	u8 status;
+again:
+	status = acpi_ec_read_status(ec);
 	spin_lock_irqsave(&ec->curr_lock, flags);
 	if (!ec->curr)
 		goto unlock;
@@ -195,8 +209,15 @@ err:
 	trace_acpi_ec_unsynchronized(status, ec->curr->wlen, ec->curr->rlen, 
 				     ec->curr->wi, ec->curr->ri);
 	/* false interrupt, state didn't change */
-	if (in_interrupt())
+	if (in_interrupt()) {
 		++ec->curr->irq_count;
+		if (repeat == 0)
+			goto unlock;
+		spin_unlock_irqrestore(&ec->curr_lock, flags);
+		usleep_range(ec_repeat_delay, ec_repeat_delay + 10);
+		repeat--;
+		goto again;
+	}
 unlock:
 	spin_unlock_irqrestore(&ec->curr_lock, flags);
 }
@@ -231,7 +252,7 @@ static int ec_poll(struct acpi_ec *ec)
 						msecs_to_jiffies(1)))
 					return 0;
 			}
-			advance_transaction(ec, acpi_ec_read_status(ec));
+			advance_transaction(ec);
 		} while (time_before(jiffies, delay));
 		if (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF)
 			break;
@@ -623,7 +644,7 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
 
 	pr_debug(PREFIX "~~~> interrupt\n");
 
-	advance_transaction(ec, acpi_ec_read_status(ec));
+	advance_transaction(ec);
 	if (ec_transaction_done(ec) &&
 	    (acpi_ec_read_status(ec) & ACPI_EC_FLAG_IBF) == 0) {
 		wake_up(&ec->wait);






>
> If regressions are reported against storm prevention support, this patch
> can be bisected and reverted before issues can be root caused.
>
> By changing the storm threshold to 0 and stops returning from
> advance_transaction() without increasing irq_count on non-error cases, we
> can perform unit test for the storm prevention. The result is as follows:
>   [    4.525321] ACPI : EC: ***** Command(RD_EC) started *****
>   [    4.525321] ACPI : EC: ===== TASK =====
>   [    4.525326] ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
>   [    4.525327] ACPI : EC: EC_SC(W) = 0x80
>   [    4.525436] ACPI : EC: ===== IRQ =====
>   [    4.525442] ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
>   [    4.525442] ACPI : EC: EC_DATA(W) = 0x23
>   [    4.525448] ACPI : EC: +++++ Polling enabled +++++
>   [    4.525451] ACPI : EC: EC_SC(R) = 0x02 SCI_EVT=0 BURST=0 CMD=0 IBF=1 OBF=0
> # [    4.528954] ACPI : EC: ===== TASK =====
>   [    4.528957] ACPI : EC: EC_SC(R) = 0x01 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=1
>   [    4.528960] ACPI : EC: EC_DATA(R) = 0x2b
>   [    4.528963] ACPI : EC: +++++ Polling disabled +++++
>   [    4.528964] ACPI : EC: ***** Command(RD_EC) stopped *****
>   [    4.528974] ACPI : EC: ===== IRQ =====
>   [    4.528977] ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
>   [    4.528980] ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
>   [    4.528988] ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
>   [    4.529347] ACPI : EC: ***** Command(WR_EC) started *****
>   [    4.529348] ACPI : EC: ===== TASK =====
>   [    4.529352] ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
>   [    4.529353] ACPI : EC: EC_SC(W) = 0x81
> * [    4.529467] ACPI : EC: ===== IRQ =====
>   [    4.529473] ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
>   [    4.529473] ACPI : EC: EC_DATA(W) = 0x04
>   [    4.529479] ACPI : EC: +++++ Polling enabled +++++
>   [    4.529482] ACPI : EC: EC_SC(R) = 0x02 SCI_EVT=0 BURST=0 CMD=0 IBF=1 OBF=0
>   [    4.532951] ACPI : EC: ===== TASK =====
>   [    4.532957] ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
>   [    4.532957] ACPI : EC: EC_DATA(W) = 0x01
>   [    4.536952] ACPI : EC: ===== TASK =====
>   [    4.536957] ACPI : EC: EC_SC(R) = 0x00 SCI_EVT=0 BURST=0 CMD=0 IBF=0 OBF=0
>   [    4.536964] ACPI : EC: +++++ Polling disabled +++++
>   [    4.536965] ACPI : EC: ***** Command(WR_EC) stopped *****
> We can see the command is advanced in the task context after enabling the
> polling mode (#) and the next command can still be started from the high
> performance IRQ mode (*).
>
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> ---
>  drivers/acpi/ec.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> index d3b1bd7..f40144e 100644
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -825,13 +825,17 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
>  {
>  	unsigned long flags;
>  	struct acpi_ec *ec = data;
> +	u32 enable = 0;
>  
>  	spin_lock_irqsave(&ec->lock, flags);
>  	if (advance_transaction(ec))
>  		wake_up(&ec->wait);
> +	if (!test_bit(EC_FLAGS_EVENT_STORM, &ec->flags) &&
> +	    !test_bit(EC_FLAGS_COMMAND_STORM, &ec->flags))
> +		enable = ACPI_REENABLE_GPE;
>  	spin_unlock_irqrestore(&ec->lock, flags);
>  	ec_check_sci(ec, acpi_ec_read_status(ec));
> -	return ACPI_INTERRUPT_HANDLED | ACPI_REENABLE_GPE;
> +	return ACPI_INTERRUPT_HANDLED | enable;
>  }
>  
>  /* --------------------------------------------------------------------------

-- 
ak@linux.intel.com -- Speaking for myself only
