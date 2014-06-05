Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaFESIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 14:08:20 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42694 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752519AbaFESIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 14:08:19 -0400
Date: Thu, 5 Jun 2014 14:08:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Wei.Yang@windriver.com
cc: balbi@ti.com, <mina86@mina86.com>, <andrzej.p@samsung.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] USB:gadget: Fix a warning while loading g_mass_storage
In-Reply-To: <1401856367-12553-1-git-send-email-Wei.Yang@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1406051403211.1103-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014 Wei.Yang@windriver.com wrote:

> From: Yang Wei <Wei.Yang@windriver.com>
> 
> While loading g_mass_storage module, the following warning is triggered.
> 
> WARNING: at drivers/usb/gadget/composite.c:
> usb_composite_setup_continue: Unexpected call
> Modules linked in: fat vfat minix nls_cp437 nls_iso8859_1 g_mass_storage
> [<800179cc>] (unwind_backtrace+0x0/0x104) from [<80619608>] (dump_stack+0x20/0x24)
> [<80619608>] (dump_stack+0x20/0x24) from [<80025100>] (warn_slowpath_common+0x64/0x74)
> [<80025100>] (warn_slowpath_common+0x64/0x74) from [<800251cc>] (warn_slowpath_fmt+0x40/0x48)
> [<800251cc>] (warn_slowpath_fmt+0x40/0x48) from [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage])
> [<7f047774>] (usb_composite_setup_continue+0xb4/0xbc [g_mass_storage]) from [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage])
> [<7f047ad4>] (handle_exception+0x358/0x3e4 [g_mass_storage]) from [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage])
> [<7f048080>] (fsg_main_thread+0x520/0x157c [g_mass_storage]) from [<8004bc90>] (kthread+0x98/0x9c)
> [<8004bc90>] (kthread+0x98/0x9c) from [<8000faec>] (kernel_thread_exit+0x0/0x8) 
> 
> The root cause is that  Robert once introduced the following patch to fix
> disconnect handling of s3c-hsotg.
> [
> commit d18f7116a5ddb8263fe62b05ad63e5ceb5875791
> Author: Robert Baldyga <r.baldyga@samsung.com>
> Date:   Thu Nov 21 13:49:18 2013 +0100
> 
>     usb: gadget: s3c-hsotg: fix disconnect handling
> 
> 	    This patch moves s3c_hsotg_disconnect function call from USBSusp interrupt
> 		handler to SET_ADDRESS request handler.
> 
> 		It's because disconnected state can't be detected directly, because this
> 		hardware doesn't support Disconnected interrupt for device mode. For both
> 		Suspend and Disconnect events there is one interrupt USBSusp, but calling
> 		s3c_hsotg_disconnect from this interrupt handler causes config reset in
> 		composite layer, which is not undesirable for Suspended state.
> 
> 		For this reason s3c_hsotg_disconnect is called from SET_ADDRESS request
> 		handler, which occurs always after disconnection, so we do disconnect
> 		immediately before we are connected again. It's probably only way we
> 		can do handle disconnection correctly.
> 
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Felipe Balbi <balbi@ti.com> 
> ]
> 
> So it also means that s3c_hsotg_disconnect is called from SET_ADDRESS request handler,
> ultimately reset_config would finally be called, it raises a FSG_STATE_CONFIG_CHANGE exception,
> and set common->new_fsg to NULL, and then wakes up fsg_main_thread to handle this exception.
> After handling SET_ADDRESS, subsequently the irq hanler of s3c-hsotg would also invokes composite_setup()
> function to handle USB_REQ_SET_CONFIGURATION request, set_config would be invoked, it
> not only raises a FSG_STATE_CONFIG_CHANGE and set common->new_fsg to new_fsg but also makes
> cdev->delayed_status plus one. If the execution ordering just likes the following scenario, the warning
> would be triggered.
> 
> irq handler
>  |
>  |-> s3c_hsotg_disconnect()
>        |
>        |-> common->new_fsg = NULL
>        |-> common->state = FSG_STATE_CONFIG
>        |-> wakes up fsg_main_thread.
>  |->set USB device address.
> 
> fsg_main_thread
>              |
>              |-> handle_exception
>                      |
>                      |-> common->state = FSG_STATE_IDLE
>                      |-> do_set_interface()
>  irq happens -------------->
> 
> irq handler needs to handle USB_REQ_SET_CONFIGURATION request
>  |
>  |-> set_config()
>         |
>         |-> common->new_fsg = new_fsg;
>         |-> common->state = FSG_STATE_CONFIG
>         |-> cdev->delayed_status++
>         |-> wakes up fsg_main_thread
> 
> fsg_main_thread
>              |
> 			 |-> Now the common->state = FSG_STATE_CONFIG and common->new_fsg is not equal to NULL
>              |-> if(common->new_fsg)
>                        |-> usb_composite_setup_continue()
>                                       |-> cdev->delayed_status--
>              |-> fsg_main_thread still finds the common->state is equal to FSG_STATE_IDLE
>              |-> so it invokes handle_exception again, subsequently the usb_composite_setup_continue
>              |-> is executed again. It would fininally results in the warning.
> 
> So we also need to define a variable(struct fsg_dev *new) and then save common->new_fsg
> to it with the common->lock protection.
> 
> Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
> ---
>  drivers/usb/gadget/f_mass_storage.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
>                 Changes in v2:
> 
>                  Only rephrase the commit log to make sense this issue.
> 		
> 		Wei
> 
> diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
> index b963939..e3b1798 100644
> --- a/drivers/usb/gadget/f_mass_storage.c
> +++ b/drivers/usb/gadget/f_mass_storage.c
> @@ -2342,6 +2342,7 @@ static void handle_exception(struct fsg_common *common)
>  	struct fsg_buffhd	*bh;
>  	enum fsg_state		old_state;
>  	struct fsg_lun		*curlun;
> +	struct fsg_dev   *new;

The spacing is different from the lines above.  There should be two tab 
characters between the 'v' and the '*', not three spaces.

Also, the variable should be named "new_fsg", not "new".

>  	unsigned int		exception_req_tag;
>  
>  	/*
> @@ -2421,6 +2422,7 @@ static void handle_exception(struct fsg_common *common)
>  		}
>  		common->state = FSG_STATE_IDLE;
>  	}
> +	new = common->new_fsg;
>  	spin_unlock_irq(&common->lock);
>  
>  	/* Carry out any extra actions required for the exception */
> @@ -2460,8 +2462,8 @@ static void handle_exception(struct fsg_common *common)
>  		break;
>  
>  	case FSG_STATE_CONFIG_CHANGE:
> -		do_set_interface(common, common->new_fsg);
> -		if (common->new_fsg)
> +		do_set_interface(common, new);
> +		if (new)
>  			usb_composite_setup_continue(common->cdev);
>  		break;

The description is long-winded and confusing, but the patch is correct.  
The existing code fails to take into account the possibility that 
common->new_fsg can change while do_set_interface() is running, because 
the spinlock isn't held at this point.

Alan Stern

