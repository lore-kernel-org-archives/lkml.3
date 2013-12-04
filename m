Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab3LDL71 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 06:59:27 -0500
Received: from ausxipps301.us.dell.com ([143.166.148.223]:45529 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab3LDL7Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:59:25 -0500
X-LoopCount0: from 10.170.28.40
X-IronPort-AV: E=Sophos;i="4.93,824,1378875600"; 
   d="scan'208";a="347981405"
From: <Srinivas_G_Gowda@Dell.com>
To: <minyard@acm.org>
CC: <linux-kernel@vger.kernel.org>
Date: Wed, 4 Dec 2013 03:58:51 -0800
Subject: Re: [PATCH 1/1] ipmi: setting mod_timer for read_event_msg buffer
 cmd
Thread-Topic: [PATCH 1/1] ipmi: setting mod_timer for read_event_msg buffer
 cmd
Thread-Index: Ac7w6DKP/u2KxOpNQRW6a+DMXU/lvg==
Message-ID: <529F178A.3050304@dell.com>
References: <52931C2D.4070908@dell.com> <5294D9D8.2030305@acm.org>
 <75F7F7632819D94BA80703D8B1F10B6D29CEE95A1D@BLRX7MCDC201.AMER.DELL.COM>
 <52992EFA.4000903@acm.org> <529C9C99.2010108@dell.com>
 <529CF5AA.5040700@acm.org>
 <75F7F7632819D94BA80703D8B1F10B6D29CEE96846@BLRX7MCDC201.AMER.DELL.COM>
 <529E1078.1060502@acm.org>
In-Reply-To: <529E1078.1060502@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131
 Thunderbird/10.0
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2013 10:40 PM, Corey Minyard wrote:

> On 12/03/2013 12:18 AM, Srinivas_G_Gowda@Dell.com wrote:
>> Dell - Internal Use - Confidential 
>>
>> Hi Corey,
>>> Unfortunately, that would start the timer unnecessarily.  You don't want to start timers unnecessarily in the kernel or the power management police will come after you.
>>    I still see the issue after applying the patch. 
>>    I have one question, for commands such as IPMI_READ_EVENT_MSG_BUFFER_CMD in smi_event_handler() that are invoked by the driver itself where do you expect the timer to be set ??
> 
> The timer should be done by the calling function.  Since the timer is
> actually used to time out complete operations, you don't want to reset
> it from interrupts or the kthread.  The patch I added would start the
> timer if it wasn't running and the event returned something non-idle.
> 
> So what should happen is smi_event_handler() starts the event message
> buffer read, goes back to the top of smi_event_handler() and handles the
> new message.  It should return something besides idle in that case.  And
> thus the timer should be started.
> 
>>> The patch I sent did have this call in the non-idle portion of the kernel thread and that should have done the same thing.  Plus, if you are using the kernel thread, it's going to run periodically and should kick things off again if they get stuck.  I'm suspicious now that something else is going on.
>>   ipmi_thread() is getting invoked when the issue is seen, but I keep hitting this condition
>>   else if (smi_result == SI_SM_CALL_WITH_DELAY && busy_wait)
>>   Since the timer is not armed for IPMI_READ_EVENT_MSG_BUFFER_CMD, smi_event_handler calls with time value 0, which doesn't help when OBF is stuck.
>>   We keep running around this loop since we never hit the kcs error states.
> 
> Maybe the timer start function needs to be called from that else clause,
> but it didn't seem so to me.  It wouldn't hurt, I suppose.  But the
> event handler should eventually return something non-idle and the timer
> start function should get called.  Is the ipmi thread just stuck using
> 100% CPU?  

Yes

> Does the final else clause ever get hit?  Maybe the bug is in
> ipmi_thread_busy_wait().
> 

No, I did not see final else in ipmi_thread ever getting hit.

I am looking at  ipmi_thread_busy_wait(),
 by default the below condition never gets set unitl I explicetly set "kipmid_max_busy_us" to some value.
if (smi_info->intf_num < num_max_busy_us)

This means by default "max_busy_us" is always 0. Hence Ill basically end up only doing this
if (max_busy_us == 0 || smi_result != SI_SM_CALL_WITH_DELAY)
                ipmi_si_set_not_busy(busy_until);

That probably explains why I never hit the else condition in ipmi_thread.

I see ipmi_start_timer_if_necessary() getting called from ipmi_thread() after setting "kipmid_max_busy_us"
Ill set "kipmid_max_busy_us=300" and run the stress. I am hoping that we will not see the issue in this case.


Thanks,
G



> Thanks,
> 
> -corey
> 
>>
>>
>> Thanks,
>> G
>>
>> -----Original Message-----
>> From: Corey Minyard [mailto:tcminyard@gmail.com] On Behalf Of Corey Minyard
>> Sent: Tuesday, December 03, 2013 2:34 AM
>> To: Gowda, Srinivas G
>> Cc: tcminyard@gmail.com; linux-kernel@vger.kernel.org; openipmi@mvista.com
>> Subject: Re: [PATCH 1/1] ipmi: setting mod_timer for read_event_msg buffer cmd On 12/02/2013 08:49 AM, Srinivas_G_Gowda@Dell.com wrote: 
>>> Thanks for the patch Corey. 
>>> I am afraid that the system does not have interrupts enabled. It uses polling mode. 
>>>
>>> When the error is seen, I know for a fact that in function
>>> ipmi_thread() smi_result is SI_SM_CALL_WITH_DELAY, I have some logs where in busy_wait always reads as 1. Not sure if it was ever set to 0. (ill check this again).
>>> Ill anyway run the test using the patch that you have shared. 
>>>
>>> b/w would it harm if we were to do to something like this ?
>> Unfortunately, that would start the timer unnecessarily.  You don't want to start timers unnecessarily in the kernel or the power management police will come after you.
>> The patch I sent did have this call in the non-idle portion of the kernel thread and that should have done the same thing.  Plus, if you are using the kernel thread, it's going to run periodically and should kick things off again if they get stuck.  I'm suspicious now that something else is going on.
>> -corey 
>>> Signed-off-by: Srinivas Gowda <srinivas_g_gowda@dell.com>
>>> ---
>>>   drivers/char/ipmi/ipmi_si_intf.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/char/ipmi/ipmi_si_intf.c
>>> b/drivers/char/ipmi/ipmi_si_intf.c
>>> index 15e4a60..e23484f 100644
>>> --- a/drivers/char/ipmi/ipmi_si_intf.c
>>> +++ b/drivers/char/ipmi/ipmi_si_intf.c
>>> @@ -1008,6 +1008,7 @@ static int ipmi_thread(void *data)
>>>                spin_unlock_irqrestore(&(smi_info->si_lock), flags);
>>>                busy_wait = ipmi_thread_busy_wait(smi_result, smi_info,
>>>                                                  &busy_until);
>>> +             ipmi_start_timer_if_necessary(smi_info);
>>>                if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
>>>                        ; /* do nothing */
>>>                else if (smi_result == SI_SM_CALL_WITH_DELAY && 
>>> busy_wait)
> 



