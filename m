Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbaIRItX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 04:49:23 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:40943 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976AbaIRItU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 04:49:20 -0400
MIME-Version: 1.0
In-Reply-To: <20140918081959.GH20727@localhost>
References: <1410290686-6680-1-git-send-email-octavian.purdila@intel.com>
	<1410290686-6680-3-git-send-email-octavian.purdila@intel.com>
	<20140917094445.GG20727@localhost>
	<CAE1zotJt+Eq7dCaWgFUV_=tXvHL=nExW-KeL3gzTUEgqu8AX9Q@mail.gmail.com>
	<20140918081959.GH20727@localhost>
Date: Thu, 18 Sep 2014 11:49:19 +0300
Message-ID: <CAE1zotKB48T9qz4NaxMbMMiuit_v+Zd9wpcdQrVFw7nVCBYX-w@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] i2c: add support for Diolan DLN-2 USB-I2C adapter
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, wsa@the-dreams.de,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Daniel Baluta <daniel.baluta@intel.com>,
        Laurentiu Palcu <laurentiu.palcu@intel.com>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-gpio@vger.kernel.org,
        linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 11:19 AM, Johan Hovold <johan@kernel.org> wrote:
> On Wed, Sep 17, 2014 at 01:07:51PM +0300, Octavian Purdila wrote:
>> On Wed, Sep 17, 2014 at 12:44 PM, Johan Hovold <johan@kernel.org> wrote:
>>
>> <snip>
>>
>> >> +     /*
>> >> +      * Buffer to hold the packet for read or write transfers. One
>> >> +      * is enough since we can't have multiple transfers in
>> >> +      * parallel on the i2c adapter.
>> >> +      */
>> >> +     union {
>> >> +             struct {
>> >> +                     u8 port;
>> >> +                     u8 addr;
>> >> +                     u8 mem_addr_len;
>> >> +                     __le32 mem_addr;
>> >> +                     __le16 buf_len;
>> >> +                     u8 buf[DLN2_I2C_MAX_XFER_SIZE];
>> >> +             } __packed tx;
>> >> +             struct {
>> >> +                     __le16 buf_len;
>> >> +                     u8 buf[DLN2_I2C_MAX_XFER_SIZE];
>> >> +             } __packed rx;
>> >> +     } buf;
>> >
>> > While this works in this case due to the extra copy you do in
>> > dln2_transfer, allocating buffers that would (generally) be used for DMA
>> > transfers as part of a larger structure is a recipe for trouble.
>> >
>> > It's probably better to allocate separately, if only to prevent people
>> > from thinking there might be a bug here.
>> >
>>
>> Just to make sure I understand this, what could the issues be? The
>> buffers not being aligned or not allocated in continuous physical
>> memory?
>
> Yes, the buffer (and any subsequent field) would have to be cache-line
> aligned to avoid corruption due to cache-line sharing on some systems.
>

Ah, ok, makes sense now. But is it safe to use kmalloc() in this case?
Does kmalloc() prevent cache line sharing?

>> <snip>
>>
>> >> +
>> >> +     rx_buf_len = le16_to_cpu(dln2->buf.rx.buf_len);
>> >> +     if (rx_len < rx_buf_len + sizeof(dln2->buf.rx.buf_len))
>> >> +             return -EPROTO;
>> >> +
>> >> +     if (data_len > rx_buf_len)
>> >> +             data_len = rx_buf_len;
>> >
>> > You're still not checking that the received data does not overflow the
>> > supplied buffer as I already commented on v3.
>> >
>> >> +
>> >> +     memcpy(data, dln2->buf.rx.buf, data_len);
>> >> +
>> >> +     return data_len;
>> >> +}
>>
>> Hmm, perhaps I am missing something, but we never transfer more then
>> data_len, where data_len is the size of the buffer supplied by the
>> user.
>
> That is the amount of data you request from the device, but you never
> check how much is actually returned.
>

Actually we check the receive buffer size here:

    if (data_len > rx_buf_len)
        data_len = rx_buf_len;

rx_buf_len is the i2c received payload size while rx_len is the length
of received message

> You really should clean up the error handling of this function as it is
> currently not very readable.
>

Perhaps adding some comments similar to the the explanation above would help?
