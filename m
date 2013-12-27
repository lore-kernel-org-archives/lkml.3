Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754727Ab3L0S1Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 13:27:25 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:48186 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3L0S1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 13:27:23 -0500
Date: Fri, 27 Dec 2013 10:27:14 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ims-pcu: Add commands supported by the new version of
 the FW
Message-ID: <20131227182713.GA11807@core.coreip.homeip.net>
References: <1387653408-10529-1-git-send-email-andrew.smirnov@gmail.com>
 <20131226225317.GD18562@core.coreip.homeip.net>
 <CAHQ1cqGPORvQQLbA_maguYU=e7hjEJu3O-zKvd4Jt7j0O6E-Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQ1cqGPORvQQLbA_maguYU=e7hjEJu3O-zKvd4Jt7j0O6E-Tg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 27, 2013 at 08:54:10AM -0800, Andrey Smirnov wrote:
> Sorry for the spam, sent the first version of the reply in non plain/text.
> 
> >> +static ssize_t ims_pcu_ofn_reg_data_show(struct device *dev,
> >> +                                      struct device_attribute *dattr,
> >> +                                      char *buf)
> >> +{
> >> +     struct usb_interface *intf = to_usb_interface(dev);
> >> +     struct ims_pcu *pcu = usb_get_intfdata(intf);
> >> +     int error;
> >> +
> >> +     mutex_lock(&pcu->cmd_mutex);
> >> +
> >> +     error = ims_pcu_execute_command(pcu, OFN_GET_CONFIG,
> >> +                                     &pcu->ofn_reg_addr,
> >> +                                     sizeof(pcu->ofn_reg_addr));
> >> +     if (error >= 0) {
> >> +             const s16 result = pcu->cmd_buf[OFN_REG_RESULT_MSB_OFFSET] << 8 |
> >> +                                pcu->cmd_buf[OFN_REG_RESULT_LSB_OFFSET];
> >
> > const here seems overkill.
> 
> That variable has a lifetime limited by the scope of if statement and
> during that lifetime its value it constant, so I'm not sure I
> understand what you mean by "overkill"?

I usually only bother with const when dealing with pointers and rarely
if ever for non-pointer arguments and local variables. That style mostly
matches the rest of the kernel.

[...]

> 
> >
> >> +             error = result;
> >
> > Does firmware guarantee that it would return errors that make sense to
> > Linux?
> 
> Firmware returns -ENOENT.

OK, still, I'd feel safer if we did something like

	if (result != 0)
		error = -EIO; /* or -ENOENT */

This way we can be sure that even if subsequent firmware version change
error codes for some reason we'd still be passing to the upper layer
Linux-specific ones.

[...]

> >>       if (error)
> >> +             goto err_stop_io;
> >> +
> >> +     error = sysfs_create_group(&intf->dev.kobj, &ims_pcu_attr_group);
> >> +     if (error)
> >>               goto err_remove_sysfs;
> >
> > Why did you move sysfs group creation? Now one can not observe progress
> > of firmware update...
> 
> I need the device ID to be known before the sysfs group is created in
> order to make the decision about OFN-related attributes visibility,
> and for that I need "ims_pcu_init_application_mode" to be called
> before "sysfs_create_group" call is made.
> 
> I see two potential ways of solving this problem:
> 
>  1. Split the calls to "ims_pcu_init_bootlader_mode" and
> "ims_pcu_init_application_mode" and make the former after the group is
> created and the latter before.
>  2. Remove the "update_firmware_status" attribute (Does the userspace
> in the system that uses this driver actually rely on this argument or
> is just added for convenience? I know that they have a userspace tool
> that they use to update the FW, so that's why I am wondering if they
> ever use it to monitor the progress)

The update_firmware_status attribute was a requirement from IMS. As far
as I know the flashing is done with standard udev facilities, so the
status is there to see what happened if something goes wrong. Still, I
believe we have to keep it.

I guess we can split the calls but even then ims_pcu_identify_type() may
fail and leave you with garbage device_id. Maybe we should alter
ims_pcu_is_attr_visible() to do:

	if (pcu->bootloader_mode) {
		...
	} else {
		if (pcu->setup_complete) {
			check_if_ofn_attrs_should_be_visible;
		}
	}

and then do 

	ysfs_update_group(&pcu->dev->kobj, &ims_pcu_attr_group);

at the end of ims_pcu_init_application_mode().

Thanks.

-- 
Dmitry
