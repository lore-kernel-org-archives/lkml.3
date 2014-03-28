Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaC1Pa4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 11:30:56 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25010 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbaC1Pax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 11:30:53 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-01-533595aa23bc
Message-id: <533595A9.8000904@samsung.com>
Date: Fri, 28 Mar 2014 16:30:49 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, a.hajda@samsung.com, kyungmin.park@samsung.com
Subject: Re: [PATCH/RFC 4/8] media: Add registration helpers for V4L2 flash
 sub-devices
References: <1395327070-20215-1-git-send-email-j.anaszewski@samsung.com>
 <1395327070-20215-5-git-send-email-j.anaszewski@samsung.com>
 <20140324000834.GC2054@valkosipuli.retiisi.org.uk>
In-reply-to: <20140324000834.GC2054@valkosipuli.retiisi.org.uk>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsVy+t/xK7qrppoGG8x4w2xxa905Vov5R4DE
	2aY37BaXd81hs9j6Zh2jRc+GrawWh9+0s1qc2b+SzYHD4/DXhSwefVtWMXp83iQXwBzFZZOS
	mpNZllqkb5fAlbHyW0jBF8mK73c/sjUwXhPpYuTkkBAwkXi/9iQ7hC0mceHeerYuRi4OIYGl
	jBL7v19mgXA+M0p0XZnAClLFK6AlsWbRPWYQm0VAVeLG1ONg3WwChhI/X7xmArFFBSIk/pze
	B1UvKPFj8j0WEFtEQE3i6aaHYEOZBQ4ySnzYfoENJCEsECkx/+UZdohtexgl1s28DdbBKWAv
	8XrBAkYQm1nAWmLlpG1QtrzE5jVvmScwCsxCsmQWkrJZSMoWMDKvYhRNLU0uKE5KzzXUK07M
	LS7NS9dLzs/dxAgJ7y87GBcfszrEKMDBqMTDm9FuGizEmlhWXJl7iFGCg1lJhDdrIlCINyWx
	siq1KD++qDQntfgQIxMHp1QD4xyH8o1MzCd7Q12ZONb4bWDmrze/K761PZ7XI3JzZWCKpvMm
	/fS54f8VMxduu2D+9LD3LW6PppCCa4zltg4sF4SMvn9ivnejIXYHg/7fMhPGTsPt/9SENV5k
	XpG6uOCTGfcjrwd/ujQfaG+bZPnwx1Sj/ecMWoT131jNPPIr9cpFpm5rk5jbSizFGYmGWsxF
	xYkAQ7a/qE0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sakari,

On 03/24/2014 01:08 AM, Sakari Ailus wrote:
> Hi Jacek,
>

[...]

>> +static int v4l2_flash_set_intensity(struct v4l2_flash *flash,
>> +				    unsigned int intensity)
>> +{
>> +	struct led_classdev *led_cdev = flash->led_cdev;
>> +	unsigned int fault;
>> +	int ret;
>> +
>> +	ret = led_get_flash_fault(led_cdev, &fault);
>> +	if (ret < 0 || fault)
>> +		return -EINVAL;
>
> Is it meaningful to check the faults here?
>
> The existing flash controller drivers mostly do not. The responsibility is
> left to the user --- something the user should probably do after the strobe
> has expectedly finished. This isn't particularly very well documented in the
> spec, though.

I was influenced by the documentation which says that sometimes strobing
the flash may not be possible due to faults. But I agree that checking
the faults should be user's responsibility.

> Also, the presence of every fault does not prevent using the flash.
>
>> +	led_set_brightness(led_cdev, intensity);
>
> Where do you convert between the LED framework brightness and the value used
> by the V4L2 controls?

I think that there is no need for conversion. AFAIK the LED subsystem
doesn't specify units of the brightness. It specifies LED_FULL enum
value but not all LED drivers stick to it. Moreover it limits
brightness resolution to 256 levels.

>> +
>> +	return ret;
>> +}
>> +
>> +static int v4l2_flash_s_ctrl(struct v4l2_ctrl *c)
>> +{
>> +	struct v4l2_flash *flash = ctrl_to_flash(c);
>> +	struct led_classdev *led_cdev = flash->led_cdev;
>> +	int ret = 0;
>> +
>> +	switch (c->id) {
>> +	case V4L2_CID_FLASH_LED_MODE:
>> +		switch (c->val) {
>> +		case V4L2_FLASH_LED_MODE_NONE:
>> +			/* clear flash mode on releae */
>
> It's not uncommon for the user to leave the mode to something else than none
> when the user goes away. Could there be other ways to mediate access?

IMHO user space application should release the mode on exit as any other
resource it acquires. However if it is terminated unexpectedly
the sysfs will remain locked forever. Maybe a dedicated sysfs
attribute should be provided in the LED subsystem for controlling the
sysfs lock state? It would have to be always available for the user
though.

>> +static int v4l2_flash_init_controls(struct v4l2_flash *flash,
>> +				struct v4l2_flash_ctrl_config *config)
>> +
>> +{
>> +	unsigned int mask;
>> +	struct v4l2_ctrl *ctrl;
>> +	struct v4l2_ctrl_config *ctrl_cfg;
>> +	bool has_flash = config->flags & V4L2_FLASH_CFG_LED_FLASH;
>> +	bool has_torch = config->flags & V4L2_FLASH_CFG_LED_TORCH;
>> +	int ret, num_ctrls;
>> +
>> +	if (!has_flash && !has_torch)
>> +		return -EINVAL;
>> +
>> +	num_ctrls = has_flash ? 8 : 2;
>> +	if (config->flags & V4L2_FLASH_CFG_FAULTS_MASK)
>> +		++num_ctrls;
>> +
>> +	v4l2_ctrl_handler_init(&flash->hdl, num_ctrls);
>> +
>> +	mask = 1 << V4L2_FLASH_LED_MODE_NONE;
>> +	if (has_flash)
>> +		mask |= 1 << V4L2_FLASH_LED_MODE_FLASH;
>> +	if (has_torch)
>> +		mask |= 1 << V4L2_FLASH_LED_MODE_TORCH;
>
> I don't expect to see this on LED flash devices. :-)

I don't get your point here. Could you be more specific? :)
Torch only mode is supported by V4L2_CID_FLASH_LED_MODE control,
isn't it?

Regards,
Jacek Anaszewski
