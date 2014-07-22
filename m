Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbaGVHtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:49:52 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:53891 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaGVHtu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:49:50 -0400
Date: Tue, 22 Jul 2014 09:49:30 +0200
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, Roger Quadros <rogerq@ti.com>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 9/9] usb: musb: musb_am335x: reinstate module
 loading/unloading support
Message-ID: <20140722094930.0c52bb01@ipc1.ka-ro>
In-Reply-To: <20140718140403.GI24914@saruman.home>
References: <1405675890-8802-1-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-2-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-3-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-4-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-5-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-6-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-7-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-8-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-9-git-send-email-LW@KARO-electronics.de>
 <1405675890-8802-10-git-send-email-LW@KARO-electronics.de>
 <20140718140403.GI24914@saruman.home>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Felipe Balbi wrote:
> On Fri, Jul 18, 2014 at 11:31:30AM +0200, Lothar Waßmann wrote:
> > There is no need to throw the baby out with the bath due to a bad
> > failure analysis. The commit:
> > 7adb5c876e9c usb: musb: Fix panic upon musb_am335x module removal
> > came to a wrong conclusion about the cause of the crash it was
> > "fixing". The real culprit was the phy-am335x module that was removed
> > from underneath its users that were still referencing data from it.
> > After having fixed this in a previous patch, module unloading can be
> > reinstated.
> > 
> > Another bug with module loading/unloading was the fact, that after
> > removing the devices instantiated from DT their 'OF_POPULATED' flag
> > was still set, so that re-loading the module after an unload had no
> > effect. This is also fixed in this patch.
> 
> now this is a good commit log. I still can't see the need for the other
> patch adding try_module_get(), though. Another thing, this needs to be
> reviewed by DT folks too.
> 
Without holding a reference to the phy module, the module may be
unloaded when its resources are still in use which may lead to the
crash observed in the above stated commit.

> > Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
> > ---
> >  drivers/usb/musb/musb_am335x.c |   23 ++++++++++++++++++-----
> >  1 file changed, 18 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/usb/musb/musb_am335x.c b/drivers/usb/musb/musb_am335x.c
> > index 164c868..152a6f5 100644
> > --- a/drivers/usb/musb/musb_am335x.c
> > +++ b/drivers/usb/musb/musb_am335x.c
> > @@ -19,6 +19,22 @@ err:
> >  	return ret;
> >  }
> >  
> > +static int of_remove_populated_child(struct device *dev, void *d)
> > +{
> > +	struct platform_device *pdev = to_platform_device(dev);
> > +
> > +	of_device_unregister(pdev);
> > +	of_node_clear_flag(pdev->dev.of_node, OF_POPULATED);
> 
> I don't think this should be called by drivers; rather by the bus.
> 
Possibly the right thing to do would be to use of_platform_depopulate()
in the remove function to pair up with op_platform_populate() in the
probe function, but doing this results in a crash in
platform_device_del() (called from platform_device_unregister()) when
release_resource() is being called on resources that were never
properly registered with the device:
Unable to handle kernel NULL pointer dereference at virtual address 00000018
pgd = 8dd64000
[00000018] *pgd=8ddc2831, *pte=00000000, *ppte=00000000
Internal error: Oops: 17 [#1] PREEMPT ARM
Modules linked in: musb_am335x(-) [last unloaded: snd]
CPU: 0 PID: 1435 Comm: modprobe Not tainted 3.16.0-rc5-next-20140717-dbg+ #13
task: 8da00880 ti: 8dda0000 task.ti: 8dda0000
PC is at release_resource+0x14/0x7c
LR is at release_resource+0x10/0x7c
pc : [<8003165c>]    lr : [<80031658>]    psr: a0000013
sp : 8dda1ec0  ip : 8dda0000  fp : 00000000
r10: 00000000  r9 : 8dda0000  r8 : 8deb7c10
r7 : 8deb7c00  r6 : 00000200  r5 : 00000001  r4 : 8deed380
r3 : 00000000  r2 : 00000000  r1 : 00000011  r0 : 806772a0
Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 10c5387d  Table: 8dd64019  DAC: 00000015
Process modprobe (pid: 1435, stack limit = 0x8dda0238)
Stack: (0x8dda1ec0 to 0x8dda2000)
1ec0: 8da00880 8deed380 00000001 802f850c 00000000 8deed380 44e10620 44e1062f
1ee0: 8deb7c00 00000000 80398c5c 00000081 8000e904 802f8848 8deb7c10 80398d0c
1f00: 00000000 802f3470 8d8d7200 8ddc84b0 8d92e810 7f0f9014 8d92e844 7f0f7010
1f20: 8d92e810 802f8110 802f80f8 802f68f8 7f0f9014 8d92e810 7f0f9014 802f7238
1f40: 7f0f9014 00000000 20000013 802f6764 7f0f9058 8007ec94 00000000 6273756d
1f60: 336d615f 00783533 8da00880 8000e764 00000001 80053ae4 00000058 76f41000
1f80: 7eb299e8 01290838 00000011 00000081 60000010 0000e854 7eb299e8 01290838
1fa0: 00000011 8000e740 7eb299e8 01290838 012908a0 00000080 00000000 00000001
1fc0: 7eb299e8 01290838 00000011 00000081 012908a0 00000000 01290844 00000000
1fe0: 76eb76f0 7eb2995c 0000a534 76eb76fc 60000010 012908a0 aaaaaaaa aaaaaaaa
[<8003165c>] (release_resource) from [<802f850c>] (platform_device_del+0xb4/0xf4)
[<802f850c>] (platform_device_del) from [<802f8848>] (platform_device_unregister+0xc/0x18)
[<802f8848>] (platform_device_unregister) from [<80398d0c>] (of_platform_device_destroy+0xb0/0xc8)
[<80398d0c>] (of_platform_device_destroy) from [<802f3470>] (device_for_each_child+0x34/0x74)
[<802f3470>] (device_for_each_child) from [<7f0f7010>] (am335x_child_remove+0x10/0x24 [musb_am335x])
[<7f0f7010>] (am335x_child_remove [musb_am335x]) from [<802f8110>] (platform_drv_remove+0x18/0x1c)
[<802f8110>] (platform_drv_remove) from [<802f68f8>] (__device_release_driver+0x70/0xc4)
[<802f68f8>] (__device_release_driver) from [<802f7238>] (driver_detach+0xb4/0xb8)
[<802f7238>] (driver_detach) from [<802f6764>] (bus_remove_driver+0x5c/0xa4)
[<802f6764>] (bus_remove_driver) from [<8007ec94>] (SyS_delete_module+0x120/0x18c)
[<8007ec94>] (SyS_delete_module) from [<8000e740>] (ret_fast_syscall+0x0/0x48)
Code: e1a04000 e59f0068 eb10bac4 e5943010 (e5932018) 
---[ end trace 24ca43dfc1a677d6 ]---

The cause for this seems to be calling platform_device_unregister() on
a device that was created with device_add() (rather than
platform_device_add()).

The call chain for registering a device from of_platform_populate() is:
of_platform_bus_create()
of_platform_device_create_pdata()
of_device_add()
device_add()

The call chain for the of_platform_depopulate() is:
of_platform_device_destroy()
platform_device_unregister()
platform_device_del()
release_resource()

The resources that are being released here have the 'parent' pointer
set to NULL which provokes the crash. This pointer would have been set
up by insert_resource() which is called by platform_device_add() but
not by device_add().

So, the conclusion to me is that of_platform_populate() /
of_platform_depopulate() are broken, because one uses device_*
functions while the other uses the platform_device_* counterparts.

Since there are no current users of of_platform_depopulate() this
obviously has gone unnoticed so far.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
