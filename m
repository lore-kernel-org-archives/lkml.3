Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734AbaJ2OxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:53:14 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49701 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933375AbaJ2OxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:53:12 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 34/47] acpi: Register power-off handler with kernel power-off handler
Date: Wed, 29 Oct 2014 16:13:47 +0100
Message-ID: <3246253.JgPaFbzR96@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54504B57.3020403@roeck-us.net>
References: <1414425354-10359-1-git-send-email-linux@roeck-us.net> <4751363.lZMkCZKZet@vostro.rjw.lan> <54504B57.3020403@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 28, 2014 07:05:11 PM Guenter Roeck wrote:
> On 10/28/2014 04:10 PM, Rafael J. Wysocki wrote:
> > On Monday, October 27, 2014 07:10:26 PM Guenter Roeck wrote:
> >> On 10/27/2014 05:26 PM, Rafael J. Wysocki wrote:
> >>> On Monday, October 27, 2014 08:55:41 AM Guenter Roeck wrote:
> >>>> Register with kernel power-off handler instead of setting pm_power_off
> >>>> directly. Register with high priority to reflect that the driver explicitly
> >>>> overrides existing power-off handlers.
> >>>
> >>> Well, I'm still rather unconvinced that notifiers are particularly suitable for
> >>> this purpose.
> >>>
> >>> Specifically ->
> >>>
> >>
> >> Fine.
> >>
> >>>> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> >>>> Cc: Len Brown <lenb@kernel.org>
> >>>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> >>>> ---
> >>>> v3:
> >>>> - Replace poweroff in all newly introduced variables and in text
> >>>>     with power_off or power-off as appropriate
> >>>> - Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
> >>>> - Replace acpi: with ACPI: in log message
> >>>> v2:
> >>>> - Use define to specify poweroff handler priority
> >>>> - Use pr_warn instead of pr_err
> >>>>
> >>>>    drivers/acpi/sleep.c | 15 +++++++++++++--
> >>>>    1 file changed, 13 insertions(+), 2 deletions(-)
> >>>>
> >>>> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> >>>> index 05a31b5..7875b92 100644
> >>>> --- a/drivers/acpi/sleep.c
> >>>> +++ b/drivers/acpi/sleep.c
> >>>> @@ -16,6 +16,8 @@
> >>>>    #include <linux/device.h>
> >>>>    #include <linux/interrupt.h>
> >>>>    #include <linux/suspend.h>
> >>>> +#include <linux/notifier.h>
> >>>> +#include <linux/pm.h>
> >>>>    #include <linux/reboot.h>
> >>>>    #include <linux/acpi.h>
> >>>>    #include <linux/module.h>
> >>>> @@ -827,14 +829,22 @@ static void acpi_power_off_prepare(void)
> >>>>    	acpi_disable_all_gpes();
> >>>>    }
> >>>>
> >>>> -static void acpi_power_off(void)
> >>>> +static int acpi_power_off(struct notifier_block *this,
> >>>> +			  unsigned long unused1, void *unused2)
> >>>>    {
> >>>
> >>> -> Is there any reason why any notifier in the new chain would use the
> >>> second argument for anything meaningful?  And the third argument for
> >>> that matter?
> >>>
> >>>>    	/* acpi_sleep_prepare(ACPI_STATE_S5) should have already been called */
> >>>>    	printk(KERN_DEBUG "%s called\n", __func__);
> >>>>    	local_irq_disable();
> >>>>    	acpi_enter_sleep_state(ACPI_STATE_S5);
> >>>> +
> >>>> +	return NOTIFY_DONE;
> >>>
> >>> Also is there any reason for any notifier in the new chain to return anything
> >>> different from NOTIFY_DONE and if so, then what happens when anything else
> >>> is returned?
> >>>
> >>
> >> As mentioned earlier, notifiers just come handy. That is all.
> >>
> >> Having said that, I don't have a strong opinion either way. If you want me
> >> to implement a priority based callback handler with a single argument,
> >> just let me know and I'll be happy to implement it. It is not worth arguing
> >> about.
> >>
> >> Would something like
> >>
> >> struct power_off_block {
> >> 	void (*power_off_call)(struct power_off_block *);
> >> 	struct power_off_block __rcu *next;
> >> 	int priority;
> >> };
> >>
> >> for the data structure be acceptable ? The power-off handler code would then
> >> be something like
> >>
> >> static void acpi_power_off(struct power_off_block *this)
> >> {
> >> }
> >>
> >> ie quite similar to the current power-off handler code, with an added argument.
> >> The API would, except for the structure argument, pretty much stay the same.
> >
> > That's better in my view.
> >
> > You could also get rid of the priority if you had something like
> >
> > struct power_off_block *power_off_list[MAX_LEVEL];
> >
> > and then made your power_off_block registration pass the level as the
> > second argument.
> >
> > I also would use struct list_head instead of the next pointer, because the
> > list manipulation would be trivial then (and the above would become
> > struct list_head power_off_list[MAX_LEVEL];) and the callers would only
> > need to do
> >
> > static struct power_off_block my_power_off_block = {
> > 	.power_off_call = my_routine,
> > };
> >
> > and then something like
> >
> > 	register_power_off_block(&my_power_off_block, <level>);
> >
> > which would be just list_add_tail(&block->node, &power_off_list[<level>]) plus
> > some bounds checking etc.  To avoid open coding stuff.
> >
> > That would allow me to avoid arbitrary gaps in the priority space too and
> > if more levels need to be added over time, that should be easy to do too if
> > an enum is used to define them.
> >
> > But if you prefer to use a unidirectional list and keep the priority in
> > struct power_off_block, I'm fine with that too.
> >
> I prefer a unidirectional list. It is not as if we expect dozens of registrations;
> in most cases there will be one, rarely two and even more rarely three.

OK

> > [Dynamic allocation of memory for the struct power_off_block things is worth
> > considering too IMHO, so that users can simply pass the name of the routine
> > and the level to the registration function, like:
> >
> > 	ret = register_power_off_call(my_routine, <level>);
> > 	if (ret)
> > 		complain;
> >
> > The unregistration would be somewhat less straightforward then, but I'm not
> > sure if unregistration is necessary at all in this case.]
> >
> 
> Problem with dynamic memory allocation is that some callers don't have
> the memory subsystem initialized when registering the poweroff function.
> That was my initial implementation, and it got me some unexpected crashes.

I see.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
