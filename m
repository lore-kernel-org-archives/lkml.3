Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaJOLtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 07:49:43 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62188 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaJOLtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 07:49:41 -0400
MIME-Version: 1.0
In-Reply-To: <20141014154151.GB10067@roeck-us.net>
References: <1413298094-9276-1-git-send-email-octavian.purdila@intel.com>
	<1413298094-9276-4-git-send-email-octavian.purdila@intel.com>
	<20141014154151.GB10067@roeck-us.net>
Date: Wed, 15 Oct 2014 14:49:39 +0300
Message-ID: <CAE1zotKpgEqAhtQvsFFee8xnX02MmhwrM0YU-6OHVZHcxiAi9g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/3] i2c: show and change bus frequency via sysfs
From: Octavian Purdila <octavian.purdila@intel.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wolfram Sang <wsa@the-dreams.de>, Johan Hovold <johan@kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>, linux-api@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 6:41 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Tue, Oct 14, 2014 at 05:48:14PM +0300, Octavian Purdila wrote:
> > This patch adds three new sysfs files: bus_frequency,
> > bus_min_frequency and bus_max_frequency which allows the user to view
> > or change the bus frequency on a per bus level.
> >

<snip>

> > +
> > +static DEVICE_ATTR(bus_frequency, S_IRUGO, i2c_sysfs_freq_show,
> > +                i2c_sysfs_freq_store);
>
> Consider using DEVICE_ATTR_RO here. Also, extra empty line.
>

Unfortunately that won't work because we must transform bus_frequency
to a RW entry (via is_visible) if the bus can change the frequency. We
can't use DEVIE_ATTR_RW either, because transforming a RW entry to a
RO entry with is visible is not possible:

fs/sysfs/group.c:

static int create_files(struct kernfs_node *parent, struct kobject *kobj,
...
                        if (grp->is_visible) {
                                mode = grp->is_visible(kobj, *attr, i);
                                if (!mode)
                                        continue;
                        }
                        error = sysfs_add_file_mode_ns(parent, *attr, false,
                                                       (*attr)->mode | mode,
                                                       NULL);

Of course if we only allow a RW frequency entry as you suggest below,
then we can use DEVICE_ATTR_RW.

> > +
> > +
> > +static ssize_t
> > +i2c_sysfs_min_freq_show(struct device *dev, struct device_attribute *attr,
> > +                       char *buf)
> > +{
> > +     struct i2c_adapter *adap = to_i2c_adapter(dev);
> > +
> > +     return snprintf(buf, PAGE_SIZE, "%d\n", adap->min_freq);
> > +}
> > +
> > +static DEVICE_ATTR(bus_min_frequency, S_IRUGO, i2c_sysfs_min_freq_show, NULL);
> > +
>
> Consider using DEVICE_ATTR_RO.
>

OK.

> > +static ssize_t
> > +i2c_sysfs_max_freq_show(struct device *dev, struct device_attribute *attr,
> > +                       char *buf)
> > +{
> > +     struct i2c_adapter *adap = to_i2c_adapter(dev);
> > +
> > +     return snprintf(buf, PAGE_SIZE, "%d\n", adap->max_freq);
> > +}
> > +
> > +static DEVICE_ATTR(bus_max_frequency, S_IRUGO, i2c_sysfs_max_freq_show, NULL);
> > +
> Consider using DEVICE_ATTR_RO.
>

OK.

> Overall, it seems to me that the bus_ in front of the attrribute names
> is really not necessary. The attributes are attached to the adapter, so it
> should be obvious that the attributes describe the adapter (=bus) frequency and
> not some other frequency.
>
> > +umode_t i2c_adapter_visible_attr(struct kobject *kobj,
> > +                              struct attribute *attr, int idx)
>
> static umode_t
>

Oops :)

> > +{
> > +     struct device *dev = container_of(kobj, struct device, kobj);
> > +     struct i2c_adapter *adap = to_i2c_adapter(dev);
> > +     umode_t mode = attr->mode;
> > +
> > +     if (attr == &dev_attr_bus_min_frequency.attr)
> > +             return adap->min_freq ? mode : 0;
> > +
> > +     if (attr == &dev_attr_bus_max_frequency.attr)
> > +             return adap->max_freq ? mode : 0;
> > +
> > +     if (attr == &dev_attr_bus_frequency.attr) {
> > +             if (adap->set_freq)
> > +                     mode |= S_IWUSR;
> > +             return adap->freq ? mode : 0;
>
> Personally, I would make all those attributes only visible if the adapter
> supports setting the frquency, and not bother with other conditions,
> to keep things simple. Not a strong call, though.
>

I don't have a strong opinion either. I think a RO frequency entry
would help with debugging, but I am not sure how useful it is in
practice.
