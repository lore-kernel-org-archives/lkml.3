Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbaDMWYY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 18:24:24 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:51445 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbaDMWYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 18:24:21 -0400
Date: Sun, 13 Apr 2014 17:24:01 -0500
From: David Fries <david@fries.net>
To: Belisko Marek <marek.belisko@gmail.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>, LKML <linux-kernel@vger.kernel.org>,
        "Dr. H. Nikolaus Schaller" <hns@goldelico.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: w1: 3.14-rc7 - possible recursive locking detected
Message-ID: <20140413222401.GE5096@spacedout.fries.net>
References: <CAAfyv37OPxJkcyYi0ZZe9MSQZ3TMeCuxa8rmWh8ahNF6Bs01Mg@mail.gmail.com>
 <20140323215041.GB5096@spacedout.fries.net>
 <698551395662480@web15j.yandex.ru>
 <CAAfyv352uNgS38ZKjb_r5Luvg=h1=f0G+ZJeZYAUSD1oxWdHxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAfyv352uNgS38ZKjb_r5Luvg=h1=f0G+ZJeZYAUSD1oxWdHxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Sun, 13 Apr 2014 17:24:04 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Belisko Marek,
Here is a possible solution, could you give it a try and report back?

Greg Kroah-Hartman,
Evgeniy asked me to look into this report.  I don't have the
reporter's hardware configuration, but I wouldn't think that would be
needed, just some w1 bus master (even W1_MASTER_GPIO might work), then
loading the slave device and manually adding a slave device with that
family id.  Even then I didn't reproduce the reported recursive
locking error.  I saw unrelated locking reports, but not this one.  I
wrote up the included patch, but that undoes the notify changes that
you added earlier in commit 47eba33a0997fc7, and I wanted to ask about
that commit.  Specifically these two lines,

        err = device_register(&sl->dev);
	...
+	dev_set_uevent_suppress(&sl->dev, false);
+	kobject_uevent(&sl->dev.kobj, KOBJ_ADD);

