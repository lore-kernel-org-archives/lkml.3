Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852Ab3HUMi5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 08:38:57 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:53371
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751818Ab3HUMiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 08:38:55 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dI9371I1432I1521Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h1155h)
Date: Wed, 21 Aug 2013 20:37:09 +0800
From: Dong Aisheng <b29396@freescale.com>
To: Grant Likely <grant.likely@linaro.org>
CC: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 0/3] of: add update device node status via cmdline feature
Message-ID: <20130821123708.GA17748@b29396-Latitude-E6410>
References: <1376564133-11286-1-git-send-email-b29396@freescale.com>
 <CACxGe6tMm=u1jFKUQ59+cj-rYkLLAZUqMhsXamyi-wwpWaOGvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CACxGe6tMm=u1jFKUQ59+cj-rYkLLAZUqMhsXamyi-wwpWaOGvw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 01:45:48PM +0100, Grant Likely wrote:
> On Thu, Aug 15, 2013 at 11:55 AM, Dong Aisheng <b29396@freescale.com> wrote:
> > We meet some boards having a lot of pin conflicts between different devices,
> > only one of them can be enabled to run at one time.
> >
> > e.g. imx6q sabreauto board, i2c, spi, weim, flexcan, uart and etc involved
> > with pin conflict.
> >
> > Instead of changing dts manually or adding a lot dts files according to
> > different device availability, we provide feature to dynamically update the
> > device node status via command line, then those devices involved with
> > pin conflict can be enabled or disabled dynamically.
> 
> Ugh, no. If there are dynamic conflicts, then the driver really should
> be responsible for handling them. ie. if the driver isn't able to get
> the resource it needs because they don't exist, then driver probe
> should fail.
> 

Detect pin confliction in driver is not our purpose.
The real requirement is to flexibly decide which device involved in confliction
is enabled when booting kernel since only one of them can be running at one time,
not detect them.

Before using device tree, we defined kernel param in mach code ourself to fix
this issue.
e.g. i2c and spi are conflicted.
We add kernel boot param i2c3_en to decide whether enable i2c3 or spi.
Then user can test devices flexibly as they want.

After switch to device tree, since this part of work actually is soc independent,
we move it into the dt core to let the kernel provide such feature.
Then everyone else can also use it if needed.

If do not provide such features in kernel, we may have to do it either in mach-code
which may cause a lot of code duplication, or board dts file which cause add a lot
duplicated board dts files.
e.g. there are 11 devices involved with pin confliction in imx6q sabreauto board.
i2c3, ecspi1, weim_nor, uart3, gpmi, can1, enet, tunner, satellite, mipi, csi.
Some of them are combined conflicted.(e.g i2c3, ecspi1, weim_nor all conflict with EIM_D18)
One simple way to use board dts to fix this issue may be add 11 more board dts files
with one common board dts with all those device disabled by default.
It may be:
imx6q-sabreauto.dts
imx6q-sabreauto-with-i2c3.dts
imx6q-sabreauto-with-ecspi1.dts
imx6q-sabreauto-with-weim-nor.dts
imx6q-sabreauto-with-uart3.dts
imx6q-sabreauto-with-gpmi.dts
imx6q-sabreauto-with-can1.dts
imx6q-sabreauto-with-enet.dts
imx6q-sabreauto-with-tunner.dts
imx6q-sabreauto-with-satellite.dts
imx6q-sabreauto-with-mipi.dts
imx6q-sabreauto-with-csi.dts

We may also reduce them by combine some of them.
e.g.
imx6q-sabreauto-with-i2c3-uart3-can1-tunner-mipi.dts
imx6q-sabreauto-with-ecspi1-gpmi-enet-satellite-csi.dts
imx6q-sabreauto-with-weim-nor-*.dts
....
The defect is the combination and name is arbitrary and may
cause dts file name changed usually.

The common issue of above two way is that 1) it bloats the device tree,
add a lot of duplicated dts files with the same board
2) the fix is out of control and not permanent.
If any new board having more conflict devices, we have to add these new board dts
separately and figure out the combination again.
e.g. for imx6q arm2 board, it also has conflicted devices flexcan, gpmi, sd and etc.
So i'm not sure if you can accept this way.

By comparing adding dts file, if the kernel provides such feature, we do not have
to add these duplicated board dts files, only one board dts file with all conflicted
devices disable by default and let user decide which device is enabled flexibly with
kernel command line. And the fix is also permanently, not depends on hw design
and how many device conflicted.

Also in our case, it's pin confliction. However, it works for other conflict type
as well that only one can work which may also exist on other platforms.

> Except in very excpetional circumstances (ie. firmware workarounds)
> the kernel needs to treat the device tree as immutable*. The tree
> passed in at boot should not be manipulated at runtime.
> 

I understand the tree passed should be treated as inmmutable at most time.
But now we did have this requirement and this is caused by real hw design.
I'm not sure if our case can be treated as an excpetional circumstances,
but it does look like a excpetional to me.

so i wonder if kernel could provide such feature and let user to decide whether
to use since it is valuable.

BTW, except the pin confliction, freescale imx6q soc can also be fused
with different IP availability.

That means the same imx6q sabreauto board, if the soc chip is with different fuse,
the device availability may be different.
e.g. 
imx6q(a) sabreauto with enet enabled.
imx6q(b) sabreauto with enet disabled.

We probably may still want to dynamically update the device node status by reading
the fuse map before populating platform devices since if the IP is not exist,
creating it's device is unreasonable.

The devices involved with fused devices for imx6sdl are:
"pxp", "ovg", "dsi_csi2", "enet", "mlb",
"epdc", "hdmi", "pcie", "sata", "dtcp",
"2d", "3d", "vpu", "divx3", "rv",
"sorensen",

> * There are powerpc platforms that modify the FDT at runtime; but in
> those cases it is in response to firmware changing the data, not the
> kernel.
> 

I'm not very clear about the case in response to firmware changing the data.
Can you help give a example?
Then i can understand the difference between our case and the exception you said.

However, i did saw many exist code calling of_property_* API to change the device tree
in kernel, although not clear about their purpose. But,
e.g
arch/powerpc/platforms/85xx/p1022_ds.c
In these file, it also disable device node dynamically by commandline.
If kernel has this feature, these code can be removed.
arch/arm/mach-omap2/timer.c
also disable the node...

Regards
Dong Aisheng

