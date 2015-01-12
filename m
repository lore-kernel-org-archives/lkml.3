Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbbALNrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:47:07 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:45597 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbbALNrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:47:03 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-24-54b3d056433a
Message-id: <54B3D053.4010300@samsung.com>
Date: Mon, 12 Jan 2015 14:46:59 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, Andrzej Hajda <a.hajda@samsung.com>,
        Lee Jones <lee.jones@linaro.org>, Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 08/19] leds: Add support for max77693 mfd flash cell
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-9-git-send-email-j.anaszewski@samsung.com>
 <20150109184606.GJ18076@amd> <54B38B55.7080503@samsung.com>
 <20150112132521.GA15838@amd>
In-reply-to: <20150112132521.GA15838@amd>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t/xK7phFzaHGPzu4bK4te4cq8XGGetZ
	LY7unMhkcf3Lc1aL+UeAYmeb3rBb3P96lNHi8q45bBZb36xjtOjZsJXV4u6po2wWu3c9ZbU4
	/Kad1eLM/pVsDnweO2fdZfc4/HUhi8eda3vYPPbM/8Hq0bdlFaPHitXf2T0+b5ILYI/isklJ
	zcksSy3St0vgynjafpqx4A9XRff2T4wNjBs4uhg5OSQETCQ6v/9ghbDFJC7cW88GYgsJLGWU
	mL67touRC8j+yCixadl6sCJeAS2Jub9WgRWxCKhKHJnyiB3EZhMwlPj54jUTiC0qECHx5/Q+
	qHpBiR+T77GA2CIC8hJb+1YwgwxlFvjKJNHUsg9skLBAgMSRqevYILY9YpRYfXQTWDengKZE
	6/NHYFOZBawlVk7axghhy0tsXvOWeQKjwCwkS2YhKZuFpGwBI/MqRtHU0uSC4qT0XCO94sTc
	4tK8dL3k/NxNjJAY+rqDcekxq0OMAhyMSjy8llKbQ4RYE8uKK3MPMUpwMCuJ8LqWAYV4UxIr
	q1KL8uOLSnNSiw8xMnFwSjUw6kqwL1+y/pbB2e1N3xx1Pr/pkmUouDutQuwvn/ifqc2340pu
	L/dP3Z0isDAv+v2nB2WvpDfuu2aziuPdlYf+l/kN9Q5c8Zll+kt7loKhg/7zmd53/873dLrP
	9e/w0sVufctk1t79sPruuXwlh9VBPj/NmqL3Vp7YGLbegXmqZNd//1tH9Z/eaFFiKc5INNRi
	LipOBAAosgOafwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 02:25 PM, Pavel Machek wrote:
> Hi!
>
>>>> +struct max77693_sub_led {
>>>> +	/* related FLED output identifier */
>>>
>>> ->flash LED, about 4x.
>>>
>>>> +/* split composite current @i into two @iout according to @imax weights */
>>>> +static void __max77693_calc_iout(u32 iout[2], u32 i, u32 imax[2])
>>>> +{
>>>> +	u64 t = i;
>>>> +
>>>> +	t *= imax[1];
>>>> +	do_div(t, imax[0] + imax[1]);
>>>> +
>>>> +	iout[1] = (u32)t / FLASH_IOUT_STEP * FLASH_IOUT_STEP;
>>>> +	iout[0] = i - iout[1];
>>>> +}
>>>
>>> Is 64-bit arithmetics neccessary here? Could we do the FLASH_IOUT_STEP
>>> divisons before t *=, so that 64-bit division is not neccessary?
>>
>> It is required. All these operations allow for splitting the composite
>> current into both outputs according to weights given in the imax
>> array.
>
> I know.
>
> What about this?
>
> static void __max77693_calc_iout(u32 iout[2], u32 i, u32 imax[2])
> {
> 	u32 t = i;
>
> 	t *= imax[1] / FLASH_IOUT_STEP;

Let's consider following case:

t = 1000000
imax[1] = 1000000

multiplication of the above will give 10^12 - much more than
it is possible to encode on 32 bits.

> 	t = t / (imax[0] + imax[1]);
> 	t /= FLASH_IOUT_STEP
>
> 	iout[1] = (u32)t;
> 	iout[0] = i - iout[1];
> }
>
> Does it lack precision?
>
> Thanks,
> 									Pavel
>


-- 
Best Regards,
Jacek Anaszewski
