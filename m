Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300AbaEDOZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 10:25:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:8306 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaEDOZ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 10:25:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,982,1389772800"; 
   d="scan'208";a="534452740"
Message-ID: <53664DD3.60907@intel.com>
Date: Sun, 04 May 2014 22:25:23 +0800
From: Xiao Jin <jin.xiao@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, yanmin.zhang@intel.com,
        juan.zou@intel.com, david.a.cohen@linux.intel.com
Subject: Re: [PATCH] USB: ehci-hub: wait for RESUME finished when hub try
 to clear SUSPEND
References: <Pine.LNX.4.44L0.1405031107350.16021-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1405031107350.16021-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/03/2014 11:20 PM, Alan Stern wrote:
> On Sat, 3 May 2014, xiao jin wrote:
>
>> We use usb ehci to connect with modem and run stress test on ehci
>> remote wake. Sometimes usb disconnect. We add more debug ftrace
>> (Kernel version: 3.10) and list the key log to show how problem
>> happened.
>>
>> <idle>-0     [000] d.h2 26879.385095: ehci_irq: irq status 1008c PPCE FLR PCD
>> <idle>-0     [000] d.h2 26879.385099: ehci_irq: rh_state[2] hcd->state[132] pstatus[0][238014c5] suspended_ports[1] reset_done[0]
=> kernel receive a remote wakeup irq from controller
>> <...>-12873 [000] d..1 26879.393536: ehci_hub_control: GetStatus port:1 status 238014c5 17  ERR POWER sig=k SUSPEND RESUME PE CONNECT
=> PORTSC = 238014c5 (line status = K-state, suspend = 1, force port 
resume = 1, J-to-K transition is detected)
>> <...>-12873 [000] d..1 26879.393549: ehci_hub_control: typeReq [2301] wIndex[1] wValue[2]
>> <...>-12873 [000] d..1 26879.393553: ehci_hub_control: [ehci_hub_control]line[891]  port[0] hostpc_reg [44000202]->[44000202]
>> <idle>-0     [001] ..s. 26879.403122: ehci_hub_status_data: wgq[ehci_hub_status_data] ignore_oc[0] resuming_ports[1]
>> <...>-12873 [000] d..1 26879.413379: ehci_hub_control: [ehci_hub_control]line[907]  port[0] write portsc_reg[238014c5] reset_done[2105769]
=> kernel write 238014c5 to PORTSC
>> <...>-12873 [000] d..1 26879.453173: ehci_hub_control: GetStatus port:1 status 23801885 17  ERR POWER sig=j SUSPEND PE CONNECT
=> PORTSC = 23801885 (line status = J-state, suspend = 1), is the status 
weird?
>> <...>-12873 [000] .... 26879.473158: check_port_resume_type: port 1 status 0000.0507 after resume, -19
>> <...>-12873 [000] .... 26879.473160: usb_port_resume: status = -19 after check_port_resume_type
>> <...>-12873 [000] .... 26879.473161: usb_port_resume: can't resume, status -19
>> <...>-12873 [000] .... 26879.473162: hub_port_logical_disconnect: logical disconnect on port 1
>
> This is a little difficult to understand...
>

We add some debug log manually, please let me explain a little more. See 
above "=>".

>> There is a in-band remote wakeup and controller run in k-state. Then kernel
>
> What do you mean by "in-band"?
>

We use EHCI as host and have two kinds of mechanism to remote wakeup 
event, "in-band" is ehci controller self wakeup, sorry to make you 
misunderstanding.

>> driver(ClearPortFeature/USB_PORT_FEAT_SUSPEND) write RESUME|LS(k-state) bit
>> into controller.
>
> Why did it do that?  Did the kernel try to resume the port at the same
> time as the device issued a remote wakeup request?  In other words, was
> there a race between resume and remote wakeup?
>

Yes, I mean a race between kernel driver resume and controller remote 
wakeup.

>>   It makes controller status weird.
>
> Why?  Your log shows that the RESUME bit was already turned on, so
> writing a 1 to it shouldn't make any difference.  (And the LS(k-state)
> bit is RO, so writing a 1 to it shouldn't matter.)
>

Here the problem is, after remote wakeup, the controller still is in 
SUSPEND and kernel report disconnect finally. Could kernel write 
"SUSPEND" or "Force Port Resume" bit be related to the problem we meet with?

>>   It's defined in EHCI
>> controller spec(Revision 1.0), "If it has enabled remote wake-up, a K-state
>> on the bus will turn the transceiver clock and generate an interrupt. The
>> software will then have to wait 20 ms for the resume to complete and the
>> port to go back to an active state."
>
> Where in the spec did you find that quote?  It's not present in my copy
> of the EHCI Rev 1.0 spec.
>

I am sorry to make a mistake, I quote it from controller reference 
manual. I can find the similar definition in EHCI Rev 1.0,
4.3.1 Port Suspend/Resume.

"When Force Port Resume bit is a one, the host controller sends resume 
signaling down the port. System software times the duration of the 
resume (nominally 20 milliseconds) then sets the Force Port Resume bit 
to a zero."


>>   In this case Kernel should wait for
>> the wakeup finished, then judge what should do next step.
>>
>> We have some thought and give a patch. This patch is to wait for controller
>> RESUME finished when hub try to clear port SUSPEND feature.
>>

>
> This is definitely wrong.  For one thing, you mustn't have a 20-ms
> delay with interrupts disabled.  For another, the spec states (Table
> 2-16, the entry for bits 11:10) that the Line Status value is valid
> only when the port enable bit is 0, so you shouldn't rely on it.
> Lastly, there really is no need to do anything, because the remote
> wakeup will finish all by itself.
>

I agree disable irq for maximum 20-ms is not good, but I can find 
another case when ehci_hub_control() deal with GetPortStatus.

I have no idea how controller run, from both EHCI spec and reference 
manual, I can only deduce that it's better kernel driver don't touch 
PORTSC until resume finished. Otherwise how to explain the problem we 
meet with? (After remote wakeup, the controller still is in SUSPEND and 
kernel report disconnect finally.)

When we try the original change in the mail, we never see the same 
problem until now.


> Try the patch below instead.
>

OK.

Jin

> Alan Stern
>
>
>
> Index: usb-3.15/drivers/usb/host/ehci-hub.c
> ===================================================================
> --- usb-3.15.orig/drivers/usb/host/ehci-hub.c
> +++ usb-3.15/drivers/usb/host/ehci-hub.c
> @@ -935,7 +935,8 @@ static int ehci_hub_control (
>   				break;
>   			}
>   #endif
> -			if (!(temp & PORT_SUSPEND))
> +			/* Port not suspended, or remote wakeup in progress? */
> +			if (!(temp & PORT_SUSPEND) || (temp & PORT_RESUME))
>   				break;
>   			if ((temp & PORT_PE) == 0)
>   				goto error;
>

