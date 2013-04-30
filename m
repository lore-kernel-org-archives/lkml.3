Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677Ab3D3T53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 15:57:29 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51460 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932735Ab3D3T50 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 15:57:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Toshi Kani <toshi.kani@hp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, isimatu.yasuaki@jp.fujitsu.com,
        vasilis.liaskovitis@profitbricks.com
Subject: Re: [PATCH 1/3 RFC] Driver core: Add offline/online device operations
Date: Tue, 30 Apr 2013 22:05:39 +0200
Message-ID: <19540823.9gExqkbsA4@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130430153228.GD8204@kroah.com>
References: <1576321.HU0tZ4cGWk@vostro.rjw.lan> <5539501.dHzXXAKYJ9@vostro.rjw.lan> <20130430153228.GD8204@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 30, 2013 08:32:28 AM Greg Kroah-Hartman wrote:
> On Tue, Apr 30, 2013 at 01:59:55PM +0200, Rafael J. Wysocki wrote:
> > On Monday, April 29, 2013 04:10:19 PM Greg Kroah-Hartman wrote:
> > > On Mon, Apr 29, 2013 at 02:26:56PM +0200, Rafael J. Wysocki wrote:
> > > > +static inline bool device_supports_offline(struct device *dev)
> > > > +{
> > > > +	return dev->bus && dev->bus->offline && dev->bus->online;
> > > 
> > > Wouldn't it be easier for us to also check offline_disabled here as
> > > well?  That would save the extra check when we go to create the sysfs
> > > file.
> > 
> > Yes, it would, but I want device_offline() to return an error in case
> > when offline_disabled is set while the above returns 'true'.  If that check
> > were folded into device_supports_offline(), device_offline() would return 0
> > in that case.
> 
> Ok, that makes sense.
> 
> > > > +static ssize_t store_online(struct device *dev, struct device_attribute *attr,
> > > > +			    const char *buf, size_t count)
> > > > +{
> > > > +	int ret;
> > > > +
> > > > +	lock_device_offline();
> > > > +	switch (buf[0]) {
> > > > +	case '0':
> > > > +		ret = device_offline(dev);
> > > > +		break;
> > > > +	case '1':
> > > > +		ret = device_online(dev);
> > > > +		break;
> > > 
> > > Should we also accept 'y', 'Y', 'n', and 'N', like most boolean sysfs
> > > files do?  I think we even have a kernel helper function for it
> > > somewhere...
> > 
> > Yes, we do, but it doesn't accept '0' as false. :-)
> 
> It doesn't?  That's crazy, and should be fixed.
> 
> > Well, I suppose I can modify that function and use it here.  What do
> > you think?
> 
> Yes please.

In fact, the function is OK, but http://lxr.free-electrons.com/source/lib/string.c#L549
shows it incorrectly.  I'll use strtobool() going forward.

> > > > +static DEFINE_MUTEX(device_offline_lock);
> > > > +
> > > > +void lock_device_offline(void)
> > > > +{
> > > > +	mutex_lock(&device_offline_lock);
> > > > +}
> > > > +
> > > > +void unlock_device_offline(void)
> > > > +{
> > > > +	mutex_unlock(&device_offline_lock);
> > > > +}
> > > 
> > > Why have functions?  Why not just do the mutex_lock/unlock instead
> > > everywhere?
> > 
> > Ah, that's something I forgot to write about in the changelog.
> > 
> > Patch [3/3] depends on that, because it has to take device_offline_lock around
> > a larger piece of code.  Specifically, it needs to put acpi_bus_trim() under
> > that lock too to avoid situations in which a previously offlined device would
> > be onlined from user space right before (or worse yet during) acpi_bus_trim()
> > (which would then remove it without offlining).
> > 
> > It is not necessary in [1/3], so I can move it to [3/3] if that's better.
> 
> No, that makes sense, but doesn't that mean you need to export the
> symbols as well?  Oh, nevermind, acpi can't be a module, that's fine.

Yup.  The exports may be added when someone needs them.

At the moment I'm working on untangling the ACPI processor driver which is
somewhat more complicated than I'd expected (oh well).  When that's done, I'll
post a more complete series of patches.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
