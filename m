Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaETJ2N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:28:13 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9359 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbaETJ2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:28:06 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-ce-537b20110c04
Message-id: <537B200C.2080903@samsung.com>
Date: Tue, 20 May 2014 11:27:40 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] drivers/base: Add interface framework
References: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
 <1399995050-28435-5-git-send-email-thierry.reding@gmail.com>
 <20140513175713.GS3908@phenom.ffwll.local> <20140514003215.GA21520@kroah.com>
 <20140515085324.GA6434@ulmo>
In-reply-to: <20140515085324.GA6434@ulmo>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xy7qCCtXBBl/XSlrMaz3KYnHl63s2
	i8u75rBZdH6ZxWZx994JFovNH16yWTxf+IPZ4u/2TSwWP3fNY3Hg9Ghp7mHz2DnrLrvH/e7j
	TB79fw08Pm+SC2CN4rJJSc3JLEst0rdL4Mr49OEfe8GxgIpHR5eyNDD+cuxi5OSQEDCR2Prg
	FTOELSZx4d56ti5GLg4hgaWMEju6pjFCOJ8YJdrPfAer4hXQkmj5OAnMZhFQlfg9exULiM0m
	oCnxd/NNoG4ODlGBCInHF4QgygUlfky+xwIyR0TgKpPEsrUfmEASwgKOEocn32MHsYUEvjFK
	nPgnD2JzAs3Z3TQBbD6zgI7E/tZpbBC2vMTmNW+ZJzDyz0IydxaSsllIyhYwMq9iFE0tTS4o
	TkrPNdQrTswtLs1L10vOz93ECAnwLzsYFx+zOsQowMGoxMPrYFsVLMSaWFZcmXuIUYKDWUmE
	94d0dbAQb0piZVVqUX58UWlOavEhRiYOTqkGxnCeyPTO0H4F+71Tz8QvnPojwEHBRjp48yu2
	+E2vHnmVWAVtjOpjve86MUlmMmfMbK+y/8fn1p27L3F+lXJRjUUK69onggsvL+tPZTX7snpZ
	y9Jz112EW+pOB/VY/d7W/OV95jMGrbOzmuqmup6P/rVerMtkpjy/dlygeYvHrOp0h/r13m1+
	SizFGYmGWsxFxYkAHB9v7k4CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thierry, Greg,


