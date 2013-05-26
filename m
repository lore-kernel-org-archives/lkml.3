Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab3EZVfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 17:35:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55253 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3EZVfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 17:35:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 26 May 2013 23:35:13 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: How to get driver_data of struct ieee1394_device_id in kernel
 driver module?
Message-ID: <20130526233513.1a95d0d5@stein>
In-Reply-To: <51A20AEE.7060201@sakamocchi.jp>
References: <51A20AEE.7060201@sakamocchi.jp>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding LKML and Greg KH, in case that there are general opinions about
how a bus_type should work.)

On May 26 Takashi Sakamoto wrote:
> Hi all,
> 
> I'm a newbile for Linux Firewire subsystem and not used to IEEE 1394 bus
> programing in Linux.
> So I happy to get your advices.
> 
> Currently I'm working for some drivers of ALSA in kernel land.
> Then some devices to which the same module applies need to handle its
> own operations.
> To implement these operations, I think it good to utilize driver_data of
> struct ieee1394_evice_id entry.
> 
> This is example.
> For entry:
> https://github.com/takaswie/snd-firewire-improve/blob/f509e4587c3f7b18eda70d07b616ef01be3546ef/bebob/bebob.c#L462
> For usage:
> https://github.com/takaswie/snd-firewire-improve/blob/f509e4587c3f7b18eda70d07b616ef01be3546ef/bebob/bebob.c#L362
> 
> (In this case, I use the cast between (kernel_ulong_t) and (struct
> snd_bebob_ops *) but I have no confidence that this is better...)
> 
> Anyway, this module need to know the id for the current device in
> device_id table but I have no idea to get the id. Do you know good way
> to get it in module's probing process?
> 
> 
> Regards
> 
> Takashi Sakamoto

I think your approach is sensible.  There is of course just the little
problem that firewire-core keeps the matching device_id table entry as a
secret to itself.  Therefore, struct ieee1394_device_id.driver_data is
currently totally useless.

How about we make it available like in the following patch?

Besides being useful to your presently out-of-tree work, the in-tree
sound/firewire/speakers.c::fwspk_detect() could be rewritten to use this
approach.  Maybe I will post an expanded version of this patch which
incorporates such a first in-tree usage.

-------- 8< --------

From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: pass matching ieee1394_device_id to drivers via struct fw_unit

FireWire audio unit drivers will need to apply various model-specific
operations.  The struct ieee1394_device_id.driver_data member can be
used to store respective flags or function pointer tables.

But until now drivers had no way to know which driver->id_table index
was matched with an fw_unit instance.  Other bus subsystems like pci or
usb pass this information via an own driver probe method, whereas the
firewire subsystem uses the stock struct device_driver.probe().

We could introduce a struct fw_driver.probe() which works similarly to
struct pci_driver.probe() or struct usb_driver.probe().  But it seems
simpler to just add a new member to struct fw_unit which caches the
matching ieee1394_device_id, so this is what is done here.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c |    7 +++++--
 include/linux/firewire.h       |    5 +++--
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -169,6 +169,7 @@ static bool is_fw_unit(struct device *de
 
 static int fw_unit_match(struct device *dev, struct device_driver *drv)
 {
+	struct fw_unit *unit = fw_unit(dev);
 	const struct ieee1394_device_id *id_table =
 			container_of(drv, struct fw_driver, driver)->id_table;
 	int id[] = {0, 0, 0, 0};
@@ -177,11 +178,13 @@ static int fw_unit_match(struct device *
 	if (!is_fw_unit(dev))
 		return 0;
 
-	get_modalias_ids(fw_unit(dev), id);
+	get_modalias_ids(unit, id);
 
 	for (; id_table->match_flags != 0; id_table++)
-		if (match_ids(id_table, id))
+		if (match_ids(id_table, id)) {
+			unit->device_id = id_table;
 			return 1;
+		}
 
 	return 0;
 }
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -216,12 +216,15 @@ static inline int fw_device_is_shutdown(
 
 int fw_device_enable_phys_dma(struct fw_device *device);
 
+struct ieee1394_device_id;
+
 /*
  * fw_unit.directory must not be accessed after device_del(&fw_unit.device).
  */
 struct fw_unit {
 	struct device device;
 	const u32 *directory;
+	const struct ieee1394_device_id *device_id;
 	struct fw_attribute_group attribute_group;
 };
 
@@ -247,8 +250,6 @@ static inline struct fw_device *fw_paren
 	return fw_device(unit->device.parent);
 }
 
-struct ieee1394_device_id;
-
 struct fw_driver {
 	struct device_driver driver;
 	/* Called when the parent device sits through a bus reset. */


-- 
Stefan Richter
-=====-===-= -=-= ==-=-
http://arcgraph.de/sr/
