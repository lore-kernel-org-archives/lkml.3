Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932639AbaGOI4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 04:56:23 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:54857 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539AbaGOI4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 04:56:18 -0400
MIME-Version: 1.0
In-Reply-To: <53C43BD6.9030102@kernel.org>
References: <1405359159-12379-1-git-send-email-tremyfr@yahoo.fr>
	<53C43BD6.9030102@kernel.org>
Date: Tue, 15 Jul 2014 16:56:17 +0800
Message-ID: <CAAj6DX2Tnt6=CuNAhkq_D=pknbEv=j7tf7Dtm7aoCm3gMu+RQw@mail.gmail.com>
Subject: Re: [PATCH] iio: add support of the max5821
From: Antonio Borneo <borneo.antonio@gmail.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Philippe Reynes <tremyfr@yahoo.fr>, linux-iio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        armadeus-forum@lists.sourceforge.net, devicetree@vger.kernel.org,
        julien.boibessot@free.fr
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 4:21 AM, Jonathan Cameron <jic23@kernel.org> wrote:
> On 14/07/14 18:32, Philippe Reynes wrote:

Hi Jonathan,

regarding your comment below

<snip>
>> +static int max5821_get_value(struct iio_dev *indio_dev,
>> +                            int *val, int channel)
>> +{
>> +       struct max5821_data *data = iio_priv(indio_dev);
>> +       struct i2c_client *client = data->client;
>> +       u8 outbuf[1];
>> +       u8 inbuf[2];
>> +       int ret;
>> +
>> +       switch (channel) {
>> +       case 0:
>> +               outbuf[0] = MAX5821_READ_DAC_A_COMMAND;
>> +               break;
>> +       case 1:
>> +               outbuf[0] = MAX5821_READ_DAC_B_COMMAND;
>> +               break;
>> +       default:
>> +               return -EINVAL;
>> +       }
>> +
>> +       ret = i2c_master_send(client, outbuf, 1);
>> +       if (ret < 0)
>> +               return ret;
>> +       else if (ret != 1)
>> +               return -EIO;
>> +
>> +       ret = i2c_master_recv(client, inbuf, 2);
>> +       if (ret < 0)
>> +               return ret;
>> +       else if (ret != 2)
>> +               return -EIO;
>
> It somehow always feels like this error handling should be in the
> i2c core.  Just how often does it make sense to receive too little
> from and i2c transaction?  Anyhow, such is life ;)

You wrote:

> You could set this up to use i2c_transfer instead of separating it like
> this.

Accordingly to:
- Documentation/i2c/i2c-protocol
- Documentation/i2c/writing-clients
a sequence of i2c_master_send() and i2c_master_recv() is not fully
equivalent to a single i2c_transfer(); in latter case the transactions
would be combined and the stop bit in between would be removed.

I checked the datasheet of max5821 and it reports that
"Each transmit sequence is framed by a START (S) or REPEATED START
(Sr) condition and a STOP (P) condition."
So combined transaction should work with this device.

But we have few I2C controllers that cannot send combined transactions
and would return error.
E.g. in drivers/i2c/busses/i2c-powermac.c
i2c_powermac_master_xfer() returns -EOPNOTSUPP when num!=1.

What is the proper way to address this:
- use combine transactions, since supported by majority of (but not
all) controllers?
or
- keep individual transactions, if not strictly required by the
protocol of the I2C device?

Thanks,
Antonio
