Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317Ab3GLH4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 03:56:55 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:64778 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184Ab3GLH4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 03:56:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=sasl; b=kwTAhP
	PCgHUSgaWmo5Xppeb3JbUB/pO8PxqQuy0U81TEhJINjSvlVpbA6qD+wneIWFXdgN
	Nk4U3k+KNoYTY6AeWfEdwR40lV4CdMlM6ijgvyFpsjkBnxoWMDMzkvk3BWemJlLC
	MPjQE6v4teXG4oJv6F6eTOzXQ4KfnDkvWd2oc=
Message-ID: <51DFB6C1.4040001@pobox.com>
Date: Fri, 12 Jul 2013 16:56:49 +0900
From: Shinya Kuribayashi <skuribay@pobox.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: mika.westerberg@linux.intel.com
CC: christian.ruppert@abilis.com, linux-i2c@vger.kernel.org, wsa@the-dreams.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c-designware: make *CNT values configurable
References: <1373283927-21677-1-git-send-email-mika.westerberg@linux.intel.com> <20130708134216.GB6402@ab42.lan> <20130709084402.GF4898@intel.com> <20130709161927.GC30236@ab42.lan> <20130710105215.GY4898@intel.com> <20130710165634.GA30693@ab42.lan> <20130711073600.GG4898@intel.com> <20130711101330.GP4898@intel.com>
In-Reply-To: <20130711101330.GP4898@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: 9D101CD0-EAC8-11E2-8664-E84251E3A03C-47602734!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/11/13 7:13 PM, Mika Westerberg wrote:
> On Thu, Jul 11, 2013 at 10:36:00AM +0300, Mika Westerberg wrote:
>> On Wed, Jul 10, 2013 at 06:56:35PM +0200, Christian Ruppert wrote:
>>> On Wed, Jul 10, 2013 at 01:52:15PM +0300, Mika Westerberg wrote:
>>>> On Tue, Jul 09, 2013 at 06:19:28PM +0200, Christian Ruppert wrote:
>>>>> What I meant is the following: The clock cycle time Tc is composed of
>>>>> the four components
>>>>>
>>>>>    Tc = Th + Tf + Tl + Tr
>>>>>
>>>>> where
>>>>>    Th: Time during which the signal is high
>>>>>    Tf: Falling edge transition time
>>>>>    Tl: Time during which the signal is low
>>>>>    Tr: Rising edge transition time
>>>>>
>>>>> The I2C specification specifies a minimum for Tl and Th and a range (or
>>>>> maximum) for Tr and Tf. A maximum frequency is specified as the
>>>>> frequency obtained by adding the minima for Th and Tl to the maxima of
>>>>> Tr ant Tf.
>>>>> Since as you said, transition times are very much PCB dependent, one way
>>>>> to guarantee the max. frequency constraint (and to achieve a constant
>>>>> frequency at its max) is to define the constants
>>>>> Th' = Th + Tf := Th_min + Tf_max
>>>>> Tl' = Tl + Tr := Tl_min + Tr_max
>>>>>
>>>>> and to calculate the variables
>>>>> Th = Th' - Tf
>>>>> Tl = Tl' - Tr
>>>>> in function of Tf and Tr of the given PCB.
>>>>
>>>> If I understand the above, it leaves Tf and Tr to be PCB specific and then
>>>> these values are passed to the core driver from platform data, right?
>>>
>>> That would be the idea: Calculate Th' and Tl' in function of the desired
>>> clock frequency and duty cycle and then adapt these values using
>>> measured transition times. What prevented me from implementing this
>>> rather academic approach are the following comments in
>>> i2c-designware-core.c:

When we talk about I2C timing specs, we should not bring up "clock speed"
things.  All we have to do is to strictly meet timing constraints of
tHIGH, tLOW, tHD;SATA, tr, tf, etc.  The resulting "clock speed" is not
a goal.

>>> /*
>>>   * DesignWare I2C core doesn't seem to have solid strategy to meet
>>>   * the tHD;STA timing spec.  Configuring _HCNT based on tHIGH spec
>>>   * will result in violation of the tHD;STA spec.
>>>   */
>>>
>>> /* ...
>>>   * This is just experimental rule; the tHD;STA period
>>>   * turned out to be proportinal to (_HCNT + 3).  With this setting,
>>>   * we could meet both tHIGH and tHD;STA timing specs.
>>>   * ...
>>>   */
>>>
>>> If I interpret this right, the slow down of the clock is intentional to
>>> meet tHD;STA timing constraints.

Correct.

>> Yeah, looks like so. tHD;STA is the SDA hold time. I wonder if the above
>> comments apply to some earlier version of the IP that didn't have the SDA
>> hold register?

If I remember DesignWare APB I2C spec correctly, SDA hold time register
doesn't help to meet tHD;STA spec.  Could someone confirm it really so
with a real hardware, please?

   Shinya

> Scratch that.
>
> I re-read the spec and tHD;STA is hold time for (repeated) start. There is
> a constraint that says that the device must internally provide a hold time
> of at least 300ns for the SDA signal. Maybe that's the constraint the
> comment above is referring to?
>

