Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932539AbaGOJVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:21:42 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49048 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbaGOJVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:21:36 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <CAAj6DX2Tnt6=CuNAhkq_D=pknbEv=j7tf7Dtm7aoCm3gMu+RQw@mail.gmail.com>
References: <1405359159-12379-1-git-send-email-tremyfr@yahoo.fr> <53C43BD6.9030102@kernel.org> <CAAj6DX2Tnt6=CuNAhkq_D=pknbEv=j7tf7Dtm7aoCm3gMu+RQw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] iio: add support of the max5821
From: Jonathan Cameron <jic23@kernel.org>
Date: Tue, 15 Jul 2014 10:21:26 +0100
To: Antonio Borneo <borneo.antonio@gmail.com>
CC: Philippe Reynes <tremyfr@yahoo.fr>, linux-iio@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        armadeus-forum@lists.sourceforge.net, devicetree@vger.kernel.org,
        julien.boibessot@free.fr
Message-ID: <c0929d8c-7835-4522-9280-6c1c422df035@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On July 15, 2014 9:56:17 AM GMT+01:00, Antonio Borneo <borneo.antonio@gmail.com> wrote:
>On Tue, Jul 15, 2014 at 4:21 AM, Jonathan Cameron <jic23@kernel.org>
>wrote:
>> On 14/07/14 18:32, Philippe Reynes wrote:
>
>Hi Jonathan,
>
>regarding your comment below
>
><snip>
>>> +static int max5821_get_value(struct iio_dev *indio_dev,
>>> +                            int *val, int channel)
>>> +{
>>> +       struct max5821_data *data = iio_priv(indio_dev);
>>> +       struct i2c_client *client = data->client;
>>> +       u8 outbuf[1];
>>> +       u8 inbuf[2];
>>> +       int ret;
>>> +
>>> +       switch (channel) {
>>> +       case 0:
>>> +               outbuf[0] = MAX5821_READ_DAC_A_COMMAND;
>>> +               break;
>>> +       case 1:
>>> +               outbuf[0] = MAX5821_READ_DAC_B_COMMAND;
>>> +               break;
>>> +       default:
>>> +               return -EINVAL;
>>> +       }
>>> +
>>> +       ret = i2c_master_send(client, outbuf, 1);
>>> +       if (ret < 0)
>>> +               return ret;
>>> +       else if (ret != 1)
>>> +               return -EIO;
>>> +
>>> +       ret = i2c_master_recv(client, inbuf, 2);
>>> +       if (ret < 0)
>>> +               return ret;
>>> +       else if (ret != 2)
>>> +               return -EIO;
>>
>> It somehow always feels like this error handling should be in the
>> i2c core.  Just how often does it make sense to receive too little
>> from and i2c transaction?  Anyhow, such is life ;)
>
>You wrote:
>
>> You could set this up to use i2c_transfer instead of separating it
>like
>> this.
>
>Accordingly to:
>- Documentation/i2c/i2c-protocol
>- Documentation/i2c/writing-clients
>a sequence of i2c_master_send() and i2c_master_recv() is not fully
>equivalent to a single i2c_transfer(); in latter case the transactions
>would be combined and the stop bit in between would be removed.
>
>I checked the datasheet of max5821 and it reports that
>"Each transmit sequence is framed by a START (S) or REPEATED START
>(Sr) condition and a STOP (P) condition."
>So combined transaction should work with this device.
>
>But we have few I2C controllers that cannot send combined transactions
>and would return error.
>E.g. in drivers/i2c/busses/i2c-powermac.c
>i2c_powermac_master_xfer() returns -EOPNOTSUPP when num!=1.
>
>What is the proper way to address this:
>- use combine transactions, since supported by majority of (but not
>all) controllers?
>or
>- keep individual transactions, if not strictly required by the
>protocol of the I2C device?
I would go with working on the vast majority unless we have a user actually using such
 an i2c controller.
>
>Thanks,
>Antonio

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
