Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab3EZWQT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 18:16:19 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:55561 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab3EZWQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 18:16:18 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 27 May 2013 00:15:53 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: Re: How to get driver_data of struct ieee1394_device_id in kernel
 driver module?
Message-ID: <20130527001553.3460a151@stein>
In-Reply-To: <20130526233513.1a95d0d5@stein>
References: <51A20AEE.7060201@sakamocchi.jp>
	<20130526233513.1a95d0d5@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 26 Stefan Richter wrote:
> (Adding LKML and Greg KH, in case that there are general opinions about
> how a bus_type should work.)
> 
> On May 26 Takashi Sakamoto wrote:
> > Hi all,
> > 
> > I'm a newbile for Linux Firewire subsystem and not used to IEEE 1394 bus
> > programing in Linux.
> > So I happy to get your advices.
> > 
> > Currently I'm working for some drivers of ALSA in kernel land.
> > Then some devices to which the same module applies need to handle its
> > own operations.
> > To implement these operations, I think it good to utilize driver_data of
> > struct ieee1394_evice_id entry.
> > 
> > This is example.
> > For entry:
> > https://github.com/takaswie/snd-firewire-improve/blob/f509e4587c3f7b18eda70d07b616ef01be3546ef/bebob/bebob.c#L462
> > For usage:
> > https://github.com/takaswie/snd-firewire-improve/blob/f509e4587c3f7b18eda70d07b616ef01be3546ef/bebob/bebob.c#L362
> > 
> > (In this case, I use the cast between (kernel_ulong_t) and (struct
> > snd_bebob_ops *) but I have no confidence that this is better...)
> > 
> > Anyway, this module need to know the id for the current device in
> > device_id table but I have no idea to get the id. Do you know good way
> > to get it in module's probing process?
> > 
> > 
> > Regards
> > 
> > Takashi Sakamoto
> 
> I think your approach is sensible.  There is of course just the little
> problem that firewire-core keeps the matching device_id table entry as a
> secret to itself.  Therefore, struct ieee1394_device_id.driver_data is
> currently totally useless.
> 
> How about we make it available like in the following patch?


From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: pass matching ieee1394_device_id to drivers via struct fw_unit

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
matching ieee1394_device_id, so this is what is done here, and used in
the snd-firewire-speakers driver.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/core-device.c |    7 +++-
 include/linux/firewire.h       |    5 ++-
 sound/firewire/speakers.c      |   65 ++++++++++++---------------------
 3 files changed, 32 insertions(+), 45 deletions(-)

