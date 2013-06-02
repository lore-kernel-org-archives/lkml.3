Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab3FBW2X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 18:28:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40373 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab3FBW2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 18:28:17 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 3 Jun 2013 00:27:49 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        linux1394-devel@lists.sourceforge.net
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] firewire: introduce fw_driver.probe and .remove methods
Message-ID: <20130603002749.4fdc36a5@stein>
In-Reply-To: <51A742A1.8010108@sakamocchi.jp>
References: <51A20AEE.7060201@sakamocchi.jp>
	<20130526233513.1a95d0d5@stein>
	<20130526225757.GA32606@kroah.com>
	<51A742A1.8010108@sakamocchi.jp>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FireWire upper layer drivers are converted from generic
    struct driver.probe() and .remove()
to bus-specific
    struct fw_driver.probe() and .remove().

The new .probe() adds a const struct ieee1394_device_id *id argument,
indicating the entry in the driver's device identifiers table which
matched the fw_unit to be probed.  This new argument is used by the
snd-firewire-speakers driver to look up device-specific parameters and
methods.  There is at least one other FireWire audio driver currently in
development in which this will be useful too.

The new .remove() drops the unused error return code.

Although all in-tree drivers are being converted to the new methods,
support for the old methods is left in place for the time being, aiming
to avoid conflicts if/when new drivers are being merged into the
mainline via other trees.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/firewire/core-device.c      |   42 +++++++++--
 drivers/firewire/net.c              |   50 ++++++-------
 drivers/firewire/sbp2.c             |   17 ++--
 drivers/media/firewire/firedtv-fw.c |   19 ++---
 drivers/staging/fwserial/fwserial.c |   14 ++--
 include/linux/firewire.h            |    2 +
 sound/firewire/isight.c             |   44 ++++++------
 sound/firewire/scs1x.c              |   39 +++++-----
 sound/firewire/speakers.c           |  106 +++++++++++-----------------
 9 files changed, 166 insertions(+), 167 deletions(-)

