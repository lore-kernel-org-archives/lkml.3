Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab3BIROY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 12:14:24 -0500
Received: from smtprelay-h22.telenor.se ([195.54.99.197]:58054 "EHLO
	smtprelay-h22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760757Ab3BIROW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 12:14:22 -0500
X-SENDER-IP: [85.230.168.206]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnVeAF6DFlFV5qjOOWdsb2JhbABFiwW1EwSBCBcDAQEBASEXNIIfAQEEAScTHCMFCwgDDhMlDwUlChoTiAsKvw0VjWqDKmEDliOGAY1a
X-IronPort-AV: E=Sophos;i="4.84,635,1355094000"; 
   d="scan'208";a="274620074"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Sat, 9 Feb 2013 18:14:28 +0100
To: Benson Leung <bleung@chromium.org>
Cc: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, khali@linux-fr.org, olofj@chromium.org,
        djkurtz@chromium.org, dudl@cypress.com
Subject: Re: [PATCH 1/1] Input: mouse: cyapa - Add support for cyapa smbus
 protocol
Message-ID: <20130209171428.GA1435@polaris.bitmath.org>
References: <1359673513-22328-1-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359673513-22328-1-git-send-email-bleung@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benson,

> This patch adds support for the Cypress APA Smbus Trackpad type,
> which uses a modified register map that fits within the
> limitations of the smbus protocol.
> 
> Devices that use this protocol include:
> CYTRA-116001-00 - Samsung Series 5 550 Chromebook trackpad
> CYTRA-103002-00 - Acer C7 Chromebook trackpad
> 
> Signed-off-by: Dudley Du <dudl@cypress.com>
> Signed-off-by: Benson Leung <bleung@chromium.org>
> Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  drivers/input/mouse/cyapa.c | 184 ++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 179 insertions(+), 5 deletions(-)

Looking good, thank you. Just a really tiny style comment inline.

> diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
> index 1a14688..4ce0cb4 100644
> --- a/drivers/input/mouse/cyapa.c
> +++ b/drivers/input/mouse/cyapa.c
> @@ -208,6 +208,7 @@ struct cyapa {
>  	char phys[32];	/* device physical location */
>  	int irq;
>  	bool irq_wake;  /* irq wake is enabled */
> +	bool smbus;
>  
>  	/* read from query data region. */
>  	char product_id[16];
> @@ -229,6 +230,60 @@ struct cyapa_cmd_len {
>  	u8 len;
>  };
>  
> +#define CYAPA_ADAPTER_FUNC_NONE   0
> +#define CYAPA_ADAPTER_FUNC_I2C    1
> +#define CYAPA_ADAPTER_FUNC_SMBUS  2
> +#define CYAPA_ADAPTER_FUNC_BOTH   3
> +
> +/*
> + * macros for SMBus communication
> + */
> +#define SMBUS_READ   0x01
> +#define SMBUS_WRITE 0x00
> +#define SMBUS_ENCODE_IDX(cmd, idx) ((cmd) | (((idx) & 0x03) << 1))
> +#define SMBUS_ENCODE_RW(cmd, rw) ((cmd) | ((rw) & 0x01))
> +#define SMBUS_BYTE_BLOCK_CMD_MASK 0x80
> +#define SMBUS_GROUP_BLOCK_CMD_MASK 0x40
> +
> + /* for byte read/write command */
> +#define CMD_RESET 0
> +#define CMD_POWER_MODE 1
> +#define CMD_DEV_STATUS 2
> +#define SMBUS_BYTE_CMD(cmd) (((cmd) & 0x3f) << 1)
> +#define CYAPA_SMBUS_RESET SMBUS_BYTE_CMD(CMD_RESET)
> +#define CYAPA_SMBUS_POWER_MODE SMBUS_BYTE_CMD(CMD_POWER_MODE)
> +#define CYAPA_SMBUS_DEV_STATUS SMBUS_BYTE_CMD(CMD_DEV_STATUS)
> +
> + /* for group registers read/write command */
> +#define REG_GROUP_DATA 0
> +#define REG_GROUP_CMD 2
> +#define REG_GROUP_QUERY 3
> +#define SMBUS_GROUP_CMD(grp) (0x80 | (((grp) & 0x07) << 3))
> +#define CYAPA_SMBUS_GROUP_DATA SMBUS_GROUP_CMD(REG_GROUP_DATA)
> +#define CYAPA_SMBUS_GROUP_CMD SMBUS_GROUP_CMD(REG_GROUP_CMD)
> +#define CYAPA_SMBUS_GROUP_QUERY SMBUS_GROUP_CMD(REG_GROUP_QUERY)
> +
> + /* for register block read/write command */
> +#define CMD_BL_STATUS 0
> +#define CMD_BL_HEAD 1
> +#define CMD_BL_CMD 2
> +#define CMD_BL_DATA 3
> +#define CMD_BL_ALL 4
> +#define CMD_BLK_PRODUCT_ID 5
> +#define CMD_BLK_HEAD 6
> +#define SMBUS_BLOCK_CMD(cmd) (0xc0 | (((cmd) & 0x1f) << 1))
> +
> +/* register block read/write command in bootloader mode */
> +#define CYAPA_SMBUS_BL_STATUS SMBUS_BLOCK_CMD(CMD_BL_STATUS)
> +#define CYAPA_SMBUS_BL_HEAD SMBUS_BLOCK_CMD(CMD_BL_HEAD)
> +#define CYAPA_SMBUS_BL_CMD SMBUS_BLOCK_CMD(CMD_BL_CMD)
> +#define CYAPA_SMBUS_BL_DATA SMBUS_BLOCK_CMD(CMD_BL_DATA)
> +#define CYAPA_SMBUS_BL_ALL SMBUS_BLOCK_CMD(CMD_BL_ALL)
> +
> +/* register block read/write command in operational mode */
> +#define CYAPA_SMBUS_BLK_PRODUCT_ID SMBUS_BLOCK_CMD(CMD_BLK_PRODUCT_ID)
> +#define CYAPA_SMBUS_BLK_HEAD SMBUS_BLOCK_CMD(CMD_BLK_HEAD)
> +
>  static const struct cyapa_cmd_len cyapa_i2c_cmds[] = {
>  	{ CYAPA_OFFSET_SOFT_RESET, 1 },
>  	{ REG_OFFSET_COMMAND_BASE + 1, 1 },
> @@ -245,6 +300,22 @@ static const struct cyapa_cmd_len cyapa_i2c_cmds[] = {
>  	{ REG_OFFSET_DATA_BASE, 32 }
>  };
>  
> +static const struct cyapa_cmd_len cyapa_smbus_cmds[] = {
> +	{ CYAPA_SMBUS_RESET, 1 },
> +	{ CYAPA_SMBUS_POWER_MODE, 1 },
> +	{ CYAPA_SMBUS_DEV_STATUS, 1 },
> +	{ CYAPA_SMBUS_GROUP_DATA, sizeof(struct cyapa_reg_data) },
> +	{ CYAPA_SMBUS_GROUP_CMD, 2 },
> +	{ CYAPA_SMBUS_GROUP_QUERY, QUERY_DATA_SIZE },
> +	{ CYAPA_SMBUS_BL_STATUS, 3 },
> +	{ CYAPA_SMBUS_BL_HEAD, 16 },
> +	{ CYAPA_SMBUS_BL_CMD, 16 },
> +	{ CYAPA_SMBUS_BL_DATA, 16 },
> +	{ CYAPA_SMBUS_BL_ALL, 32 },
> +	{ CYAPA_SMBUS_BLK_PRODUCT_ID, PRODUCT_ID_SIZE },
> +	{ CYAPA_SMBUS_BLK_HEAD, 16 },
> +};
> +
>  static ssize_t cyapa_i2c_reg_read_block(struct cyapa *cyapa, u8 reg, size_t len,
>  					u8 *values)
>  {
> @@ -257,26 +328,96 @@ static ssize_t cyapa_i2c_reg_write_block(struct cyapa *cyapa, u8 reg,
>  	return i2c_smbus_write_i2c_block_data(cyapa->client, reg, len, values);
>  }
>  
> +/*
> + * cyapa_smbus_read_block - perform smbus block read command
> + * @cyapa  - private data structure of the driver
> + * @cmd    - the properly encoded smbus command
> + * @len    - expected length of smbus command result
> + * @values - buffer to store smbus command result
> + *
> + * Returns negative errno, else the number of bytes written.
> + *
> + * Note:
> + * In trackpad device, the memory block allocated for I2C register map
> + * is 256 bytes, so the max read block for I2C bus is 256 bytes.
> + */
> +static ssize_t cyapa_smbus_read_block(struct cyapa *cyapa, u8 cmd, size_t len,
> +				      u8 *values)
> +{
> +	ssize_t ret;
> +	u8 index;
> +	u8 smbus_cmd;
> +	u8 *buf;
> +	struct i2c_client *client = cyapa->client;
> +	struct device *dev = &client->dev;
> +
> +	if (!(SMBUS_BYTE_BLOCK_CMD_MASK & cmd))
> +		return -EINVAL;
> +
> +	if (SMBUS_GROUP_BLOCK_CMD_MASK & cmd) {
> +		/* read specific block registers command. */
> +		smbus_cmd = SMBUS_ENCODE_RW(cmd, SMBUS_READ);
> +		ret = i2c_smbus_read_block_data(client, smbus_cmd, values);
> +		goto out;
> +	}
> +
> +	ret = 0;
> +	for (index = 0; index * I2C_SMBUS_BLOCK_MAX < len; index++) {
> +		smbus_cmd = SMBUS_ENCODE_IDX(cmd, index);
> +		smbus_cmd = SMBUS_ENCODE_RW(smbus_cmd, SMBUS_READ);
> +		buf = values + I2C_SMBUS_BLOCK_MAX * index;
> +		ret = i2c_smbus_read_block_data(client, smbus_cmd, buf);
> +		if (ret < 0)
> +			goto out;
> +	}
> +
> +out:
> +
> +	return (ret > 0) ? len : ret;
> +}
> +
>  static s32 cyapa_read_byte(struct cyapa *cyapa, u8 cmd_idx)
>  {
> -	u8 cmd = cyapa_i2c_cmds[cmd_idx].cmd;
> +	struct device *dev = &cyapa->client->dev;
> +	u8 cmd;
>  
> +	if (cyapa->smbus) {
> +		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
> +		cmd = SMBUS_ENCODE_RW(cmd, SMBUS_READ);
> +	} else {
> +		cmd = cyapa_i2c_cmds[cmd_idx].cmd;
> +	}
>  	return i2c_smbus_read_byte_data(cyapa->client, cmd);
>  }
>  
>  static s32 cyapa_write_byte(struct cyapa *cyapa, u8 cmd_idx, u8 value)
>  {
> -	u8 cmd = cyapa_i2c_cmds[cmd_idx].cmd;
> +	struct device *dev = &cyapa->client->dev;
> +	u8 cmd;
>  
> +	if (cyapa->smbus) {
> +		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
> +		cmd = SMBUS_ENCODE_RW(cmd, SMBUS_WRITE);
> +	} else {
> +		cmd = cyapa_i2c_cmds[cmd_idx].cmd;
> +	}
>  	return i2c_smbus_write_byte_data(cyapa->client, cmd, value);
>  }
>  
>  static ssize_t cyapa_read_block(struct cyapa *cyapa, u8 cmd_idx, u8 *values)
>  {
> -	u8 cmd = cyapa_i2c_cmds[cmd_idx].cmd;
> -	size_t len = cyapa_i2c_cmds[cmd_idx].len;
> +	u8 cmd;
> +	size_t len;
>  
> -	return cyapa_i2c_reg_read_block(cyapa, cmd, len, values);
> +	if (cyapa->smbus) {
> +		cmd = cyapa_smbus_cmds[cmd_idx].cmd;
> +		len = cyapa_smbus_cmds[cmd_idx].len;
> +		return cyapa_smbus_read_block(cyapa, cmd, len, values);
> +	} else {
> +		cmd = cyapa_i2c_cmds[cmd_idx].cmd;
> +		len = cyapa_i2c_cmds[cmd_idx].len;
> +		return cyapa_i2c_reg_read_block(cyapa, cmd, len, values);
> +	}
>  }
>  
>  /*
> @@ -298,6 +439,16 @@ static int cyapa_get_state(struct cyapa *cyapa)
>  	 */
>  	ret = cyapa_i2c_reg_read_block(cyapa, BL_HEAD_OFFSET, BL_STATUS_SIZE,
>  				       status);
> +
> +	/*
> +	 * On smbus systems in OP mode, the i2c_reg_read will fail with
> +	 * -ETIMEDOUT.  In this case, try again using the smbus equivalent
> +	 * command.  This should return a BL_HEAD indicating CYAPA_STATE_OP.
> +	 */
> +	if (cyapa->smbus && (ret == -ETIMEDOUT || ret == -ENXIO)) {
> +		ret = cyapa_read_block(cyapa, CYAPA_CMD_BL_STATUS, status);
> +	}

It is customary to skip brackets for single expressions.

> +
>  	if (ret != BL_STATUS_SIZE)
>  		goto error;
>  
> @@ -594,6 +745,19 @@ out:
>  	return IRQ_HANDLED;
>  }
>  
> +static u8 cyapa_check_adapter_functionality(struct i2c_client *client)
> +{
> +	u8 ret = CYAPA_ADAPTER_FUNC_NONE;
> +
> +	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
> +		ret |= CYAPA_ADAPTER_FUNC_I2C;
> +	if (i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA |
> +				     I2C_FUNC_SMBUS_BLOCK_DATA |
> +				     I2C_FUNC_SMBUS_I2C_BLOCK))
> +		ret |= CYAPA_ADAPTER_FUNC_SMBUS;
> +	return ret;
> +}
> +
>  static int cyapa_create_input_dev(struct cyapa *cyapa)
>  {
>  	struct device *dev = &cyapa->client->dev;
> @@ -668,9 +832,16 @@ static int cyapa_probe(struct i2c_client *client,
>  		       const struct i2c_device_id *dev_id)
>  {
>  	int ret;
> +	u8 adapter_func;
>  	struct cyapa *cyapa;
>  	struct device *dev = &client->dev;
>  
> +	adapter_func = cyapa_check_adapter_functionality(client);
> +	if (adapter_func == CYAPA_ADAPTER_FUNC_NONE) {
> +		dev_err(dev, "not a supported I2C/SMBus adapter\n");
> +		return -EIO;
> +	}
> +
>  	cyapa = kzalloc(sizeof(struct cyapa), GFP_KERNEL);
>  	if (!cyapa) {
>  		dev_err(dev, "allocate memory for cyapa failed\n");
> @@ -683,6 +854,9 @@ static int cyapa_probe(struct i2c_client *client,
>  	sprintf(cyapa->phys, "i2c-%d-%04x/input0", client->adapter->nr,
>  		client->addr);
>  
> +	/* i2c isn't supported, set smbus */
> +	if (adapter_func == CYAPA_ADAPTER_FUNC_SMBUS)
> +		cyapa->smbus = true;
>  	cyapa->state = CYAPA_STATE_NO_DEVICE;
>  	ret = cyapa_check_is_operational(cyapa);
>  	if (ret) {
> -- 
> 1.8.1
> 

Thanks,
Henrik
