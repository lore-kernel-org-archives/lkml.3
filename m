Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbaFPULY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 16:11:24 -0400
Received: from mail.kernel.org ([198.145.19.201]:34338 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755875AbaFPULW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 16:11:22 -0400
Message-ID: <539F4FDC.80300@kernel.org>
Date: Mon, 16 Jun 2014 21:13:16 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Support Opensource <Support.Opensource@diasemi.com>
Subject: Re: [PATCH 1/8] mfd: Add support for DA9150 combined charger & fuel-gauge
 device
References: <cover.1402484954.git.Adam.Thomson.Opensource@diasemi.com> <bf472aa7fddd1e67a3d5b9024b5b621744146a27.1402484954.git.Adam.Thomson.Opensource@diasemi.com> <539DF8C6.8030009@kernel.org> <2E89032DDAA8B9408CB92943514A0337AB4FD95E@SW-EX-MBX01.diasemi.com>
In-Reply-To: <2E89032DDAA8B9408CB92943514A0337AB4FD95E@SW-EX-MBX01.diasemi.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/06/14 14:12, Opensource [Adam Thomson] wrote:
> On Sun, Jun 15, 2014 at 20:49, Jonathan Cameron wrote:
>
>> Hi Adam,
>>
>> Some general comments inline.
>>
>> It's been a while since I've looked at any particularly similar parts,
>> but it seems to me that a lot of indirection gets added here that
>> if anything makes the codes slightly harder to follow...
>>
>> Feel free to disagree with me though!
>
> Will do :)
>
>> To my mind all these wrappers add nothing significant so you might as well
>> just call da9150->read_dev etc directly.
>>
>> Also, what are the read_qif and write_qif for?  They don't seem to be used
>> anywhere.
>
> read_qif and write_qif are for the Fuel-Gauge functionality of the chip. The
> associated driver will be submitted after acceptance of initial driver code,
> and will make use of these functions.
I'll be interested to see how this interacts with the rest of the driver.
Or does it?  Often these dual i2c address devices are best handled as two
entirely separate drivers sitting on the same bus.  No idea if that
is true here as don't have a datasheet!
>
> The wrappers automatically choose the correct client to use (QIF uses a
> different slave address to the main chip one). Means the child drivers only need
> to pass through the da9150 struct and the rest is dealt with underneath.
>
>> The only real reason I can see for these wrappers is because you want
>> to hide the struct da9150 contents from the children of the mfd. As you
>> aren't doing that, you might as well drop these in favour of direct
>> calls to regmap_read and friends.
>
> As I have a need to pass through the main da9150 struct point for the
> aforementioned wrappers, it seemed cleaner and more consistent to have wrappers
> for these as well, which did the job of regmap access. Means all HW access
> uses the same kind of approach, and all sub-devices just need a point to the
> main da9150 struct to be able to use the functions.
>
>> I'll continue my tirade against obvious comments. Wrong format and
>> adds nothing to what is here as init and exit functions are clearly
>> doing what their name suggests (it's one of my pet hates ;)
>
> I agree the comment doesn't add much in terms of description but for me it
> breaks up the code to make it easier to follow. However if I get an overwhelming
> hatred for this I can change it. Also, I know the rule regarding single/multiple
> line comments but here again I feel it helps separate the code and makes it
> easier to read.
Kernel code generally has to keep to the kernel coding style.  If you leave the
single line comments as are, then chances are the mfd maintainers will get a
patch soon after 'fixing' them which is always irritating.

Having said that, mfd is their area not mine, so up to Lee / Samuel.
The same is true of the code structure comments. Now for the IIO driver
I get to be picky ;)
>
>> As a general good practice point, I'd rather that the driver supported
>> more than one instance of the chip.. Hence you'd take a copy of da9150_devs
>> to use here.  I guess it is relatively unlikely with one of these, but
>> you never know ;)
>
> Have followed the general methods for MFD here, and a number of drivers take the
> same approach. Also, I think it would be undesirable to have multiple charger
> chips of the same type in one platform. I agree generally it's best to support
> multiple instances, but here I don't think we should.
I'm happy to let this go if it is something that would not be done, but we
certainly should not be preventing it if someone wants to build hardware
with more than one of these.  If they submit a patch later allowing it because
they have hardware that does this, then there is no way anyone is going to
block it.
>
>> Why does this need it's own file?  Does the DA9150 support any other
>> interfaces?
>
> Yes, the DA9150 also has a SPI interface. At present the plan is to just add I2C
> support for now, but in the future we may add SPI support, so have written the
> code with this in mind.
>
>> Why the indirection?  The da9150 only supports i2c as far as I can see.
>
> As per my last comment.
Fair enough.  I couldn't find a datasheet and the product brief only seemed to mention
i2c.
>
>> I'd roll this into one line and not bother with the local variable...
>
> Fair enough but I think this keeps the code cleaner, and to me it makes sense
> for the actual logic to be in core file as that's interface agnostic.
>
>> Drop comments on things that are self-evident.  Also these are one
>> line comments so should be using the single line comment syntax.
>
> As per my previous comment I think it just helps to break up the code and makes
> it more readable. Will change it though if the general consensus is to remove
> it.


