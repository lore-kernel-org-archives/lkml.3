Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbaAWHoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 02:44:37 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58898 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbaAWHof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 02:44:35 -0500
MIME-Version: 1.0
Date: Thu, 23 Jan 2014 07:44:33 +0000
X-Google-Sender-Auth: iL-G7-q4FgOcHikGEVF0Webl_Z0
Message-ID: <CAOMwXhMVgcVVWiUYbEgGcM+K5bZmKA3LO0=jZCEsyJak1TbTSA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add at24 based EEPROMs to the eeprom_dev hardware class
From: Laszlo Papp <lpapp@kde.org>
To: Curt Brune <curt@cumulusnetworks.com>
Cc: Thomas De Schampheleire <patrickdepinguin@gmail.com>,
        gregkh@linuxfoundation.org,
        Shrijeet Mukherjee <shm@cumulusnetworks.com>, wolfram@the-dreams.de,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 5:23 PM, Curt Brune <curt@cumulusnetworks.com> wrote:
> During device instantiation have the at24 driver add the new device to
> the eeprom_dev hardware class.  The functionality is enabled by
> CONFIG_EEPROM_CLASS.
>
> Signed-off-by: Curt Brune <curt@cumulusnetworks.com>
> ---
>  drivers/misc/eeprom/at24.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>
> diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
> index d87f77f..07782ea 100644
> --- a/drivers/misc/eeprom/at24.c
> +++ b/drivers/misc/eeprom/at24.c
> @@ -1,170 +1,177 @@
>  /*
>   * at24.c - handle most I2C EEPROMs
>   *
>   * Copyright (C) 2005-2007 David Brownell
>   * Copyright (C) 2008 Wolfram Sang, Pengutronix
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License as published by
>   * the Free Software Foundation; either version 2 of the License, or
>   * (at your option) any later version.
>   */
>  #include <linux/kernel.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
>  #include <linux/delay.h>
>  #include <linux/mutex.h>
>  #include <linux/sysfs.h>
>  #include <linux/mod_devicetable.h>
>  #include <linux/log2.h>
>  #include <linux/bitops.h>
>  #include <linux/jiffies.h>
>  #include <linux/of.h>
>  #include <linux/i2c.h>
>  #include <linux/platform_data/at24.h>
>
> +#ifdef CONFIG_EEPROM_CLASS
> +#include <linux/eeprom_class.h>
> +#endif
> +
>  /*
>   * I2C EEPROMs from most vendors are inexpensive and mostly interchangeable.
>   * Differences between different vendor product lines (like Atmel AT24C or
>   * MicroChip 24LC, etc) won't much matter for typical read/write access.
>   * There are also I2C RAM chips, likewise interchangeable. One example
>   * would be the PCF8570, which acts like a 24c02 EEPROM (256 bytes).
>   *
>   * However, misconfiguration can lose data. "Set 16-bit memory address"
>   * to a part with 8-bit addressing will overwrite data. Writing with too
>   * big a page size also loses data. And it's not safe to assume that the
>   * conventional addresses 0x50..0x57 only hold eeproms; a PCF8563 RTC
>   * uses 0x51, for just one example.
>   *
>   * Accordingly, explicit board-specific configuration data should be used
>   * in almost all cases. (One partial exception is an SMBus used to access
>   * "SPD" data for DRAM sticks. Those only use 24c02 EEPROMs.)
>   *
>   * So this driver uses "new style" I2C driver binding, expecting to be
>   * told what devices exist. That may be in arch/X/mach-Y/board-Z.c or
>   * similar kernel-resident tables; or, configuration data coming from
>   * a bootloader.
>   *
>   * Other than binding model, current differences from "eeprom" driver are
>   * that this one handles write access and isn't restricted to 24c02 devices.
>   * It also handles larger devices (32 kbit and up) with two-byte addresses,
>   * which won't work on pure SMBus systems.
>   */
>
>  struct at24_data {
>         struct at24_platform_data chip;
>         struct memory_accessor macc;
>         int use_smbus;
>
>         /*
>          * Lock protects against activities from other Linux tasks,
>          * but not from changes by other I2C masters.
>          */
>         struct mutex lock;
>         struct bin_attribute bin;
>
>         u8 *writebuf;
>         unsigned write_max;
>         unsigned num_addresses;
>
> +#ifdef CONFIG_EEPROM_CLASS
> +       struct device *eeprom_dev;
> +#endif
>         /*
>          * Some chips tie up multiple I2C addresses; dummy devices reserve
>          * them for us, and we'll use them with SMBus calls.
>          */
>         struct i2c_client *client[];
>  };
>
>  /*
>   * This parameter is to help this driver avoid blocking other drivers out
>   * of I2C for potentially troublesome amounts of time. With a 100 kHz I2C
>   * clock, one 256 byte read takes about 1/43 second which is excessive;
>   * but the 1/170 second it takes at 400 kHz may be quite reasonable; and
>   * at 1 MHz (Fm+) a 1/430 second delay could easily be invisible.
>   *
>   * This value is forced to be a power of two so that writes align on pages.
>   */
>  static unsigned io_limit = 128;
>  module_param(io_limit, uint, 0);
>  MODULE_PARM_DESC(io_limit, "Maximum bytes per I/O (default 128)");
>
>  /*
>   * Specs often allow 5 msec for a page write, sometimes 20 msec;
>   * it's important to recover from write timeouts.
>   */
>  static unsigned write_timeout = 25;
>  module_param(write_timeout, uint, 0);
>  MODULE_PARM_DESC(write_timeout, "Time (in ms) to try writes (default 25)");
>
>  #define AT24_SIZE_BYTELEN 5
>  #define AT24_SIZE_FLAGS 8
>
>  #define AT24_BITMASK(x) (BIT(x) - 1)
>
>  /* create non-zero magic value for given eeprom parameters */
>  #define AT24_DEVICE_MAGIC(_len, _flags)                \
>         ((1 << AT24_SIZE_FLAGS | (_flags))              \
>             << AT24_SIZE_BYTELEN | ilog2(_len))
>
>  static const struct i2c_device_id at24_ids[] = {
>         /* needs 8 addresses as A0-A2 are ignored */
>         { "24c00", AT24_DEVICE_MAGIC(128 / 8, AT24_FLAG_TAKE8ADDR) },
>         /* old variants can't be handled with this generic entry! */
>         { "24c01", AT24_DEVICE_MAGIC(1024 / 8, 0) },
>         { "24c02", AT24_DEVICE_MAGIC(2048 / 8, 0) },
>         /* spd is a 24c02 in memory DIMMs */
>         { "spd", AT24_DEVICE_MAGIC(2048 / 8,
>                 AT24_FLAG_READONLY | AT24_FLAG_IRUGO) },
>         { "24c04", AT24_DEVICE_MAGIC(4096 / 8, 0) },
>         /* 24rf08 quirk is handled at i2c-core */
>         { "24c08", AT24_DEVICE_MAGIC(8192 / 8, 0) },
>         { "24c16", AT24_DEVICE_MAGIC(16384 / 8, 0) },
>         { "24c32", AT24_DEVICE_MAGIC(32768 / 8, AT24_FLAG_ADDR16) },
>         { "24c64", AT24_DEVICE_MAGIC(65536 / 8, AT24_FLAG_ADDR16) },
>         { "24c128", AT24_DEVICE_MAGIC(131072 / 8, AT24_FLAG_ADDR16) },
>         { "24c256", AT24_DEVICE_MAGIC(262144 / 8, AT24_FLAG_ADDR16) },
>         { "24c512", AT24_DEVICE_MAGIC(524288 / 8, AT24_FLAG_ADDR16) },
>         { "24c1024", AT24_DEVICE_MAGIC(1048576 / 8, AT24_FLAG_ADDR16) },
>         { "at24", 0 },
>         { /* END OF LIST */ }
>  };
>  MODULE_DEVICE_TABLE(i2c, at24_ids);
>
>  /*-------------------------------------------------------------------------*/
>
>  /*
>   * This routine supports chips which consume multiple I2C addresses. It
>   * computes the addressing information to be used for a given r/w request.
>   * Assumes that sanity checks for offset happened at sysfs-layer.
>   */
>  static struct i2c_client *at24_translate_offset(struct at24_data *at24,
>                 unsigned *offset)
>  {
>         unsigned i;
>
>         if (at24->chip.flags & AT24_FLAG_ADDR16) {
>                 i = *offset >> 16;
>                 *offset &= 0xffff;
>         } else {
>                 i = *offset >> 8;
>                 *offset &= 0xff;
>         }
>
>         return at24->client[i];
>  }
>
>  static ssize_t at24_eeprom_read(struct at24_data *at24, char *buf,
>                 unsigned offset, size_t count)
>  {
>         struct i2c_msg msg[2];
>         u8 msgbuf[2];
>         struct i2c_client *client;
>         unsigned long timeout, read_time;
>         int status, i;
>
>         memset(msg, 0, sizeof(msg));
>
>         /*
>          * REVISIT some multi-address chips don't rollover page reads to
>          * the next slave address, so we may need to truncate the count.
>          * Those chips might need another quirk flag.
> @@ -524,173 +531,186 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
>                 return -EINVAL;
>         }
>         if (!is_power_of_2(chip.page_size))
>                 dev_warn(&client->dev,
>                         "page_size looks suspicious (no power of 2)!\n");
>
>         /* Use I2C operations unless we're stuck with SMBus extensions. */
>         if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
>                 if (chip.flags & AT24_FLAG_ADDR16)
>                         return -EPFNOSUPPORT;
>
>                 if (i2c_check_functionality(client->adapter,
>                                 I2C_FUNC_SMBUS_READ_I2C_BLOCK)) {
>                         use_smbus = I2C_SMBUS_I2C_BLOCK_DATA;
>                 } else if (i2c_check_functionality(client->adapter,
>                                 I2C_FUNC_SMBUS_READ_WORD_DATA)) {
>                         use_smbus = I2C_SMBUS_WORD_DATA;
>                 } else if (i2c_check_functionality(client->adapter,
>                                 I2C_FUNC_SMBUS_READ_BYTE_DATA)) {
>                         use_smbus = I2C_SMBUS_BYTE_DATA;
>                 } else {
>                         return -EPFNOSUPPORT;
>                 }
>         }
>
>         if (chip.flags & AT24_FLAG_TAKE8ADDR)
>                 num_addresses = 8;
>         else
>                 num_addresses = DIV_ROUND_UP(chip.byte_len,
>                         (chip.flags & AT24_FLAG_ADDR16) ? 65536 : 256);
>
>         at24 = devm_kzalloc(&client->dev, sizeof(struct at24_data) +
>                 num_addresses * sizeof(struct i2c_client *), GFP_KERNEL);
>         if (!at24)
>                 return -ENOMEM;
>
>         mutex_init(&at24->lock);
>         at24->use_smbus = use_smbus;
>         at24->chip = chip;
>         at24->num_addresses = num_addresses;
>
>         /*
>          * Export the EEPROM bytes through sysfs, since that's convenient.
>          * By default, only root should see the data (maybe passwords etc)
>          */
>         sysfs_bin_attr_init(&at24->bin);
>         at24->bin.attr.name = "eeprom";
>         at24->bin.attr.mode = chip.flags & AT24_FLAG_IRUGO ? S_IRUGO : S_IRUSR;
>         at24->bin.read = at24_bin_read;
>         at24->bin.size = chip.byte_len;
>
>         at24->macc.read = at24_macc_read;
>
>         writable = !(chip.flags & AT24_FLAG_READONLY);
>         if (writable) {
>                 if (!use_smbus || i2c_check_functionality(client->adapter,
>                                 I2C_FUNC_SMBUS_WRITE_I2C_BLOCK)) {
>
>                         unsigned write_max = chip.page_size;
>
>                         at24->macc.write = at24_macc_write;
>
>                         at24->bin.write = at24_bin_write;
>                         at24->bin.attr.mode |= S_IWUSR;
>
>                         if (write_max > io_limit)
>                                 write_max = io_limit;
>                         if (use_smbus && write_max > I2C_SMBUS_BLOCK_MAX)
>                                 write_max = I2C_SMBUS_BLOCK_MAX;
>                         at24->write_max = write_max;
>
>                         /* buffer (data + address at the beginning) */
>                         at24->writebuf = devm_kzalloc(&client->dev,
>                                 write_max + 2, GFP_KERNEL);
>                         if (!at24->writebuf)
>                                 return -ENOMEM;
>                 } else {
>                         dev_warn(&client->dev,
>                                 "cannot write due to controller restrictions.");
>                 }
>         }
>
>         at24->client[0] = client;
>
>         /* use dummy devices for multiple-address chips */
>         for (i = 1; i < num_addresses; i++) {
>                 at24->client[i] = i2c_new_dummy(client->adapter,
>                                         client->addr + i);
>                 if (!at24->client[i]) {
>                         dev_err(&client->dev, "address 0x%02x unavailable\n",
>                                         client->addr + i);
>                         err = -EADDRINUSE;
>                         goto err_clients;
>                 }
>         }
>
>         err = sysfs_create_bin_file(&client->dev.kobj, &at24->bin);
>         if (err)
>                 goto err_clients;
>
> +#ifdef CONFIG_EEPROM_CLASS
> +       at24->eeprom_dev = eeprom_device_register(&client->dev);
> +       if (IS_ERR(at24->eeprom_dev)) {
> +               dev_err(&client->dev, "error registering eeprom device.\n");
> +               err = PTR_ERR(at24->eeprom_dev);
> +               goto err_clients;
> +       }
> +#endif
> +
>         i2c_set_clientdata(client, at24);
>
>         dev_info(&client->dev, "%zu byte %s EEPROM, %s, %u bytes/write\n",
>                 at24->bin.size, client->name,
>                 writable ? "writable" : "read-only", at24->write_max);
>         if (use_smbus == I2C_SMBUS_WORD_DATA ||
>             use_smbus == I2C_SMBUS_BYTE_DATA) {
>                 dev_notice(&client->dev, "Falling back to %s reads, "
>                            "performance will suffer\n", use_smbus ==
>                            I2C_SMBUS_WORD_DATA ? "word" : "byte");
>         }
>
>         /* export data to kernel code */
>         if (chip.setup)
>                 chip.setup(&at24->macc, chip.context);
>
>         return 0;
>
>  err_clients:
>         for (i = 1; i < num_addresses; i++)
>                 if (at24->client[i])
>                         i2c_unregister_device(at24->client[i]);
>
>         return err;
>  }
>
>  static int at24_remove(struct i2c_client *client)
>  {
>         struct at24_data *at24;
>         int i;
>
>         at24 = i2c_get_clientdata(client);
>         sysfs_remove_bin_file(&client->dev.kobj, &at24->bin);
>
>         for (i = 1; i < at24->num_addresses; i++)
>                 i2c_unregister_device(at24->client[i]);
>
> +#ifdef CONFIG_EEPROM_CLASS
> +       eeprom_device_unregister(at24->eeprom_dev);
> +#endif
> +
>         return 0;
>  }
>
>  /*-------------------------------------------------------------------------*/
>
>  static struct i2c_driver at24_driver = {
>         .driver = {
>                 .name = "at24",
>                 .owner = THIS_MODULE,
>         },
>         .probe = at24_probe,
>         .remove = at24_remove,
>         .id_table = at24_ids,
>  };
>
>  static int __init at24_init(void)
>  {
>         if (!io_limit) {
>                 pr_err("at24: io_limit must not be 0!\n");
>                 return -EINVAL;
>         }
>
>         io_limit = rounddown_pow_of_two(io_limit);
>         return i2c_add_driver(&at24_driver);
>  }
>  module_init(at24_init);
>
>  static void __exit at24_exit(void)
>  {
>         i2c_del_driver(&at24_driver);
>  }
>  module_exit(at24_exit);

Couldn't you use module_i2c_driver() instead of this?

>  MODULE_DESCRIPTION("Driver for most I2C EEPROMs");
>  MODULE_AUTHOR("David Brownell and Wolfram Sang");

I would personally put your name in here if I were you, otherwise
David and Wolfram might get contacted by some people instead of you
(at least based on this).

PS.: Fixing the broken i2c mailing list typo, and updating Wolfram's
address from the broken (obsolete?) version.
