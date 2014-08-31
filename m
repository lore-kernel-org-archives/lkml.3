Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaHaLZH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 07:25:07 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:48264 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaHaLZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 07:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140831110200.GC19853@htj.dyndns.org>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
	<20140831101358.GB19853@htj.dyndns.org>
	<20140831110200.GC19853@htj.dyndns.org>
Date: Sun, 31 Aug 2014 13:25:03 +0200
Message-ID: <CANq1E4QFtTrCU8eq67AqeUO1v9EAZnAfaHJW4CnJkh0KKq9XmA@mail.gmail.com>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
From: David Herrmann <dh.herrmann@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, falcon@meizu.com,
        Takashi Iwai <tiwai@suse.de>, arjan@linux.intel.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        penguin-kernel@i-love.sakura.ne.jp,
        Joseph Salisbury <joseph.salisbury@canonical.com>, bpoirier@suse.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sun, Aug 31, 2014 at 1:02 PM, Tejun Heo <tj@kernel.org> wrote:
> So, something like the following.  A couple things to note
>
> * driver_attach() can never fail but is marked with __must_check.  We
>   prolly should change it to void.
>
> * Old/weird userspace which depends on insmod to wait for device
>   probing might choke and the new behavior might need to be switched
>   somehow (sysctl, insmod param or whatever).
>
> Lightly tested and seems to work fine.
>
> Thanks.
> ---
>  drivers/base/bus.c |   39 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 36 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 83e910a..e4fc9bc 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -23,6 +23,7 @@
>
>  /* /sys/devices/system */
>  static struct kset *system_kset;
> +static struct workqueue_struct *driver_attach_wq;
>
>  #define to_bus_attr(_attr) container_of(_attr, struct bus_attribute, attr)
>
> @@ -657,6 +658,20 @@ static ssize_t uevent_store(struct device_driver *drv, const char *buf,
>  }
>  static DRIVER_ATTR_WO(uevent);
>
> +struct driver_attach_work {
> +       struct work_struct              work;
> +       struct device_driver            *driver;
> +};
> +
> +static void driver_attach_workfn(struct work_struct *work)
> +{
> +       struct driver_attach_work *daw =
> +               container_of(work, struct driver_attach_work, work);
> +
> +       driver_attach(daw->driver);
> +       kfree(daw);
> +}
> +
>  /**
>   * bus_add_driver - Add a driver to the bus.
>   * @drv: driver.
> @@ -689,9 +704,23 @@ int bus_add_driver(struct device_driver *drv)
>
>         klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
>         if (drv->bus->p->drivers_autoprobe) {
> -               error = driver_attach(drv);
> -               if (error)
> -                       goto out_unregister;
> +               struct driver_attach_work *daw;
> +
> +               if (drv->owner) {
> +                       daw = kzalloc(sizeof(*daw), GFP_KERNEL);
> +                       if (!daw) {
> +                               error = -ENOMEM;
> +                               goto out_unregister;
> +                       }
> +
> +                       INIT_WORK(&daw->work, driver_attach_workfn);
> +                       daw->driver = drv;
> +                       queue_work(driver_attach_wq, &daw->work);

Doesn't this break on-demand cdev initialization? We currently call
request_module() on open() for unclaimed major/minor combinations. If
driver_attach() is no longer part of module_init(), there is no
guarantee the driver created the cdev before request_module() returns.

I actually like this "deferred attach" approach, so this is not meant
as counter-argument. We just need to make sure to have a notion of
"settled modules" so we know how long to wait after loading a module.

Thanks
David

> +               } else {
> +                       error = driver_attach(drv);
> +                       if (error)
> +                               goto out_unregister;
> +               }
>         }
>         module_add_driver(drv->owner, drv);
>
> @@ -1268,5 +1297,9 @@ int __init buses_init(void)
>         if (!system_kset)
>                 return -ENOMEM;
>
> +       driver_attach_wq = alloc_ordered_workqueue("driver_attach", 0);
> +       if (!driver_attach_wq)
> +               return -ENOMEM;
> +
>         return 0;
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
