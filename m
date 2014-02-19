Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaBSRKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 12:10:55 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:43942 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616AbaBSRKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 12:10:25 -0500
MIME-Version: 1.0
In-Reply-To: <20140219153850.GB13973@katana>
References: <cover.1387588711.git.luto@amacapital.net> <5508fef38f88601de1973d4252bc7aa98b54ea53.1387588711.git.luto@amacapital.net>
 <20140219153850.GB13973@katana>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 19 Feb 2014 09:10:03 -0800
Message-ID: <CALCETrWj-4T3r14L3xUvvg6G-piexL2-LCAqQ+nXsJFkhG51sw@mail.gmail.com>
Subject: Re: [PATCH v6 3/4] i2c_imc: New driver for Intel's iMC, found on
 LGA2011 chips
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rui Wang <ruiv.wang@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19, 2014 at 7:38 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
>> +config I2C_IMC
>> +     tristate "Intel iMC (LGA 2011) SMBus Controller"
>> +     depends on PCI && X86
>> +     select I2C_DIMM_BUS
>> +     help
>> +       If you say yes to this option, support will be included for the Intel
>> +       Integrated Memory Controller SMBus host controller interface.  This
>> +       controller is found on LGA 2011 Xeons and Core i7 Extremes.
>> +
>> +       It is possibly, although unlikely, that the use of this driver will
>> +       interfere with your platform's RAM thermal management.
>
> This sounds scary and thus needs some more detail :) How does that show?
> What can happen? Anything to take care of?
>

Here's how this works, as far as I can figure it out:

The Sandy Bridge (and presumably Ivy Bridge) platforms make some
effort to avoid overheating system DRAM, and they can dynamically
adjust the refresh interval depending on DIMM temperature.  This
happens in one of a few modes:

CLTT (closed loop thermal throttling):  the memory controller
(presumably via the magic, barely documented "P-code") will
periodically poll the TSOD (Temperature Sensor on DIMM) over i2c.  In
this mode the SMBUS registers are, IMO sensibly, locked*, and the
worse that can happen is that the driver will confuse itself.  For
sanity, the driver will just refuse to load in this case.

OLTT (open loop thermal throttling):  the memory controller will
estimate recent heat output based on access patterns and will adjust
accordingly.  There are lots of registers related to this in the
public docs, but the overall algorithm and purpose is not described
anywhere that I've looked.  In this mode, something (SMI? P-code?) can
still poll the TSOD, but it respects the POLL_EN bit.

Thermal throttling off: the memory controller pays no attention.  I
suspect that we can't cause any real harm in this case even if we
tried.

The interesting case is OLTT.  If we fail to twiddle the POLL_EN bit
correctly, then, in principle, we could cause a problem.  I don't know
what that problem would be -- the memory controller's P-code could
malfunction with unknown results.  I've abused a test system quite a
bit, and I've been completely unable to cause a problem, though.

There may be other modes, too, but, if so, I can't find them.  Maybe
some day there will be CLTT with i2c access.  If so, presumably the
driver will need updating.

In some sense, this is no worse than other i2c drivers -- there are
plenty of ways that a badly behaving i2c driver can cause something to
blow up.

* This is not documented at all AFAIK.  I figured it out by trial and error.

