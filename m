Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758398Ab3D2SP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:15:57 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:40669 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758378Ab3D2SPy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:15:54 -0400
Date: Mon, 29 Apr 2013 11:15:50 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH] PCI: Fix racing for pci device removing via sysfs
Message-ID: <20130429181550.GA17343@google.com>
References: <1366940841-15370-1-git-send-email-yinghai@kernel.org>
 <CAErSpo5zfHR-agNBdgqfVjCU+-KcTZV+1bvML5Uw-+icDqzzEA@mail.gmail.com>
 <CAE9FiQVEQO-dLJRjn9Z7JgwGWAn1M8S1Tn2_V0Fq+6kB0rG=Bg@mail.gmail.com>
 <CAErSpo7DUDQ_XgVKAfWxqYJA=q85ps46bffV-4a7b0vOzAP5DA@mail.gmail.com>
 <CAE9FiQWv-bN2XzHiQ0WU+Y678zcqs_Owua6vXXijdMO6=0OWpg@mail.gmail.com>
 <517E45C8.4060407@cn.fujitsu.com>
 <CAE9FiQUXxCH0xjFPk1S7e_JRsBPosqQ=N5Kpcrjp3RNWDh9yZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQUXxCH0xjFPk1S7e_JRsBPosqQ=N5Kpcrjp3RNWDh9yZQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 29, 2013 at 08:19:10AM -0700, Yinghai Lu wrote:
