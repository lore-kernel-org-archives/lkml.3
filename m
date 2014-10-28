Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932288AbaJ1Imh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:42:37 -0400
Received: from vader.hardeman.nu ([95.142.160.32]:37286 "EHLO hardeman.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbaJ1Imf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:42:35 -0400
To: Tomas Melin <tomas.melin@iki.fi>
Subject: Re: [PATCH v2 1/2] [media] rc-core: fix =?UTF-8?Q?protocol=5Fchan?=  =?UTF-8?Q?ge=20regression=20in=20ir=5Fraw=5Fevent=5Fregister?=
X-PHP-Originating-Script: 0:rcmail.php
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Tue, 28 Oct 2014 09:42:30 +0100
From: =?UTF-8?Q?David_H=C3=A4rdeman?= <david@hardeman.nu>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-media@vger.kernel.org,
        james.hogan@imgtec.com,
        =?UTF-8?Q?Antti_Sepp=C3=A4l=C3=A4?= <a.seppala@gmail.com>,
        =?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0?=
	 =?UTF-8?Q?=D0=BD=D0=B4=D1=80_=D0=91=D0=B5=D1=80=D1=81=D0=B5=D0=BD=D0=B5?=
	 =?UTF-8?Q?=D0=B2?= <bay@hackerdom.ru>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>, tomas.j.melin@gmail.com
In-Reply-To: <CACraW2pZnOnjj4iXoAN4A23efWVoL4ZjFXvXiS4ktxZ5YYEz9Q@mail.gmail.com>
References: <1413916218-7481-1-git-send-email-tomas.melin@iki.fi>
 <20141025090307.GA31078@hardeman.nu>
 <CACraW2pZnOnjj4iXoAN4A23efWVoL4ZjFXvXiS4ktxZ5YYEz9Q@mail.gmail.com>
Message-ID: <f308d753cb68dc6afbfe4360c1bd4404@hardeman.nu>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-10-26 20:33, Tomas Melin wrote:
> On Sat, Oct 25, 2014 at 12:03 PM, David Härdeman <david@hardeman.nu> 
> wrote:
>> Wouldn't something like this be a simpler way of achieving the same
>> result? (untested):
> 
> The idea was to remove the empty change_protocol function that had
> been added in the breaking commit.

The empty function was added for a reason? The presence of a 
change_protocol function implies that the receiver supports protocol 
changing (whether it's via the raw IR decoding or in hardware).

> IMHO, it would be better to not have functions that don't do anything.
> Actually, another problem with that empty function is that if the
> driver first sets up a "real" change_protocol function and related
> data, and then calls rc_register_device, the driver defined
> change_protocol function would be overwritten.

change_protocol is only set if it's a driver that does in-kernel 
decoding...meaning that it generates pulse/space timings...meaning that 
hardware protocol changes aren't necessary?

>> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
>> index a7991c7..d521f20 100644
>> --- a/drivers/media/rc/rc-main.c
>> +++ b/drivers/media/rc/rc-main.c
>> @@ -1421,6 +1421,9 @@ int rc_register_device(struct rc_dev *dev)
>> 
>>         if (dev->change_protocol) {
>>                 u64 rc_type = (1 << rc_map->rc_type);
>> +               if (dev->driver_type == RC_DRIVER_IR_RAW)
>> +                       rc_type |= RC_BIT_LIRC;
>> +
>>                 rc = dev->change_protocol(dev, &rc_type);
>>                 if (rc < 0)
>>                         goto out_raw;
> 
> But otherwise yes, your suggestion could work, with the addition that
> we still need to update enabled_protocols (and not init
> enabled_protocols anymore in ir_raw_event_register() ).

First, enabled_protocols is already taken care of in the above patch 
(the line after "goto out_raw" is "dev->enabled_protocols = rc_type;")?

Second, initializing enabled_protocols to some default in 
ir_raw_event_register() might not be strictly necessary but it also 
doesn't hurt since that happens before dev->change_protocol() is called 
in rc_register_device()?

> +               dev->enabled_protocols = (rc_type | RC_BIT_LIRC);
> 
> Please let me know your preferences on which you prefer, and, if
> needed, I'll make a new patch version.

I'd prefer the above, minimal, approach. But it's Mauro who decides in 
the end.

Regards,
David