>> @@ -15,6 +15,7 @@ obj-$(CONFIG_I2C_AMD8111)   += i2c-amd8111.o
>>  obj-$(CONFIG_I2C_I801)               += i2c-i801.o
>>  obj-$(CONFIG_I2C_ISCH)               += i2c-isch.o
>>  obj-$(CONFIG_I2C_ISMT)               += i2c-ismt.o
>> +obj-$(CONFIG_I2C_IMC)                += i2c-imc.o
>
> This is not perfectly sorted.
>
>>  obj-$(CONFIG_I2C_NFORCE2)    += i2c-nforce2.o
>>  obj-$(CONFIG_I2C_NFORCE2_S4985)      += i2c-nforce2-s4985.o
>>  obj-$(CONFIG_I2C_PIIX4)              += i2c-piix4.o
>> diff --git a/drivers/i2c/busses/i2c-imc.c b/drivers/i2c/busses/i2c-imc.c
>> new file mode 100644
>> index 0000000..c846077
>> --- /dev/null
>> +++ b/drivers/i2c/busses/i2c-imc.c
>> @@ -0,0 +1,559 @@
>> +/*
>> + * Copyright (c) 2013 Andrew Lutomirski <luto@amacapital.net>
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License version 2
>> + * as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + * You should have received a copy of the GNU General Public License
>> + * along with this program; if not, write to the Free Software
>> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>
> Please skip the address. And run checkpatch.pl --strict! It would have
> warned you about this and other stuff:

Will do.  That's the first time I've heard of --strict :)


>
>> +/* Register offsets (in PCI configuration space) */
>> +#define SMBSTAT(i)                   (0x180 + 0x10*i)
>> +#define SMBCMD(i)                    (0x184 + 0x10*i)
>> +#define SMBCNTL(i)                   (0x188 + 0x10*i)
>> +#define SMB_TSOD_POLL_RATE_CNTR(i)   (0x18C + 0x10*i)
>> +#define SMB_TSOD_POLL_RATE           (0x1A8)
>
> Spaces around operators!

Will do.