Wouldn't the default be to not suppress?  Nothing in the W1 system
enables suppressing so is that even needed?  (I'm fine with saying
it's a good idea).
device_register at some point must call device_add and device_add
calls kobject_uevent(&dev->kobj, KOBJ_ADD);
so doesn't the KOBJ_ADD send the add a second time?  As in it
shouldn't be needed?
Can the suppress be called before device_register to avoid the
automatic notify, then after it returns setup the slave device as this
patch does to avoid this problem report, and then call the KOBJ_ADD to
make everything happy?

I'm based on commit ce7613db2d8d4d5af2587a.

On Tue, Apr 08, 2014 at 09:47:50PM +0200, Belisko Marek wrote:
> Hi,
> 
> On Mon, Mar 24, 2014 at 1:01 PM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> > Hi everyone
> >
> > 24.03.2014, 01:50, "David Fries" <David@Fries.net>:
> >> On Mon, Mar 17, 2014 at 10:38:13PM +0100, Belisko Marek wrote:
> >>>  booting latest 3.14-rc7 on gta04 board gives following warning:
> >>>
> >>>  [    3.101409] Driver for 1-wire Dallas network protocol.
> >>>  [    3.109649] omap_hdq omap_hdq: OMAP HDQ Hardware Rev 0.5. Driver in
> >>>  [    3.400146]        CPU0
> >>>  [    3.402709]        ----
> >>>  [    3.405273]   lock(&(&priv->bus_notifier)->rwsem);
> >>>  [    3.410308]   lock(&(&priv->bus_notifier)->rwsem);
> >>>  [    3.415374]
> >>>  [    3.415374]  *** DEADLOCK ***
> >>>
> >>>  AFAIK we didn't see that on (at least 3/14-rc2).
> >>
> >> The last drivers/w1 change went in before v3.14-rc1, so if it is
> >> something in the w1 code, it has either been there or something else
> >> in the rest of the kernel changed to expose it.  I'm using the ds2490
> >> USB w1 dongle, I didn't see that problem when enabling lock debugging
> >> on 3.14.0-rc5+ which includes some changes I'm working on.
> >>
> >> https://github.com/dfries/linux.git w1_rework
> >
> > Can it be a bug in omap w1 driver?
> We test with actual Linus master and it's even worse (it hangs completely).
> Trace look little bit different and it only happens when booting via
> device tree (not with board file).
> 
> [    2.807434] Driver for 1-wire Dallas network protocol.
> [    2.814117] omap_hdq omap_hdq: OMAP HDQ Hardware Rev 0.5. Driver in
> Interrupt mode
> [    3.034271] call_modprobe: w1-family-0x1
> [    3.051818]
> [    3.053405] =============================================
> [    3.059051] [ INFO: possible recursive locking detected ]
> [    3.064727] 3.14.0-gta04 #556 Not tainted
> [    3.068939] ---------------------------------------------
> [    3.074615] w1_bus_master1/795 is trying to acquire lock:
> [    3.080261]  (&(&priv->bus_notifier)->rwsem){.+.+.+}, at:
> [<c0058ab0>] __blocking_notifier_call_chain+0x28/0x58
> [    3.090911]
> [    3.090911] but task is already holding lock:
> [    3.097045]  (&(&priv->bus_notifier)->rwsem){.+.+.+}, at:
> [<c0058ab0>] __blocking_notifier_call_chain+0x28/0x58
> [    3.107666]
> [    3.107666] other info that might help us debug this:
> [    3.114501]  Possible unsafe locking scenario:
> [    3.114501]
> [    3.120727]        CPU0
> [    3.123291]        ----
> [    3.125854]   lock(&(&priv->bus_notifier)->rwsem);
> [    3.130889]   lock(&(&priv->bus_notifier)->rwsem);
> [    3.135925]
> [    3.135925]  *** DEADLOCK ***
> [    3.135925]
> [    3.142150]  May be due to missing lock nesting notation
> [    3.142150]
> [    3.149291] 2 locks held by w1_bus_master1/795:
> [    3.154052]  #0:  (&dev->mutex#3){+.+.+.}, at: [<c03ba1c8>]
> w1_attach_slave_device+0xc4/0x1c8
> [    3.163055]  #1:  (&(&priv->bus_notifier)->rwsem){.+.+.+}, at:
> [<c0058ab0>] __blocking_notifier_call_chain+0x28/0x58
> [    3.174163]
> [    3.174163] stack backtrace:
> [    3.178741] CPU: 0 PID: 795 Comm: w1_bus_master1 Not tainted
> 3.14.0-gta04 #556
> [    3.186370] [<c0013ca0>] (unwind_backtrace) from [<c0010f68>]
> (show_stack+0x10/0x14)
> [    3.194488] [<c0010f68>] (show_stack) from [<c04f0900>]
> (dump_stack+0x6c/0x88)
> [    3.202117] [<c04f0900>] (dump_stack) from [<c00746bc>]
> (print_deadlock_bug+0xc0/0xf0)
> [    3.210449] [<c00746bc>] (print_deadlock_bug) from [<c0075f80>]
> (validate_chain.isra.29+0x4dc/0x534)
> [    3.220031] [<c0075f80>] (validate_chain.isra.29) from [<c0076dac>]
> (__lock_acquire+0x728/0x834)
> [    3.229248] [<c0076dac>] (__lock_acquire) from [<c00774b8>]
> (lock_acquire+0xf4/0x118)
> [    3.237487] [<c00774b8>] (lock_acquire) from [<c04f8e04>]
> (down_read+0x24/0x34)
> [    3.245178] [<c04f8e04>] (down_read) from [<c0058ab0>]
> (__blocking_notifier_call_chain+0x28/0x58)
> [    3.254516] [<c0058ab0>] (__blocking_notifier_call_chain) from
> [<c0058af4>] (blocking_notifier_call_chain+0x14/0x18)
> [    3.265563] [<c0058af4>] (blocking_notifier_call_chain) from
> [<c0301db8>] (device_add+0x1f4/0x368)
> [    3.274993] [<c0301db8>] (device_add) from [<c03055cc>]
> (platform_device_add+0x138/0x1c8)
> [    3.283569] [<c03055cc>] (platform_device_add) from [<c03bd124>]
> (w1_bq27000_add_slave+0x44/0x74)
> [    3.292907] [<c03bd124>] (w1_bq27000_add_slave) from [<c03b9ed8>]
> (w1_bus_notify.part.0+0x48/0xc8)
> [    3.302337] [<c03b9ed8>] (w1_bus_notify.part.0) from [<c04fbe1c>]
> (notifier_call_chain+0x38/0x68)
> [    3.311645] [<c04fbe1c>] (notifier_call_chain) from [<c0058acc>]
> (__blocking_notifier_call_chain+0x44/0x58)
> [    3.321899] [<c0058acc>] (__blocking_notifier_call_chain) from
> [<c0058af4>] (blocking_notifier_call_chain+0x14/0x18)
> [    3.332946] [<c0058af4>] (blocking_notifier_call_chain) from
> [<c0301db8>] (device_add+0x1f4/0x368)
> [    3.342346] [<c0301db8>] (device_add) from [<c03b9ad0>]
> (__w1_attach_slave_device+0x9c/0x134)
> [    3.351318] [<c03b9ad0>] (__w1_attach_slave_device) from
> [<c03ba238>] (w1_attach_slave_device+0x134/0x1c8)
> [    3.361480] [<c03ba238>] (w1_attach_slave_device) from [<c03ba348>]
> (w1_slave_found+0x7c/0x98)
> [    3.370513] [<c03ba348>] (w1_slave_found) from [<c03bc818>]
> (omap_w1_search_bus+0x54/0x5c)
> [    3.379211] [<c03bc818>] (omap_w1_search_bus) from [<c03bc758>]
> (w1_search_devices+0x3c/0x48)
> [    3.388153] [<c03bc758>] (w1_search_devices) from [<c03baaec>]
> (w1_search_process_cb+0x64/0x108)
> [    3.397399] [<c03baaec>] (w1_search_process_cb) from [<c03bac60>]
> (w1_process+0x68/0x14c)
> [    3.405975] [<c03bac60>] (w1_process) from [<c0054bdc>] (kthread+0xdc/0xf0)
> [    3.413299] [<c0054bdc>] (kthread) from [<c000dca8>]
> (ret_from_fork+0x14/0x2c)
> [   24.451049] INFO: rcu_sched detected stalls on CPUs/tasks: {}
> (detected by 0, t=2102 jiffies, g=4294967086, c=4294967085, q=19)
> [   24.463134] INFO: Stall ended before state dump start
> [   87.501037] INFO: rcu_sched detected stalls on CPUs/tasks: {}
> (detected by 0, t=8407 jiffies, g=4294967086, c=4294967085, q=19)
> [   87.513122] INFO: Stall ended before state dump start
> [  150.551055] INFO: rcu_sched detected stalls on CPUs/tasks: {}
> (detected by 0, t=14712 jiffies, g=4294967086, c=4294967085, q=19)
> [  150.563232] INFO: Stall ended before state dump start
> [  213.601043] INFO: rcu_sched detected stalls on CPUs/tasks: {}
> (detected by 0, t=21017 jiffies, g=4294967086, c=4294967085, q=19)
> [  213.613220] INFO: Stall ended before state dump start
> [  276.651062] INFO: rcu_sched detected stalls on CPUs/tasks: {}
> (detected by 0, t=27322 jiffies, g=4294967086, c=4294967085, q=19)
> [  276.663238] INFO: Stall ended before state dump start
> 
> BR,
> 
> marek
> 
> -- 
> as simple and primitive as possible
> -------------------------------------------------
> Marek Belisko - OPEN-NANDRA
> Freelance Developer
> 
> Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
> Tel: +421 915 052 184
> skype: marekwhite
> twitter: #opennandra
> web: http://open-nandra.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/


commit b3afc24a3ca6c261a8fe2c08b5bbccb51233c09a
Author: David Fries <David@Fries.net>
Date:   Sun Apr 13 15:36:45 2014 -0500

    w1: avoid recursive device_add
    
    __w1_attach_slave_device calls device_add which calls w1_bus_notify
    which calls for the w1_bq27000 slave driver, which calls
    platform_device_add and device_add and deadlocks on getting
    &(&priv->bus_notifier)->rwsem as it is still held in the previous
    device_add.  This avoids the problem by processing the family
    add/remove outside of the slave device_add call.  This does mean that
    the slave device isn't setup when the notification that a slave is
    available goes out.
    
    Reported-by: Belisko Marek <marek.belisko@gmail.com>

diff --git a/drivers/w1/w1.c b/drivers/w1/w1.c
index b96f61b..dde09c1 100644
--- a/drivers/w1/w1.c
+++ b/drivers/w1/w1.c
@@ -614,27 +614,11 @@ end:
 	return err;
 }
 
