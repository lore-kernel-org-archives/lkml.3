Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3KTVil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:38:41 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27231 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab3KTVih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:38:37 -0500
Message-ID: <528D2C4F.7070104@oracle.com>
Date: Wed, 20 Nov 2013 16:40:31 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian.Campbell@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        david.vrabel@citrix.com
Subject: Re: [PATCH 3/4] xen/manage: Guard against user-space initiated poweroff
 and XenBus.
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com> <1383932286-25080-4-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1383932286-25080-4-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 12:38 PM, Konrad Rzeszutek Wilk wrote:
> There is a race case where the user does 'poweroff'
> and at the same time the system admin does 'xl shutdown'.
>
> Depending on the race, the system_state will be SYSTEM_RUNNING or
> SYSTEM_POWER_OFF. If SYSTEM_RUNNING we just end up making
> a duplicate call to 'poweroff' (while it is running).
>
> That will fail or execute (And if executed then it will be
> stuck in the reboot_mutex mutex). But nobody will care b/c the
> machine is in poweroff sequence.
>
> If the system_state is SYSTEM_POWER_OFF then we end up making
> a duplicate call to kernel_power_off. There is no locking
> there so we walk in the same steps as what 'poweroff'
> has been doing.
>
> The code in kernel/reboot.c has a mutex guarding against multiple
> 'poweroff' operations. But not against the kernel 'orderly_poweroff'.
>
> As such, lets detect this so that we don't invoke orderly_poweroff
> if the user had initiated a poweroff.
>
> This is code by changing the 'shutting_down' to an atomic and
> having a reboot notifier. If the 'shutting_down' is set to anything
> but SHUTDOWN_INVALID the XenBus handler will not run.
>
> That is exactly what we do in the reboot notifier - we set the
> 'shutting_down' to SHUTDOWN_POWEROFF.
>
> The reason we change the 'shutting_down' to an atomic is that
> the changes to said variable were normally guarded by the XenBus
> mutex - "xenwatch_mutex" - guarantting only one caller changing
> shutting_down. Since we have now the reboot notifier we have
> another user of this variable. Surfacing the 'xenwatch_mutex'
> out of XenBus is not a nice way of doing it. Having the
> variable however be atomic solves the problem easily.
>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> [v2: Don't expose xenwatch_mutex, add comments]

Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

> ---
>   drivers/xen/manage.c | 51 ++++++++++++++++++++++++++++++++++++++++++---------
>   1 file changed, 42 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> index 3f8496c..323703a 100644
> --- a/drivers/xen/manage.c
> +++ b/drivers/xen/manage.c
> @@ -36,8 +36,16 @@ enum shutdown_state {
>   	 SHUTDOWN_HALT = 4,
>   };
>   
> -/* Ignore multiple shutdown requests. */
> -static enum shutdown_state shutting_down = SHUTDOWN_INVALID;
> +/* Ignore multiple shutdown requests. There are two potential race conditions:
> + *  - Multiple XenStore 'shutdown' requests. We don't want to run any off
> + *    the callbacks in parallel.
> + *  - In progress 'poweroff' (initiated inside the guest) and a XenStore
> + *     'shutdown' request. If the poweroff has transitioned 'system_state' to
> + *    SYSTEM_POWER_OFF we do not want to call orderly_poweroff. 'system_state'
> + *    is not SMP safe so we depend on reboot notifiers to set 'shutting_down'
> + *    so that we will ignore XenBus shutdown requests.
> + */
> +static atomic_t shutting_down = ATOMIC_INIT(SHUTDOWN_INVALID);
>   
>   struct suspend_info {
>   	int cancelled;
> @@ -109,7 +117,7 @@ static void do_suspend(void)
>   	int err;
>   	struct suspend_info si;
>   
> -	shutting_down = SHUTDOWN_SUSPEND;
> +	atomic_set(&shutting_down, SHUTDOWN_SUSPEND);
>   
>   #ifdef CONFIG_PREEMPT
>   	/* If the kernel is preemptible, we need to freeze all the processes
> @@ -173,7 +181,7 @@ out_thaw:
>   	thaw_processes();
>   out:
>   #endif
> -	shutting_down = SHUTDOWN_INVALID;
> +	atomic_set(&shutting_down, SHUTDOWN_INVALID);
>   }
>   #endif	/* CONFIG_HIBERNATE_CALLBACKS */
>   
> @@ -184,7 +192,7 @@ struct shutdown_handler {
>   
>   static void do_poweroff(void)
>   {
> -	shutting_down = SHUTDOWN_POWEROFF;
> +	atomic_set(&shutting_down, SHUTDOWN_POWEROFF);
>   	switch (system_state) {
>   	case SYSTEM_BOOTING:
>   		orderly_poweroff(true);
> @@ -201,7 +209,7 @@ static void do_poweroff(void)
>   
>   static void do_reboot(void)
>   {
> -	shutting_down = SHUTDOWN_POWEROFF; /* ? */
> +	atomic_set(&shutting_down, SHUTDOWN_POWEROFF); /* ? */
>   	ctrl_alt_del();
>   }
>   
> @@ -222,7 +230,7 @@ static void shutdown_handler(struct xenbus_watch *watch,
>   	};
>   	static struct shutdown_handler *handler;
>   
> -	if (shutting_down != SHUTDOWN_INVALID)
> +	if (atomic_read(&shutting_down) != SHUTDOWN_INVALID)
>   		return;
>   
>    again:
> @@ -256,12 +264,29 @@ static void shutdown_handler(struct xenbus_watch *watch,
>   		handler->cb();
>   	} else {
>   		pr_info("Ignoring shutdown request: %s\n", str);
> -		shutting_down = SHUTDOWN_INVALID;
> +		atomic_set(&shutting_down, SHUTDOWN_INVALID);
>   	}
>   
>   	kfree(str);
>   }
> +/*
> + * This function is called when the system is being rebooted.
> + */
> +static int
> +xen_system_reboot(struct notifier_block *nb, unsigned long event, void *unused)
> +{
> +	switch (event) {
> +	case SYS_RESTART:
> +	case SYS_HALT:
> +	case SYS_POWER_OFF:
> +		atomic_set(&shutting_down, SHUTDOWN_POWEROFF);
> +		break;
> +	default:
> +		break;
> +	}
>   
> +	return NOTIFY_DONE;
> +}
>   #ifdef CONFIG_MAGIC_SYSRQ
>   static void sysrq_handler(struct xenbus_watch *watch, const char **vec,
>   			  unsigned int len)
> @@ -302,6 +327,10 @@ static struct xenbus_watch shutdown_watch = {
>   	.callback = shutdown_handler
>   };
>   
> +static struct notifier_block xen_shutdown_notifier = {
> +	.notifier_call = xen_system_reboot,
> +};
> +
>   static int setup_shutdown_watcher(void)
>   {
>   	int err;
> @@ -319,7 +348,11 @@ static int setup_shutdown_watcher(void)
>   		return err;
>   	}
>   #endif
> -
> +	err = register_reboot_notifier(&xen_shutdown_notifier);
> +	if (err) {
> +		pr_warn("Failed to register shutdown notifier\n");
> +		return err;
> +	}
>   	return 0;
>   }
>   

