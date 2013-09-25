Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab3IYVLL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 17:11:11 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:63862 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab3IYVLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 17:11:10 -0400
Date: Wed, 25 Sep 2013 14:11:05 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: i2c-dev: Create 'name' attribute automatically
Message-ID: <20130925211104.GA2784@roeck-us.net>
References: <1377966619-20197-1-git-send-email-linux@roeck-us.net>
 <20130925202035.GB4290@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925202035.GB4290@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 10:20:35PM +0200, Wolfram Sang wrote:
> On Sat, Aug 31, 2013 at 09:30:19AM -0700, Guenter Roeck wrote:
> > The 'name' attribute is needed for all i2c-dev class devices, meaning
> > it can be created automatically by pointing to it in the class data
> > structure. This simplifies the code and reduces the probability for race
> > conditions.
> 
> What race condition?
> 

Userspace trying to access the name attribute before it is created.
See http://kroah.com/log/blog/2013/06/26/how-to-create-a-sysfs-file-correctly/
for details; Greg describes the problem and solution much better than I could
ever do.

> > 
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> > ---
> >  drivers/i2c/i2c-dev.c |   32 ++++++++++++++++----------------
> >  1 file changed, 16 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
> > index c3ccdea..46eea02 100644
> > --- a/drivers/i2c/i2c-dev.c
> > +++ b/drivers/i2c/i2c-dev.c
> > @@ -111,7 +111,11 @@ static ssize_t show_adapter_name(struct device *dev,
> >  		return -ENODEV;
> >  	return sprintf(buf, "%s\n", i2c_dev->adap->name);
> >  }
> > -static DEVICE_ATTR(name, S_IRUGO, show_adapter_name, NULL);
> > +
> > +static struct device_attribute i2c_dev_attributes[] = {
> > +	__ATTR(name, S_IRUGO, show_adapter_name, NULL),
> > +	{ }
> > +};
> >  
> >  /* ------------------------------------------------------------------------- */
> >  
> > @@ -538,7 +542,11 @@ static const struct file_operations i2cdev_fops = {
> >  
> >  /* ------------------------------------------------------------------------- */
> >  
> > -static struct class *i2c_dev_class;
> > +static struct class i2c_dev_class = {
> > +	.owner = THIS_MODULE,
> > +	.name = "i2c-dev",
> > +	.dev_attrs = i2c_dev_attributes,
> > +};
> 
> Have you tried this with two instances? I don't think it will work since
> class_register modifies the class struct.
> 
Half a dozen instances, actually. Unless I am missing something, seems to be
unlikely that there is a problem, since the kernel would fail all over the place
if there was a problem with class->dev_attrs (or its replacement dev_groups);

Anyway, the patch is obsolete; one is supposed to use class->dev_groups now.

Thanks,
Guenter
