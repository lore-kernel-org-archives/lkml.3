Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3KDQmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 11:42:53 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:38886 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3KDQmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 11:42:52 -0500
Subject: Re: [PATCH] Generic WorkQueue Engine (GenWQE) device driver (v4)
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
Reply-To: haver@linux.vnet.ibm.com
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        Frank Haverkamp <haver@vnet.ibm.com>
In-Reply-To: <20131030174403.GF20147@kroah.com>
References: <1383125578-26202-1-git-send-email-haver@linux.vnet.ibm.com>
	 <1383125578-26202-2-git-send-email-haver@linux.vnet.ibm.com>
	 <20131030174403.GF20147@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Organization: IBM
Date: Mon, 04 Nov 2013 17:41:27 +0100
Message-ID: <1383583287.15642.29.camel@oc7383187364.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110416-3548-0000-0000-0000070AC386
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Am Mittwoch, den 30.10.2013, 10:44 -0700 schrieb Greg KH:
> On Wed, Oct 30, 2013 at 10:32:58AM +0100, Frank Haverkamp wrote:
> > +/*
> > + * Create device_attribute structures / params: name, mode, show, store
> > + * additional flag if valid in VF
> > + */
> > +struct genwqe_dev_attrib {
> > +	struct device_attribute att;	/* sysfs entry attributes */
> > +	int vf;				/* may exist in VF or not */
> > +};
> 
> Why do you need your own structure?  Use the is_visible() callback to
> create or not, the individual attributes for a specific device, don't
> roll your own logic for something the driver core already supports.
> 
> > +static struct genwqe_dev_attrib dev_attr_tab[] = {
> > +	{__ATTR(tempsens,       S_IRUGO, show_card_tempsens, NULL), 0},
> > +	{__ATTR(next_bitstream, (S_IRUGO | S_IWUSR),
> > +		show_card_next_bitstream, store_card_next_bitstream), 0},
> > +	{__ATTR(curr_bitstream, S_IRUGO, show_card_curr_bitstream, NULL), 0},
> > +	{__ATTR(cpld_version,   S_IRUGO, show_cpld_version, NULL), 0},
> > +	{__ATTR(base_clock,	S_IRUGO, show_card_base_clock, NULL), 0},
> > +
> > +	{__ATTR(driver,		S_IRUGO, show_card_driver, NULL), 1},
> > +	{__ATTR(type,		S_IRUGO, show_card_type, NULL), 1},
> > +	{__ATTR(version,	S_IRUGO, show_card_version, NULL), 1},
> > +	{__ATTR(appid,		S_IRUGO, show_card_appid, NULL), 1},
> > +	{__ATTR(status,		S_IRUGO, show_card_status, NULL), 1},
> > +};
> > +
> > +/**
> > + * create_card_sysfs() - Setup sysfs entries of the card device
> > + *
> > + * VFs have restricted mmio capabilities, so not all sysfs entries
> > + * are allowed in VFs.
> > + */
> > +int create_card_sysfs(struct genwqe_dev *cd)
> > +{
> > +	int rc, priv;
> > +	unsigned int i;
> > +
> > +	priv = genwqe_is_privileged(cd);
> > +	for (i = 0; i < ARRAY_SIZE(dev_attr_tab); i++) {
> > +		struct genwqe_dev_attrib *dev_attr = &dev_attr_tab[i];
> > +		if (dev_attr->vf || priv) {
> > +			rc = device_create_file(cd->dev, &dev_attr->att);
> 
> No, you just raced with userspace, creating the sysfs files _after_ it
> was told to userspace that the driver was bound to the device.

> Please use the attribute groups for this driver to have the driver core
> create the files before it it told to userspace.

The code got a little smaller now, which is good. I introduced the usage
of is_visible(), but wondered if it really makes sense for my driver.
Alternatively I thought I could use something like this:

if (genwqe_is_privileged(cd))
        sysfs_create_group(&cd->dev->kobj, &genwqe_attribute_group);
else
        sysfs_create_group(&cd->dev->kobj,
                           &genwqe_normal_attribute_group);



> Also, instead of using __ATTR(), please use DEVICE_ATTR_RO(), it makes
> things easier to audit and saves me from having to change it later on
> (I'm doing a tree-wide change of this type of thing...)

Ok.

I stumbled across your article:
http://kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-correctly/

I am using sysfs_create_group() now, but do I understand you correctly
that setting the const struct attribute_group **groups; in my device
(where in my struct pci_device.dev?) is an even better way to establish
my sysfs attributes? Is there a function which I could call rather than
trying to find the right pointer?

> thanks,
> 
> greg k-h
> 
Regards

Frank

