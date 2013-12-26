Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab3LZWxW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 17:53:22 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:34388 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916Ab3LZWxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 17:53:20 -0500
Date: Thu, 26 Dec 2013 14:53:17 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ims-pcu: Add commands supported by the new version of
 the FW
Message-ID: <20131226225317.GD18562@core.coreip.homeip.net>
References: <1387653408-10529-1-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387653408-10529-1-git-send-email-andrew.smirnov@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrey,

On Sat, Dec 21, 2013 at 11:16:48AM -0800, Andrey Smirnov wrote:
> New version of the PCU firmware supports two new commands:
>   - IMS_PCU_CMD_OFN_SET_CONFIG which allows to write data to the
>   registers of one finger navigation(OFN) chip present on the device
>   - IMS_PCU_CMD_OFN_GET_CONFIG which allows to read data form the
>   registers of said chip.
> 
> This commit adds two helper functions to use those commands and sysfs
> attributes to use them. It also exposes some OFN configuration
> parameters via sysfs.
> 
> Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
> ---
>  drivers/input/misc/ims-pcu.c | 274 +++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 263 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/input/misc/ims-pcu.c b/drivers/input/misc/ims-pcu.c
> index e204f26..050c960 100644
> --- a/drivers/input/misc/ims-pcu.c
> +++ b/drivers/input/misc/ims-pcu.c
> @@ -68,6 +68,9 @@ struct ims_pcu {
>  	char bl_version[IMS_PCU_BL_VERSION_LEN];
>  	char reset_reason[IMS_PCU_BL_RESET_REASON_LEN];
>  	int update_firmware_status;
> +	u8 device_id;
> +
> +	u8 ofn_reg_addr;
>  
>  	struct usb_interface *ctrl_intf;
>  
> @@ -371,6 +374,8 @@ static void ims_pcu_destroy_gamepad(struct ims_pcu *pcu)
>  #define IMS_PCU_CMD_GET_DEVICE_ID	0xae
>  #define IMS_PCU_CMD_SPECIAL_INFO	0xb0
>  #define IMS_PCU_CMD_BOOTLOADER		0xb1	/* Pass data to bootloader */
> +#define IMS_PCU_CMD_OFN_SET_CONFIG	0xb3
> +#define IMS_PCU_CMD_OFN_GET_CONFIG	0xb4
>  
>  /* PCU responses */
>  #define IMS_PCU_RSP_STATUS		0xc0
> @@ -389,6 +394,9 @@ static void ims_pcu_destroy_gamepad(struct ims_pcu *pcu)
>  #define IMS_PCU_RSP_GET_DEVICE_ID	0xce
>  #define IMS_PCU_RSP_SPECIAL_INFO	0xd0
>  #define IMS_PCU_RSP_BOOTLOADER		0xd1	/* Bootloader response */
> +#define IMS_PCU_RSP_OFN_SET_CONFIG	0xd2
> +#define IMS_PCU_RSP_OFN_GET_CONFIG	0xd3
> +
>  
>  #define IMS_PCU_RSP_EVNT_BUTTONS	0xe0	/* Unsolicited, button state */
>  #define IMS_PCU_GAMEPAD_MASK		0x0001ff80UL	/* Bits 7 through 16 */
> @@ -1216,6 +1224,226 @@ ims_pcu_update_firmware_status_show(struct device *dev,
>  static DEVICE_ATTR(update_firmware_status, S_IRUGO,
>  		   ims_pcu_update_firmware_status_show, NULL);
>  
> +enum pcu_ofn_offsets {
> +	OFN_REG_RESULT_LSB_OFFSET = 2,
> +	OFN_REG_RESULT_MSB_OFFSET = 3,
> +};
> +
> +static ssize_t ims_pcu_ofn_reg_data_show(struct device *dev,
> +					 struct device_attribute *dattr,
> +					 char *buf)
> +{
> +	struct usb_interface *intf = to_usb_interface(dev);
> +	struct ims_pcu *pcu = usb_get_intfdata(intf);
> +	int error;
> +
> +	mutex_lock(&pcu->cmd_mutex);
> +
> +	error = ims_pcu_execute_command(pcu, OFN_GET_CONFIG,
> +					&pcu->ofn_reg_addr,
> +					sizeof(pcu->ofn_reg_addr));
> +	if (error >= 0) {
> +		const s16 result = pcu->cmd_buf[OFN_REG_RESULT_MSB_OFFSET] << 8 |
> +			           pcu->cmd_buf[OFN_REG_RESULT_LSB_OFFSET];

const here seems overkill.

> +		if (result < 0)
> +			error = result;
> +		else
> +			error = scnprintf(buf, PAGE_SIZE, "%x\n", (u8)result);

Why cast to u8?

> +	}
> +
> +	mutex_unlock(&pcu->cmd_mutex);
> +
> +	return error;
> +}
> +
> +static ssize_t ims_pcu_ofn_reg_data_store(struct device *dev,
> +					  struct device_attribute *dattr,
> +					  const char *buf, size_t count)
> +{
> +	struct usb_interface *intf = to_usb_interface(dev);
> +	struct ims_pcu *pcu = usb_get_intfdata(intf);
> +	int error;
> +	int value;
> +	u8 buffer[2];
> +
> +	error = kstrtoint(buf, 0, &value);
> +	if (error)
> +		return error;
> +
> +	buffer[0] = pcu->ofn_reg_addr;
> +	buffer[1] = (u8) value;

If you want u8 we have kstrtou8().

> +
> +	mutex_lock(&pcu->cmd_mutex);
> +
> +	error = ims_pcu_execute_command(pcu, OFN_SET_CONFIG,
> +					&buffer, sizeof(buffer));
> +
> +	mutex_unlock(&pcu->cmd_mutex);
> +
> +	if (!error) {
> +		const s16 result = pcu->cmd_buf[OFN_REG_RESULT_MSB_OFFSET] << 8 |
> +			           pcu->cmd_buf[OFN_REG_RESULT_LSB_OFFSET];

You should not be checking contents of pcu->cmd_buf after releasing
mutex as someone else could be accessing the same sysfs attribute and
stomping on your data.

> +		error = result;

Does firmware guarantee that it would return errors that make sense to
Linux?

> +	}
> +
> +	return error ?: count;
> +}
> +
> +static DEVICE_ATTR(ofn_reg_data, S_IRUGO | S_IWUSR,
> +		   ims_pcu_ofn_reg_data_show, ims_pcu_ofn_reg_data_store);
> +
> +static ssize_t ims_pcu_ofn_reg_addr_show(struct device *dev,
> +					 struct device_attribute *dattr,
> +					 char *buf)
> +{
> +	struct usb_interface *intf = to_usb_interface(dev);
> +	struct ims_pcu *pcu = usb_get_intfdata(intf);
> +	int error;
> +
> +	mutex_lock(&pcu->cmd_mutex);
> +	error = scnprintf(buf, PAGE_SIZE, "%x\n", pcu->ofn_reg_addr);
> +	mutex_unlock(&pcu->cmd_mutex);
> +
> +	return error;
> +}
> +
> +static ssize_t ims_pcu_ofn_reg_addr_store(struct device *dev,
> +					  struct device_attribute *dattr,
> +					  const char *buf, size_t count)
> +{
> +	struct usb_interface *intf = to_usb_interface(dev);
> +	struct ims_pcu *pcu = usb_get_intfdata(intf);
> +	int error;
> +	int value;
> +
> +	error = kstrtoint(buf, 0, &value);
> +	if (error)
> +		return error;

kstrtou8().

> +
> +	mutex_lock(&pcu->cmd_mutex);
> +	pcu->ofn_reg_addr = (u8) value;
> +	mutex_unlock(&pcu->cmd_mutex);
> +
> +	return error ?: count;
> +}
> +
> +static DEVICE_ATTR(ofn_reg_addr, S_IRUGO | S_IWUSR,
> +		   ims_pcu_ofn_reg_addr_show, ims_pcu_ofn_reg_addr_store);
> +
> +static ssize_t ims_pcu_ofn_bit_show(u8 addr, u8 nr,
> +				    struct device *dev,
> +				    struct device_attribute *dattr,
> +				    char *buf)
> +{
> +	struct usb_interface *intf = to_usb_interface(dev);
> +	struct ims_pcu *pcu = usb_get_intfdata(intf);
> +	int error;
> +
> +	mutex_lock(&pcu->cmd_mutex);
> +
> +	error = ims_pcu_execute_command(pcu, OFN_GET_CONFIG,
> +					&addr, sizeof(addr));
> +	if (error >= 0) {
> +		const s16 result = pcu->cmd_buf[OFN_REG_RESULT_MSB_OFFSET] << 8 |
> +			           pcu->cmd_buf[OFN_REG_RESULT_LSB_OFFSET];
> +		if (result < 0)
> +			error = result;
> +		else
> +			error = scnprintf(buf, PAGE_SIZE, "%d\n",
> +					  !!(result & (1 << nr)));
> +	}
> +
> +	mutex_unlock(&pcu->cmd_mutex);
> +	return error;
> +}
> +
> +static ssize_t ims_pcu_ofn_bit_store(u8 addr, u8 nr,
> +				     struct device *dev,
> +				     struct device_attribute *dattr,
> +				     const char *buf, size_t count)
> +{
> +	struct usb_interface *intf = to_usb_interface(dev);
> +	struct ims_pcu *pcu = usb_get_intfdata(intf);
> +	int error;
> +	int value;
> +	u8 contents;
> +
> +
> +	error = kstrtoint(buf, 0, &value);
> +	if (error)
> +		return error;
> +
> +	if (value > 1)
> +		return -EINVAL;
> +
> +	mutex_lock(&pcu->cmd_mutex);
> +
> +	error = ims_pcu_execute_command(pcu, OFN_GET_CONFIG,
> +					&addr, sizeof(addr));
> +	if (error < 0)
> +		goto exit;
> +
> +	{

Generally dislike artificial code blocks. Please declare all needed
variables upfront.

> +		const s16 result = pcu->cmd_buf[OFN_REG_RESULT_MSB_OFFSET] << 8 |
> +			           pcu->cmd_buf[OFN_REG_RESULT_LSB_OFFSET];
> +		if (result < 0) {
> +			error = result;
> +			goto exit;
> +		}
> +		contents = (u8) result;
> +	}
> +
> +	if (value)
> +		contents |= 1 << nr;
> +	else
> +		contents &= ~(1 << nr);
> +
> +	{
> +		const u8 buffer[] = { addr, contents };
> +		error = ims_pcu_execute_command(pcu, OFN_SET_CONFIG,
> +						&buffer, sizeof(buffer));
> +	}
> +
> +exit:
> +	mutex_unlock(&pcu->cmd_mutex);
> +
> +	if (!error) {
> +		const s16 result = pcu->cmd_buf[OFN_REG_RESULT_MSB_OFFSET] << 8 |
> +			           pcu->cmd_buf[OFN_REG_RESULT_LSB_OFFSET];
> +		error = result;
> +	}
> +
> +	return error ?: count;
> +}
> +
> +
> +#define IMS_PCU_BIT_ATTR(name, addr, nr)				\
> +	static ssize_t ims_pcu_##name##_show(struct device *dev,	\
> +					     struct device_attribute *dattr, \
> +					     char *buf)			\
> +	{								\
> +		return ims_pcu_ofn_bit_show(addr, nr, dev, dattr, buf);	\
> +	}								\
> +									\
> +	static ssize_t ims_pcu_##name##_store(struct device *dev,	\
> +					      struct device_attribute *dattr, \
> +					      const char *buf, size_t count) \
> +	{								\
> +		return ims_pcu_ofn_bit_store(addr, nr, dev, dattr, buf, count); \
> +	}								\
> +									\
> +	static DEVICE_ATTR(name, S_IRUGO | S_IWUSR,			\
> +			   ims_pcu_##name##_show, ims_pcu_##name##_store)
> +
> +IMS_PCU_BIT_ATTR(ofn_engine_enable,   0x60, 7);
> +IMS_PCU_BIT_ATTR(ofn_speed_enable,    0x60, 6);
> +IMS_PCU_BIT_ATTR(ofn_assert_enable,   0x60, 5);
> +IMS_PCU_BIT_ATTR(ofn_xyquant_enable,  0x60, 4);
> +IMS_PCU_BIT_ATTR(ofn_xyscale_enable,  0x60, 1);
> +
> +IMS_PCU_BIT_ATTR(ofn_scale_x2,        0x63, 6);
> +IMS_PCU_BIT_ATTR(ofn_scale_y2,        0x63, 7);
> +
>  static struct attribute *ims_pcu_attrs[] = {
>  	&ims_pcu_attr_part_number.dattr.attr,
>  	&ims_pcu_attr_serial_number.dattr.attr,
> @@ -1226,6 +1454,18 @@ static struct attribute *ims_pcu_attrs[] = {
>  	&dev_attr_reset_device.attr,
>  	&dev_attr_update_firmware.attr,
>  	&dev_attr_update_firmware_status.attr,
> +
> +#define IMS_PCU_ATTRS_OFN_START_OFFSET (9)
> +
> +	&dev_attr_ofn_reg_data.attr,
> +	&dev_attr_ofn_reg_addr.attr,
> +	&dev_attr_ofn_engine_enable.attr,
> +	&dev_attr_ofn_speed_enable.attr,
> +	&dev_attr_ofn_assert_enable.attr,
> +	&dev_attr_ofn_xyquant_enable.attr,
> +	&dev_attr_ofn_xyscale_enable.attr,
> +	&dev_attr_ofn_scale_x2.attr,
> +	&dev_attr_ofn_scale_y2.attr,
>  	NULL
>  };
>  
> @@ -1244,8 +1484,21 @@ static umode_t ims_pcu_is_attr_visible(struct kobject *kobj,
>  			mode = 0;
>  		}
>  	} else {
> -		if (attr == &dev_attr_update_firmware_status.attr)
> +		if (attr == &dev_attr_update_firmware_status.attr) {
>  			mode = 0;
> +		} else if (pcu->device_id == 5) {
> +			/*
> +			   PCU-B devices, both GEN_1 and GEN_2(device_id == 5),
> +			   have no OFN sensor so exposing those attributes
> +			   for them does not make any sense
> +			*/
> +			int i;
> +			for (i = IMS_PCU_ATTRS_OFN_START_OFFSET; ims_pcu_attrs[i]; i++)
> +				if (attr == ims_pcu_attrs[i]) {
> +					mode = 0;
> +					break;
> +				}
> +		}
>  	}
>  
>  	return mode;
> @@ -1624,7 +1877,6 @@ static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
>  	static atomic_t device_no = ATOMIC_INIT(0);
>  
>  	const struct ims_pcu_device_info *info;
> -	u8 device_id;
>  	int error;
>  
>  	error = ims_pcu_get_device_info(pcu);
> @@ -1633,7 +1885,7 @@ static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
>  		return error;
>  	}
>  
> -	error = ims_pcu_identify_type(pcu, &device_id);
> +	error = ims_pcu_identify_type(pcu, &pcu->device_id);
>  	if (error) {
>  		dev_err(pcu->dev,
>  			"Failed to identify device, error: %d\n", error);
> @@ -1645,9 +1897,9 @@ static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
>  		return 0;
>  	}
>  
> -	if (device_id >= ARRAY_SIZE(ims_pcu_device_info) ||
> -	    !ims_pcu_device_info[device_id].keymap) {
> -		dev_err(pcu->dev, "Device ID %d is not valid\n", device_id);
> +	if (pcu->device_id >= ARRAY_SIZE(ims_pcu_device_info) ||
> +	    !ims_pcu_device_info[pcu->device_id].keymap) {
> +		dev_err(pcu->dev, "Device ID %d is not valid\n", pcu->device_id);
>  		/* Same as above, punt to userspace */
>  		return 0;
>  	}
> @@ -1659,7 +1911,7 @@ static int ims_pcu_init_application_mode(struct ims_pcu *pcu)
>  	if (error)
>  		return error;
>  
> -	info = &ims_pcu_device_info[device_id];
> +	info = &ims_pcu_device_info[pcu->device_id];
>  	error = ims_pcu_setup_buttons(pcu, info->keymap, info->keymap_len);
>  	if (error)
>  		goto err_destroy_backlight;
> @@ -1783,14 +2035,14 @@ static int ims_pcu_probe(struct usb_interface *intf,
>  	if (error)
>  		goto err_stop_io;
>  
> -	error = sysfs_create_group(&intf->dev.kobj, &ims_pcu_attr_group);
> -	if (error)
> -		goto err_stop_io;
> -
>  	error = pcu->bootloader_mode ?
>  			ims_pcu_init_bootloader_mode(pcu) :
>  			ims_pcu_init_application_mode(pcu);
>  	if (error)
> +		goto err_stop_io;
> +
> +	error = sysfs_create_group(&intf->dev.kobj, &ims_pcu_attr_group);
> +	if (error)
>  		goto err_remove_sysfs;

Why did you move sysfs group creation? Now one can not observe progress
of firmware update...

Thanks.

-- 
Dmitry
