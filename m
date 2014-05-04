Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaEDOlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 10:41:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:45866 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbaEDOlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 10:41:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,982,1389772800"; 
   d="scan'208";a="427400157"
Message-ID: <5366519E.50805@intel.com>
Date: Sun, 04 May 2014 22:41:34 +0800
From: Xiao Jin <jin.xiao@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Chen <peter.chen@freescale.com>
CC: stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        yanmin.zhang@intel.com, juan.zou@intel.com,
        david.a.cohen@linux.intel.com
Subject: Re: [PATCH] USB: ehci-hub: wait for RESUME finished when hub try
 to clear SUSPEND
References: <1399089145-21351-1-git-send-email-jin.xiao@intel.com> <20140504002607.GA30091@shlinux1.ap.freescale.net>
In-Reply-To: <20140504002607.GA30091@shlinux1.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 08:26 AM, Peter Chen wrote:
> On Sat, May 03, 2014 at 11:52:25AM +0800, xiao jin wrote:
>> We use usb ehci to connect with modem and run stress test on ehci
>> remote wake. Sometimes usb disconnect. We add more debug ftrace
>> (Kernel version: 3.10) and list the key log to show how problem
>> happened.
>>
>> <idle>-0     [000] d.h2 26879.385095: ehci_irq: irq status 1008c PPCE FLR PCD
>> <idle>-0     [000] d.h2 26879.385099: ehci_irq: rh_state[2] hcd->state[132] pstatus[0][238014c5] suspended_ports[1] reset_done[0]
>> <...>-12873 [000] d..1 26879.393536: ehci_hub_control: GetStatus port:1 status 238014c5 17  ERR POWER sig=k SUSPEND RESUME PE CONNECT
>> <...>-12873 [000] d..1 26879.393549: ehci_hub_control: typeReq [2301] wIndex[1] wValue[2]
>> <...>-12873 [000] d..1 26879.393553: ehci_hub_control: [ehci_hub_control]line[891]  port[0] hostpc_reg [44000202]->[44000202]
>> <idle>-0     [001] ..s. 26879.403122: ehci_hub_status_data: wgq[ehci_hub_status_data] ignore_oc[0] resuming_ports[1]
>> <...>-12873 [000] d..1 26879.413379: ehci_hub_control: [ehci_hub_control]line[907]  port[0] write portsc_reg[238014c5] reset_done[2105769]
>> <...>-12873 [000] d..1 26879.453173: ehci_hub_control: GetStatus port:1 status 23801885 17  ERR POWER sig=j SUSPEND PE CONNECT
>> <...>-12873 [000] .... 26879.473158: check_port_resume_type: port 1 status 0000.0507 after resume, -19
>> <...>-12873 [000] .... 26879.473160: usb_port_resume: status = -19 after check_port_resume_type
>> <...>-12873 [000] .... 26879.473161: usb_port_resume: can't resume, status -19
>> <...>-12873 [000] .... 26879.473162: hub_port_logical_disconnect: logical disconnect on port 1
>>
>> There is a in-band remote wakeup and controller run in k-state. Then kernel
>> driver(ClearPortFeature/USB_PORT_FEAT_SUSPEND) write RESUME|LS(k-state) bit
>> into controller. It makes controller status weird. It's defined in EHCI
>
> Are you sure you are at this path? If there is a remote wakeup, the
> sending resume signal from host controller will be skipped
> (USB_PORT_FEAT_SUSPEND), see usb_port_resume at drivers/usb/core/hub.c.
>

Yes, I abstract more debug log to explain.

<...>-12873 [000] .... 26879.393496: usb_port_resume: wgq[usb_port_resume]
<...>-12873 [000] .... 26879.393544: usb_port_resume: status = 0 after 
hub_port_status
             <...>-12873 [000] d..1 26879.393549: ehci_hub_control: 
typeReq [2301] wIndex[1] wValue[2]
            <...>-12873 [000] d..1 26879.413379: ehci_hub_control: 
[ehci_hub_control]line[907]  port[0] write portsc_reg[238014c5] 
reset_done[2105769]
            <...>-12873 [000] .... 26879.413401: usb_port_resume: status 
= 0 after clear_port_feature

>> controller spec(Revision 1.0), "If it has enabled remote wake-up, a K-state
>> on the bus will turn the transceiver clock and generate an interrupt. The
>> software will then have to wait 20 ms for the resume to complete and the
>> port to go back to an active state." In this case Kernel should wait for
>> the wakeup finished, then judge what should do next step.
>
> Do you use a chipidea core? Try to do not clear run/stop to see if this
> problem is fixed or not.
>

I have explained more about the problem in another mail. Please have a 
look if there still need more info.

Jin

