Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3CPT4k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 15:56:40 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:53072 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3CPT4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 15:56:38 -0400
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqFwAPTNRFFV5qjOPGdsb2JhbABDh0uFILhDAgIBgWwXAwEBAQE4NYIqAQEEAScTHCMFCwgDDgcMJQ8FJQoaE4gOCsJ+FY1lVDwLB4JfYQOWXYYNjgE7
X-IronPort-AV: E=Sophos;i="4.84,857,1355094000"; 
   d="scan'208";a="517863293"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 16 Mar 2013 21:00:47 +0100
To: Benson Leung <bleung@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.torokhov@gmail.com, olofj@chromium.org, djkurtz@chromium.org,
        dudl@cypress.com
Subject: Re: [PATCH 2/4] Input: cyapa - Firmware update via request firmware
Message-ID: <20130316200047.GA6155@polaris.bitmath.org>
References: <1363218651-22457-1-git-send-email-bleung@chromium.org>
 <1363218651-22457-3-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363218651-22457-3-git-send-email-bleung@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benson,

> From: Daniel Kurtz <djkurtz@chromium.org>
> 
> Use the kernel request_firmware API to allow a hotplug script to load new
> firmware into CYAPA device.  When request_firmware is called by a driver,
> the kernel creates 'loading' and 'data' sysfs entries, and generates a
> firmware udev event containing the name of a file ("cyapa.bin").
> 
> A udev rule can detect this event and use the sysfs entries to provide the
> driver with the contents of a binary image firmware image. For instance,
> the gentoo distribution includes /lib/udev/rules.d/50-firmware.rules,
> which looks in /lib/firmware/ for a file matching the requested filename,
> and sends the file to the driver using its sysfs entries.
> 
> Userspace can initiate the firmware update procedure by copying cyapa.bin
> to /lib/firmware, and then writing anything to the device sysfs attribute:
>   /sys/bus/i2c/devices/7-0067/update_fw

Why do you need to trigger this from userland via sysfs?

> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> Signed-off-by: Benson Leung <bleung@chromium.org>
> ---
>  drivers/input/mouse/cyapa.c | 351 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 351 insertions(+)
> 
> diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> index a631aca..e622c25 100644
> --- a/drivers/input/mouse/cyapa.c
> +++ b/drivers/input/mouse/cyapa.c
> @@ -15,6 +15,7 @@
>   */
>  
>  #include <linux/delay.h>
> +#include <linux/firmware.h>
>  #include <linux/i2c.h>
>  #include <linux/input.h>
>  #include <linux/input/mt.h>
> @@ -116,6 +117,9 @@
>  #define BL_STATUS_SIZE  3  /* length of bootloader status registers */
>  #define BLK_HEAD_BYTES 32
>  
> +/* Macro for register map group offset. */
> +#define CYAPA_REG_MAP_SIZE  256
> +
>  #define PRODUCT_ID_SIZE  16
>  #define QUERY_DATA_SIZE  27
>  #define REG_PROTOCOL_GEN_QUERY_OFFSET  20
> @@ -220,6 +224,8 @@ struct cyapa {
>  	int physical_size_y;
>  };
>  
> +static const u8 bl_activate[] = { 0x00, 0xff, 0x38, 0x00, 0x01, 0x02, 0x03,
> +		0x04, 0x05, 0x06, 0x07 };
>  static const u8 bl_deactivate[] = { 0x00, 0xff, 0x3b, 0x00, 0x01, 0x02, 0x03,
>  		0x04, 0x05, 0x06, 0x07 };
>  static const u8 bl_exit[] = { 0x00, 0xff, 0xa5, 0x00, 0x01, 0x02, 0x03, 0x04,
> @@ -316,6 +322,41 @@ static const struct cyapa_cmd_len cyapa_smbus_cmds[] = {
>  	{ CYAPA_SMBUS_BLK_HEAD, 16 },
>  };
>  
> +#define CYAPA_FW_NAME		"cyapa.bin"
> +#define CYAPA_FW_BLOCK_SIZE	64
> +#define CYAPA_FW_HDR_START	0x0780
> +#define CYAPA_FW_HDR_BLOCK_COUNT  2
> +#define CYAPA_FW_HDR_BLOCK_START  (CYAPA_FW_HDR_START / CYAPA_FW_BLOCK_SIZE)
> +#define CYAPA_FW_HDR_SIZE	(CYAPA_FW_HDR_BLOCK_COUNT * \
> +				 CYAPA_FW_BLOCK_SIZE)
> +#define CYAPA_FW_DATA_START	0x0800
> +#define CYAPA_FW_DATA_BLOCK_COUNT  480
> +#define CYAPA_FW_DATA_BLOCK_START  (CYAPA_FW_DATA_START / CYAPA_FW_BLOCK_SIZE)
> +#define CYAPA_FW_DATA_SIZE	(CYAPA_FW_DATA_BLOCK_COUNT * \
> +				 CYAPA_FW_BLOCK_SIZE)
> +#define CYAPA_FW_SIZE		(CYAPA_FW_HDR_SIZE + CYAPA_FW_DATA_SIZE)
> +#define CYAPA_CMD_LEN		16
> +
> +#define BYTE_PER_LINE  8
> +void cyapa_dump_data(struct cyapa *cyapa, size_t length, const u8 *data)
> +{
> +#ifdef DEBUG
> +	struct device *dev = &cyapa->client->dev;
> +	int i;
> +	char buf[BYTE_PER_LINE * 3 + 1];
> +	char *s = buf;
> +
> +	for (i = 0; i < length; i++) {
> +		s += sprintf(s, " %02x", data[i]);
> +		if ((i + 1) == length || ((i + 1) % BYTE_PER_LINE) == 0) {
> +			dev_dbg(dev, "%s\n", buf);
> +			s = buf;
> +		}
> +	}
> +#endif
> +}
> +#undef BYTE_PER_LINE
> +
>  static ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
>  					u8 *values)
>  {
> @@ -498,6 +539,75 @@ static int cyapa_poll_state(struct cyapa *cyapa, unsigned int timeout)
>  	return (ret == -EAGAIN || ret == -ETIMEDOUT) ? -ETIMEDOUT : ret;
>  }
>  
> +/*
> + * Enter bootloader by soft resetting the device.
> + *
> + * If device is already in the bootloader, the function just returns.
> + * Otherwise, reset the device; after reset, device enters bootloader idle
> + * state immediately.
> + *
> + * Also, if device was unregister device from input core.  Device will
> + * re-register after it is detected following resumption of operational mode.
> + *
> + * Returns:
> + *   0 on success
> + *   -EAGAIN  device was reset, but is not now in bootloader idle state
> + *   < 0 if the device never responds within the timeout
> + */
> +static int cyapa_bl_enter(struct cyapa *cyapa)
> +{
> +	int ret;
> +
> +	if (cyapa->input) {
> +		disable_irq(cyapa->irq);
> +		input_unregister_device(cyapa->input);
> +		cyapa->input = NULL;
> +	}
> +
> +	ret = cyapa_get_state(cyapa);
> +	if (ret < 0)
> +		return ret;
> +	if (cyapa->state == CYAPA_STATE_BL_IDLE)
> +		return 0;
> +
> +	if (cyapa->state != CYAPA_STATE_OP)
> +		return -EAGAIN;
> +
> +	cyapa->state = CYAPA_STATE_NO_DEVICE;
> +	ret = cyapa_write_byte(cyapa, CYAPA_CMD_SOFT_RESET, 0x01);
> +	if (ret < 0)
> +		return -EIO;
> +
> +	usleep_range(25000, 50000);
> +	ret = cyapa_get_state(cyapa);
> +	if (ret < 0)
> +		return ret;
> +	if (cyapa->state != CYAPA_STATE_BL_IDLE)
> +		return -EAGAIN;
> +
> +	return 0;
> +}
> +
> +static int cyapa_bl_activate(struct cyapa *cyapa)
> +{
> +	int ret;
> +
> +	ret = cyapa_i2c_reg_write_block(cyapa, 0, sizeof(bl_activate),
> +					bl_activate);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* Wait for bootloader to activate; takes between 2 and 12 seconds */
> +	msleep(2000);
> +	ret = cyapa_poll_state(cyapa, 10000);
> +	if (ret < 0)
> +		return ret;
> +	if (cyapa->state != CYAPA_STATE_BL_ACTIVE)
> +		return -EAGAIN;
> +
> +	return 0;
> +}
> +
>  static int cyapa_bl_deactivate(struct cyapa *cyapa)
>  {
>  	int ret;
> @@ -682,6 +792,154 @@ static int cyapa_check_is_operational(struct cyapa *cyapa)
>  	return 0;
>  }
>  
> +static u16 cyapa_csum(const u8 *buf, size_t count)
> +{
> +	int i;
> +	u16 csum = 0;
> +
> +	for (i = 0; i < count; i++)
> +		csum += buf[i];
> +
> +	return csum;
> +}
> +
> +/*
> + * Write a |len| byte long buffer |buf| to the device, by chopping it up into a
> + * sequence of smaller |CYAPA_CMD_LEN|-length write commands.
> + *
> + * The data bytes for a write command are prepended with the 1-byte offset
> + * of the data relative to the start of |buf|.
> + */
> +static int cyapa_write_buffer(struct cyapa *cyapa, const u8 *buf, size_t len)
> +{
> +	int ret;
> +	size_t i;
> +	unsigned char cmd[CYAPA_CMD_LEN + 1];
> +	size_t cmd_len;
> +
> +	for (i = 0; i < len; i += CYAPA_CMD_LEN) {
> +		const u8 *payload = &buf[i];
> +		cmd_len = (len - i >= CYAPA_CMD_LEN) ? CYAPA_CMD_LEN : len - i;
> +		cmd[0] = i;
> +		memcpy(&cmd[1], payload, cmd_len);
> +
> +		ret = cyapa_i2c_reg_write_block(cyapa, 0, cmd_len + 1, cmd);
> +		if (ret < 0)
> +			return ret;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * A firmware block write command writes 64 bytes of data to a single flash
> + * page in the device.  The 78-byte block write command has the format:
> + *   <0xff> <CMD> <Key> <Start> <Data> <Data-Checksum> <CMD Checksum>
> + *
> + *  <0xff>  - every command starts with 0xff
> + *  <CMD>   - the write command value is 0x39
> + *  <Key>   - write commands include an 8-byte key: { 00 01 02 03 04 05 06 07 }
> + *  <Block> - Memory Block number (address / 64) (16-bit, big-endian)
> + *  <Data>  - 64 bytes of firmware image data
> + *  <Data Checksum> - sum of 64 <Data> bytes, modulo 0xff
> + *  <CMD Checksum> - sum of 77 bytes, from 0xff to <Data Checksum>
> + *
> + * Each write command is split into 5 i2c write transactions of up to 16 bytes.
> + * Each transaction starts with an i2c register offset: (00, 10, 20, 30, 40).
> + */
> +static int cyapa_write_fw_block(struct cyapa *cyapa, u16 block, const u8 *data)
> +{
> +	int ret;
> +	u8 cmd[78];
> +	u8 status[BL_STATUS_SIZE];
> +	int tries = 3;
> +
> +	/* set write command and security key bytes. */
> +	cmd[0] = 0xff;
> +	cmd[1] = 0x39;
> +	cmd[2] = 0x00;
> +	cmd[3] = 0x01;
> +	cmd[4] = 0x02;
> +	cmd[5] = 0x03;
> +	cmd[6] = 0x04;
> +	cmd[7] = 0x05;
> +	cmd[8] = 0x06;
> +	cmd[9] = 0x07;

Can't this be a command string somewhere as well?

> +	cmd[10] = block >> 8;
> +	cmd[11] = block;
> +	memcpy(&cmd[12], data, CYAPA_FW_BLOCK_SIZE);
> +	cmd[76] = cyapa_csum(data, CYAPA_FW_BLOCK_SIZE);
> +	cmd[77] = cyapa_csum(cmd, sizeof(cmd) - 1);
> +
> +	ret = cyapa_write_buffer(cyapa, cmd, sizeof(cmd));
> +	if (ret)
> +		return ret;
> +
> +	/* wait for write to finish */
> +	do {
> +		usleep_range(10000, 20000);
> +
> +		/* check block write command result status. */
> +		ret = cyapa_i2c_reg_read_block(cyapa, BL_HEAD_OFFSET,
> +					       BL_STATUS_SIZE, status);
> +		if (ret != BL_STATUS_SIZE)
> +			return (ret < 0) ? ret : -EIO;
> +		ret = (status[1] == 0x10 && status[2] == 0x20) ? 0 : -EIO;
> +	} while (--tries && ret);
> +
> +	return ret;
> +}
> +
> +/*
> + * Verify the integrity of a CYAPA firmware image file.
> + *
> + * The firmware image file is 30848 bytes, composed of 482 64-byte blocks.
> + *
> + * The first 2 blocks are the firmware header.
> + * The next 480 blocks are the firmware image.
> + *
> + * The first two bytes of the header hold the header checksum, computed by
> + * summing the other 126 bytes of the header.
> + * The last two bytes of the header hold the firmware image checksum, computed
> + * by summing the 30720 bytes of the image modulo 0xffff.
> + *
> + * Both checksums are stored little-endian.
> + */
> +static int cyapa_check_fw(struct cyapa *cyapa, const struct firmware *fw)
> +{
> +	struct device *dev = &cyapa->client->dev;
> +	u16 csum;
> +	u16 csum_expected;
> +
> +	/* Firmware must match exact 30848 bytes = 482 64-byte blocks. */
> +	if (fw->size != CYAPA_FW_SIZE) {
> +		dev_err(dev, "invalid firmware size = %zu, expected %u.\n",
> +			fw->size, CYAPA_FW_SIZE);
> +		return -EINVAL;
> +	}
> +
> +	/* Verify header block */
> +	csum_expected = (fw->data[0] << 8) | fw->data[1];
> +	csum = cyapa_csum(&fw->data[2], CYAPA_FW_HDR_SIZE - 2);
> +	if (csum != csum_expected) {
> +		dev_err(dev,
> +			"invalid fw header checksum = %04x, expected: %04x\n",
> +			csum, csum_expected);
> +		return -EINVAL;
> +	}
> +
> +	/* Verify firmware image */
> +	csum_expected = (fw->data[CYAPA_FW_HDR_SIZE - 2] << 8) |
> +			 fw->data[CYAPA_FW_HDR_SIZE - 1];
> +	csum = cyapa_csum(&fw->data[CYAPA_FW_HDR_SIZE], CYAPA_FW_DATA_SIZE);
> +	if (csum != csum_expected) {
> +		dev_err(dev,
> +			"invalid fw header checksum = %04x, expected: %04x\n",
> +			csum, csum_expected);
> +		return -EINVAL;
> +	}
> +	return 0;
> +}
> +
>  static irqreturn_t cyapa_irq(int irq, void *dev_id)
>  {
>  	struct cyapa *cyapa = dev_id;
> @@ -857,6 +1115,94 @@ static void cyapa_detect(struct cyapa *cyapa)
>  	}
>  }
>  
> +static int cyapa_firmware(struct cyapa *cyapa, const char *fw_name)
> +{
> +	struct device *dev = &cyapa->client->dev;
> +	int ret;
> +	const struct firmware *fw;
> +	int i;
> +
> +	ret = request_firmware(&fw, fw_name, dev);
> +	if (ret) {
> +		dev_err(dev, "Could not load firmware from %s, %d\n",
> +			fw_name, ret);
> +		return ret;
> +	}
> +
> +	ret = cyapa_check_fw(cyapa, fw);
> +	if (ret) {
> +		dev_err(dev, "Invalid CYAPA firmware image: %s\n", fw_name);
> +		goto done;
> +	}
> +
> +	ret = cyapa_bl_enter(cyapa);
> +	if (ret)
> +		goto err_detect;
> +
> +	ret = cyapa_bl_activate(cyapa);
> +	if (ret)
> +		goto err_detect;
> +
> +	/* First write data, starting at byte 128  of fw->data */
> +	for (i = 0; i < CYAPA_FW_DATA_BLOCK_COUNT; i++) {
> +		size_t block = CYAPA_FW_DATA_BLOCK_START + i;
> +		size_t addr = (i + CYAPA_FW_HDR_BLOCK_COUNT) *
> +				CYAPA_FW_BLOCK_SIZE;
> +		const u8 *data = &fw->data[addr];
> +		ret = cyapa_write_fw_block(cyapa, block, data);
> +		if (ret)
> +			goto err_detect;
> +	}
> +
> +	/* Then write checksum */
> +	for (i = 0; i < CYAPA_FW_HDR_BLOCK_COUNT; i++) {
> +		size_t block = CYAPA_FW_HDR_BLOCK_START + i;
> +		size_t addr = i * CYAPA_FW_BLOCK_SIZE;
> +		const u8 *data = &fw->data[addr];
> +		ret = cyapa_write_fw_block(cyapa, block, data);
> +		if (ret)
> +			goto err_detect;
> +	}
> +
> +err_detect:
> +	cyapa_detect(cyapa);
> +
> +done:
> +	release_firmware(fw);
> +	return ret;
> +}
> +
> +/*
> + * Sysfs Interface.
> + */
> +static ssize_t cyapa_update_fw_store(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct cyapa *cyapa = dev_get_drvdata(dev);
> +	const char *fw_name = CYAPA_FW_NAME;
> +	int ret;
> +
> +	ret = cyapa_firmware(cyapa, fw_name);
> +	if (ret)
> +		dev_err(dev, "firmware update failed, %d\n", ret);
> +	else
> +		dev_dbg(dev, "firmware update succeeded\n");
> +
> +	return ret ? ret : count;
> +}
> +
> +static DEVICE_ATTR(update_fw, S_IWUSR, NULL, cyapa_update_fw_store);
> +
> +static struct attribute *cyapa_sysfs_entries[] = {
> +	&dev_attr_update_fw.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group cyapa_sysfs_group = {
> +	.attrs = cyapa_sysfs_entries,
> +};
> +
>  static int cyapa_probe(struct i2c_client *client,
>  		       const struct i2c_device_id *dev_id)
>  {
> @@ -902,6 +1248,9 @@ static int cyapa_probe(struct i2c_client *client,
>  		goto err_unregister_device;
>  	}
>  
> +	if (sysfs_create_group(&client->dev.kobj, &cyapa_sysfs_group))
> +		dev_warn(dev, "error creating sysfs entries.\n");
> +

Would it not be neat to invoke the firmware update automatically instead?

>  	return 0;
>  
>  err_unregister_device:
> @@ -916,6 +1265,8 @@ static int cyapa_remove(struct i2c_client *client)
>  {
>  	struct cyapa *cyapa = i2c_get_clientdata(client);
>  
> +	sysfs_remove_group(&client->dev.kobj, &cyapa_sysfs_group);
> +
>  	free_irq(cyapa->irq, cyapa);
>  	input_unregister_device(cyapa->input);
>  	cyapa_set_power_mode(cyapa, PWR_MODE_OFF);
> -- 
> 1.8.1.3
> 

Thanks,
Henrik
