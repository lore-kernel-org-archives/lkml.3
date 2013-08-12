Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab3HLXGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 19:06:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290Ab3HLXGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 19:06:18 -0400
Date: Mon, 12 Aug 2013 16:06:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, Rob Landley <rob@landley.net>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux-doc@vger.kernel.org,
        AsiasHeasias@redhat.com, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Caz Yokoyama <Caz.Yokoyama@intel.com>,
        Dasaratharaman Chandramouli 
	<dasaratharaman.chandramouli@intel.com>,
        Harshavardhan R Kharche <harshavardhan.r.kharche@intel.com>,
        "Yaozu (Eddie) Dong" <eddie.dong@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [PATCH v2 1/7] Intel MIC Host Driver for X100 family.
Message-ID: <20130812230617.GB30952@kroah.com>
References: <cover.1375927849.git.sudeep.dutt@intel.com>
 <a5214cbe041674f0b5dcd7eb9b581b4d7f923947.1375927849.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5214cbe041674f0b5dcd7eb9b581b4d7f923947.1375927849.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 07, 2013 at 08:04:07PM -0700, Sudeep Dutt wrote:
> +/**
> + * struct mic_device -  MIC device information for each card.
> + *
> + * @name: Unique name for this MIC device.
> + * @mmio: MMIO bar information.
> + * @pdev: The PCI device structure.
> + * @family: The MIC family to which this device belongs.
> + * @ops: MIC HW specific operations.
> + * @id: The unique device id for this MIC device.
> + * @stepping: Stepping ID.
> + * @attr_group: Sysfs attribute group.
> + * @sdev: Device for sysfs entries.
> + * @aper: Aperture bar information.
> + */
> +struct mic_device {
> +	char name[20];

The name can be in the struct device (it should be the same, right?)

> +	struct mic_mw mmio;
> +	struct pci_dev *pdev;

Isn't this just the parent of the device?  Do you really need this?

> +	enum mic_hw_family family;
> +	struct mic_hw_ops *ops;
> +	int id;
> +	enum mic_stepping stepping;
> +	struct attribute_group attr_group;

Shouldn't this be a pointer to a list of groups?

> +	struct device *sdev;

Shouldn't this be embedded inside here, instead of a pointer?

> +	struct mic_mw aper;
> +};


> +/**
> + * struct mic_info -  Global information about all MIC devices.
> + *
> + * @next_id: Next available MIC device id.
> + * @mic_class: Class of MIC devices for sysfs accessibility.
> + * @mdev_id: Base device node number.
> + */
> +struct mic_info {
> +	int next_id;

Please use the idr interface, don't roll your own, odds are you got it
wrong, and I don't want to have to debug it :(

> +	struct class *mic_class;

Isn't this a global symbol that you have (or static symbol).  There
should never be more than one "class" around for these devices.

> +	dev_t mdev_id;
> +};
> +
> +/* g_mic - Global information about all MIC devices. */
> +static struct mic_info g_mic;

See, one class :)