>
>> +     int i;
>> +     for (i = 0; i < 50; i++) {
>> +             pci_read_config_dword(priv->pci_dev, SMBSTAT(chan), stat);
>> +             if (!(*stat & SMBSTAT_SMB_BUSY))
>> +                     return 0;
>> +             udelay(70);
>
> usleep_range?

No -- see the comment just above this excerpt.  There's an erratum
(which I can trigger on occasion but not reliably) that causes the i2c
hardware to return bogus results if the system enters a sufficiently
deep sleep while a transaction is running.  udelay prevents that.
It's a bit ugly, but 70us isn't very long, and pm_qos doesn't seem to
be a good alternative (there's no way to tell pm_qos to keep at least
one logical thread out of C2 and lower).  I'll change the code to
udelay(70); /* don't sleep -- see above */ to make it more obvious.
Better ideas welcome.

>
>> +     }
>> +
>> +     return -ETIMEDOUT;
>> +}
>> +
>
> ...
>
>> +static s32 imc_smbus_xfer(struct i2c_adapter *adap, u16 addr,
>> +                       unsigned short flags, char read_write, u8 command,
>> +                       int size, union i2c_smbus_data *data)
>> +{
>> +     int ret, chan;
>> +     u32 cmd = 0, cntl, final_cmd, final_cntl, stat;
>> +     struct imc_channel *ch;
>> +     struct imc_priv *priv = i2c_get_adapdata(adap);
>> +
>> +     if (atomic_read(&imc_raced))
>> +             return -EIO;  /* Minimize damage. */
>> +
>> +     chan = (adap == &priv->channels[0].adapter ? 0 : 1);
>> +     ch = &priv->channels[chan];
>> +
>> +     if (addr > 0x7f)
>> +             return -EOPNOTSUPP;  /* No large address support */
>
> Unneeded. The core checks for that...
>
>> +     if (flags)
>> +             return -EOPNOTSUPP;  /* No PEC */
>
> ... and your code would bail out if I2C_M_TEN was set.

I'll take another look at the core code and try to get this more correct :)

>
>> +     if (size != I2C_SMBUS_BYTE_DATA && size != I2C_SMBUS_WORD_DATA)
>> +             return -EOPNOTSUPP;
>> +
>> +     /* Encode CMD part of addresses and access size */
>> +     cmd  |= ((u32)addr & 0x7) << SMBCMD_SA_SHIFT;
>> +     cmd |= ((u32)command) << SMBCMD_BA_SHIFT;
>> +     if (size == I2C_SMBUS_WORD_DATA)
>> +             cmd |= SMBCMD_WORD_ACCESS;
>> +
>> +     /* Encode read/write and data to write */
>> +     if (read_write == I2C_SMBUS_READ) {
>> +             cmd |= SMBCMD_TYPE_READ;
>> +     } else {
>> +             cmd |= SMBCMD_TYPE_WRITE;
>> +             cmd |= (size == I2C_SMBUS_WORD_DATA
>> +                         ? swab16(data->word)
>> +                         : data->byte);
>> +     }
>> +
>> +     mutex_lock(&ch->mutex);
>
> Why is the per-adapter lock not sufficient?

Is there a per-adapter lock in the core that I didn't notice?
i2c_lock_adapter seems to be optional, and I don't want to blow up if
two threads try to hit the same channel at the same time.

There's nothing wrong with accessing both channels on an adapter at
once, though -- AFAICT they are completely independent.

>
>> +
>> +     ret = imc_channel_claim(priv, chan);
>> +     if (ret)
>> +             goto out_unlock;
>> +
>> +     pci_read_config_dword(priv->pci_dev, SMBCNTL(chan), &cntl);
>> +     cntl &= ~SMBCNTL_DTI_MASK;
>> +     cntl |= ((u32)addr >> 3) << SMBCNTL_DTI_SHIFT;
>> +     pci_write_config_dword(priv->pci_dev, SMBCNTL(chan), cntl);
>> +
>> +     /*
>> +      * This clears SMBCMD_PNTR_SEL.  We leave it cleared so that we don't
>> +      * need to think about keeping the TSOD pointer state consistent with
>> +      * the hardware's expectation.  This probably has some miniscule
>> +      * power cost, as TSOD polls will take 9 extra cycles.
>> +      */
>> +     cmd |= SMBCMD_TRIGGER;
>> +     pci_write_config_dword(priv->pci_dev, SMBCMD(chan), cmd);
>> +
>> +     if (imc_wait_not_busy(priv, chan, &stat) != 0) {
>> +             /* Timeout.  TODO: Reset the controller? */
>> +             ret = -EIO;
>> +             dev_err(&priv->pci_dev->dev, "controller is wedged\n");
>> +             goto out_release;
>> +     }
>> +
>> +     /*
>> +      * Be paranoid: try to detect races.  This will only detect races
>> +      * against BIOS, not against hardware.  (I've never seen this happen.)
>> +      */
>> +     pci_read_config_dword(priv->pci_dev, SMBCMD(chan), &final_cmd);
>> +     pci_read_config_dword(priv->pci_dev, SMBCNTL(chan), &final_cntl);
>> +     if (((cmd ^ final_cmd) & SMBCMD_OUR_BITS) ||
>> +         ((cntl ^ final_cntl) & SMBCNTL_OUR_BITS)) {
>> +             WARN(1, "iMC SMBUS raced against firmware");
>> +             dev_emerg(&priv->pci_dev->dev,
>> +                       "Access to channel %d raced: cmd 0x%08X->0x%08X, cntl 0x%08X->0x%08X\n",
>> +                       chan, cmd, final_cmd, cntl, final_cntl);
>
> Ehrm, do we need WARN and dev_emerg? And the error message should be
> updated. It should tell what the user should do next to handle the
> emergency.

I tried for a while, and I can't trigger this race.  The code is here
out of paranoia -- it should, in theory, detect a case where BIOS or
P-code fails to respect the TSOD_EN bit and conflicts with us.  If
this happens, the driver shuts itself down.

The outcome I want is that anyone who manages to trigger this will
email me and the linux-i2c list so that we can fix it.  The WARN will
cause abrt to notice, and the dev_emerg (which could be downgraded,
given the WARN) will supply useful information.  I could add an extra
line saying "Please contact luto@amacapital.net and
linux-i2c@vger.kernel.org".

Suggestions welcome :)

It would be awesome if an Intel engineer with access to better docs or
architectural insight could chime in -- I'm pretty sure that Intel is
funding NV-DIMM work, so they need this driver, and the old NDAed imc
smbus driver is almost certainly far less safe, less correct, and less
comprehensible than my driver. :)

TBH, the fact that, in CLTT mode, the SMBUS registers are all locked
makes me a lot more comfortable with this driver.  That's the mode in
which it would be easy to cause problems.

--Andy
