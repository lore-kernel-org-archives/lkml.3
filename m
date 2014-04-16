Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756676AbaDPUqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 16:46:36 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.217]:9648 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754882AbaDPUqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 16:46:35 -0400
X-RZG-AUTH: :JGIXVUS7cutRB/49FwqZ7WcKdUCnXG6JabOfSXKWrat+htPvyOWM
X-RZG-CLASS-ID: mo00
Subject: Re: [PATCH] w1: avoid recursive device_add
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20140416062121.GF5096@spacedout.fries.net>
Date: Wed, 16 Apr 2014 22:46:27 +0200
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Belisko Marek <marek.belisko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <EA7BA038-9EA9-43FD-AAC8-D4582F31CBE5@goldelico.com>
References: <CAAfyv37OPxJkcyYi0ZZe9MSQZ3TMeCuxa8rmWh8ahNF6Bs01Mg@mail.gmail.com> <20140323215041.GB5096@spacedout.fries.net> <698551395662480@web15j.yandex.ru> <CAAfyv352uNgS38ZKjb_r5Luvg=h1=f0G+ZJeZYAUSD1oxWdHxA@mail.gmail.com> <20140413222401.GE5096@spacedout.fries.net> <20140416062121.GF5096@spacedout.fries.net>
To: David Fries <david@fries.net>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Am 16.04.2014 um 08:21 schrieb David Fries:

> __w1_attach_slave_device calls device_add which calls w1_bus_notify
> which calls the w1_bq27000 slave driver, which calls
> platform_device_add and device_add and deadlocks on getting
> &(&priv->bus_notifier)->rwsem as it is still held in the previous
> device_add.  This avoids the problem by processing the family
> add/remove outside of the slave device_add call.
> 
> Commit 47eba33a0997fc7362a introduced this deadlock and added
> a KOBJ_ADD, as the add was already reported in device_register two add
> events were being sent.  This change suppresses the device_register
> add so that any slave device sysfs entries are setup before the add
> goes out.
> 
> Belisko Marek reported this change fixed the deadlock he was seeing on
> ARM device tree, while testing on my x86-64 system never saw the
> deadlock.
> 
> Reported-by: Belisko Marek <marek.belisko@gmail.com>
> Signed-off-by: David Fries <David@Fries.net>
> ---
> Evgeniy any comments?  The patch looks good to me.
> Dr. H. Nikolaus Schaller, Can you give this patch another test?  I
> don't expect any problems, but it is now only sending one add instead
> of two which is a change.

It merges fine and we don't see the problematic deadlock.

BR,
Nikolaus

> I verified two KOBJ_ADD notifications were going out prior to this
> change, and only one after.  There should only be one, also verified
> that the w1_bq27000 add notification went out before the slave device
> id, showing the suppression was working.  Used
> udevadm monitor --kernel --property
> for notification monitoring.
> 
> drivers/w1/w1.c |   32 ++++++--------------------------
> 1 file changed, 6 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
> index b96f61b..ff52618 100644
> --- a/drivers/w1/w1.c
> +++ b/drivers/w1/w1.c
> @@ -614,27 +614,11 @@ end:
> 	return err;
> }
> 
> -/*
> - * Handle sysfs file creation and removal here, before userspace is told that
> - * the device is added / removed from the system
> - */
> -static int w1_bus_notify(struct notifier_block *nb, unsigned long action,
> -			 void *data)
> +static int w1_family_notify(unsigned long action, struct w1_slave *sl)
> {
> -	struct device *dev = data;
> -	struct w1_slave *sl;
> 	struct w1_family_ops *fops;
> 	int err;
> 
> -	/*
> -	 * Only care about slave devices at the moment.  Yes, we should use a
> -	 * separate "type" for this, but for now, look at the release function
> -	 * to know which type it is...
> -	 */
> -	if (dev->release != w1_slave_release)
> -		return 0;
> -
> -	sl = dev_to_w1_slave(dev);
> 	fops = sl->family->fops;
> 
> 	if (!fops)
> @@ -673,10 +657,6 @@ static int w1_bus_notify(struct notifier_block *nb, unsigned long action,
> 	return 0;
> }
> 
> -static struct notifier_block w1_bus_nb = {
> -	.notifier_call = w1_bus_notify,
> -};
> -
> static int __w1_attach_slave_device(struct w1_slave *sl)
> {
> 	int err;
> @@ -698,6 +678,9 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
> 	dev_dbg(&sl->dev, "%s: registering %s as %p.\n", __func__,
> 		dev_name(&sl->dev), sl);
> 
> +	/* suppress for w1_family_notify before sending KOBJ_ADD */
> +	dev_set_uevent_suppress(&sl->dev, true);
> +
> 	err = device_register(&sl->dev);
> 	if (err < 0) {
> 		dev_err(&sl->dev,
> @@ -705,7 +688,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
> 			dev_name(&sl->dev), err);
> 		return err;
> 	}
> -
> +	w1_family_notify(BUS_NOTIFY_ADD_DEVICE, sl);
> 
> 	dev_set_uevent_suppress(&sl->dev, false);
> 	kobject_uevent(&sl->dev.kobj, KOBJ_ADD);
> @@ -799,6 +782,7 @@ int w1_unref_slave(struct w1_slave *sl)
> 		msg.type = W1_SLAVE_REMOVE;
> 		w1_netlink_send(sl->master, &msg);
> 
> +		w1_family_notify(BUS_NOTIFY_DEL_DEVICE, sl);
> 		device_unregister(&sl->dev);
> 		#ifdef DEBUG
> 		memset(sl, 0, sizeof(*sl));
> @@ -1186,10 +1170,6 @@ static int __init w1_init(void)
> 		goto err_out_exit_init;
> 	}
> 
> -	retval = bus_register_notifier(&w1_bus_type, &w1_bus_nb);
> -	if (retval)
> -		goto err_out_bus_unregister;
> -
> 	retval = driver_register(&w1_master_driver);
> 	if (retval) {
> 		printk(KERN_ERR
> -- 
> 1.7.10.4

