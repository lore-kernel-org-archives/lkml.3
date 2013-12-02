Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab3LBOu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:50:57 -0500
Received: from ausxippc101.us.dell.com ([143.166.85.207]:19240 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3LBOuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:50:55 -0500
X-LoopCount0: from 10.175.216.249
X-IronPort-AV: E=Sophos;i="4.93,811,1378875600"; 
   d="scan'208";a="337112160"
From: <Srinivas_G_Gowda@Dell.com>
To: <minyard@acm.org>
CC: <tcminyard@gmail.com>, <linux-kernel@vger.kernel.org>,
        <openipmi@mvista.com>
Date: Mon, 2 Dec 2013 20:19:42 +0530
Subject: Re: [PATCH 1/1] ipmi: setting mod_timer for read_event_msg buffer
 cmd
Thread-Topic: [PATCH 1/1] ipmi: setting mod_timer for read_event_msg buffer
 cmd
Thread-Index: Ac7vbbu5767JGCLPTmqaeJEDSIJKbw==
Message-ID: <529C9C99.2010108@dell.com>
References: <52931C2D.4070908@dell.com> <5294D9D8.2030305@acm.org>
 <75F7F7632819D94BA80703D8B1F10B6D29CEE95A1D@BLRX7MCDC201.AMER.DELL.COM>
 <52992EFA.4000903@acm.org>
In-Reply-To: <52992EFA.4000903@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131
 Thunderbird/10.0
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks for the patch Corey. 
I am afraid that the system does not have interrupts enabled. It uses polling mode. 

When the error is seen, I know for a fact that in function ipmi_thread() smi_result is SI_SM_CALL_WITH_DELAY, 
I have some logs where in busy_wait always reads as 1. Not sure if it was ever set to 0. (ill check this again). 
Ill anyway run the test using the patch that you have shared. 

b/w would it harm if we were to do to something like this ?  

Signed-off-by: Srinivas Gowda <srinivas_g_gowda@dell.com>
---
 drivers/char/ipmi/ipmi_si_intf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 15e4a60..e23484f 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1008,6 +1008,7 @@ static int ipmi_thread(void *data)
 		spin_unlock_irqrestore(&(smi_info->si_lock), flags);
 		busy_wait = ipmi_thread_busy_wait(smi_result, smi_info,
 						  &busy_until);
+		ipmi_start_timer_if_necessary(smi_info);
 		if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
 			; /* do nothing */
 		else if (smi_result == SI_SM_CALL_WITH_DELAY && busy_wait)
-- 
1.8.1.2
  

Thanks,
G



On 11/30/2013 05:49 AM, Corey Minyard wrote:

> On 11/27/2013 04:34 AM, Srinivas_G_Gowda@Dell.com wrote:
>>
>> *Dell - Internal Use - Confidential *
>>
>> I hit a bug during one of our stress tests, Here is the issue that I
>> am looking at.
>>
>> We have IPMI_READ_EVENT_MSG_BUFFER_CMD getting invoked from
>> smi_event_handler.
>>
>> In case we hit error scenario, say "OBF not ready in time" we do not
>> have smi_timeout driving the interface.
>>
>> Seems like the timer is not armed when we invoke
>> IPMI_READ_EVENT_MSG_BUFFER_CMD from smi_event_handler.
>>
>> For the proposed patch I checked the return value of mod_timer just
>> before smi_info->handlers->start_transaction, that returns 0 !!!
>>
>> gWithout smi_timeout handler getting called periodically, if the BMC
>> fails to set OBF flag during the msg transaction of
>> IPMI_READ_EVENT_MSG_BUFFER_CMD,
>>
>> the driver just keeps looping until the flag is set. Ideally we would
>> want BMC to set the flag, but in case it doesn’t we do not want the
>> driver to loop indefinitely rather hit KCS_ERROR states.
>>
>> To summarize, we do not have timer set to invoke smi_timeout() when we
>> call IPMI_READ_EVENT_MSG_BUFFER_CMD from smi_event_handler.
>>
>> Do you feel there is a better way to fix it or a bug elsewhere…!
>>
> 
> Ok, I think I know what is happening, and I think I have a fix. I'm
> betting that you have interrupts on this, and
> I found a situation where if an interrupt came in at a certain time, it
> wouldn't start the timer. The attached patch should fix the problem.
> 
> Can you try this out?
> 
> Thanks for the detailed description.
> 
> -corey



