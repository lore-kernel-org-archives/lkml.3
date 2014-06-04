Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaFDBVO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 21:21:14 -0400
Received: from mail1.windriver.com ([147.11.146.13]:50069 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbaFDBVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 21:21:13 -0400
Message-ID: <538E745B.1020200@windriver.com>
Date: Wed, 4 Jun 2014 09:20:27 +0800
From: "Yang,Wei" <Wei.Yang@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
CC: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] USB:gadget: Fix a warning while loading g_mass_storage
References: <Pine.LNX.4.44L0.1406031033010.1054-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1406031033010.1054-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 10:48 PM, Alan Stern wrote:
> On Tue, 3 Jun 2014 Wei.Yang@windriver.com wrote:
>
>> From: Yang Wei <Wei.Yang@windriver.com>
>>
>> While loading g_mass_storage module, the following warning is triggered.
>> In fact, it is more easy to reproduce it with RT kernel.
>>
>> WARNING: at drivers/usb/gadget/composite.c:
>> usb_composite_setup_continue: Unexpected call
>> Modules linked in: fat vfat minix nls_cp437 nls_iso8859_1 g_mass_storage
>> [<800179cc>] (unwind_backtrace+0x0/0x104) from [<80619608>] (dump_stack+0x20/0x24)
>> [<80619608>] (dump_stack+0x20/0x24) from [<80025100>] (warn_slowpath_common+0x64/0x74)
>> [<80025100>] (warn_slowpath_common+0x64/0x74) from [<800251cc>] (warn_slowpath_fmt+0x40/0x48)
>> [<800251cc>] (warn_slowpath_fmt+0x40/0x48) from [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage])
>> [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage]) from [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage])
>> [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage]) from [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage])
>> [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage]) from [<8004bc90>] (kthread+0x98/0x9c)
>> [<8004bc90>] (kthread+0x98/0x9c) from [<8000faec>] (kernel_thread_exit+0x0/0x8)
>>
>> The root cause just likes the following scenario.
>>
>> irq thread
>>
>> composite_disconnect()
>> |
>> |->fsg_disable() fsg->common->new_fsg = NULL
>>                   and then wake fsg_main_thread
>>                   with seting common->state to
>>                   FSG_STATE_CONFIG_CHANGE.
>>                                                      fsg_main_thread
>>                                                      |
>>                                                      |->do_set_interface()
>> irq thread
>>
>> set_config()
>> |
>> |->fsg_set_alt() fsg->common->new_fsg = new_fsg
>>                   and then also wake up fsg_main_thread
>>                   with setting common->state to
>>                   FSG_STATE_CONFIG_CHANGE.
>>                                                      |-> if(common->new_fsg)
>> 		                                                 usb_composite_setup_continue()
>>
>> In this case, fsg_main_thread would invoke usb_composite_setup_continue
>> twice, so the second call would trigger the above call trace, as we also
>> save common->new_fsg while changing the common->state.
> Michal and Andrzej:
>
> I haven't paid much attention to these matters, because you handled the
> conversion from g_file_storage to f_mass_storage using the composite
> framework.  But this patch seemed odd, so I took a closer look.

Let me make sense it, Robert once introduced the following patch to fix 
disconnect handling of s3c-hsotg.

commit d18f7116a5ddb8263fe62b05ad63e5ceb5875791
Author: Robert Baldyga <r.baldyga@samsung.com>
Date:   Thu Nov 21 13:49:18 2013 +0100

     usb: gadget: s3c-hsotg: fix disconnect handling

     This patch moves s3c_hsotg_disconnect function call from USBSusp 
interrupt
     handler to SET_ADDRESS request handler.

     It's because disconnected state can't be detected directly, because 
this
     hardware doesn't support Disconnected interrupt for device mode. 
For both
     Suspend and Disconnect events there is one interrupt USBSusp, but 
calling
     s3c_hsotg_disconnect from this interrupt handler causes config reset in
     composite layer, which is not undesirable for Suspended state.

     For this reason s3c_hsotg_disconnect is called from SET_ADDRESS request
     handler, which occurs always after disconnection, so we do disconnect
     immediately before we are connected again. It's probably only way we
     can do handle disconnection correctly.

     Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
     Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
     Signed-off-by: Felipe Balbi <balbi@ti.com>

Just like what the commit log described, s3c_hsotg_disconnect is called 
from SET_ADDRESS request handler, therefore,
reset_config would finally be called, it raises a 
FSG_STATE_CONFIG_CHANGE exception and wakes up fsg_main_thread to
handle this exception. After handling SET_ADDRESS, subsequently the irq 
hanler of s3c-hsotg would also invokes composite_setup()
function to handle USB_REQ_SET_CONFIGURATION request, set_config would 
be invoked, it also raises a FSG_STATE_CONFIG_CHANGE
exception and wakes up fsg_main_thread, in mean time, 
cdev->delayed_status would be plus one. Right? If I am missing 
something, please
let me know it.:-) If so, the following scenario would trigger the above 
call trace.

irq handler
   |
   |-> s3c_hsotg_disconnect()
            |
            |-> common->new_fsg = NULL
            |-> common->state to FSG_STATE_CONFIG.
            |-> wakes up fsg_main_thread.
   |-> set USB device address

fsg_main_thread finds the common->state == FSG_STATE_CONFIG
|
|-> handle_execption
|
|-> set common->state to FSG_STATE_IDLE
irq hanppens ------------>|
  irq handler needs to hanle USB_REQ_SET_CONFIGURATION request. 
|->do_set_interface()
   |-> set_config()
          |
          |-> common->new_fsg = new_fsg;
          |-> common->state = FSG_STATE_CONFIG
          |-> cdev->delayed_status++
          |-> wakes up fsg_main_thread

|-> Now the common->state == FSG_STATE_CONFIG
|-> if(common->new_fsg)
                                       usb_composite_setup_continue()
|->cdev->delayed_status--
                                                                  | 
fsg_main_thread finds the common->state still is FSG_STATE_CONFIG,
                     | so it would invoke handle_execption again.
                     |->hanle_execption
                              |->  set common->state to FSG_STATE_IDLE
                              |->  do_set_interface()
                              |-> if (common->new_fsg)
usb_composite_setup_continue()
                                             |-> cdev->delayed_status == 
0, so
this warning is triggered.


Thanks
Wei

>
> In f_mass_storage.c, struct fsg_common is shared among all the function
> instances.  This structure includes things like cmnd and nluns, which
> will in general be different for different functions.
>
> That's okay if each function is in a separate config, but what happens
> when there are multiple functions in the same config, using different
> interfaces?  What if the host sends concurrent commands to two of these
> functions?
>
> Am I missing something?
>
> Alan Stern
>
>
>