On 05/15/2014 10:53 AM, Thierry Reding wrote:
> On Tue, May 13, 2014 at 05:32:15PM -0700, Greg Kroah-Hartman wrote:
>> On Tue, May 13, 2014 at 07:57:13PM +0200, Daniel Vetter wrote:
>>> On Tue, May 13, 2014 at 05:30:47PM +0200, Thierry Reding wrote:
>>>> From: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>>>>
>>>> Some drivers, such as graphics drivers in the DRM subsystem, do not have
>>>> a real device that they can bind to. They are often composed of several
>>>> devices, each having their own driver. The master/component framework
>>>> can be used in these situations to collect the devices pertaining to one
>>>> logical device, wait until all of them have registered and then bind
>>>> them all at once.
>>>>
>>>> For some situations this is only a partial solution. An implementation
>>>> of a master still needs to be registered with the system somehow. Many
>>>> drivers currently resort to creating a dummy device that a driver can
>>>> bind to and register the master against. This is problematic since it
>>>> requires (and presumes) knowledge about the system within drivers.
>>>>
>>>> Furthermore there are setups where a suitable device already exists, but
>>>> is already bound to a driver. For example, on Tegra the following device
>>>> tree extract (simplified) represents the host1x device along with child
>>>> devices:
>>>>
>>>> 	host1x {
>>>> 		display-controller {
>>>> 			...
>>>> 		};
>>>>
>>>> 		display-controller {
>>>> 			...
>>>> 		};
>>>>
>>>> 		hdmi {
>>>> 			...
>>>> 		};
>>>>
>>>> 		dsi {
>>>> 			...
>>>> 		};
>>>>
>>>> 		csi {
>>>> 			...
>>>> 		};
>>>>
>>>> 		video-input {
>>>> 			...
>>>> 		};
>>>> 	};
>>>>
>>>> Each of the child devices is in turn a client of host1x, in that it can
>>>> request resources (command stream DMA channels and syncpoints) from it.
>>>> To implement the DMA channel and syncpoint infrastructure, host1x comes
>>>> with its own driver. Children are implemented in separate drivers. In
>>>> Linux this set of devices would be exposed by DRM and V4L2 drivers.
>>>>
>>>> However, neither the DRM nor the V4L2 drivers have a single device that
>>>> they can bind to. The DRM device is composed of the display controllers
>>>> and the various output devices, whereas the V4L2 device is composed of
>>>> one or more video input devices.
>>>>
>>>> This patch introduces the concept of an interface and drivers that can
>>>> bind to a given interface. An interface can be exposed by any device,
>>>> and interface drivers can bind to these interfaces. Multiple drivers can
>>>> bind against a single interface. When a device is removed, interfaces
>>>> exposed by it will be removed as well, thereby removing the drivers that
>>>> were bound to those interfaces.
>>>>
>>>> In the example above, the host1x device would expose the "tegra-host1x"
>>>> interface. DRM and V4L2 drivers can then bind to that interface and
>>>> instantiate the respective subsystem objects from there.
>>>>
>>>> Signed-off-by: Thierry Reding <treding-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
>>>> ---
>>>> Note that I'd like to merge this through the Tegra DRM tree so that the
>>>> changes to the Tegra DRM driver later in this series can be merged at
>>>> the same time and are not delayed for another release cycle.
>>>>
>>>> In particular that means that I'm looking for an Acked-by from Greg.
>>>>
>>>>  drivers/base/Makefile     |   2 +-
>>>>  drivers/base/interface.c  | 186 ++++++++++++++++++++++++++++++++++++++++++++++
>>>>  include/linux/interface.h |  40 ++++++++++
>>>>  3 files changed, 227 insertions(+), 1 deletion(-)
>>>>  create mode 100644 drivers/base/interface.c
>>>>  create mode 100644 include/linux/interface.h
>>>
>>> Hm, this interface stuff smells like bus drivers light. Should we instead
>>> have a pile of helpers to make creating new buses with match methods more
>>> trivial? There's a fairly big pile of small use-cases where this might be
>>> useful. In your case here all the host1x children would sit on a host1x
>>> bus. Admittedly I didn't look into the details.
>>
>> I have no problem adding such "bus-light" functions, to make it easier
>> to create and implement a bus in the driver core, as I know it's really
>> heavy.  That's been on my "todo" list for over a decade now...

I have posted some times ago RFC for interface_tracker framework [1].
It seems with interface_tracker you can achieve similar functionality
and it seems to be more generic.

[1]: https://lkml.org/lkml/2014/4/30/345

Two small things should be added to interface_tracker framework:
- matching objects using string comparison,
- before notifier unregistration call notifier to inform that observed
  interface will disappear for him.

Greg, this is another use case for interface_tracker framework.

To show how it could be achieved I present pseudo patch which converts
tegra drivers to interface_tracker. Obviously I have not tested it.

diff --git a/drivers/gpu/drm/tegra/drm.c b/drivers/gpu/drm/tegra/drm.c
index 11d0deb..79fcb43 100644
--- a/drivers/gpu/drm/tegra/drm.c
+++ b/drivers/gpu/drm/tegra/drm.c
@@ -728,27 +728,27 @@ static const struct component_master_ops
tegra_drm_master_ops = {
 	.unbind = tegra_drm_unbind,
 };

