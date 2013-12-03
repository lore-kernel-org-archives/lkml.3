Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab3LCG3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 01:29:44 -0500
Received: from ausxipps301.us.dell.com ([143.166.148.223]:30109 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746Ab3LCG3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 01:29:42 -0500
X-Greylist: delayed 570 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Dec 2013 01:29:42 EST
X-LoopCount0: from 10.170.28.41
X-IronPort-AV: E=Sophos;i="4.93,815,1378875600"; 
   d="scan'208";a="346776859"
From: <Srinivas_G_Gowda@Dell.com>
To: <minyard@acm.org>
CC: <tcminyard@gmail.com>, <linux-kernel@vger.kernel.org>,
        <openipmi@mvista.com>
Date: Tue, 3 Dec 2013 11:48:34 +0530
Subject: RE: [PATCH 1/1] ipmi: setting mod_timer for read_event_msg buffer
 cmd
Thread-Topic: [PATCH 1/1] ipmi: setting mod_timer for read_event_msg buffer
 cmd
Thread-Index: Ac7vogVU58zaz2HwT6CVRPOZstrmBwATPhkw
Message-ID: <75F7F7632819D94BA80703D8B1F10B6D29CEE96846@BLRX7MCDC201.AMER.DELL.COM>
References: <52931C2D.4070908@dell.com> <5294D9D8.2030305@acm.org>
 <75F7F7632819D94BA80703D8B1F10B6D29CEE95A1D@BLRX7MCDC201.AMER.DELL.COM>
 <52992EFA.4000903@acm.org> <529C9C99.2010108@dell.com>
 <529CF5AA.5040700@acm.org>
In-Reply-To: <529CF5AA.5040700@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-version: 3.5.21.1
x-tituslabs-classifications-30: TLPropertyRoot=Dell;Classification=Internal
 Use;External=No;Sublabels=;
x-tituslabs-classificationhash-30: VgNFIFU9Hx+/nZJb9Kg7IvZV04sjhm5ohgj17I+k6kb57u1mCD6mXo7G2RxAJ5LHz9JyVEDNEzdqgYO6hcVAT7xEGd7h12ZZm93khSwJAQ6W5tprmmQqiZ0IdpJ5/dfW7Ea8h7DNgu4fGLe1S9/mTsx1H3wZRv504AThSoNGr3Dup4a36rmaHAEx3ivbjfCAxWhZAH7tSMsaac2cbRJBLWlgmjiOD+lgf64D7/ntuHFvEXfwBeBw1VxdX9xd/3zEi/Om5jkkYVX0mRQVwyBM6sNWFpLqSfGjjMlphQlgKNw=
x-titusconfig: 1.2AMER
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dell - Internal Use - Confidential 

Hi Corey,
> Unfortunately, that would start the timer unnecessarily.  You don't want to start timers unnecessarily in the kernel or the power management police will come after you.
   I still see the issue after applying the patch. 
   I have one question, for commands such as IPMI_READ_EVENT_MSG_BUFFER_CMD in smi_event_handler() that are invoked by the driver itself where do you expect the timer to be set ??

> The patch I sent did have this call in the non-idle portion of the kernel thread and that should have done the same thing.  Plus, if you are using the kernel thread, it's going to run periodically and should kick things off again if they get stuck.  I'm suspicious now that something else is going on.
  ipmi_thread() is getting invoked when the issue is seen, but I keep hitting this condition
  else if (smi_result == SI_SM_CALL_WITH_DELAY && busy_wait)
  Since the timer is not armed for IPMI_READ_EVENT_MSG_BUFFER_CMD, smi_event_handler calls with time value 0, which doesn't help when OBF is stuck.
  We keep running around this loop since we never hit the kcs error states.


Thanks,
G

-----Original Message-----
From: Corey Minyard [mailto:tcminyard@gmail.com] On Behalf Of Corey Minyard
Sent: Tuesday, December 03, 2013 2:34 AM
To: Gowda, Srinivas G
Cc: tcminyard@gmail.com; linux-kernel@vger.kernel.org; openipmi@mvista.com
Subject: Re: [PATCH 1/1] ipmi: setting mod_timer for read_event_msg buffer cmd On 12/02/2013 08:49 AM, Srinivas_G_Gowda@Dell.com wrote: 
> Thanks for the patch Corey. 
> I am afraid that the system does not have interrupts enabled. It uses polling mode. 
> 
> When the error is seen, I know for a fact that in function
> ipmi_thread() smi_result is SI_SM_CALL_WITH_DELAY, I have some logs where in busy_wait always reads as 1. Not sure if it was ever set to 0. (ill check this again).
> Ill anyway run the test using the patch that you have shared. 
> 
> b/w would it harm if we were to do to something like this ?
Unfortunately, that would start the timer unnecessarily.  You don't want to start timers unnecessarily in the kernel or the power management police will come after you.
The patch I sent did have this call in the non-idle portion of the kernel thread and that should have done the same thing.  Plus, if you are using the kernel thread, it's going to run periodically and should kick things off again if they get stuck.  I'm suspicious now that something else is going on.
-corey 
> 
> Signed-off-by: Srinivas Gowda <srinivas_g_gowda@dell.com>
> ---
>  drivers/char/ipmi/ipmi_si_intf.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c
> b/drivers/char/ipmi/ipmi_si_intf.c
> index 15e4a60..e23484f 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -1008,6 +1008,7 @@ static int ipmi_thread(void *data)
>               spin_unlock_irqrestore(&(smi_info->si_lock), flags);
>               busy_wait = ipmi_thread_busy_wait(smi_result, smi_info,
>                                                 &busy_until);
> +             ipmi_start_timer_if_necessary(smi_info);
>               if (smi_result == SI_SM_CALL_WITHOUT_DELAY)
>                       ; /* do nothing */
>               else if (smi_result == SI_SM_CALL_WITH_DELAY && 
>busy_wait)

