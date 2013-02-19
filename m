Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933011Ab3BSO3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 09:29:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50136 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936Ab3BSO3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 09:29:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: kishon <kishon@ti.com>
Subject: Re: [PATCH v2 1/5] drivers: phy: add generic PHY framework
Date: Tue, 19 Feb 2013 14:28:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: rob@landley.net, tony@atomide.com, linux@arm.linux.org.uk,
        eballetbo@gmail.com, javier@dowhile0.org, balbi@ti.com,
        gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        mchehab@redhat.com, cesarb@cesarb.net, davem@davemloft.net,
        santosh.shilimkar@ti.com, broonie@opensource.wolfsonmicro.com,
        swarren@nvidia.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
References: <1361253198-7401-1-git-send-email-kishon@ti.com> <201302191256.24557.arnd@arndb.de> <51238485.1020408@ti.com>
In-Reply-To: <51238485.1020408@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302191428.42407.arnd@arndb.de>
X-Provags-ID: V02:K0:9vkJcV9glYbO0ncbERjoJSc+7lhWlGYWX1lKs69/gt2
 K5uZFXnGiLwSObh6k1OAb0oO0xVLPnZEoZXNArBo3YJNxd1xas
 sWFJbHMD2uk/ON5U32qcKNXbxuaTZTeQ/i5NEkJy1qa5NZBxK8
 kYHC6/HWkGtimZ1CyRas0bok/2b5HTAkDVVJSZ8dgcNFF0fCLx
 vHsm1rMa2KKss4iiH83JiSfGd37MCsy2bGOZkrRs2rypy+SI5K
 rXB6vo+/8Kb+Mv50OzY+KSRPKpTQP7xVqjXThSb7/vz2wqHLVi
 MiGrLCZlFu5COWb2OsZrc1TnVKG1H194tG2EXHcN0xWsa8MO8I
 PhkL1J1TAb7piVv+VV0w=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2013, kishon wrote:
> >> +
> >> +	devname = dev_name(dev);
> >> +	device_initialize(&phy->dev);
> >> +	phy->desc = desc;
> >> +	phy->dev.class = phy_class;
> >> +	phy->dev.parent = dev;
> >> +	phy->dev.bus = desc->bus;
> >> +	ret = dev_set_name(&phy->dev, "%s", devname);
> >
> >
> > Passing a bus_type through the descriptor seems misplaced. What is this for?
> 
> I thought if we are adding ethernet phys here (say drivers/phy/net), we 
> can make phy_device_create() (currently in drivers/net/phy/phy_device.c) 
> call phy_create with bus_type set to mdio_bus_type. Then we can have all 
> the PHYs showing up in /sys/class/phy/ and ethernet can continue to use 
> its own phy abstraction layer.

Hmm, that relies on the fact that mdio uses a 'bus_type' while the new phy
support uses a 'class', and it will break if we ever get to the point
where those two concepts are merged. I would rather not plan ahead here.

> > Why is this function not just:
> >
> > struct phy *phy_create(struct device *dev, const char *label, int type,
> > 			struct phy_ops *ops);
> 
> since while calling the callback functions using ops, there wont be 
> anyway to get back the device specific structure pointer.
> 
> struct phy_dev {
>   	.
>          .
> 	struct phy_descriptor	desc;
> 	void __iomem		*base;
> 	.
> 	.
> };
> 
> static int phy_resume(struct phy_descriptor *desc)
> {
> 
> //if we dont pass a member of phy_dev while *phy_create* we can't get 
> back phy_dev from callback functions as used below.
> 	struct phy_dev *phy = desc_to_omapusb(desc);
> 
> 	return 0;
> }
> 
> static struct phy_ops ops = {
> 	.resume		= phy_resume,
> 	.owner		= THIS_MODULE,
> };


In other subsystems, that is what the device->private_data pointer is used
for, which you could also pass to phy_create, or set after calling that
function.

> > Passing a structure like you do here seems dangerous because when someone
> > decides to add members to the structure, existing code will not give a
> > build error but silently break.
> 
> Not sure I understood this point. Care to explain?

Nevermind, when I wrote that sentence, I had not yet noticed that the
phy_descriptor is kept around. I was thinking that the structure was
only used to pass more arguments into phy_create.

	Arnd
