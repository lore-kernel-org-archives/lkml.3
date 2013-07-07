Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab3GGARH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 20:17:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35632 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab3GGARE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 20:17:04 -0400
Date: Sat, 6 Jul 2013 17:17:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Oliver Schinagl <oliver+list@schinagl.nl>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>, arnd@arndb.de,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        andy.shevchenko@gmail.com, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, linux-sunxi@googlegroups.com,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH 1/2] Initial support for Allwinner's Security ID fuses
Message-ID: <20130707001758.GA15335@kroah.com>
References: <20130624092942.GG26008@lukather>
 <20130624160440.GA15201@kroah.com>
 <51C87DC7.50005@schinagl.nl>
 <20130624181509.GA8847@kroah.com>
 <51C8B84C.3020200@schinagl.nl>
 <20130624214615.GA17604@kroah.com>
 <51CAA709.4060801@schinagl.nl>
 <20130626175144.GC2222@kroah.com>
 <51D674BF.9030207@schinagl.nl>
 <20130706193646.GB9778@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130706193646.GB9778@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 06, 2013 at 12:36:46PM -0700, Greg KH wrote:
> On Fri, Jul 05, 2013 at 09:24:47AM +0200, Oliver Schinagl wrote:
> > The other 'broken' drivers that where linked earlier, also use the
> > BINARY attributes.
> > 
> > So Greg, if you could be so kind and give me an example how to
> > implement this properly, I am at loss and don't know :(
> 
> Ah crap, devices don't have a binary attribute group, like struct class
> does.  I'll go add that on Monday and send you the patch to see if that
> helps you out.  I'll also go through and fix up all of the binary
> attribute drivers to keep them from doing that...
> 
> Sorry, I missed that earlier, but thanks for trying and pointing out my
> mistake.

Can you try this patch out, with your driver, and see if it works for
you?

thanks,

greg k-h

------------------

Subject: driver core: add binary attributes to struct device

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This lets a device provide a set of default binary attributes, like
normal attributes, that are initialized and torn down by the driver core
at the proper times, so that there are no races with userspace.

Reported-by: : Oliver Schinagl <oliver+list@schinagl.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


diff --git a/drivers/base/core.c b/drivers/base/core.c
index 2499cef..4040191 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -433,7 +433,7 @@ static void device_remove_attributes(struct device *dev,
 }
 
 static int device_add_bin_attributes(struct device *dev,
-				     struct bin_attribute *attrs)
+				     const struct bin_attribute *attrs)
 {
 	int error = 0;
 	int i;
@@ -452,7 +452,7 @@ static int device_add_bin_attributes(struct device *dev,
 }
 
 static void device_remove_bin_attributes(struct device *dev,
-					 struct bin_attribute *attrs)
+					 const struct bin_attribute *attrs)
 {
 	int i;
 
@@ -516,8 +516,14 @@ static int device_add_attrs(struct device *dev)
 	if (error)
 		goto err_remove_type_groups;
 
+	error = device_add_bin_attributes(dev, dev->bin_attrs);
+	if (error)
+		goto err_remove_groups;
 	return 0;
 
+ err_remove_groups:
+	device_remove_groups(dev, dev->groups);
+
  err_remove_type_groups:
 	if (type)
 		device_remove_groups(dev, type->groups);
@@ -537,6 +543,7 @@ static void device_remove_attrs(struct device *dev)
 	const struct device_type *type = dev->type;
 
 	device_remove_groups(dev, dev->groups);
+	device_remove_bin_attributes(dev, dev->bin_attrs);
 
 	if (type)
 		device_remove_groups(dev, type->groups);
diff --git a/include/linux/device.h b/include/linux/device.h
index c0a1261..6620ad8 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -645,6 +645,7 @@ struct acpi_dev_node {
  * @knode_class: The node used to add the device to the class list.
  * @class:	The class of the device.
  * @groups:	Optional attribute groups.
+ * @bin_attrs:	Optional binary attributes for this device.
  * @release:	Callback to free the device after all references have
  * 		gone away. This should be set by the allocator of the
  * 		device (i.e. the bus driver that discovered the device).
@@ -717,6 +718,7 @@ struct device {
 	struct klist_node	knode_class;
 	struct class		*class;
 	const struct attribute_group **groups;	/* optional groups */
+	const struct bin_attribute *bin_attrs;
 
 	void	(*release)(struct device *dev);
 	struct iommu_group	*iommu_group;
