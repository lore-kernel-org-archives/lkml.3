Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080AbaGGI1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:27:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54969 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaGGI1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:27:16 -0400
Date: Mon, 7 Jul 2014 10:27:11 +0200
From: Jean Delvare <jdelvare@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wolfram Sang <wsa@the-dreams.de>, Randy Dunlap <rdunlap@infradead.org>,
        linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] i2c: stub: Add support for SMBus block commands
Message-ID: <20140707102711.1b630fe2@endymion.delvare>
In-Reply-To: <1404705312-27633-1-git-send-email-linux@roeck-us.net>
References: <1404705312-27633-1-git-send-email-linux@roeck-us.net>
Organization: SUSE Linux
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Sun,  6 Jul 2014 20:55:12 -0700, Guenter Roeck wrote:
> SMBus block commands are different to I2C block commands since
> the returned data is not normally accessible with byte or word
> commands on other command offsets. Add linked list of 'block'
> commands to support those commands.
> 
> Access mechanism is quite simple: Block commands must be written
> before they can be read. The first write selects the block length.
> Subsequent writes can be partial. Block read commands always return
> the number of bytes selected with the first write.

Very smart, I like it.

> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> ---
>  Documentation/i2c/i2c-stub |  7 +++-
>  drivers/i2c/i2c-stub.c     | 96 ++++++++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 98 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/i2c/i2c-stub b/Documentation/i2c/i2c-stub
> index fa4b669..8a112cc 100644
> --- a/Documentation/i2c/i2c-stub
> +++ b/Documentation/i2c/i2c-stub
> @@ -2,9 +2,9 @@ MODULE: i2c-stub
>  
>  DESCRIPTION:
>  
> -This module is a very simple fake I2C/SMBus driver.  It implements five
> +This module is a very simple fake I2C/SMBus driver.  It implements six
>  types of SMBus commands: write quick, (r/w) byte, (r/w) byte data, (r/w)
> -word data, and (r/w) I2C block data.
> +word data, (r/w) I2C block data, and (r/w) SMBus block data.
>  
>  You need to provide chip addresses as a module parameter when loading this
>  driver, which will then only react to SMBus commands to these addresses.
> @@ -19,6 +19,9 @@ A pointer register with auto-increment is implemented for all byte
>  operations.  This allows for continuous byte reads like those supported by
>  EEPROMs, among others.
>  
> +SMBus block commands must be written to configure an SMBus command for
> +SMBus block operations. The first SMBus block write selects the block length.

I think you should add valuable parts of the patch description here:
"Subsequent writes can be partial. Block read commands always return
the number of bytes selected with the first write."

> +
>  The typical use-case is like this:
>  	1. load this module
>  	2. use i2cset (from the i2c-tools project) to pre-load some data
> diff --git a/drivers/i2c/i2c-stub.c b/drivers/i2c/i2c-stub.c
> index 77e4849..e08aa9d 100644
> --- a/drivers/i2c/i2c-stub.c
> +++ b/drivers/i2c/i2c-stub.c
> @@ -27,11 +27,12 @@
>  #include <linux/slab.h>
>  #include <linux/errno.h>
>  #include <linux/i2c.h>
> +#include <linux/list.h>
>  
>  #define MAX_CHIPS 10
>  #define STUB_FUNC (I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE | \
>  		   I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA | \
> -		   I2C_FUNC_SMBUS_I2C_BLOCK)
> +		   I2C_FUNC_SMBUS_I2C_BLOCK | I2C_FUNC_SMBUS_BLOCK_DATA)

As discussed earlier, I don't think SMBus block support should be
enabled by default, as it can confuse some device drivers. I think we
want:

#define STUB_FUNC_DEFAULT \
	(I2C_FUNC_SMBUS_QUICK | I2C_FUNC_SMBUS_BYTE | \
	 I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA | \
	 I2C_FUNC_SMBUS_I2C_BLOCK)

#define STUB_FUNC_ALL \
	(STUB_FUNC_DEFAULT | I2C_FUNC_SMBUS_BLOCK_DATA)

