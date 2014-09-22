Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaIVKYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:24:43 -0400
Received: from exprod7og125.obsmtp.com ([64.18.2.28]:56672 "EHLO
	exprod7og125.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbaIVKYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:24:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140922095939.GB1406@katana>
References: <1408967482-17723-1-git-send-email-anders.berg@avagotech.com>
	<20140920121242.GA3833@katana>
	<CAE0=X_0VQ8rWrUgbsgKm1MwCP8bwWm3UJPq9p=xNDfjP4CC7Bg@mail.gmail.com>
	<20140922095939.GB1406@katana>
Date: Mon, 22 Sep 2014 12:24:39 +0200
Message-ID: <CAE0=X_3JVt3+a8Hjm9Keyw0-TPMS+MpOnDCx9XhwdoPzxJ7ikg@mail.gmail.com>
Subject: Re: [PATCH] i2c: axxia: Add I2C driver for AXM55xx
From: Anders Berg <anders.berg@avagotech.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: devicetree <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 11:59 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
>> >> +             if (idev->msg_xfrd == 0 && i2c_m_recv_len(msg)) {
>> >> +                     /*
>> >> +                      * Check length byte for SMBus block read
>> >> +                      */
>> >> +                     if (c <= 0) {
>> >> +                             idev->msg_err = -EPROTO;
>> >> +                             i2c_int_disable(idev, ~0);
>> >> +                             complete(&idev->msg_complete);
>> >> +                             break;
>> >> +                     } else if (c > I2C_SMBUS_BLOCK_MAX) {
>> >> +                             c = I2C_SMBUS_BLOCK_MAX;
>> >
>> > What about returning -EPROTO here as well? I don't think that reading
>> > just a slice of all the data is helpful.
>> >
>>
>> Right, that is probably true. This came from the device I was using to
>> test the block-read operation. This device violated the
>> I2C_SMBUS_BLOCK_MAX limit, so I added this truncation to at least get
>> something out...
>
> Which device was it? I know there are some doing that, yet I like to
> know which ones.

It was a LTC2974, register MFR_FAULT_LOG (0xee).

>
>> >> +{
>> >> +     struct axxia_i2c_dev *idev = _dev;
>> >> +     u32 status;
>> >> +
>> >> +     if (!idev->msg)
>> >> +             return IRQ_NONE;
>> >
>> > This is actually not true. There might be interrupt bits set, so there
>> > is an IRQ. There shouldn't be one, right, but that's another case IMO.
>> >
>>
>> You could see it as: there is no interrupt that this handler is
>> interested in serving. I'd like to keep this test as there is some
>> legacy software that could be run on platforms with this driver that
>> access the I2C controller directly. If this happens, this test assures
>> that the user get an informative "unhandled irq" error message
>> (instead of a null pointer dereference).
>
> IRQ_NONE is "this interrupt wasn't by me" so for shared IRQs, the next
> handler can check. You shouldn't remove the check per se. Still,  since
> this interrupt was definately from the I2C core, you should return
> IRQ_HANDLED and print an error message to the logs.
>

Ok, I'll do that.


>> >> +static int
>> >> +axxia_i2c_xfer_msg(struct axxia_i2c_dev *idev, struct i2c_msg *msg)
>> >> +{
>> >> +     u32 int_mask = MST_STATUS_ERR | MST_STATUS_SNS;
>> >> +     u32 rx_xfer, tx_xfer;
>> >> +     u32 addr_1, addr_2;
>> >> +     int ret;
>> >> +
>> >> +     if (msg->len == 0 || msg->len > 255)
>> >> +             return -EINVAL;
>> >
>> > Ouch, really? Maybe we should warn the user here.
>>
>> Yeah, the transfer length register limits the length to 255. I'll add
>> a warning here.
>
> Please also add this information to the Kconfig description and
> somewhere at the top of the source file. This is an important flaw which
> people should easily find out about.
>

Ok.

Thanks,
Anders
