Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753660AbaAFMhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 07:37:45 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:53150 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbaAFMho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:37:44 -0500
Message-ID: <52CAA38C.9050307@mev.co.uk>
Date: Mon, 6 Jan 2014 12:37:32 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        Rostislav Lisovy <lisovy@gmail.com>, Ian Abbott <ian.abbott@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
CC: "pisa@cmp.felk.cvut.cz" <pisa@cmp.felk.cvut.cz>
Subject: Re: [PATCH] comedi: Humusoft MF634 and MF624 DAQ cards driver
References: <1388453796-17088-1-git-send-email-lisovy@gmail.com> <1388453796-17088-2-git-send-email-lisovy@gmail.com> <DC148C5AA1CEBA4E87973D432B1C2D8817E5C72E@P3PWEX4MB008.ex4.secureserver.net>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8817E5C72E@P3PWEX4MB008.ex4.secureserver.net>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-02 18:38, Hartley Sweeten wrote:
> On Monday, December 30, 2013 6:37 PM, Rostislav Lisovy wrote:
[snip]
>> +static int mf6x4_dio_insn_bits(struct comedi_device *dev,
>> +                            struct comedi_subdevice *s,
>> +                            struct comedi_insn *insn, unsigned int *data)
>> +{
>> +     struct mf6x4_private *devpriv = dev->private;
>> +
>> +     switch (s->type) {
>> +     case COMEDI_SUBD_DI: /* DIN */
>> +             data[1] = ioread16(devpriv->bar1_mem + MF6X4_DIN_reg) & MF6X4_DIN_mask;
>> +             break;
>> +
>> +     case COMEDI_SUBD_DO: /* DOUT */
>> +             /* data[0] -- mask
>> +                data[1] -- actual value */
>> +             if (data[0]) {
>> +                     s->state &= ~data[0];
>> +                     s->state |= (data[0] & data[1]);
>
> Please use comedi_dio_update_state() to handle this boilerplate code.
>
>> +
>> +                     iowrite16(s->state & MF6X4_DOUT_mask,
>> +                             devpriv->bar1_mem + MF6X4_DOUT_reg);
>> +
>> +                     data[1] = s->state;
>> +             }
>> +             break;
>> +     }
>> +
>> +     return insn->n;
>> +}
>
> Please split this function into a mf6x4_di_insn_bits() and mf6x4_do_insn_bits().
> That will remove an indent level and make the usage a bit clearer.

I'll also add that the `data[1] = s->state;` should be done even if 
data[0] is zero, i.e. it should be moved after the end of the `if` 
statement.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