static unsigned long functionality = STUB_FUNC_DEFAULT;

static u32 stub_func(struct i2c_adapter *adapter)
{
	return STUB_FUNC_ALL & functionality;
}

Would that be OK with you? You'd simply need to load the driver with
functionality=0xffffffff to get the SMBus block support.

>  
>  static unsigned short chip_addr[MAX_CHIPS];
>  module_param_array(chip_addr, ushort, NULL, S_IRUGO);
> @@ -42,14 +43,44 @@ static unsigned long functionality = STUB_FUNC;
>  module_param(functionality, ulong, S_IRUGO | S_IWUSR);
>  MODULE_PARM_DESC(functionality, "Override functionality bitfield");
>  
> +struct smbus_block_data {
> +	struct list_head node;
> +	u8 command;
> +	u8 len;
> +	u8 block[I2C_SMBUS_BLOCK_MAX];
> +};
> +
>  struct stub_chip {
>  	u8 pointer;
>  	u16 words[256];		/* Byte operations use the LSB as per SMBus
>  				   specification */
> +	struct list_head smbus_blocks;
>  };
>  
>  static struct stub_chip *stub_chips;
>  
> +static struct smbus_block_data *stub_find_block(struct device *dev,
> +						struct stub_chip *chip,
> +						u8 command, bool create)
> +{
> +	struct smbus_block_data *b, *rb = NULL;
> +
> +	list_for_each_entry(b, &chip->smbus_blocks, node) {
> +		if (b->command == command) {
> +			rb = b;
> +			break;
> +		}
> +	}
> +	if (rb == NULL && create) {
> +		rb = devm_kzalloc(dev, sizeof(*b), GFP_KERNEL);

While this is exactly the same, sizeof(*rb) might be more intuitive and
make static code analyzers happier too.

> +		if (rb == NULL)
> +			return rb;
> +		rb->command = command;
> +		list_add(&rb->node, &chip->smbus_blocks);
> +	}
> +	return rb;
> +}
> +
>  /* Return negative errno on error. */
>  static s32 stub_xfer(struct i2c_adapter *adap, u16 addr, unsigned short flags,
>  	char read_write, u8 command, int size, union i2c_smbus_data *data)
> @@ -57,6 +88,7 @@ static s32 stub_xfer(struct i2c_adapter *adap, u16 addr, unsigned short flags,
>  	s32 ret;
>  	int i, len;
>  	struct stub_chip *chip = NULL;
> +	struct smbus_block_data *b;
>  
>  	/* Search for the right chip */
>  	for (i = 0; i < MAX_CHIPS && chip_addr[i]; i++) {
> @@ -68,6 +100,8 @@ static s32 stub_xfer(struct i2c_adapter *adap, u16 addr, unsigned short flags,
>  	if (!chip)
>  		return -ENODEV;
>  
> +	b = stub_find_block(&adap->dev, chip, command, false);

I'm not too happy to see this executed with every command. That's one
function call plus one list search, this isn't cheap. I would prefer if
this was only executed for actual SMBus block transfers. I think this
is possible, see below.

> +
>  	switch (size) {
>  
>  	case I2C_SMBUS_QUICK:
> @@ -93,13 +127,20 @@ static s32 stub_xfer(struct i2c_adapter *adap, u16 addr, unsigned short flags,
>  
>  	case I2C_SMBUS_BYTE_DATA:
>  		if (read_write == I2C_SMBUS_WRITE) {
> +			if (b) {
> +				ret = -EINVAL;
> +				break;
> +			}

Is this really necessary? I very much doubt a device driver would do
that in the first place. And if it did, would a real device actually
fail?

>  			chip->words[command] &= 0xff00;
>  			chip->words[command] |= data->byte;
>  			dev_dbg(&adap->dev,
>  				"smbus byte data - addr 0x%02x, wrote 0x%02x at 0x%02x.\n",
>  				addr, data->byte, command);
>  		} else {
> -			data->byte = chip->words[command] & 0xff;
> +			if (b)
> +				data->byte = b->len;
> +			else
> +				data->byte = chip->words[command] & 0xff;

You could avoid this conditional (and the same below in case
I2C_SMBUS_WORD_DATA) by writing to chip->words at the same time you
write to b->block. Block transfers being rare and reads occurring more
frequently than writes, I think the performance benefit is clear.

>  			dev_dbg(&adap->dev,
>  				"smbus byte data - addr 0x%02x, read  0x%02x at 0x%02x.\n",
>  				addr, data->byte, command);
> @@ -111,12 +152,19 @@ static s32 stub_xfer(struct i2c_adapter *adap, u16 addr, unsigned short flags,
>  
>  	case I2C_SMBUS_WORD_DATA:
>  		if (read_write == I2C_SMBUS_WRITE) {
> +			if (b) {
> +				ret = -EINVAL;
> +				break;
> +			}
>  			chip->words[command] = data->word;
>  			dev_dbg(&adap->dev,
>  				"smbus word data - addr 0x%02x, wrote 0x%04x at 0x%02x.\n",
>  				addr, data->word, command);
>  		} else {
> -			data->word = chip->words[command];
> +			if (b)
> +				data->word = (b->block[0] << 8) | b->len;
> +			else
> +				data->word = chip->words[command];
>  			dev_dbg(&adap->dev,
>  				"smbus word data - addr 0x%02x, read  0x%04x at 0x%02x.\n",
>  				addr, data->word, command);
> @@ -148,6 +196,46 @@ static s32 stub_xfer(struct i2c_adapter *adap, u16 addr, unsigned short flags,
>  		ret = 0;
>  		break;
>  
> +	case I2C_SMBUS_BLOCK_DATA:
> +		if (read_write == I2C_SMBUS_WRITE) {
> +			len = data->block[0];
> +			if (len == 0 || len > I2C_SMBUS_BLOCK_MAX ||
> +			    (b && len > b->len)) {

A useful debug message in the latter case might be good to have.

> +				ret = -EINVAL;
> +				break;
> +			}
> +			if (b == NULL) {
> +				b = stub_find_block(&adap->dev, chip, command,
> +						    true);
> +				if (b == NULL) {
> +					ret = -ENOMEM;
> +					break;
> +				}
> +				/* First write sets block length */
> +				b->len = len;
> +			}
> +			for (i = 0; i < len; i++)
> +				b->block[i] = data->block[i + 1];
> +			dev_dbg(&adap->dev,
> +				"smbus block data - addr 0x%02x, wrote %d bytes at 0x%02x.\n",
> +				addr, len, command);
> +		} else {
> +			if (b == NULL) {
> +				ret = -EINVAL;

I would suggest -EOPNOTSUPP with a useful debug message.

> +				break;
> +			}
> +			len = b->len;
> +			data->block[0] = len;
> +			for (i = 0; i < len; i++)
> +				data->block[i + 1] = b->block[i];
> +			dev_dbg(&adap->dev,
> +				"smbus block data - addr 0x%02x, read  %d bytes at 0x%02x.\n",
> +				addr, len, command);
> +		}
> +
> +		ret = 0;
> +		break;
> +
>  	default:
>  		dev_dbg(&adap->dev, "Unsupported I2C/SMBus command\n");
>  		ret = -EOPNOTSUPP;
> @@ -199,6 +287,8 @@ static int __init i2c_stub_init(void)
>  		pr_err("i2c-stub: Out of memory\n");
>  		return -ENOMEM;
>  	}
> +	for (i--; i >= 0; i--)
> +		INIT_LIST_HEAD(&stub_chips[i].smbus_blocks);

That works but I have to admit it confused me at first, because
traditionally reverse iterations like that are for cleanups on failure
paths. I think it might make sense to introduce an additional variable
to store the actual number of instantiated chips, so that we can use
the regular iteration direction (which I think modern memory
controllers can anticipate and optimize.) This would also let us
optimize the first test in stub_xfer.

But well this can be left as a separate cleanup patch, I'll take care
of that (unless you object.)

>  
>  	ret = i2c_add_adapter(&stub_adapter);
>  	if (ret)


-- 
Jean Delvare
SUSE L3 Support
