Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab3KDWNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 17:13:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48750 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab3KDWNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 17:13:12 -0500
Date: Mon, 4 Nov 2013 14:15:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
Message-ID: <20131104221524.GD14141@kroah.com>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
 <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
 <20131030174403.GF20147@kroah.com>
 <1383583287.15642.29.camel@oc7383187364.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383583287.15642.29.camel@oc7383187364.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 05:41:27PM +0100, Frank Haverkamp wrote:
> Hi Greg,
> 
> Am Mittwoch, den 30.10.2013, 10:44 -0700 schrieb Greg KH:
> > On Wed, Oct 30, 2013 at 10:32:58AM +0100, Frank Haverkamp wrote:
> > > +/*
> > > + * Create device_attribute structures / params: name, mode, show, store
> > > + * additional flag if valid in VF
> > > + */
> > > +struct genwqe_dev_attrib {
> > > +	struct device_attribute att;	/* sysfs entry attributes */
> > > +	int vf;				/* may exist in VF or not */
> > > +};
> > 
> > Why do you need your own structure?  Use the is_visible() callback to
> > create or not, the individual attributes for a specific device, don't
> > roll your own logic for something the driver core already supports.
> > 
> > > +static struct genwqe_dev_attrib dev_attr_tab[] = {
> > > +	{__ATTR(tempsens,       S_IRUGO, show_card_tempsens, NULL), 0},
> > > +	{__ATTR(next_bitstream, (S_IRUGO | S_IWUSR),
> > > +		show_card_next_bitstream, store_card_next_bitstream), 0},
> > > +	{__ATTR(curr_bitstream, S_IRUGO, show_card_curr_bitstream, NULL), 0},
> > > +	{__ATTR(cpld_version,   S_IRUGO, show_cpld_version, NULL), 0},
> > > +	{__ATTR(base_clock,	S_IRUGO, show_card_base_clock, NULL), 0},
> > > +
> > > +	{__ATTR(driver,		S_IRUGO, show_card_driver, NULL), 1},
> > > +	{__ATTR(type,		S_IRUGO, show_card_type, NULL), 1},
> > > +	{__ATTR(version,	S_IRUGO, show_card_version, NULL), 1},
> > > +	{__ATTR(appid,		S_IRUGO, show_card_appid, NULL), 1},
> > > +	{__ATTR(status,		S_IRUGO, show_card_status, NULL), 1},
> > > +};
> > > +
> > > +/**
> > > + * create_card_sysfs() - Setup sysfs entries of the card device
> > > + *
> > > + * VFs have restricted mmio capabilities, so not all sysfs entries
> > > + * are allowed in VFs.
> > > + */
> > > +int create_card_sysfs(struct genwqe_dev *cd)
> > > +{
> > > +	int rc, priv;
> > > +	unsigned int i;
> > > +
> > > +	priv = genwqe_is_privileged(cd);
> > > +	for (i = 0; i < ARRAY_SIZE(dev_attr_tab); i++) {
> > > +		struct genwqe_dev_attrib *dev_attr = &dev_attr_tab[i];
> > > +		if (dev_attr->vf || priv) {
> > > +			rc = device_create_file(cd->dev, &dev_attr->att);
> > 
> > No, you just raced with userspace, creating the sysfs files _after_ it
> > was told to userspace that the driver was bound to the device.
> 
> > Please use the attribute groups for this driver to have the driver core
> > create the files before it it told to userspace.
> 
> The code got a little smaller now, which is good. I introduced the usage
> of is_visible(), but wondered if it really makes sense for my driver.
> Alternatively I thought I could use something like this:
> 
> if (genwqe_is_privileged(cd))
>         sysfs_create_group(&cd->dev->kobj, &genwqe_attribute_group);
> else
>         sysfs_create_group(&cd->dev->kobj,
>                            &genwqe_normal_attribute_group);

Ideally you would never call that function, so yes, is_visible() should
be used.

> > Also, instead of using __ATTR(), please use DEVICE_ATTR_RO(), it makes
> > things easier to audit and saves me from having to change it later on
> > (I'm doing a tree-wide change of this type of thing...)
> 
> Ok.
> 
> I stumbled across your article:
> http://kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-correctly/
> 
> I am using sysfs_create_group() now, but do I understand you correctly
> that setting the const struct attribute_group **groups; in my device
> (where in my struct pci_device.dev?) is an even better way to establish
> my sysfs attributes? Is there a function which I could call rather than
> trying to find the right pointer?

Ugh, this is still a problem, I'm trying to work through how to have
individual drivers implement groups and sysfs files in a non-racy way.
The issue is your device was announced to userspace _before_ it was
bound to the driver, so there's no way to get the sysfs files to apply
before then.

You should just have the attributes on the sysfs device you create
yourself, not your pci device, as that's where they make more sense, and
there you should be able to use the attribute group easily, right?

thanks,

greg k-h