-static int host1x_interface_bind(struct interface *intf)
-{
-	return component_master_add(intf->dev, &tegra_drm_master_ops);
-}
-
-static void host1x_interface_unbind(struct interface *intf)
-{
-	component_master_del(intf->dev, &tegra_drm_master_ops);
-}
-
-static struct interface_driver host1x_interface_driver = {
-	.name = "nvidia,tegra-host1x",
-	.bind = host1x_interface_bind,
-	.unbind = host1x_interface_unbind,
-};
+void itb_callback(struct interface_tracker_block *itb, const void *object,
+		  unsigned long type, bool on, void *data)
+{
+	struct device *dev = data;
+
+	if (on)
+		component_master_add(dev, &tegra_drm_master_ops);
+	else
+		component_master_del(dev, &tegra_drm_master_ops);
+}
+static struct interface_tracker_block itb = {
+	.callback = itb_callback
+};

 static int __init tegra_drm_init(void)
 {
 	int err;

-	err = interface_register_driver(&host1x_interface_driver);
+	err = interface_tracker_register("nvidia,tegra-host1x",
+		INTERFACE_TRACKER_TYPE_PARENT_DEV, &itb);
 	if (err < 0)
 		return err;

@@ -795,7 +795,8 @@ unregister_dsi:
 unregister_dc:
 	platform_driver_unregister(&tegra_dc_driver);
 unregister_host1x:
-	interface_unregister_driver(&host1x_interface_driver);
+	interface_tracker_unregister("nvidia,tegra-host1x",
+				     INTERFACE_TRACKER_TYPE_PARENT_DEV, &itb);
 	return err;
 }
 module_init(tegra_drm_init);
@@ -809,7 +810,8 @@ static void __exit tegra_drm_exit(void)
 	platform_driver_unregister(&tegra_sor_driver);
 	platform_driver_unregister(&tegra_dsi_driver);
 	platform_driver_unregister(&tegra_dc_driver);
-	interface_unregister_driver(&host1x_interface_driver);
+	interface_tracker_unregister("nvidia,tegra-host1x",
+		INTERFACE_TRACKER_TYPE_PARENT_DEV, &itb);
 }
 module_exit(tegra_drm_exit);

diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index b92812b..f4455c5 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -175,10 +175,9 @@ static int host1x_probe(struct platform_device *pdev)

 	host1x_debug_init(host);

-	host->interface.name = "nvidia,tegra-host1x";
-	host->interface.dev = &pdev->dev;
-
-	err = interface_add(&host->interface);
+	err = interface_tracker_ifup("nvidia,tegra-host1x",
+		INTERFACE_TRACKER_TYPE_PARENT_DEV, &pdev->dev);
 	if (err < 0)
 		goto fail_deinit_intr;

@@ -197,7 +196,9 @@ static int host1x_remove(struct platform_device *pdev)
 {
 	struct host1x *host = platform_get_drvdata(pdev);

-	interface_remove(&host->interface);
+	err = interface_tracker_ifdown("nvidia,tegra-host1x",
+		INTERFACE_TRACKER_TYPE_PARENT_DEV, &pdev->dev);
 	host1x_intr_deinit(host);
 	host1x_syncpt_deinit(host);
 	clk_disable_unprepare(host->clk);


Regards
Andrzej

> 
> Greg,
> 
> Do you think you could find the time to look at this patch in a little
> more detail? This isn't about creating a light alternative to busses at
> all. It is an attempt to solve a different problem.
> 
> Consider the following: you have a collection of hardware devices that
> together can implement functionality in a given subsystem such as DRM or
> V4L2. In many cases all these devices have their own driver and they are
> glued together using the component helpers. This results in a situation
> where people are instantiating dummy devices for the sole purpose of
> getting a driver probed, since all of the existing devices have already
> had a driver bind to them.
> 
> Another downside of using dummy devices is that they mess up the device
> hierarchy. All of a sudden you have a situation where the dummy device
> is the logical parent for its aunts and uncles (or siblings).
> 
> The solution proposed here is to allow any device to expose an interface
> that interface drivers can bind to. This removes the need for dummy
> devices. As opposed to device drivers, an interface can be bound to by
> multiple drivers. That's a feature that is needed specifically by host1x
> on Tegra since two drivers need to hang off of the host1x device (DRM
> and V4L2), but I can easily imagine this to be useful in other cases.
> Interfaces are exposed explicitly at probe time by the device drivers
> for the devices they drive.
> 
> Even though this was designed with the above use-case in mind I can
> imagine this to be useful for other things as well. For example a set of
> generic interfaces could be created and devices (or even whole classes
> of devices) could be made to expose these interfaces. This would cause
> interfaces to be created for each of these devices. That's functionality
> similar to what can be done with notifiers, albeit somewhat more
> structured. That could for example be useful to apply policy to a class
> of devices or collect statistics, etc.
> 
> If you think that I'm on a wild-goose chase, please let me know so that
> I don't waste any more time on this.
> 
> Thierry
> 