> +/**
> + * mic_probe - Device Initialization Routine
> + *
> + * @pdev: PCI device structure
> + * @ent: entry in mic_pci_tbl
> + *
> + * returns 0 on success, < 0 on failure.
> + */
> +static int __init mic_probe(struct pci_dev *pdev,
> +		const struct pci_device_id *ent)
> +{
> +	int rc;
> +	struct mic_device *mdev;
> +	char name[20];
> +
> +	rc = g_mic.next_id++;

No locking, please use the idr interface...

> +
> +	snprintf(name, sizeof(name), "mic%d", rc);
> +	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
> +	if (!mdev) {
> +		rc = -ENOMEM;
> +		dev_err(&pdev->dev, "dev kmalloc failed rc %d\n", rc);
> +		goto dec_num_dev;
> +	}
> +	strncpy(mdev->name, name, sizeof(name));
> +	mdev->id = rc;
> +
> +	mic_device_init(mdev, pdev);
> +
> +	rc = pci_enable_device(pdev);
> +	if (rc) {
> +		dev_err(&pdev->dev, "failed to enable pci device.\n");
> +		goto free_device;
> +	}
> +
> +	pci_set_master(pdev);
> +
> +	rc = pci_request_regions(pdev, mic_driver_name);
> +	if (rc) {
> +		dev_err(&pdev->dev, "failed to get pci regions.\n");
> +		goto disable_device;
> +	}
> +
> +	rc = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
> +	if (rc) {
> +		dev_err(&pdev->dev, "Cannot set DMA mask\n");
> +		goto release_regions;
> +	}
> +
> +	mdev->mmio.pa = pci_resource_start(pdev, mdev->ops->mmio_bar);
> +	mdev->mmio.len = pci_resource_len(pdev, mdev->ops->mmio_bar);
> +	mdev->mmio.va = pci_ioremap_bar(pdev, mdev->ops->mmio_bar);
> +	if (!mdev->mmio.va) {
> +		dev_err(&pdev->dev, "Cannot remap MMIO BAR\n");
> +		rc = -EIO;
> +		goto release_regions;
> +	}
> +
> +	mdev->aper.pa = pci_resource_start(pdev, mdev->ops->aper_bar);
> +	mdev->aper.len = pci_resource_len(pdev, mdev->ops->aper_bar);
> +	mdev->aper.va = ioremap_wc(mdev->aper.pa, mdev->aper.len);
> +	if (!mdev->aper.va) {
> +		dev_err(&pdev->dev, "Cannot remap Aperture BAR\n");
> +		rc = -EIO;
> +		goto unmap_mmio;
> +	}
> +
> +	mdev->ops->init(mdev);
> +
> +	pci_set_drvdata(pdev, mdev);
> +
> +	mdev->sdev = device_create(g_mic.mic_class, &pdev->dev,
> +		MKDEV(MAJOR(g_mic.mdev_id), mdev->id), NULL, "%s", mdev->name);
> +	if (IS_ERR(mdev->sdev)) {
> +		rc = PTR_ERR(mdev->sdev);
> +		dev_err(&pdev->dev, "device_create failed rc %d\n", rc);
> +		goto unmap_aper;
> +	}
> +
> +	rc = sysfs_create_group(&mdev->sdev->kobj, &mdev->attr_group);

We now have a function you should use instead,
device_create_with_groups() that solves the race condition you just
caused here by creating and notifying userspace that the device is
present, _before_ creating the sysfs files for it.



> +	if (rc) {
> +		dev_err(&pdev->dev, "sysfs_create_group failed rc %d\n", rc);
> +		goto destroy_device;
> +	}
> +	dev_info(&pdev->dev, "Probe successful for %s\n", mdev->name);

Useless noise, remove it.

> +	return 0;
> +destroy_device:
> +	device_destroy(g_mic.mic_class, MKDEV(MAJOR(g_mic.mdev_id), mdev->id));
> +unmap_aper:
> +	iounmap(mdev->mmio.va);
> +unmap_mmio:
> +	iounmap(mdev->aper.va);
> +release_regions:
> +	pci_release_regions(pdev);
> +disable_device:
> +	pci_disable_device(pdev);
> +free_device:
> +	kfree(mdev);
> +dec_num_dev:
> +	g_mic.next_id--;
> +	dev_err(&pdev->dev, "Probe failed rc %d\n", rc);
> +	return rc;
> +}
> +
> +/**
> + * mic_remove - Device Removal Routine
> + * mic_remove is called by the PCI subsystem to alert the driver
> + * that it should release a PCI device.
> + *
> + * @pdev: PCI device structure
> + */
> +static void mic_remove(struct pci_dev *pdev)
> +{
> +	struct mic_device *mdev;
> +	int id;
> +
> +	mdev = pci_get_drvdata(pdev);
> +	if (!mdev)
> +		return;
> +
> +	id = mdev->id;
> +
> +	sysfs_remove_group(&mdev->sdev->kobj, &mdev->attr_group);

No need to do this as:

> +	device_destroy(g_mic.mic_class, MKDEV(MAJOR(g_mic.mdev_id), mdev->id));

Will do it for you if you make the changes above.

thanks,

greg k-h