--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -168,21 +168,24 @@ static bool match_ids(const struct ieee1
 static bool is_fw_unit(struct device *dev);
 
 static int fw_unit_match(struct device *dev, struct device_driver *drv)
 {
+	struct fw_unit *unit = fw_unit(dev);
 	const struct ieee1394_device_id *id_table =
 			container_of(drv, struct fw_driver, driver)->id_table;
 	int id[] = {0, 0, 0, 0};
 
 	/* We only allow binding to fw_units. */
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
@@ -215,14 +215,17 @@ static inline int fw_device_is_shutdown(
 }
 
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
 
 static inline struct fw_unit *fw_unit(struct device *dev)
@@ -246,10 +249,8 @@ static inline struct fw_device *fw_paren
 {
 	return fw_device(unit->device.parent);
 }
 
-struct ieee1394_device_id;
-
 struct fw_driver {
 	struct device_driver driver;
 	/* Called when the parent device sits through a bus reset. */
 	void (*update)(struct fw_unit *unit);
--- a/sound/firewire/speakers.c
+++ b/sound/firewire/speakers.c
@@ -657,44 +657,8 @@ static void fwspk_card_free(struct snd_c
 	fw_unit_put(fwspk->unit);
 	mutex_destroy(&fwspk->mutex);
 }
 
-static const struct device_info *fwspk_detect(struct fw_device *dev)
-{
-	static const struct device_info griffin_firewave = {
-		.driver_name = "FireWave",
-		.short_name  = "FireWave",
-		.long_name   = "Griffin FireWave Surround",
-		.pcm_constraints = firewave_constraints,
-		.mixer_channels = 6,
-		.mute_fb_id   = 0x01,
-		.volume_fb_id = 0x02,
-	};
-	static const struct device_info lacie_speakers = {
-		.driver_name = "FWSpeakers",
-		.short_name  = "FireWire Speakers",
-		.long_name   = "LaCie FireWire Speakers",
-		.pcm_constraints = lacie_speakers_constraints,
-		.mixer_channels = 1,
-		.mute_fb_id   = 0x01,
-		.volume_fb_id = 0x01,
-	};
-	struct fw_csr_iterator i;
-	int key, value;
-
-	fw_csr_iterator_init(&i, dev->config_rom);
-	while (fw_csr_iterator_next(&i, &key, &value))
-		if (key == CSR_VENDOR)
-			switch (value) {
-			case VENDOR_GRIFFIN:
-				return &griffin_firewave;
-			case VENDOR_LACIE:
-				return &lacie_speakers;
-			}
-
-	return NULL;
-}
-
 static int fwspk_probe(struct device *unit_dev)
 {
 	struct fw_unit *unit = fw_unit(unit_dev);
 	struct fw_device *fw_dev = fw_parent_device(unit);
@@ -711,13 +675,10 @@ static int fwspk_probe(struct device *un
 	fwspk = card->private_data;
 	fwspk->card = card;
 	mutex_init(&fwspk->mutex);
 	fwspk->unit = fw_unit_get(unit);
-	fwspk->device_info = fwspk_detect(fw_dev);
-	if (!fwspk->device_info) {
-		err = -ENODEV;
-		goto err_unit;
-	}
+	fwspk->device_info =
+		(const struct device_info *)unit->device_id->driver_data;
 
 	err = cmp_connection_init(&fwspk->connection, unit, 0);
 	if (err < 0)
 		goto err_unit;
@@ -797,8 +758,28 @@ static void fwspk_bus_reset(struct fw_un
 
 	amdtp_stream_update(&fwspk->stream);
 }
 
+static const struct device_info griffin_firewave = {
+	.driver_name = "FireWave",
+	.short_name  = "FireWave",
+	.long_name   = "Griffin FireWave Surround",
+	.pcm_constraints = firewave_constraints,
+	.mixer_channels = 6,
+	.mute_fb_id   = 0x01,
+	.volume_fb_id = 0x02,
+};
+
+static const struct device_info lacie_speakers = {
+	.driver_name = "FWSpeakers",
+	.short_name  = "FireWire Speakers",
+	.long_name   = "LaCie FireWire Speakers",
+	.pcm_constraints = lacie_speakers_constraints,
+	.mixer_channels = 1,
+	.mute_fb_id   = 0x01,
+	.volume_fb_id = 0x01,
+};
+
 static const struct ieee1394_device_id fwspk_id_table[] = {
 	{
 		.match_flags  = IEEE1394_MATCH_VENDOR_ID |
 				IEEE1394_MATCH_MODEL_ID |
@@ -807,8 +788,9 @@ static const struct ieee1394_device_id f
 		.vendor_id    = VENDOR_GRIFFIN,
 		.model_id     = 0x00f970,
 		.specifier_id = SPECIFIER_1394TA,
 		.version      = VERSION_AVC,
+		.driver_data  = (kernel_ulong_t)&griffin_firewave,
 	},
 	{
 		.match_flags  = IEEE1394_MATCH_VENDOR_ID |
 				IEEE1394_MATCH_MODEL_ID |
@@ -817,8 +799,9 @@ static const struct ieee1394_device_id f
 		.vendor_id    = VENDOR_LACIE,
 		.model_id     = 0x00f970,
 		.specifier_id = SPECIFIER_1394TA,
 		.version      = VERSION_AVC,
+		.driver_data  = (kernel_ulong_t)&lacie_speakers,
 	},
 	{ }
 };
 MODULE_DEVICE_TABLE(ieee1394, fwspk_id_table);


-- 
Stefan Richter
-=====-===-= -=-= ==-==
http://arcgraph.de/sr/
