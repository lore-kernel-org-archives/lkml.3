Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaAHCBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 21:01:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44444 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbaAHCBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 21:01:40 -0500
MIME-Version: 1.0
In-Reply-To: <52C80AE6.1070302@acm.org>
References: <52C80A50.3000602@acm.org>
	<52C80AE6.1070302@acm.org>
Date: Wed, 8 Jan 2014 10:01:38 +0800
Message-ID: <CACVXFVODMd1UPbzg-fBn-n991scnAseArvFLpPExe44EoPZuyA@mail.gmail.com>
Subject: Re: [PATCH 3/3] driver-core: Fix use-after-free triggered by bus_unregister()
From: Ming Lei <ming.lei@canonical.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 4, 2014 at 9:21 PM, Bart Van Assche <bvanassche@acm.org> wrote:
> Avoid that bus_unregister() triggers a use-after-free with
> CONFIG_DEBUG_KOBJECT_RELEASE=y. This patch avoids that the
> following sequence triggers a kernel crash with memory poisoning
> enabled:
> * bus_register()
> * driver_register()
> * driver_unregister()
> * bus_unregister()
>
> The above sequence causes the bus private data to be freed from
> inside the bus_unregister() call although it is not guaranteed in
> that function that the reference count on the bus private data has
> dropped to zero. As an example, with CONFIG_DEBUG_KOBJECT_RELEASE=y
> the ${bus}/drivers kobject is still holding a reference on
> bus->p->subsys.kobj via its parent pointer at the time the bus
> private data is freed. Fix this by deferring freeing the bus private
> data until the last kobject_put() call on bus->p->subsys.kobj.
>
> The kernel oops triggered by the above sequence and with memory
> poisoning enabled and that is fixed by this patch is as follows:
>
> general protection fault: 0000 [#1] PREEMPT SMP
> CPU: 3 PID: 2711 Comm: kworker/3:32 Tainted: G        W  O 3.13.0-rc4-debug+ #1
> Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> Workqueue: events kobject_delayed_cleanup
> task: ffff880037f866d0 ti: ffff88003b638000 task.ti: ffff88003b638000
> Call Trace:
>  [<ffffffff81263105>] ? kobject_get_path+0x25/0x100
>  [<ffffffff81264354>] kobject_uevent_env+0x134/0x600
>  [<ffffffff8126482b>] kobject_uevent+0xb/0x10
>  [<ffffffff81262fa2>] kobject_delayed_cleanup+0xc2/0x1b0
>  [<ffffffff8106c047>] process_one_work+0x217/0x700
>  [<ffffffff8106bfdb>] ? process_one_work+0x1ab/0x700
>  [<ffffffff8106c64b>] worker_thread+0x11b/0x3a0
>  [<ffffffff8106c530>] ? process_one_work+0x700/0x700
>  [<ffffffff81074b70>] kthread+0xf0/0x110
>  [<ffffffff81074a80>] ? insert_kthread_work+0x80/0x80
>  [<ffffffff815673bc>] ret_from_fork+0x7c/0xb0
>  [<ffffffff81074a80>] ? insert_kthread_work+0x80/0x80
> Code: 89 f8 48 89 e5 f6 82 c0 27 63 81 20 74 15 0f 1f 44 00 00 48 83 c0 01 0f b6 10 f6 82 c0 27 63 81 20 75 f0 5d c3 66 0f 1f 44 00 00 <80> 3f 00 55 48 89 e5 74 15 48 89 f8 0f 1f 40 00 48 83 c0 01 80
> RIP  [<ffffffff81267ed0>] strlen+0x0/0x30
>  RSP <ffff88003b639c70>
> ---[ end trace 210f883ef80376aa ]---
>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/base/bus.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/base/bus.c b/drivers/base/bus.c
> index 73f6c29..59dc808 100644
> --- a/drivers/base/bus.c
> +++ b/drivers/base/bus.c
> @@ -146,8 +146,19 @@ void bus_remove_file(struct bus_type *bus, struct bus_attribute *attr)
>  }
>  EXPORT_SYMBOL_GPL(bus_remove_file);
>
> +static void bus_release(struct kobject *kobj)
> +{
> +       struct subsys_private *priv =
> +               container_of(kobj, typeof(*priv), subsys.kobj);
> +       struct bus_type *bus = priv->bus;
> +
> +       kfree(priv);
> +       bus->p = NULL;
> +}
> +
>  static struct kobj_type bus_ktype = {
>         .sysfs_ops      = &bus_sysfs_ops,
> +       .release        = bus_release,
>  };
>
>  static int bus_uevent_filter(struct kset *kset, struct kobject *kobj)
> @@ -953,8 +964,6 @@ void bus_unregister(struct bus_type *bus)
>         kset_unregister(bus->p->devices_kset);
>         bus_remove_file(bus, &bus_attr_uevent);
>         kset_unregister(&bus->p->subsys);
> -       kfree(bus->p);
> -       bus->p = NULL;
>  }
>  EXPORT_SYMBOL_GPL(bus_unregister);

Looks the fix is fine,

Acked-by: Ming Lei <ming.lei@canonical.com>


Thanks,
--
Ming Lei
