Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978AbaHVIlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:41:55 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:64157 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaHVIlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:41:52 -0400
Message-ID: <53f7024e.4498420a.1bbf.79ce@mx.google.com>
X-Google-Original-Message-ID: <002801cfbde4$ea0edef0$be2c9cd0$@dulixin@gmail.com>
From: "Dudley Du" <dudley.dulixin@gmail.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>
Cc: "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
        "'Benson Leung'" <bleung@google.com>,
        "'Patrik Fimml'" <patrikf@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "Dudley Du" <dudl@cypress.com>
References: <53c77269.a7c8440a.7a5b.4c20@mx.google.com> <20140821182848.GD5854@core.coreip.homeip.net>
In-Reply-To: <20140821182848.GD5854@core.coreip.homeip.net>
Subject: RE: [PATCH v4 4/14] input: cyapa: add cyapa key function interfaces in sysfs system
Date: Fri, 22 Aug 2014 16:41:36 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac+9bcKKEJcVivHMRCGD7WxjPtVf/QAbepAA
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Friday, August 22, 2014 2:29 AM
> To: Dudley Du
> Cc: Rafael J. Wysocki; Benson Leung; Patrik Fimml; linux-input@vger.kernel.org;
> linux-kernel@vger.kernel.org; Dudley Du
> Subject: Re: [PATCH v4 4/14] input: cyapa: add cyapa key function interfaces
> in sysfs system
> 
> On Thu, Jul 17, 2014 at 02:51:04PM +0800, Dudley Du wrote:
> > Add key basic function interfaces in cyapa driver in sysfs system,
> > these interfaces are commonly used in pre- and after production, and
> > for trackpad device state checking, manage and firmware image updating.
> > These interfaces including firmware_version and product_id interfaces
> > for reading firmware version and trackpad device product id values,
> > and including update_fw interface to command firmware image update
> > process. Also including baseline and calibrate interfaces, so can
> > read and check the trackpad device states. If the baseline values are
> > invalid, then can use calibrate interface to recover it.
> > TEST=test on Chromebooks.
> >
> > Signed-off-by: Dudley Du <dudl@cypress.com>
> > ---
> >  drivers/input/mouse/cyapa.c |  190
> +++++++++++++++++++++++++++++++++++++++++++
> >  drivers/input/mouse/cyapa.h |   27 ++++++
> >  2 files changed, 217 insertions(+)
> >
> > diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> > index 6a2783b..53c9d59 100644
> > --- a/drivers/input/mouse/cyapa.c
> > +++ b/drivers/input/mouse/cyapa.c
> > @@ -388,6 +388,78 @@ static void cyapa_detect(struct cyapa *cyapa)
> >  	}
> >  }
> >
> > +static int cyapa_firmware(struct cyapa *cyapa, const char *fw_name)
> > +{
> > +	struct device *dev = &cyapa->client->dev;
> > +	int ret;
> > +	const struct firmware *fw;
> > +
> > +	ret = request_firmware(&fw, fw_name, dev);
> > +	if (ret) {
> > +		dev_err(dev, "Could not load firmware from %s, %d\n",
> > +			fw_name, ret);
> > +		return ret;
> > +	}
> > +
> > +	if (cyapa->ops->check_fw) {
> > +		ret = cyapa->ops->check_fw(cyapa, fw);
> > +		if (ret) {
> > +			dev_err(dev, "Invalid CYAPA firmware image: %s\n",
> > +					fw_name);
> > +			goto done;
> > +		}
> > +	} else {
> > +		dev_err(dev, "Unknown status, operation forbidden, gen=%d\n",
> > +			cyapa->gen);
> > +		ret = -ENOTSUPP;
> 
> I'd say EIO or EINVAL.

Thanks, I will set it to EINVAL in next release.


> 
> > +		goto done;
> > +	}
> > +
> > +	/*
> > +	 * Resume the potentially suspended device because doing FW
> > +	 * update on a device not in the FULL mode has a chance to
> > +	 * fail.
> > +	 */
> > +	pm_runtime_get_sync(dev);
> > +
> > +	if (cyapa->ops->bl_enter) {
> > +		ret = cyapa->ops->bl_enter(cyapa);
> > +		if (ret)
> > +			goto err_detect;
> > +	}
> > +
> > +	if (cyapa->ops->bl_activate) {
> > +		ret = cyapa->ops->bl_activate(cyapa);
> > +		if (ret)
> > +			goto err_detect;
> > +	}
> > +
> > +	if (cyapa->ops->bl_initiate) {
> > +		ret = cyapa->ops->bl_initiate(cyapa, fw);
> > +		if (ret)
> > +			goto err_detect;
> > +	}
> > +
> > +	if (cyapa->ops->update_fw) {
> > +		ret = cyapa->ops->update_fw(cyapa, fw);
> > +		if (ret)
> > +			goto err_detect;
> > +	}
> > +
> > +	if (cyapa->ops->bl_verify_app_integrity) {
> > +		ret = cyapa->ops->bl_verify_app_integrity(cyapa);
> > +		if (ret)
> > +			goto err_detect;
> > +	}
> > +
> > +err_detect:
> > +	pm_runtime_put_noidle(dev);
> > +
> > +done:
> > +	release_firmware(fw);
> > +	return ret;
> > +}
> > +
> >  /*
> >   * Sysfs Interface.
> >   */
> > @@ -584,6 +656,120 @@ static void cyapa_start_runtime(struct cyapa *cyapa)
> >  static void cyapa_start_runtime(struct cyapa *cyapa) {}
> >  #endif /* CONFIG_PM_RUNTIME */
> >
> > +static ssize_t cyapa_show_fm_ver(struct device *dev,
> > +				 struct device_attribute *attr, char *buf)
> > +{
> > +	int ret;
> > +	struct cyapa *cyapa = dev_get_drvdata(dev);
> > +
> > +	mutex_lock(&cyapa->state_sync_lock);
> > +	ret = scnprintf(buf, PAGE_SIZE, "%d.%d\n", cyapa->fw_maj_ver,
> > +			 cyapa->fw_min_ver);
> > +	mutex_unlock(&cyapa->state_sync_lock);
> > +	return ret;
> > +}
> > +
> > +static ssize_t cyapa_show_product_id(struct device *dev,
> > +				     struct device_attribute *attr, char *buf)
> > +{
> > +	int ret;
> > +	struct cyapa *cyapa = dev_get_drvdata(dev);
> > +
> > +	mutex_lock(&cyapa->state_sync_lock);
> > +	ret = scnprintf(buf, PAGE_SIZE, "%s\n", cyapa->product_id);
> > +	mutex_unlock(&cyapa->state_sync_lock);
> > +	return ret;
> > +}
> > +
> > +static ssize_t cyapa_update_fw_store(struct device *dev,
> > +				     struct device_attribute *attr,
> > +				     const char *buf, size_t count)
> > +{
> > +	struct cyapa *cyapa = dev_get_drvdata(dev);
> > +	const char *fw_name;
> > +	int ret;
> > +
> > +	/* Do not allow paths that step out of /lib/firmware  */
> > +	if (strstr(buf, "../") != NULL)
> > +		return -EINVAL;
> 
> This should go away, it does not help anything.

Thanks. It will be removed in next release.

> 
> > +
> > +	if (!strncmp(buf, "1", count) || !strncmp(buf, "1\n", count))
> > +		fw_name = CYAPA_FW_NAME;
> > +	else
> > +		fw_name = buf;
> 
> I'd rather you either required firmware name to be passed always or settle on
> given name. Otherwise why can't I call my firmware file '1'?
> 

Thanks. I will modify to require firmware name to be passed always.

> > +
> > +	mutex_lock(&cyapa->state_sync_lock);
> > +
> > +	ret = cyapa_firmware(cyapa, fw_name);
> > +	if (ret)
> > +		dev_err(dev, "firmware update failed, %d\n", ret);
> > +	else
> > +		dev_dbg(dev, "firmware update succeeded\n");
> > +
> > +	mutex_unlock(&cyapa->state_sync_lock);
> > +
> > +	/* Redetect trackpad device states. */
> > +	cyapa_detect_async(cyapa, 0);
> > +
> > +	return ret ? ret : count;
> > +}
> > +
> > +static ssize_t cyapa_calibrate_store(struct device *dev,
> > +				     struct device_attribute *attr,
> > +				     const char *buf, size_t count)
> > +{
> > +	struct cyapa *cyapa = dev_get_drvdata(dev);
> > +	int ret;
> > +
> > +	mutex_lock(&cyapa->state_sync_lock);
> > +
> > +	if (!cyapa->ops->calibrate_store) {
> > +		dev_err(dev, "Calibrate operation not permitted.\n");
> > +		ret = -ENOTSUPP;
> 
> Permitted as in supported or forbidden?

The "permitted" means not supported, because device state is unknown.
I will modify the word "permitted" to "supported".
Thanks.

> 
> > +	} else
> > +		ret = cyapa->ops->calibrate_store(dev, attr, buf, count);
> > +
> > +	mutex_unlock(&cyapa->state_sync_lock);
> > +	return ret < 0 ? ret : count;
> > +}
> > +
> > +static ssize_t cyapa_show_baseline(struct device *dev,
> > +				   struct device_attribute *attr, char *buf)
> > +{
> > +	struct cyapa *cyapa = dev_get_drvdata(dev);
> > +	ssize_t ret;
> > +
> > +	mutex_lock(&cyapa->state_sync_lock);
> > +
> > +	if (!cyapa->ops->show_baseline) {
> > +		dev_err(dev, "Calibrate operation not permitted.\n");
> > +		ret = -ENOTSUPP;
> > +	} else
> > +		ret = cyapa->ops->show_baseline(dev, attr, buf);
> > +
> > +	mutex_unlock(&cyapa->state_sync_lock);
> > +	return ret;
> > +}
> > +
> > +static DEVICE_ATTR(firmware_version, S_IRUGO, cyapa_show_fm_ver, NULL);
> > +static DEVICE_ATTR(product_id, S_IRUGO, cyapa_show_product_id, NULL);
> > +static DEVICE_ATTR(update_fw, S_IWUSR, NULL, cyapa_update_fw_store);
> > +static DEVICE_ATTR(baseline, S_IRUGO, cyapa_show_baseline, NULL);
> > +static DEVICE_ATTR(calibrate, S_IWUSR, NULL, cyapa_calibrate_store);
> > +
> > +static struct attribute *cyapa_sysfs_entries[] = {
> > +	&dev_attr_firmware_version.attr,
> > +	&dev_attr_product_id.attr,
> > +	&dev_attr_update_fw.attr,
> > +	&dev_attr_baseline.attr,
> > +	&dev_attr_calibrate.attr,
> > +	NULL,
> > +};
> > +
> > +static const struct attribute_group cyapa_sysfs_group = {
> > +	.attrs = cyapa_sysfs_entries,
> > +};
> > +
> >  void cyapa_detect_async(void *data, async_cookie_t cookie)
> >  {
> >  	struct cyapa *cyapa = (struct cyapa *)data;
> > @@ -680,6 +866,9 @@ static int cyapa_probe(struct i2c_client *client,
> >  		goto err_uninit_tp_modules;
> >  	}
> >
> > +	if (sysfs_create_group(&client->dev.kobj, &cyapa_sysfs_group))
> > +		dev_warn(dev, "error creating sysfs entries.\n");
> > +
> >  #ifdef CONFIG_PM_SLEEP
> >  	if (device_can_wakeup(dev) &&
> >  	    sysfs_merge_group(&client->dev.kobj, &cyapa_power_wakeup_group))
> > @@ -704,6 +893,7 @@ static int cyapa_remove(struct i2c_client *client)
> >  	struct cyapa *cyapa = i2c_get_clientdata(client);
> >
> >  	pm_runtime_disable(&client->dev);
> > +	sysfs_remove_group(&client->dev.kobj, &cyapa_sysfs_group);
> >
> >  #ifdef CONFIG_PM_SLEEP
> >  	sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_wakeup_group);
> > diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
> > index 9c1f0b91..567ab08 100644
> > --- a/drivers/input/mouse/cyapa.h
> > +++ b/drivers/input/mouse/cyapa.h
> > @@ -171,6 +171,22 @@ struct cyapa;
> >  typedef bool (*cb_sort)(struct cyapa *, u8 *, int);
> >
> >  struct cyapa_dev_ops {
> > +	int (*check_fw)(struct cyapa *, const struct firmware *);
> > +	int (*bl_enter)(struct cyapa *);
> > +	int (*bl_activate)(struct cyapa *);
> > +	int (*bl_initiate)(struct cyapa *, const struct firmware *);
> > +	int (*update_fw)(struct cyapa *, const struct firmware *);
> > +	int (*bl_verify_app_integrity)(struct cyapa *);
> > +	int (*bl_deactivate)(struct cyapa *);
> > +
> > +	ssize_t (*show_baseline)(struct device *,
> > +			struct device_attribute *, char *);
> > +	ssize_t (*calibrate_store)(struct device *,
> > +			struct device_attribute *, const char *, size_t);
> > +
> > +	int (*read_fw)(struct cyapa *);
> > +	int (*read_raw_data)(struct cyapa *);
> > +
> >  	int (*initialize)(struct cyapa *cyapa);
> >  	int (*uninitialize)(struct cyapa *cyapa);
> >
> > @@ -243,6 +259,17 @@ struct cyapa {
> >  	 */
> >  	struct mutex state_sync_lock;
> >
> > +	/* Per-instance debugfs root */
> > +	struct dentry *dentry_dev;
> > +
> > +	/* Buffer to store firmware read using debugfs */
> > +	struct mutex debugfs_mutex;
> > +	u8 *fw_image;
> > +	size_t fw_image_size;
> > +	/* Buffer to store sensors' raw data */
> > +	u8 *tp_raw_data;
> > +	size_t tp_raw_data_size;
> > +
> >  	const struct cyapa_dev_ops *ops;
> >  };
> >
> > --
> > 1.7.9.5
> >
> >
> 
> Thanks.
> 
> --
> Dmitry

