Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbaHYC1K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 22:27:10 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:64366 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbaHYC1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 22:27:08 -0400
Message-ID: <53fa9efa.e724460a.3174.ffffaa88@mx.google.com>
X-Google-Original-Message-ID: <000301cfc00c$0b9776d0$22c66470$@dulixin@gmail.com>
From: "Dudley Du" <dudley.dulixin@gmail.com>
To: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        "Dudley Du" <dudley.dulixin@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Benson Leung" <bleung@google.com>,
        "Patrik Fimml" <patrikf@google.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <53c772c1.e683460a.3dd2.4a4c@mx.google.com> <20140822235138.GA24242@core.coreip.homeip.net>
In-Reply-To: <20140822235138.GA24242@core.coreip.homeip.net>
Subject: RE: [PATCH v4 5/14] input: cyapa: add read firmware image and raw data interfaces in debugfs system
Date: Mon, 25 Aug 2014 10:26:45 +0800
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac+hi7FgkKkcJ7efTdiPHexSQWgLNwc+dkUAAGAzgRA=
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

> -----Original Message-----
> From: Dmitry Torokhov [mailto:dmitry.torokhov@gmail.com]
> Sent: Saturday, August 23, 2014 7:52 AM
> To: Dudley Du
> Cc: Rafael J. Wysocki; Benson Leung; Patrik Fimml; linux-input@vger.kernel.org;
> linux-kernel@vger.kernel.org; Dudley Du
> Subject: Re: [PATCH v4 5/14] input: cyapa: add read firmware image and raw
> data interfaces in debugfs system
> 
> Hi Dudley,
> 
> On Thu, Jul 17, 2014 at 02:52:36PM +0800, Dudley Du wrote:
> > Add read_fw and raw_data debugfs interfaces for easier issues location
> > and collection when report by user.
> > TEST=test on Chromebooks.
> >
> > Signed-off-by: Dudley Du <dudl@cypress.com>
> > ---
> >  drivers/input/mouse/cyapa.c |  219
> +++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 219 insertions(+)
> >
> > diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> > index 53c9d59..ae24b02 100644
> > --- a/drivers/input/mouse/cyapa.c
> > +++ b/drivers/input/mouse/cyapa.c
> > @@ -39,6 +39,8 @@
> >
> >  const char unique_str[] = "CYTRA";
> >
> > +/* Global root node of the cyapa debugfs directory. */
> > +static struct dentry *cyapa_debugfs_root;
> >
> >
> >  ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
> > @@ -461,6 +463,205 @@ done:
> >  }
> >
> >  /*
> > + **************************************************************
> > + * debugfs interface
> > + **************************************************************
> > +*/
> > +static int cyapa_debugfs_open(struct inode *inode, struct file *file)
> > +{
> > +	struct cyapa *cyapa = inode->i_private;
> > +	int ret;
> > +
> > +	if (!cyapa)
> > +		return -ENODEV;
> > +
> > +	ret = mutex_lock_interruptible(&cyapa->debugfs_mutex);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (!kobject_get(&cyapa->client->dev.kobj)) {
> 
> Why not get_device() here and elsewhere?

Thanks. I will use get_device()/put_device() instead.

> 
> > +		ret = -ENODEV;
> > +		goto out;
> > +	}
> > +
> > +	file->private_data = cyapa;
> > +
> > +	if (cyapa->fw_image) {
> > +		ret = 0;
> > +		goto out;
> > +	}
> > +
> > +	mutex_lock(&cyapa->state_sync_lock);
> > +	/*
> > +	 * If firmware hasn't been read yet, read it all in one pass.
> > +	 * Subsequent opens will reuse the data in this same buffer.
> > +	 */
> > +	if (cyapa->ops->read_fw)
> > +		ret = cyapa->ops->read_fw(cyapa);
> > +	else
> > +		ret = -EPERM;
> > +	mutex_unlock(&cyapa->state_sync_lock);
> > +
> > +	/* Redetect trackpad device states. */
> > +	cyapa_detect_async(cyapa, 0);
> > +
> > +out:
> > +	mutex_unlock(&cyapa->debugfs_mutex);
> > +	return ret;
> > +}
> > +
> > +static int cyapa_debugfs_release(struct inode *inode, struct file *file)
> > +{
> > +	struct cyapa *cyapa = file->private_data;
> > +	int ret;
> > +
> > +	if (!cyapa)
> > +		return 0;
> > +
> > +	ret = mutex_lock_interruptible(&cyapa->debugfs_mutex);
> > +	if (ret)
> > +		return ret;
> > +	file->private_data = NULL;
> > +	kobject_put(&cyapa->client->dev.kobj);
> > +	mutex_unlock(&cyapa->debugfs_mutex);
> > +
> > +	return 0;
> > +}
> > +
> > +/* Return some bytes from the buffered firmware image, starting from *ppos
> */
> > +static ssize_t cyapa_debugfs_read_fw(struct file *file, char __user *buffer,
> > +				     size_t count, loff_t *ppos)
> > +{
> > +	struct cyapa *cyapa = file->private_data;
> > +
> > +	if (!cyapa->fw_image)
> > +		return -EINVAL;
> > +
> > +	if (*ppos >= cyapa->fw_image_size)
> > +		return 0;
> > +
> > +	if (count + *ppos > cyapa->fw_image_size)
> > +		count = cyapa->fw_image_size - *ppos;
> > +
> > +	if (copy_to_user(buffer, &cyapa->fw_image[*ppos], count))
> > +		return -EFAULT;
> > +
> > +	*ppos += count;
> > +	return count;
> > +}
> > +
> > +static const struct file_operations cyapa_read_fw_fops = {
> > +	.open = cyapa_debugfs_open,
> > +	.release = cyapa_debugfs_release,
> > +	.read = cyapa_debugfs_read_fw
> > +};
> > +
> > +static int cyapa_debugfs_raw_data_open(struct inode *inode, struct file
> *file)
> > +{
> > +	struct cyapa *cyapa = inode->i_private;
> > +	int ret;
> > +
> > +	if (!cyapa)
> > +		return -ENODEV;
> > +
> > +	/* Start to be supported after Gen5 trackpad devices. */
> > +	if (cyapa->gen < CYAPA_GEN5)
> > +		return -ENOTSUPP;
> > +
> > +	ret = mutex_lock_interruptible(&cyapa->debugfs_mutex);
> > +	if (ret)
> > +		return ret;
> > +
> > +	if (!kobject_get(&cyapa->client->dev.kobj)) {
> > +		ret = -ENODEV;
> > +		goto out;
> > +	}
> > +
> > +	file->private_data = cyapa;
> > +
> > +	mutex_lock(&cyapa->state_sync_lock);
> > +	if (cyapa->ops->read_raw_data)
> > +		ret = cyapa->ops->read_raw_data(cyapa);
> > +	else
> > +		ret = -EPERM;
> > +	mutex_unlock(&cyapa->state_sync_lock);
> > +out:
> > +	mutex_unlock(&cyapa->debugfs_mutex);
> > +	return ret;
> > +}
> > +
> > +static int cyapa_debugfs_raw_data_release(struct inode *inode,
> > +				struct file *file)
> > +{
> > +	struct cyapa *cyapa = file->private_data;
> > +	int ret;
> > +
> > +	if (!cyapa)
> > +		return 0;
> > +
> > +	ret = mutex_lock_interruptible(&cyapa->debugfs_mutex);
> > +	if (ret)
> > +		return ret;
> > +	file->private_data = NULL;
> > +	kobject_put(&cyapa->client->dev.kobj);
> > +	mutex_unlock(&cyapa->debugfs_mutex);
> > +
> > +	return 0;
> > +}
> > +
> > +/* Always return the sensors' latest raw data from trackpad device. */
> > +static ssize_t cyapa_debugfs_read_raw_data(struct file *file,
> > +				     char __user *buffer,
> > +				     size_t count, loff_t *ppos)
> > +{
> > +	struct cyapa *cyapa = file->private_data;
> > +
> > +	if (!cyapa->tp_raw_data)
> > +		return -EINVAL;
> > +
> > +	if (*ppos >= cyapa->tp_raw_data_size)
> > +		return 0;
> > +
> > +	if (count + *ppos > cyapa->tp_raw_data_size)
> > +		count = cyapa->tp_raw_data_size - *ppos;
> > +
> > +	if (copy_to_user(buffer, &cyapa->tp_raw_data[*ppos], count))
> > +		return -EFAULT;
> > +
> > +	*ppos += count;
> > +	return count;
> > +}
> > +
> > +static const struct file_operations cyapa_read_raw_data_fops = {
> > +	.open = cyapa_debugfs_raw_data_open,
> > +	.release = cyapa_debugfs_raw_data_release,
> > +	.read = cyapa_debugfs_read_raw_data
> > +};
> > +
> > +static int cyapa_debugfs_init(struct cyapa *cyapa)
> > +{
> > +	struct device *dev = &cyapa->client->dev;
> > +
> > +	if (!cyapa_debugfs_root)
> > +		return -ENODEV;
> > +
> > +	cyapa->dentry_dev = debugfs_create_dir(kobject_name(&dev->kobj),
> > +					       cyapa_debugfs_root);
> > +
> > +	if (!cyapa->dentry_dev)
> > +		return -ENODEV;
> > +
> > +	mutex_init(&cyapa->debugfs_mutex);
> > +
> > +	debugfs_create_file(CYAPA_DEBUGFS_READ_FW, S_IRUSR, cyapa->dentry_dev,
> > +			    cyapa, &cyapa_read_fw_fops);
> > +
> > +	debugfs_create_file(CYAPA_DEBUGFS_RAW_DATA, S_IRUSR, cyapa->dentry_dev,
> > +			    cyapa, &cyapa_read_raw_data_fops);
> > +	return 0;
> > +}
> > +
> > +/*
> >   * Sysfs Interface.
> >   */
> >
> > @@ -869,6 +1070,13 @@ static int cyapa_probe(struct i2c_client *client,
> >  	if (sysfs_create_group(&client->dev.kobj, &cyapa_sysfs_group))
> >  		dev_warn(dev, "error creating sysfs entries.\n");
> >
> > +	/* Create a global debugfs root for all cyapa devices */
> > +	cyapa_debugfs_root = debugfs_create_dir("cyapa", NULL);
> > +	if (cyapa_debugfs_root == ERR_PTR(-ENODEV))
> > +		cyapa_debugfs_root = NULL;
> > +	if (cyapa_debugfs_init(cyapa))
> > +		dev_warn(dev, "error creating debugfs entries.\n");
> > +
> >  #ifdef CONFIG_PM_SLEEP
> >  	if (device_can_wakeup(dev) &&
> >  	    sysfs_merge_group(&client->dev.kobj, &cyapa_power_wakeup_group))
> > @@ -902,8 +1110,19 @@ static int cyapa_remove(struct i2c_client *client)
> >  #ifdef CONFIG_PM_RUNTIME
> >  	sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_runtime_group);
> >  #endif
> > +
> > +	kfree(cyapa->fw_image);
> > +	cyapa->fw_image = NULL;
> > +	cyapa->fw_image_size = 0;
> > +	kfree(cyapa->tp_raw_data);
> > +	cyapa->tp_raw_data = NULL;
> > +	cyapa->tp_raw_data_size = 0;
> 
> This should be happening only after you remove debugfs entries.

Thanks, will change to the correct order.

> 
> 
> >  	free_irq(cyapa->irq, cyapa);
> >
> > +	debugfs_remove_recursive(cyapa->dentry_dev);
> > +	debugfs_remove_recursive(cyapa_debugfs_root);
> 
> Hm, it seems that your debugfs entries are created per-devce, but you remove
> all of them at one when very first device us unbound. You probably want to
> create and destroy root of your debugfs hierarchy on module level.


Yes. You are correct.
I would change it to use module_init()/module_exit() to create and remove cyapa_debugfs_root.


> 
> > +	mutex_destroy(&cyapa->debugfs_mutex);
> > +
> >  	input_unregister_device(cyapa->input);
> >  	if (cyapa->ops->set_power_mode)
> >  		cyapa->ops->set_power_mode(cyapa, PWR_MODE_OFF, 0);
> > --
> > 1.7.9.5
> >
> >
> 
> Thanks.
> 
> --
> Dmitry

