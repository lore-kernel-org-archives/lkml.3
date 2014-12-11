Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116AbaLKPub (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 10:50:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932909AbaLKPu3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 10:50:29 -0500
Date: Thu, 11 Dec 2014 10:50:11 -0500
From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
To: Peter Wu <peter@lekensteyn.nl>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Nestor Lopez Casado <nlopezcasad@logitech.com>,
        Peter Hutterer <peter.hutterer@who-t.net>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] HID: logitech-hidpp: prefix the name with Logitech
Message-ID: <20141211155011.GG29747@mail.corp.redhat.com>
References: <1418250070-28604-1-git-send-email-benjamin.tissoires@redhat.com>
 <1511661.CjWHljXQbp@al>
 <20141210231739.GD4861@mail.corp.redhat.com>
 <2407359.LsiQoHNGbj@al>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2407359.LsiQoHNGbj@al>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 11 2014 or thereabouts, Peter Wu wrote:
> On Wednesday 10 December 2014 18:17:40 Benjamin Tissoires wrote:
> > On Dec 11 2014 or thereabouts, Peter Wu wrote:
> > > On Wednesday 10 December 2014 17:21:10 Benjamin Tissoires wrote:
> > > > Current names are reported as "K750", "M705", and it can be misleading
> > > > for the users when they look at their input device list.
> > > > 
> > > > Prefixing the names with "Logitech " makes things better.
> > > 
> > > Doesn't this apply to all input devices? Like, every USB device can be
> > > queried for the manufacturer which could then by included by the input
> > > subsystem.
> > 
> > Yes and no. Yes, it's good to have the manufacturer name in the input
> > subsystem, and no, because usbhid already prepend the name with the
> > manufacturer.
> 
> I see, previously (and now, if the device name cannot be retrieved
> because one unplugs the receiver during probe which I have actually
> tested) a string such as "Logitech Unifying Device. Wireless PID:XXX"
> shows up. Now the only string visible is "M512".

Well, if you unplug the receiver during the probe(), the input nodes
should be cleared, so whatever the name you get, it does not really
matter.

> 
> Speaking of errors retrieving the name, if a device is turned off then
> the name cannot be queried using HID++ 2.0 (think of "T650" instead of
> "Wireless Rechargeable Touchpad T650"). Wouldn't this confuse userspace
> applications which rely on a constant name?

It will. However, this only matters for the devices which have a
HIDPP_QUIRK_DELAYED_INIT. We do not overwrite the name of the input node
for the others.

Making hidpp_connect_event() and wtp_connect() returning an error code
could help us not to create the input node until we have all the
information (setup parameters, and name).

This will require a little bit of tuning in the code. Again, I am not
sure I will have the time to do this today, so feel free to start a
first version on this if you want.

Many thanks for the deep analysis you are conducting on
hid-logitech-hidpp. This is really appreciated.

Cheers,
Benjamin

> 
> > > 
> > > What about duplicate names? Can this patch cause a conflict with devices
> > > having the same name?
> > 
> > I am not sure what you mean here. I am adding a prefix to the name, so I
> > do not see how a conflict can be possible. If there were a "M705" and a
> > "Logitech M705", with different wireless PID, that would be worrisome to
> > some extend.
> > But I am pretty sure this will not happen.
> 
> I thought that this name would be used for /dev/bus/hid/devices/XXX and
> therefore had to be unique, but this is not the case (the name is
> available under the input device). No worries then!
> 
> > > 
> > > > Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> > > > ---
> > > > 
> > > > Hi Jiri,
> > > > 
> > > > I'd love to see this one in 3.19 (after a strong review, of course).
> > > > The idea came with the mouse DPI database that Peter is currently working on
> > > > (see http://who-t.blogspot.com.au/2014/12/building-a-dpi-database-for-mice.html).
> > > > 
> > > > I think, if you do not qualify the series for 3.19, we should drop it entirely.
> > > > 3.19 introduces the hidpp module and changes the labels. The DPI hwdb will check
> > > > on the label to match the actual mouse, so if this one does not get into 3.19,
> > > > we will end up in 3 entries for each Logitech device.
> > > > 
> > > > Cheers,
> > > > Benjamin
> > > > 
> > > > 
> > > >  drivers/hid/hid-logitech-hidpp.c | 34 ++++++++++++++++++++++++++++++++++
> > > >  1 file changed, 34 insertions(+)
> > > > 
> > > > diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
> > > > index 3846305..8cf4352 100644
> > > > --- a/drivers/hid/hid-logitech-hidpp.c
> > > > +++ b/drivers/hid/hid-logitech-hidpp.c
> > > > @@ -282,6 +282,33 @@ static inline bool hidpp_report_is_connect_event(struct hidpp_report *report)
> > > >  		(report->rap.sub_id == 0x41);
> > > >  }
> > > >  
> > > > +/**
> > > > + * hidpp_prefix_name() prefixes the current given name with "Logitech ".
> > > > + */
> > > > +static void hidpp_prefix_name(char **name, int name_length)
> > > > +{
> > > > +#define PREFIX_SIZE 9 /* "Logitech " */
> > > > +
> > > > +	int new_length;
> > > > +	char *new_name;
> > > > +
> > > > +	if (name_length > PREFIX_SIZE &&
> > > > +	    strncmp(*name, "Logitech ", PREFIX_SIZE) == 0)
> > > 
> > > I think you meant || here, not &&.
> > 
> > No, I meant &&. The idea is to not add a prefix if the provided name
> > already contains the prefix. Read that as "if the size of the name may
> > contain the prefix and that the prefix is here, then we bail out".
> 
> Ah, I somehow read it as "if the name is longer than what can be
> stored".
> 
> > > 
> > > > +		/* The prefix has is already in the name */
> > > > +		return;
> > > > +
> > > > +	new_length = name_length + PREFIX_SIZE;
> > > 
> > > Stylistic note, but 'PREFIX_SIZE + name_length' would match the order of
> > > the string that gets prepended.
> > 
> > Works for me.
> > 
> > I will send a v2 with your comments addressed.
> 
> Thanks!
> 
> Kind regards,
> Peter
> 
> > Cheers,
> > Benjamin
> > 
> > > 
> > > Kind regards,
> > > Peter
> > > 
> > > > +	new_name = kzalloc(new_length, GFP_KERNEL);
> > > > +	if (!new_name)
> > > > +		return;
> > > > +
> > > > +	snprintf(new_name, new_length, "Logitech %s", *name);
> > > > +
> > > > +	kfree(*name);
> > > > +
> > > > +	*name = new_name;
> > > > +}
> > > > +
> > > >  /* -------------------------------------------------------------------------- */
> > > >  /* HIDP++ 1.0 commands                                                        */
> > > >  /* -------------------------------------------------------------------------- */
> > > > @@ -318,6 +345,10 @@ static char *hidpp_get_unifying_name(struct hidpp_device *hidpp_dev)
> > > >  		return NULL;
> > > >  
> > > >  	memcpy(name, &response.rap.params[2], len);
> > > > +
> > > > +	/* include the terminating '\0' */
> > > > +	hidpp_prefix_name(&name, len + 1);
> > > > +
> > > >  	return name;
> > > >  }
> > > >  
> > > > @@ -489,6 +520,9 @@ static char *hidpp_get_device_name(struct hidpp_device *hidpp)
> > > >  			feature_index, index, name + index,
> > > >  			__name_length - index);
> > > >  
> > > > +	/* include the terminating '\0' */
> > > > +	hidpp_prefix_name(&name, __name_length + 1);
> > > > +
> > > >  	return name;
> > > >  
> > > >  out_err:
> > > > 
> 
