Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754231AbaCaTJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 15:09:24 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39072 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824AbaCaTJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 15:09:23 -0400
Date: Mon, 31 Mar 2014 15:09:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Ian.Campbell@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH 3/4] xen/manage: Guard against user-space initiated
 poweroff and XenBus.
Message-ID: <20140331190912.GA9026@phenom.dumpdata.com>
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>
 <1383932286-25080-4-git-send-email-konrad.wilk@oracle.com>
 <528DEA00.7070505@citrix.com>
 <20131126164552.GF2959@phenom.dumpdata.com>
 <529C6EAC.4030408@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529C6EAC.4030408@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 11:27:40AM +0000, David Vrabel wrote:
> On 26/11/13 16:45, Konrad Rzeszutek Wilk wrote:
> > On Thu, Nov 21, 2013 at 11:09:52AM +0000, David Vrabel wrote:
> >> On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
> >>> There is a race case where the user does 'poweroff'
> >>> and at the same time the system admin does 'xl shutdown'.
> >>
> >> This isn't a Xen-specific problem is it?  Wouldn't it be better to fix
> >> this in generic code?
> > 
> > Possibly. I believe the reason for the reboot_notifier to exist is
> > to provide a means to fix the race.
> > 
> >>
> >> Especially since I don't think this patch actually fixes the race
> >> completely.
> >>
> >>> --- a/drivers/xen/manage.c
> >>> +++ b/drivers/xen/manage.c
> >> [...]
> >>> @@ -222,7 +230,7 @@ static void shutdown_handler(struct xenbus_watch *watch,
> >>>  	};
> >>>  	static struct shutdown_handler *handler;
> >>>  
> >>> -	if (shutting_down != SHUTDOWN_INVALID)
> >>> +	if (atomic_read(&shutting_down) != SHUTDOWN_INVALID)
> >>>  		return;
> >>
> >> In guest initiated poweroff at this time will still race with this
> >> toolstack initiated poweroff.
> > 
> > No, b/c the reboot notifier would have set 'shutting_down' already.
> 
> If the guest initiated power off is started here, the reboot notifier
> won't have run yet.

This is what I think you are saying:

CPU0                                                 CPU1

'poweroff'						'shutdown_handler'
->SYSCALL_DEFINE4(reboot)				 -> atomic_read(&shutting_down) == SHUTDOWN_INVALID
  mutex_lock(&reboot_mutex)			 	 -> do_poweroff
  kernel_power_off()
    -> kernel_shutdown_prepare

         -> blocking_notifier_call_chain()
		\- xen_system_reboot
			\- atomic_set(&shutting_down, SHUTDOWN_POWEROFF);

                                                         -> atomic_set(&shutting_down, SHUTDOWN_POWEROFF);
                                                         -> orderly_poweroff(false)
								-> 'poweroff' called
									->SYSCALL_DEFINE4(reboot)
									     -> mutex_lock(&reboot_mutex)
          -> system_state = SYSTEM_HALT
     -> machine_halt().

What you are describing was outlined in the commit description:

"
   'poweroff' and 'xl shutdown'..

    Depending on the race, the system_state will be SYSTEM_RUNNING or
    SYSTEM_POWER_OFF. If SYSTEM_RUNNING we just end up making
    a duplicate call to 'poweroff' (while it is running).

    That will fail or execute (And if executed then it will be
    stuck in the reboot_mutex mutex). But nobody will care b/c the
    machine is in poweroff sequence.
"

which means that this code does guard.. but not that well :-(

> 
> David