-/*
- * Handle sysfs file creation and removal here, before userspace is told that
- * the device is added / removed from the system
- */
-static int w1_bus_notify(struct notifier_block *nb, unsigned long action,
-			 void *data)
+static int w1_family_notify(unsigned long action, struct w1_slave *sl)
 {
-	struct device *dev = data;
-	struct w1_slave *sl;
 	struct w1_family_ops *fops;
 	int err;
 
-	/*
-	 * Only care about slave devices at the moment.  Yes, we should use a
-	 * separate "type" for this, but for now, look at the release function
-	 * to know which type it is...
-	 */
-	if (dev->release != w1_slave_release)
-		return 0;
-
-	sl = dev_to_w1_slave(dev);
 	fops = sl->family->fops;
 
 	if (!fops)
@@ -673,10 +657,6 @@ static int w1_bus_notify(struct notifier_block *nb, unsigned long action,
 	return 0;
 }
 
-static struct notifier_block w1_bus_nb = {
-	.notifier_call = w1_bus_notify,
-};
-
 static int __w1_attach_slave_device(struct w1_slave *sl)
 {
 	int err;
@@ -705,6 +685,7 @@ static int __w1_attach_slave_device(struct w1_slave *sl)
 			dev_name(&sl->dev), err);
 		return err;
 	}
+	w1_family_notify(BUS_NOTIFY_ADD_DEVICE, sl);
 
 
 	dev_set_uevent_suppress(&sl->dev, false);
@@ -799,6 +780,7 @@ int w1_unref_slave(struct w1_slave *sl)
 		msg.type = W1_SLAVE_REMOVE;
 		w1_netlink_send(sl->master, &msg);
 
+		w1_family_notify(BUS_NOTIFY_DEL_DEVICE, sl);
 		device_unregister(&sl->dev);
 		#ifdef DEBUG
 		memset(sl, 0, sizeof(*sl));
@@ -1186,10 +1168,6 @@ static int __init w1_init(void)
 		goto err_out_exit_init;
 	}
 
-	retval = bus_register_notifier(&w1_bus_type, &w1_bus_nb);
-	if (retval)
-		goto err_out_bus_unregister;
-
 	retval = driver_register(&w1_master_driver);
 	if (retval) {
 		printk(KERN_ERR