> On Mon, Apr 29, 2013 at 3:04 AM, Gu Zheng <guz.fnst@cn.fujitsu.com> wrote:
> > On 04/27/2013 05:01 AM, Yinghai Lu wrote:
> >> On Fri, Apr 26, 2013 at 1:53 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> >>>
> >>> You can't be serious.  This is a disgusting mess.  Checking a list
> >>> pointer for LIST_POISON1?  As far as I'm concerned, this is a waste of
> >>> my time.
> 
> looks like xhci is using that LIST_POISON1 ...
> 
> >> Well, then need to hold the bus ref, and check bus->devices list instead.
> >
> > @@ -341,6 +352,7 @@ remove_store(struct device *dev, struct
> >  {
> >         int err;
> >         unsigned long val;
> > +       struct pci_dev *pdev;
> >
> >         if (strict_strtoul(buf, 0, &val) < 0)
> >                 return -EINVAL;
> > @@ -351,9 +363,14 @@ remove_store(struct device *dev, struct
> >         /* An attribute cannot be unregistered by one of its own methods,
> >          * so we have to use this roundabout approach.
> >          */
> > +       pdev = pci_dev_get(to_pci_dev(dev));
> >
> > There is no need to increase pci_dev's ref here, because we'll increase it
> > in sysfs_schedule_callback.
> 
> ok, i missed that. if we can use LIST_POISON, then could be more simple.
> like -v4.

I inlined your v4 patch below for convenience.

Maybe my allergic reaction to your use of LIST_POISON1 is unjustified,
but I am dubious about the idea that xhci was the only place that needed
it before now, and we just happened to find one more place in PCI that
needs it.  That doesn't make sense because good design patterns are used
many times, not just once or twice.

I thought the whole point of the get/put scheme was that if we had a
pointer to a correctly reference-counted object, we didn't need to check
whether the object was still valid because the object remains valid until
all the references are released.

Gu's "[v2 2/2] PCI: Convert alloc_pci_dev(void) to pci_alloc_dev(bus)"
patch essentially did this:

    pci_destroy_dev(struct pci_dev *dev) {
      ...
+     pci_bus_put(dev->bus)
      pci_free_resources(dev)
      put_device(&dev->dev)
    }

I think this is the wrong place to do the pci_bus_put() because the
pci_dev is reference-counted, and there may be other users that still
have valid references to it.

In this case, 10:00.0 is a bridge leading to [bus 11-1e], and 1a:01.0 is
part of that subtree.  The user removed both 10:00.0 and 1a:01.0 almost
simultaneously via sysfs and we scheduled a callback for each.

Each callback acquires a pci_dev reference, and removal of 10:00.0 and the
subtree below it, including pci_destroy_dev(1a:01.0), is done first.  The
callback to remove 1a:01.0 is still pending and has a valid reference to
the 1a:01.0 pci_dev.

Since the 1a:01.0 callback is still pending, the put_device in that first
pci_destroy_dev(1a:01.0) call decrements the ref count but doesn't release
the pci_dev.

I think the 1a:01.0 pci_dev should retain its reference to the pci_bus
for as long as the pci_dev exists, so the pci_bus_put() should go in
pci_release_dev() instead.

Bjorn

> Subject: [PATCH -v4] PCI: Fix racing for pci device removing via sysfs
> From: Yinghai Lu <yinghai@kernel.org>
> 
> Gu found nested removing through
> 	echo -n 1 > /sys/bus/pci/devices/0000\:10\:00.0/remove ; echo -n 1 >
> /sys/bus/pci/devices/0000\:1a\:01.0/remove
> 
> will cause kernel crash as bus get freed.
> 
> [  418.946462] CPU 4
> [  418.968377] Pid: 512, comm: kworker/u:2 Tainted: G        W    3.8.0 #2
> FUJITSU-SV PRIMEQUEST 1800E/SB
> [  419.081763] RIP: 0010:[<ffffffff8137972e>]  [<ffffffff8137972e>]
> pci_bus_read_config_word+0x5e/0x90
> [  420.494137] Call Trace:
> [  420.523326]  [<ffffffff813851ef>] ? remove_callback+0x1f/0x40
> [  420.591984]  [<ffffffff8138044b>] pci_pme_active+0x4b/0x1c0
> [  420.658545]  [<ffffffff8137d8e7>] pci_stop_bus_device+0x57/0xb0
> [  420.729259]  [<ffffffff8137dab6>] pci_stop_and_remove_bus_device+0x16/0x30
> [  420.811392]  [<ffffffff813851fb>] remove_callback+0x2b/0x40
> [  420.877955]  [<ffffffff81257a56>] sysfs_schedule_callback_work+0x26/0x70
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=54411
> 
> We have one patch that will let device hold bus ref to prevent it from
> being freed, but that will still generate warning.
> 
> ------------[ cut here ]------------
> WARNING: at lib/list_debug.c:53 __list_del_entry+0x63/0xd0()
> Hardware name: PRIMEQUEST 1800E
> list_del corruption, ffff8807d1b6c000->next is LIST_POISON1 (dead000000100100)
> Call Trace:
>  [<ffffffff81056d4f>] warn_slowpath_common+0x7f/0xc0
>  [<ffffffff81056e46>] warn_slowpath_fmt+0x46/0x50
>  [<ffffffff81280b13>] __list_del_entry+0x63/0xd0
>  [<ffffffff81280b91>] list_del+0x11/0x40
>  [<ffffffff81298331>] pci_destroy_dev+0x31/0xc0
>  [<ffffffff812985bb>] pci_remove_bus_device+0x5b/0x70
>  [<ffffffff812985ee>] pci_stop_and_remove_bus_device+0x1e/0x30
>  [<ffffffff8129fc89>] remove_callback+0x29/0x40
>  [<ffffffff811f3b84>] sysfs_schedule_callback_work+0x24/0x70
> 
> We can just check if the device get removed from pci tree
> already in the protection under pci_remove_rescan_mutex.
> 
> -v2: check if the dev->bus_list is poisoned instead to
>      find out if it is removed already.
>      Also add one extra ref to dev to make sure dev is not
>      get freed too early.
> -v4: remove not needed ref holding pointed by Gu Zheng.
> 
> Reported-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Tested-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  drivers/pci/pci-sysfs.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/pci/pci-sysfs.c
> ===================================================================
> --- linux-2.6.orig/drivers/pci/pci-sysfs.c
> +++ linux-2.6/drivers/pci/pci-sysfs.c
> @@ -331,7 +331,8 @@ static void remove_callback(struct devic
>  	struct pci_dev *pdev = to_pci_dev(dev);
>  
>  	mutex_lock(&pci_remove_rescan_mutex);
> -	pci_stop_and_remove_bus_device(pdev);
> +	if (pdev->bus_list.next != LIST_POISON1)
> +		pci_stop_and_remove_bus_device(pdev);
>  	mutex_unlock(&pci_remove_rescan_mutex);
>  }
>  
