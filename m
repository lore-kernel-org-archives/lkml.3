Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbbAIKYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:24:32 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:32848 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbbAIKYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:24:30 -0500
Message-ID: <54AFAC4C.7010209@ti.com>
Date: Fri, 9 Jan 2015 12:24:12 +0200
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Andrew Jackson <Andrew.Jackson@arm.com>, Mark Brown <broonie@kernel.org>,
        Dave Airlie <airlied@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 3/4] ASoC: tda998x: add a codec to the HDMI transmitter
References: <cover.1420628786.git.moinejf@free.fr>	<23b36acc1f769418a06f3e929eba288b5911da12.1420628786.git.moinejf@free.fr>	<54AD4C77.5000401@arm.com>	<20150107154138.GL12302@n2100.arm.linux.org.uk> <20150107190241.27ebac8b@armhf>
In-Reply-To: <20150107190241.27ebac8b@armhf>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 08:02 PM, Jean-Francois Moine wrote:
> On Wed, 7 Jan 2015 15:41:38 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>
>> On Wed, Jan 07, 2015 at 03:10:47PM +0000, Andrew Jackson wrote:
>>> On 01/07/15 10:51, Jean-Francois Moine wrote:
>>>> diff --git a/drivers/gpu/drm/i2c/Kconfig b/drivers/gpu/drm/i2c/Kconfig
>>>> index 22c7ed6..24fc975 100644
>>>> --- a/drivers/gpu/drm/i2c/Kconfig
>>>> +++ b/drivers/gpu/drm/i2c/Kconfig
>>>> @@ -28,6 +28,7 @@ config DRM_I2C_SIL164
>>>>   config DRM_I2C_NXP_TDA998X
>>>>          tristate "NXP Semiconductors TDA998X HDMI encoder"
>>>>          default m if DRM_TILCDC
>>>> +       select SND_SOC_TDA998X
>>>
>>> Do you need this since sound/soc/codecs/Kconfig conditionally brings in the
>>> CODEC driver?
>
> For SND_SOC_ALL_CODECS only.
>
>> More importantly, it's broken, because it'll cause Kconfig to complain
>> if you enable DRM_I2C_NXP_TDA998X, but have ASoC disabled.
>>
>> Moreover, if you decide you want the sound and ASoC built as a module,
>> but want to build in DRM and TDA998x support (so you can get video
>> output working on boot before initramfs/rootfs), Kconfig may well
>> complain.
>
> 	select SND_SOC_TDA998X if SND_SOC
>
> should work in all cases.
>

I think that would still fail if DRM and TDA998x is built in and SND_SOC 
is built as modules. A request_module() call before 
tda9998x_codec_register() should help. Or could could write:

select SND_SOC_TDA998X if (SND_SOC=DRM_I2C_NXP_TDA998X || SND_SOC=y)

>>>> +static int __init tda998x_codec_init(void)
>>>> +{
>>>> +       return 0;
>>>> +}
>>>> +static void __exit tda998x_codec_exit(void)
>>>> +{
>>>> +}
>>>> +module_init(tda998x_codec_init);
>>>> +module_exit(tda998x_codec_exit);
>>
>> There's no need for these if they remain as the above.  Modules can have
>> both init/exit functions, or neither, and they are still unloadable.
>> Only modules which provide only an init function get locked in on load.
>
> Thanks.
>

