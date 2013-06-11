Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab3FKVbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 17:31:09 -0400
Received: from mail-bk0-f42.google.com ([209.85.214.42]:46489 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3FKVbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 17:31:08 -0400
Message-ID: <51B79718.1030402@gmail.com>
Date: Tue, 11 Jun 2013 23:31:04 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Francisco Jerez <currojerez@riseup.net>
CC: Daniel Vetter <daniel@ffwll.ch>, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: encoder_slave: respect of_node on i2c encoder init
References: <1370899422-1281-1-git-send-email-sebastian.hesselbarth@gmail.com> <20130611072433.GP22870@phenom.ffwll.local> <51B6D91D.3000906@gmail.com> <8738soptt7.fsf@riseup.net>
In-Reply-To: <8738soptt7.fsf@riseup.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 05:10 PM, Francisco Jerez wrote:
> Sebastian Hesselbarth<sebastian.hesselbarth@gmail.com>  writes:
>>> - I think we could also drop the call to ->set_config since presumably an
>>>     of-enabled driver grabbed any required info already from the dt.
>> [...]
>>> I think this way we could still share encoder slaves across tons of
>>> platforms, only the init sequence (and specifically how they get at their
>
> The "set_config" hook is just the way a DRM driver communicates those
> board-specific differences in the init sequence to the slave encoder
> driver.  I don't think it would make sense to remove it unless we make
> sure it's being called elsewhere.

Francisco,

for the non-DT case all probe related stuff could be passed with 
board_info.platform_data. For the DT case, the i2c device driver
will parse properties into .platform_data. IMHO in the end,
.set_config can be safely removed. But for now and especially because
I only have a DT-only platform to test, leave it there and rework
existing drivers and drm master encoders to pass it that way.

>> IMHO, the whole i2c encoder stuff is just wrong. Not any i2c slave
>> driver is even really using its probe(). Everything is packed somewhere
>> because it just worked.. this is at least a start.
>>
> Why is that?  What do you mean by the probe hooks not being used?
> ch7006 and sil164 rely on it being called on initialization.

You are right, I remembered wrong.

>> I suggest this to get merged to at least allow to have DT slaves,
>> then start with improving tda998x as an example, then maybe rethink
>> drm_slave_encoder completely, e.g.
>>
>> - generalize the concept to SPI attached encoders, "internal" encoders..
>
> drm_encoder_slave is bus-agnostic.  drm_i2c_encoder_init() is just a
> helper function taking care of bus-specific details like the creation of
> the underlying I2C device object, which cannot be made bus-agnostic for
> obvious reasons.  You're welcome to implement SPI and internal
> counterparts of drm_i2c_encoder_init().

Hehe, true again. I like to help and improve it wherever possible. But
to be honest, DRM is not an easy starter for blindly touch commonly
shared functions. If I break Dove, there is little people complaining.
If I also break x86 complaining quickly becomes ranting ;)

>> - find a way to setup .encoder_type and .connector_type correctly
>
> I guess encoder_type could be initialized correctly from the slave
> encoder_init() hook -- that hasn't been necessary until now because the
> DRM driver making use of the slave encoder has been expected to have
> some other means to find out encoder types [e.g. device-specific BIOS
> tables].  OTOH, I don't think that setting connector types is the slave
> encoder's business.

Well, I do not completely agree here. Actually, the connector type
cannot be set from any encoder in the chain in a consitent way. But
at least the slave encoder is closer to it.

For Dove (and many other SoCs) the lcd controller is just a dumb rgb
scan-out controller. It makes no difference if you directly connect an
LCD panel or have a HDMI encoder finally connected to an DVI plug.
The LCD controller shouldn't really care because it always sees a dumb
rgb receiver, the HDMI encoder at least can say it is either HDMI or
DVI plug.

For DT, I tend to have a video-card node comprising lcd controllers,
video memory range, external encoder phandle. Maybe put the board-
specific connector here, and then it is up the the master encoder
(or video card "driver") to set the correct connector.

Sebastian