--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -167,23 +167,51 @@ static bool match_ids(const struct ieee1
 
 static bool is_fw_unit(struct device *dev);
 
-static int fw_unit_match(struct device *dev, struct device_driver *drv)
+static const struct ieee1394_device_id *unit_match(struct device *dev,
+						   struct device_driver *drv)
 {
 	const struct ieee1394_device_id *id_table =
 			container_of(drv, struct fw_driver, driver)->id_table;
 	int id[] = {0, 0, 0, 0};
 
+	get_modalias_ids(fw_unit(dev), id);
+
+	for (; id_table->match_flags != 0; id_table++)
+		if (match_ids(id_table, id))
+			return id_table;
+
+	return NULL;
+}
+
+static int fw_unit_match(struct device *dev, struct device_driver *drv)
+{
 	/* We only allow binding to fw_units. */
 	if (!is_fw_unit(dev))
 		return 0;
 
-	get_modalias_ids(fw_unit(dev), id);
+	return !!unit_match(dev, drv);
+}
 
-	for (; id_table->match_flags != 0; id_table++)
-		if (match_ids(id_table, id))
-			return 1;
+static int fw_unit_probe(struct device *dev)
+{
+	struct fw_driver *driver =
+			container_of(dev->driver, struct fw_driver, driver);
 
-	return 0;
+	if (driver->probe)
+		return driver->probe(fw_unit(dev), unit_match(dev, dev->driver));
+	else
+		return driver->driver.probe(dev);
+}
+
+static int fw_unit_remove(struct device *dev)
+{
+	struct fw_driver *driver =
+			container_of(dev->driver, struct fw_driver, driver);
+
+	if (driver->remove)
+		return driver->remove(fw_unit(dev)), 0;
+	else
+		return driver->driver.remove(dev);
 }
 
 static int get_modalias(struct fw_unit *unit, char *buffer, size_t buffer_size)
@@ -213,6 +241,8 @@ static int fw_unit_uevent(struct device
 struct bus_type fw_bus_type = {
 	.name = "firewire",
 	.match = fw_unit_match,
+	.probe = fw_unit_probe,
+	.remove = fw_unit_remove,
 };
 EXPORT_SYMBOL(fw_bus_type);
 
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -1440,9 +1440,9 @@ static int fwnet_add_peer(struct fwnet_d
 	return 0;
 }
 
-static int fwnet_probe(struct device *_dev)
+static int fwnet_probe(struct fw_unit *unit,
+		       const struct ieee1394_device_id *id)
 {
-	struct fw_unit *unit = fw_unit(_dev);
 	struct fw_device *device = fw_parent_device(unit);
 	struct fw_card *card = device->card;
 	struct net_device *net;
@@ -1526,6 +1526,24 @@ static int fwnet_probe(struct device *_d
 	return ret;
 }
 
+/*
+ * FIXME abort partially sent fragmented datagrams,
+ * discard partially received fragmented datagrams
+ */
+static void fwnet_update(struct fw_unit *unit)
+{
+	struct fw_device *device = fw_parent_device(unit);
+	struct fwnet_peer *peer = dev_get_drvdata(&unit->device);
+	int generation;
+
+	generation = device->generation;
+
+	spin_lock_irq(&peer->dev->lock);
+	peer->node_id    = device->node_id;
+	peer->generation = generation;
+	spin_unlock_irq(&peer->dev->lock);
+}
+
 static void fwnet_remove_peer(struct fwnet_peer *peer, struct fwnet_device *dev)
 {
 	struct fwnet_partial_datagram *pd, *pd_next;
@@ -1542,9 +1560,9 @@ static void fwnet_remove_peer(struct fwn
 	kfree(peer);
 }
 
-static int fwnet_remove(struct device *_dev)
+static void fwnet_remove(struct fw_unit *unit)
 {
-	struct fwnet_peer *peer = dev_get_drvdata(_dev);
+	struct fwnet_peer *peer = dev_get_drvdata(&unit->device);
 	struct fwnet_device *dev = peer->dev;
 	struct net_device *net;
 	int i;
@@ -1569,26 +1587,6 @@ static int fwnet_remove(struct device *_
 	}
 
 	mutex_unlock(&fwnet_device_mutex);
-
-	return 0;
-}
-
-/*
- * FIXME abort partially sent fragmented datagrams,
- * discard partially received fragmented datagrams
- */
-static void fwnet_update(struct fw_unit *unit)
-{
-	struct fw_device *device = fw_parent_device(unit);
-	struct fwnet_peer *peer = dev_get_drvdata(&unit->device);
-	int generation;
-
-	generation = device->generation;
-
-	spin_lock_irq(&peer->dev->lock);
-	peer->node_id    = device->node_id;
-	peer->generation = generation;
-	spin_unlock_irq(&peer->dev->lock);
 }
 
 static const struct ieee1394_device_id fwnet_id_table[] = {
@@ -1614,10 +1612,10 @@ static struct fw_driver fwnet_driver = {
 		.owner  = THIS_MODULE,
 		.name   = KBUILD_MODNAME,
 		.bus    = &fw_bus_type,
-		.probe  = fwnet_probe,
-		.remove = fwnet_remove,
 	},
+	.probe    = fwnet_probe,
 	.update   = fwnet_update,
+	.remove   = fwnet_remove,
 	.id_table = fwnet_id_table,
 };
 
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1128,11 +1128,10 @@ static void sbp2_init_workarounds(struct
 }
 
 static struct scsi_host_template scsi_driver_template;
-static int sbp2_remove(struct device *dev);
+static void sbp2_remove(struct fw_unit *unit);
 
-static int sbp2_probe(struct device *dev)
+static int sbp2_probe(struct fw_unit *unit, const struct ieee1394_device_id *id)
 {
-	struct fw_unit *unit = fw_unit(dev);
 	struct fw_device *device = fw_parent_device(unit);
 	struct sbp2_target *tgt;
 	struct sbp2_logical_unit *lu;
@@ -1196,7 +1195,7 @@ static int sbp2_probe(struct device *dev
 	return 0;
 
  fail_remove:
-	sbp2_remove(dev);
+	sbp2_remove(unit);
 	return -ENOMEM;
 
  fail_shost_put:
@@ -1222,9 +1221,8 @@ static void sbp2_update(struct fw_unit *
 	}
 }
 
-static int sbp2_remove(struct device *dev)
+static void sbp2_remove(struct fw_unit *unit)
 {
-	struct fw_unit *unit = fw_unit(dev);
 	struct fw_device *device = fw_parent_device(unit);
 	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
 	struct sbp2_logical_unit *lu, *next;
@@ -1261,10 +1259,9 @@ static int sbp2_remove(struct device *de
 		kfree(lu);
 	}
 	scsi_remove_host(shost);
-	dev_notice(dev, "released target %d:0:0\n", shost->host_no);
+	dev_notice(&unit->device, "released target %d:0:0\n", shost->host_no);
 
 	scsi_host_put(shost);
-	return 0;
 }
 
 #define SBP2_UNIT_SPEC_ID_ENTRY	0x0000609e
@@ -1285,10 +1282,10 @@ static struct fw_driver sbp2_driver = {
 		.owner  = THIS_MODULE,
 		.name   = KBUILD_MODNAME,
 		.bus    = &fw_bus_type,
-		.probe  = sbp2_probe,
-		.remove = sbp2_remove,
 	},
+	.probe    = sbp2_probe,
 	.update   = sbp2_update,
+	.remove   = sbp2_remove,
 	.id_table = sbp2_id_table,
 };
 
--- a/drivers/media/firewire/firedtv-fw.c
+++ b/drivers/media/firewire/firedtv-fw.c
@@ -248,7 +248,7 @@ static const char * const model_names[]
 /* Adjust the template string if models with longer names appear. */
 #define MAX_MODEL_NAME_LEN sizeof("FireDTV ????")
 
-static int node_probe(struct device *dev)
+static int node_probe(struct fw_unit *unit, const struct ieee1394_device_id *id)
 {
 	struct firedtv *fdtv;
 	char name[MAX_MODEL_NAME_LEN];
@@ -258,8 +258,8 @@ static int node_probe(struct device *dev
 	if (!fdtv)
 		return -ENOMEM;
 
-	dev_set_drvdata(dev, fdtv);
-	fdtv->device		= dev;
+	dev_set_drvdata(&unit->device, fdtv);
+	fdtv->device		= &unit->device;
 	fdtv->isochannel	= -1;
 	fdtv->voltage		= 0xff;
 	fdtv->tone		= 0xff;
@@ -269,7 +269,7 @@ static int node_probe(struct device *dev
 	mutex_init(&fdtv->demux_mutex);
 	INIT_WORK(&fdtv->remote_ctrl_work, avc_remote_ctrl_work);
 
-	name_len = fw_csr_string(fw_unit(dev)->directory, CSR_MODEL,
+	name_len = fw_csr_string(unit->directory, CSR_MODEL,
 				 name, sizeof(name));
 	for (i = ARRAY_SIZE(model_names); --i; )
 		if (strlen(model_names[i]) <= name_len &&
@@ -277,7 +277,7 @@ static int node_probe(struct device *dev
 			break;
 	fdtv->type = i;
 
-	err = fdtv_register_rc(fdtv, dev);
+	err = fdtv_register_rc(fdtv, &unit->device);
 	if (err)
 		goto fail_free;
 
@@ -307,9 +307,9 @@ fail_free:
 	return err;
 }
 
-static int node_remove(struct device *dev)
+static void node_remove(struct fw_unit *unit)
 {
-	struct firedtv *fdtv = dev_get_drvdata(dev);
+	struct firedtv *fdtv = dev_get_drvdata(&unit->device);
 
 	fdtv_dvb_unregister(fdtv);
 
@@ -320,7 +320,6 @@ static int node_remove(struct device *de
 	fdtv_unregister_rc(fdtv);
 
 	kfree(fdtv);
-	return 0;
 }
 
 static void node_update(struct fw_unit *unit)
@@ -391,10 +390,10 @@ static struct fw_driver fdtv_driver = {
 		.owner  = THIS_MODULE,
 		.name   = "firedtv",
 		.bus    = &fw_bus_type,
-		.probe  = node_probe,
-		.remove = node_remove,
 	},
+	.probe    = node_probe,
 	.update   = node_update,
+	.remove   = node_remove,
 	.id_table = fdtv_id_table,
 };
 
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -2438,9 +2438,9 @@ free_ports:
  * last peer for a given fw_card triggering the destruction of the same
  * fw_serial for the same fw_card.
  */
-static int fwserial_probe(struct device *dev)
+static int fwserial_probe(struct fw_unit *unit,
+			  const struct ieee1394_device_id *id)
 {
-	struct fw_unit *unit = fw_unit(dev);
 	struct fw_serial *serial;
 	int err;
 
@@ -2462,9 +2462,9 @@ static int fwserial_probe(struct device
  * specific fw_card). If this is the last peer being removed, then trigger
  * the destruction of the underlying TTYs.
  */
-static int fwserial_remove(struct device *dev)
+static void fwserial_remove(struct fw_unit *unit)
 {
-	struct fwtty_peer *peer = dev_get_drvdata(dev);
+	struct fwtty_peer *peer = dev_get_drvdata(&unit->device);
 	struct fw_serial *serial = peer->serial;
 	int i;
 
@@ -2484,8 +2484,6 @@ static int fwserial_remove(struct device
 		kref_put(&serial->kref, fwserial_destroy);
 	}
 	mutex_unlock(&fwserial_list_mutex);
-
-	return 0;
 }
 
 /**
@@ -2530,10 +2528,10 @@ static struct fw_driver fwserial_driver
 		.owner  = THIS_MODULE,
 		.name   = KBUILD_MODNAME,
 		.bus    = &fw_bus_type,
-		.probe  = fwserial_probe,
-		.remove = fwserial_remove,
 	},
+	.probe    = fwserial_probe,
 	.update   = fwserial_update,
+	.remove   = fwserial_remove,
 	.id_table = fwserial_id_table,
 };
 
--- a/include/linux/firewire.h
+++ b/include/linux/firewire.h
@@ -251,8 +251,10 @@ struct ieee1394_device_id;
 
 struct fw_driver {
 	struct device_driver driver;
+	int (*probe)(struct fw_unit *unit, const struct ieee1394_device_id *id);
 	/* Called when the parent device sits through a bus reset. */
 	void (*update)(struct fw_unit *unit);
+	void (*remove)(struct fw_unit *unit);
 	const struct ieee1394_device_id *id_table;
 };
 
--- a/sound/firewire/isight.c
+++ b/sound/firewire/isight.c
@@ -626,9 +626,9 @@ static u64 get_unit_base(struct fw_unit
 	return 0;
 }
 
-static int isight_probe(struct device *unit_dev)
+static int isight_probe(struct fw_unit *unit,
+			const struct ieee1394_device_id *id)
 {
-	struct fw_unit *unit = fw_unit(unit_dev);
 	struct fw_device *fw_dev = fw_parent_device(unit);
 	struct snd_card *card;
 	struct isight *isight;
@@ -637,7 +637,7 @@ static int isight_probe(struct device *u
 	err = snd_card_create(-1, NULL, THIS_MODULE, sizeof(*isight), &card);
 	if (err < 0)
 		return err;
-	snd_card_set_dev(card, unit_dev);
+	snd_card_set_dev(card, &unit->device);
 
 	isight = card->private_data;
 	isight->card = card;
@@ -674,7 +674,7 @@ static int isight_probe(struct device *u
 	if (err < 0)
 		goto error;
 
-	dev_set_drvdata(unit_dev, isight);
+	dev_set_drvdata(&unit->device, isight);
 
 	return 0;
 
@@ -686,23 +686,6 @@ error:
 	return err;
 }
 
-static int isight_remove(struct device *dev)
-{
-	struct isight *isight = dev_get_drvdata(dev);
-
-	isight_pcm_abort(isight);
-
-	snd_card_disconnect(isight->card);
-
-	mutex_lock(&isight->mutex);
-	isight_stop_streaming(isight);
-	mutex_unlock(&isight->mutex);
-
-	snd_card_free_when_closed(isight->card);
-
-	return 0;
-}
-
 static void isight_bus_reset(struct fw_unit *unit)
 {
 	struct isight *isight = dev_get_drvdata(&unit->device);
@@ -716,6 +699,21 @@ static void isight_bus_reset(struct fw_u
 	}
 }
 
+static void isight_remove(struct fw_unit *unit)
+{
+	struct isight *isight = dev_get_drvdata(&unit->device);
+
+	isight_pcm_abort(isight);
+
+	snd_card_disconnect(isight->card);
+
+	mutex_lock(&isight->mutex);
+	isight_stop_streaming(isight);
+	mutex_unlock(&isight->mutex);
+
+	snd_card_free_when_closed(isight->card);
+}
+
 static const struct ieee1394_device_id isight_id_table[] = {
 	{
 		.match_flags  = IEEE1394_MATCH_SPECIFIER_ID |
@@ -732,10 +730,10 @@ static struct fw_driver isight_driver =
 		.owner	= THIS_MODULE,
 		.name	= KBUILD_MODNAME,
 		.bus	= &fw_bus_type,
-		.probe	= isight_probe,
-		.remove	= isight_remove,
 	},
+	.probe    = isight_probe,
 	.update   = isight_bus_reset,
+	.remove   = isight_remove,
 	.id_table = isight_id_table,
 };
 
--- a/sound/firewire/scs1x.c
+++ b/sound/firewire/scs1x.c
@@ -384,9 +384,8 @@ static void scs_card_free(struct snd_car
 	kfree(scs->buffer);
 }
 
-static int scs_probe(struct device *unit_dev)
+static int scs_probe(struct fw_unit *unit, const struct ieee1394_device_id *id)
 {
-	struct fw_unit *unit = fw_unit(unit_dev);
 	struct fw_device *fw_dev = fw_parent_device(unit);
 	struct snd_card *card;
 	struct scs *scs;
@@ -395,7 +394,7 @@ static int scs_probe(struct device *unit
 	err = snd_card_create(-16, NULL, THIS_MODULE, sizeof(*scs), &card);
 	if (err < 0)
 		return err;
-	snd_card_set_dev(card, unit_dev);
+	snd_card_set_dev(card, &unit->device);
 
 	scs = card->private_data;
 	scs->card = card;
@@ -440,7 +439,7 @@ static int scs_probe(struct device *unit
 	if (err < 0)
 		goto err_card;
 
-	dev_set_drvdata(unit_dev, scs);
+	dev_set_drvdata(&unit->device, scs);
 
 	return 0;
 
@@ -451,9 +450,20 @@ err_card:
 	return err;
 }
 
-static int scs_remove(struct device *dev)
+static void scs_update(struct fw_unit *unit)
 {
-	struct scs *scs = dev_get_drvdata(dev);
+	struct scs *scs = dev_get_drvdata(&unit->device);
+	__be64 data;
+
+	data = cpu_to_be64(((u64)HSS1394_TAG_CHANGE_ADDRESS << 56) |
+			   scs->hss_handler.offset);
+	snd_fw_transaction(scs->unit, TCODE_WRITE_BLOCK_REQUEST,
+			   HSS1394_ADDRESS, &data, 8);
+}
+
+static void scs_remove(struct fw_unit *unit)
+{
+	struct scs *scs = dev_get_drvdata(&unit->device);
 
 	snd_card_disconnect(scs->card);
 
@@ -465,19 +475,6 @@ static int scs_remove(struct device *dev
 	tasklet_kill(&scs->tasklet);
 
 	snd_card_free_when_closed(scs->card);
-
-	return 0;
-}
-
-static void scs_update(struct fw_unit *unit)
-{
-	struct scs *scs = dev_get_drvdata(&unit->device);
-	__be64 data;
-
-	data = cpu_to_be64(((u64)HSS1394_TAG_CHANGE_ADDRESS << 56) |
-			   scs->hss_handler.offset);
-	snd_fw_transaction(scs->unit, TCODE_WRITE_BLOCK_REQUEST,
-			   HSS1394_ADDRESS, &data, 8);
 }
 
 static const struct ieee1394_device_id scs_id_table[] = {
@@ -506,10 +503,10 @@ static struct fw_driver scs_driver = {
 		.owner  = THIS_MODULE,
 		.name   = KBUILD_MODNAME,
 		.bus    = &fw_bus_type,
-		.probe  = scs_probe,
-		.remove = scs_remove,
 	},
+	.probe    = scs_probe,
 	.update   = scs_update,
+	.remove   = scs_remove,
 	.id_table = scs_id_table,
 };
 
--- a/sound/firewire/speakers.c
+++ b/sound/firewire/speakers.c
@@ -663,45 +663,9 @@ static void fwspk_card_free(struct snd_c
 	mutex_destroy(&fwspk->mutex);
 }
 
-static const struct device_info *fwspk_detect(struct fw_device *dev)
+static int fwspk_probe(struct fw_unit *unit,
+		       const struct ieee1394_device_id *id)
 {
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
-static int fwspk_probe(struct device *unit_dev)
-{
-	struct fw_unit *unit = fw_unit(unit_dev);
 	struct fw_device *fw_dev = fw_parent_device(unit);
 	struct snd_card *card;
 	struct fwspk *fwspk;
@@ -711,17 +675,13 @@ static int fwspk_probe(struct device *un
 	err = snd_card_create(-1, NULL, THIS_MODULE, sizeof(*fwspk), &card);
 	if (err < 0)
 		return err;
-	snd_card_set_dev(card, unit_dev);
+	snd_card_set_dev(card, &unit->device);
 
 	fwspk = card->private_data;
 	fwspk->card = card;
 	mutex_init(&fwspk->mutex);
 	fwspk->unit = fw_unit_get(unit);
-	fwspk->device_info = fwspk_detect(fw_dev);
-	if (!fwspk->device_info) {
-		err = -ENODEV;
-		goto err_unit;
-	}
+	fwspk->device_info = (const struct device_info *)id->driver_data;
 
 	err = cmp_connection_init(&fwspk->connection, unit, 0);
 	if (err < 0)
@@ -756,7 +716,7 @@ static int fwspk_probe(struct device *un
 	if (err < 0)
 		goto error;
 
-	dev_set_drvdata(unit_dev, fwspk);
+	dev_set_drvdata(&unit->device, fwspk);
 
 	return 0;
 
@@ -770,22 +730,6 @@ error:
 	return err;
 }
 
-static int fwspk_remove(struct device *dev)
-{
-	struct fwspk *fwspk = dev_get_drvdata(dev);
-
-	amdtp_out_stream_pcm_abort(&fwspk->stream);
-	snd_card_disconnect(fwspk->card);
-
-	mutex_lock(&fwspk->mutex);
-	fwspk_stop_stream(fwspk);
-	mutex_unlock(&fwspk->mutex);
-
-	snd_card_free_when_closed(fwspk->card);
-
-	return 0;
-}
-
 static void fwspk_bus_reset(struct fw_unit *unit)
 {
 	struct fwspk *fwspk = dev_get_drvdata(&unit->device);
@@ -803,6 +747,40 @@ static void fwspk_bus_reset(struct fw_un
 	amdtp_out_stream_update(&fwspk->stream);
 }
 
+static void fwspk_remove(struct fw_unit *unit)
+{
+	struct fwspk *fwspk = dev_get_drvdata(&unit->device);
+
+	amdtp_out_stream_pcm_abort(&fwspk->stream);
+	snd_card_disconnect(fwspk->card);
+
+	mutex_lock(&fwspk->mutex);
+	fwspk_stop_stream(fwspk);
+	mutex_unlock(&fwspk->mutex);
+
+	snd_card_free_when_closed(fwspk->card);
+}
+
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
@@ -813,6 +791,7 @@ static const struct ieee1394_device_id f
 		.model_id     = 0x00f970,
 		.specifier_id = SPECIFIER_1394TA,
 		.version      = VERSION_AVC,
+		.driver_data  = (kernel_ulong_t)&griffin_firewave,
 	},
 	{
 		.match_flags  = IEEE1394_MATCH_VENDOR_ID |
@@ -823,6 +802,7 @@ static const struct ieee1394_device_id f
 		.model_id     = 0x00f970,
 		.specifier_id = SPECIFIER_1394TA,
 		.version      = VERSION_AVC,
+		.driver_data  = (kernel_ulong_t)&lacie_speakers,
 	},
 	{ }
 };
@@ -833,10 +813,10 @@ static struct fw_driver fwspk_driver = {
 		.owner	= THIS_MODULE,
 		.name	= KBUILD_MODNAME,
 		.bus	= &fw_bus_type,
-		.probe	= fwspk_probe,
-		.remove	= fwspk_remove,
 	},
+	.probe    = fwspk_probe,
 	.update   = fwspk_bus_reset,
+	.remove   = fwspk_remove,
 	.id_table = fwspk_id_table,
 };
 


-- 
Stefan Richter
-=====-===-= -==- ---==
http://arcgraph.de/sr/
