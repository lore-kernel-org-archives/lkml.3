Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab3HYJRh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 05:17:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:50365 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab3HYJRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 05:17:35 -0400
Date: Sun, 25 Aug 2013 10:17:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Ben Dooks <ben@simtec.co.uk>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [tps_init] BUG: unable to handle kernel paging request at
	484970c9
Message-ID: <20130825091700.GT6617@n2100.arm.linux.org.uk>
References: <20130825000421.GC26317@localhost> <20130825040939.GB17883@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130825040939.GB17883@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 24, 2013 at 09:09:39PM -0700, Greg Kroah-Hartman wrote:
> Same as before, are you unloading and loading modules?  We have a fix
> for modules that cause problems when unloading with the config option
> above enabled.  But that shouldn't be this issue.

What seems to be is going on here is that something creates a kobject,
which gets exported into sysfs, then removed and then immediately
recreated.

It appears that sysfs entries are deleted in the cleanup function:

static void kobject_cleanup(struct kobject *kobj)
{
...
        /* remove from sysfs if the caller did not do it */
        if (kobj->state_in_sysfs) {
                pr_debug("kobject: '%s' (%p): auto cleanup kobject_del\n",
                         kobject_name(kobj), kobj);
                kobject_del(kobj);
        }

which is now delayed.  I don't think this is specifically a problem of
my patch - I think my patch is revealing a problem here.

Let's take it from the point of view of a struct device.  Lets say that
a device with name "foo" gets created.  This creates a sysfs directory
entry called "foo".  Various things take a reference on the device.

You then unregister that struct device because it's been removed.  As
all the references haven't yet been released, it means that the sysfs
directory persists.  Now, if the device is recreated with the same
name, sysfs complains that the directory exists.

In this case, it's not a struct device, but a device driver itself:

        /* some boards have startup glitches */
        while (tries--) {
                status = i2c_add_driver(&tps65010_driver);
                if (the_tps)
                        break;
                i2c_del_driver(&tps65010_driver);
                if (!tries) {
                        printk(KERN_ERR "%s: no chip?\n", DRIVER_NAME);
                        return -ENODEV;
                }
                pr_debug("%s: re-probe ...\n", DRIVER_NAME);
                msleep(10);
        }

Notice how the (i2c) driver is registered and removed multiple times.
If something can independently grab a reference to the kobject associated
with that driver, then it can cause the sysfs directory to persist longer
than the re-probe, which will cause sysfs to complain.

I don't think moving the sysfs directory cleanup (via kobject_del()) before
the delayed release fixes the fundamental problem here, because that just
covers up what happens if a reference is held.

Commit 0f4dafc05 (Kobject: auto-cleanup on final unref) introduced the
kobject_del() into the cleanup function.

Any thoughts?
