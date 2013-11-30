Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3K3ATO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 19:19:14 -0500
Received: from mail-ob0-f179.google.com ([209.85.214.179]:43039 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab3K3ATK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 19:19:10 -0500
Message-ID: <52992EFA.4000903@acm.org>
Date: Fri, 29 Nov 2013 18:19:06 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Srinivas_G_Gowda@Dell.com, tcminyard@gmail.com,
        linux-kernel@vger.kernel.org, openipmi@mvista.com
Subject: Re: [PATCH 1/1] ipmi: setting mod_timer for read_event_msg buffer
 cmd
References: <52931C2D.4070908@dell.com> <5294D9D8.2030305@acm.org> <75F7F7632819D94BA80703D8B1F10B6D29CEE95A1D@BLRX7MCDC201.AMER.DELL.COM>
In-Reply-To: <75F7F7632819D94BA80703D8B1F10B6D29CEE95A1D@BLRX7MCDC201.AMER.DELL.COM>
Content-Type: multipart/mixed;
 boundary="------------080305010206030903060902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080305010206030903060902
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit

On 11/27/2013 04:34 AM, Srinivas_G_Gowda@Dell.com wrote:
>
> *Dell - Internal Use - Confidential *
>
> I hit a bug during one of our stress tests, Here is the issue that I
> am looking at.
>
> We have IPMI_READ_EVENT_MSG_BUFFER_CMD getting invoked from
> smi_event_handler.
>
> In case we hit error scenario, say "OBF not ready in time" we do not
> have smi_timeout driving the interface.
>
> Seems like the timer is not armed when we invoke
> IPMI_READ_EVENT_MSG_BUFFER_CMD from smi_event_handler.
>
> For the proposed patch I checked the return value of mod_timer just
> before smi_info->handlers->start_transaction, that returns 0 !!!
>
> gWithout smi_timeout handler getting called periodically, if the BMC
> fails to set OBF flag during the msg transaction of
> IPMI_READ_EVENT_MSG_BUFFER_CMD,
>
> the driver just keeps looping until the flag is set. Ideally we would
> want BMC to set the flag, but in case it doesn’t we do not want the
> driver to loop indefinitely rather hit KCS_ERROR states.
>
> To summarize, we do not have timer set to invoke smi_timeout() when we
> call IPMI_READ_EVENT_MSG_BUFFER_CMD from smi_event_handler.
>
> Do you feel there is a better way to fix it or a bug elsewhere…!
>

Ok, I think I know what is happening, and I think I have a fix. I'm
betting that you have interrupts on this, and
I found a situation where if an interrupt came in at a certain time, it
wouldn't start the timer. The attached patch should fix the problem.

Can you try this out?

Thanks for the detailed description.

-corey

--------------080305010206030903060902
Content-Type: text/x-diff;
 name="0001-IPMI-Start-the-timer-properly-in-certain-situations.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-IPMI-Start-the-timer-properly-in-certain-situations.pat";
 filename*1="ch"

>From a3dcd3ce65c4072acd707a000ba30ff917d52ef3 Mon Sep 17 00:00:00 2001
From: Corey Minyard <cminyard@mvista.com>
Date: Fri, 29 Nov 2013 18:13:45 -0600
Subject: [PATCH] IPMI: Start the timer properly in certain situations

If using interrupt, or in some cases with the IPMI thread, the
IPMI timer would not be started to time out operations, resulting
in the driver operation hanging.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---
 drivers/char/ipmi/ipmi_si_intf.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 68c5ef5..a8dfd94 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -981,6 +981,13 @@ static int ipmi_thread_busy_wait(enum si_sm_result smi_result,
 	return 1;
 }
 
+static void ipmi_start_timer_if_necessary(struct smi_info *smi_info)
+{
+	if (!timer_pending(&smi_info->si_timer)) {
+		mod_timer(&smi_info->si_timer, jiffies + SI_TIMEOUT_JIFFIES);
+		smi_info->last_timeout_jiffies = jiffies;
+	}
+}
 
 /*
  * A busy-waiting loop for speeding up IPMI operation.
@@ -1014,8 +1021,10 @@ static int ipmi_thread(void *data)
 			schedule();
 		else if (smi_result == SI_SM_IDLE)
 			schedule_timeout_interruptible(100);
-		else
+		else {
+			ipmi_start_timer_if_necessary(smi_info);
 			schedule_timeout_interruptible(1);
+		}
 	}
 	return 0;
 }
@@ -1118,7 +1127,8 @@ static irqreturn_t si_irq_handler(int irq, void *data)
 	do_gettimeofday(&t);
 	printk(KERN_DEBUG "**Interrupt: %d.%9.9d\n", t.tv_sec, t.tv_usec);
 #endif
-	smi_event_handler(smi_info, 0);
+	if (smi_event_handler(smi_info, 0) != SI_SM_IDLE)
+		ipmi_start_timer_if_necessary(smi_info);
 	spin_unlock_irqrestore(&(smi_info->si_lock), flags);
 	return IRQ_HANDLED;
 }
@@ -1979,7 +1989,8 @@ static u32 ipmi_acpi_gpe(acpi_handle gpe_device,
 	do_gettimeofday(&t);
 	printk("**ACPI_GPE: %d.%9.9d\n", t.tv_sec, t.tv_usec);
 #endif
-	smi_event_handler(smi_info, 0);
+	if (smi_event_handler(smi_info, 0) != SI_SM_IDLE)
+		ipmi_start_timer_if_necessary(smi_info);
 	spin_unlock_irqrestore(&(smi_info->si_lock), flags);
 
 	return ACPI_INTERRUPT_HANDLED;
-- 
1.8.3.1


--------------080305010206030903060902--
