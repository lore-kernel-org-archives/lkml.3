Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3L0QyM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 11:54:12 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:52333 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab3L0QyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 11:54:11 -0500
MIME-Version: 1.0
In-Reply-To: <20131226225317.GD18562@core.coreip.homeip.net>
References: <1387653408-10529-1-git-send-email-andrew.smirnov@gmail.com>
	<20131226225317.GD18562@core.coreip.homeip.net>
Date: Fri, 27 Dec 2013 08:54:10 -0800
Message-ID: <CAHQ1cqGPORvQQLbA_maguYU=e7hjEJu3O-zKvd4Jt7j0O6E-Tg@mail.gmail.com>
Subject: Re: [PATCH] ims-pcu: Add commands supported by the new version of the FW
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the spam, sent the first version of the reply in non plain/text.

>> +static ssize_t ims_pcu_ofn_reg_data_show(struct device *dev,
>> +                                      struct device_attribute *dattr,
>> +                                      char *buf)
>> +{
>> +     struct usb_interface *intf = to_usb_interface(dev);
>> +     struct ims_pcu *pcu = usb_get_intfdata(intf);
>> +     int error;
>> +
>> +     mutex_lock(&pcu->cmd_mutex);
>> +
>> +     error = ims_pcu_execute_command(pcu, OFN_GET_CONFIG,
>> +                                     &pcu->ofn_reg_addr,
>> +                                     sizeof(pcu->ofn_reg_addr));
>> +     if (error >= 0) {
>> +             const s16 result = pcu->cmd_buf[OFN_REG_RESULT_MSB_OFFSET] << 8 |
>> +                                pcu->cmd_buf[OFN_REG_RESULT_LSB_OFFSET];
>
> const here seems overkill.

That variable has a lifetime limited by the scope of if statement and
during that lifetime its value it constant, so I'm not sure I
understand what you mean by "overkill"?

I usually try to declare all of the variables values of which I do not
intend to change as constant to allow the compiler to hopefully make
more informed decision about optimizing that piece of code and also to
warn me when I go against my intention and try to change that value.
Also, IMHO, this makes it easier to read the code since from it's
declaration I know that that value would not be changed and I don't
have to wonder if I missed a line of code that actually changes it.

>
>> +             if (result < 0)
>> +                     error = result;
>> +             else
>> +                     error = scnprintf(buf, PAGE_SIZE, "%x\n", (u8)result);
>
> Why cast to u8?

Will fix in the next version.

>
>> +     }
>> +
>> +     mutex_unlock(&pcu->cmd_mutex);
>> +
>> +     return error;
>> +}
>> +
>> +static ssize_t ims_pcu_ofn_reg_data_store(struct device *dev,
>> +                                       struct device_attribute *dattr,
>> +                                       const char *buf, size_t count)
>> +{
>> +     struct usb_interface *intf = to_usb_interface(dev);
>> +     struct ims_pcu *pcu = usb_get_intfdata(intf);
>> +     int error;
>> +     int value;
>> +     u8 buffer[2];
>> +
>> +     error = kstrtoint(buf, 0, &value);
>> +     if (error)
>> +             return error;
>> +
>> +     buffer[0] = pcu->ofn_reg_addr;
>> +     buffer[1] = (u8) value;
>
> If you want u8 we have kstrtou8().

Ditto.

>
>> +
>> +     mutex_lock(&pcu->cmd_mutex);
>> +
>> +     error = ims_pcu_execute_command(pcu, OFN_SET_CONFIG,
>> +                                     &buffer, sizeof(buffer));
>> +
>> +     mutex_unlock(&pcu->cmd_mutex);
>> +
>> +     if (!error) {
>> +             const s16 result = pcu->cmd_buf[OFN_REG_RESULT_MSB_OFFSET] << 8 |
>> +                                pcu->cmd_buf[OFN_REG_RESULT_LSB_OFFSET];
>
> You should not be checking contents of pcu->cmd_buf after releasing
> mutex as someone else could be accessing the same sysfs attribute and
> stomping on your data.

Ditto.

>
>> +             error = result;
>
> Does firmware guarantee that it would return errors that make sense to
> Linux?

Firmware returns -ENOENT.

>
>> +     }
>> +
>> +     return error ?: count;
>> +}
>> +
>> +static DEVICE_ATTR(ofn_reg_data, S_IRUGO | S_IWUSR,
>> +                ims_pcu_ofn_reg_data_show, ims_pcu_ofn_reg_data_store);
>> +
>> +static ssize_t ims_pcu_ofn_reg_addr_show(struct device *dev,
>> +                                      struct device_attribute *dattr,
>> +                                      char *buf)
>> +{
>> +     struct usb_interface *intf = to_usb_interface(dev);
>> +     struct ims_pcu *pcu = usb_get_intfdata(intf);
>> +     int error;
>> +
>> +     mutex_lock(&pcu->cmd_mutex);
>> +     error = scnprintf(buf, PAGE_SIZE, "%x\n", pcu->ofn_reg_addr);
>> +     mutex_unlock(&pcu->cmd_mutex);
>> +
>> +     return error;
>> +}
>> +
>> +static ssize_t ims_pcu_ofn_reg_addr_store(struct device *dev,
>> +                                       struct device_attribute *dattr,
>> +                                       const char *buf, size_t count)
>> +{
>> +     struct usb_interface *intf = to_usb_interface(dev);
>> +     struct ims_pcu *pcu = usb_get_intfdata(intf);
>> +     int error;
>> +     int value;
>> +
>> +     error = kstrtoint(buf, 0, &value);
>> +     if (error)
>> +             return error;
>
> kstrtou8().

Will fix in the next version.

>
>> +
>> +     mutex_lock(&pcu->cmd_mutex);
>> +     pcu->ofn_reg_addr = (u8) value;
>> +     mutex_unlock(&pcu->cmd_mutex);
>> +
>> +     return error ?: count;
>> +}
>> +
>> +static DEVICE_ATTR(ofn_reg_addr, S_IRUGO | S_IWUSR,
>> +                ims_pcu_ofn_reg_addr_show, ims_pcu_ofn_reg_addr_store);
>> +
>> +static ssize_t ims_pcu_ofn_bit_show(u8 addr, u8 nr,
>> +                                 struct device *dev,
>> +                                 struct device_attribute *dattr,
>> +                                 char *buf)
>> +{
>> +     struct usb_interface *intf = to_usb_interface(dev);
>> +     struct ims_pcu *pcu = usb_get_intfdata(intf);
>> +     int error;
>> +
>> +     mutex_lock(&pcu->cmd_mutex);
>> +
>> +     error = ims_pcu_execute_command(pcu, OFN_GET_CONFIG,
>> +                                     &addr, sizeof(addr));
>> +     if (error >= 0) {
>> +             const s16 result = pcu->cmd_buf[OFN_REG_RESULT_MSB_OFFSET] << 8 |
>> +                                pcu->cmd_buf[OFN_REG_RESULT_LSB_OFFSET];
>> +             if (result < 0)
>> +                     error = result;
>> +             else
>> +                     error = scnprintf(buf, PAGE_SIZE, "%d\n",
>> +                                       !!(result & (1 << nr)));
>> +     }
>> +
>> +     mutex_unlock(&pcu->cmd_mutex);
>> +     return error;
>> +}
>> +
>> +static ssize_t ims_pcu_ofn_bit_store(u8 addr, u8 nr,
>> +                                  struct device *dev,
>> +                                  struct device_attribute *dattr,
>> +                                  const char *buf, size_t count)
>> +{
>> +     struct usb_interface *intf = to_usb_interface(dev);
>> +     struct ims_pcu *pcu = usb_get_intfdata(intf);
>> +     int error;
>> +     int value;
>> +     u8 contents;
>> +
>> +
>> +     error = kstrtoint(buf, 0, &value);
>> +     if (error)
>> +             return error;
>> +
>> +     if (value > 1)
>> +             return -EINVAL;
>> +
>> +     mutex_lock(&pcu->cmd_mutex);
>> +
>> +     error = ims_pcu_execute_command(pcu, OFN_GET_CONFIG,
>> +                                     &addr, sizeof(addr));
>> +     if (error < 0)
>> +             goto exit;
>> +
>> +     {
>
> Generally dislike artificial code blocks. Please declare all needed
> variables upfront.

This is done because pre '99 C standard does not allow for variable
declaration in the middle of the function and I wanted to have the
result variable to be constant.

But, sure, since you are the author of the driver I don't really want
to spend any time arguing coding styles, I'll change that in the next
version.

>
>> +             const s16 result = pcu->cmd_buf[OFN_REG_RESULT_MSB_OFFSET] << 8 |
>> +                                pcu->cmd_buf[OFN_REG_RESULT_LSB_OFFSET];
>> +             if (result < 0) {
>> +                     error = result;
>> +                     goto exit;
>> +             }
>> +             contents = (u8) result;
>> +     }
>> +
>> +     if (value)
>> +             contents |= 1 << nr;

>> @@ -1783,14 +2035,14 @@ static int ims_pcu_probe(struct usb_interface *intf,
>>       if (error)
>>               goto err_stop_io;
>>
>> -     error = sysfs_create_group(&intf->dev.kobj, &ims_pcu_attr_group);
>> -     if (error)
>> -             goto err_stop_io;
>> -
>>       error = pcu->bootloader_mode ?
>>                       ims_pcu_init_bootloader_mode(pcu) :
>>                       ims_pcu_init_application_mode(pcu);
>>       if (error)
>> +             goto err_stop_io;
>> +
>> +     error = sysfs_create_group(&intf->dev.kobj, &ims_pcu_attr_group);
>> +     if (error)
>>               goto err_remove_sysfs;
>
> Why did you move sysfs group creation? Now one can not observe progress
> of firmware update...

I need the device ID to be known before the sysfs group is created in
order to make the decision about OFN-related attributes visibility,
and for that I need "ims_pcu_init_application_mode" to be called
before "sysfs_create_group" call is made.

I see two potential ways of solving this problem:

 1. Split the calls to "ims_pcu_init_bootlader_mode" and
"ims_pcu_init_application_mode" and make the former after the group is
created and the latter before.
 2. Remove the "update_firmware_status" attribute (Does the userspace
in the system that uses this driver actually rely on this argument or
is just added for convenience? I know that they have a userspace tool
that they use to update the FW, so that's why I am wondering if they
ever use it to monitor the progress)

>
> Thanks.
>
> --
> Dmitry
