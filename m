Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933234Ab3CEE7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 23:59:11 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14876 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932907Ab3CEE7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 23:59:10 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 04 Mar 2013 20:53:15 -0800
Message-ID: <51357B9A.8080004@nvidia.com>
Date: Tue, 5 Mar 2013 13:59:06 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Andrew Chew <AChew@nvidia.com>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] pwm_bl: Add support for backlight enable GPIO
References: <1362433790-22560-1-git-send-email-achew@nvidia.com> <20130304224611.GB17149@avionic-0098.mockup.avionic-design.de> <51355FA4.1090909@nvidia.com> <643E69AA4436674C8F39DCC2C05F7638629BFE1B02@HQMAIL03.nvidia.com> <5135774D.6080708@nvidia.com> <643E69AA4436674C8F39DCC2C05F7638629BFE1B11@HQMAIL03.nvidia.com>
In-Reply-To: <643E69AA4436674C8F39DCC2C05F7638629BFE1B11@HQMAIL03.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 01:48 PM, Andrew Chew wrote:
> I sent out a new patch that enables/disables the backlight enable gpio.
>
>> On 03/05/2013 01:00 PM, Andrew Chew wrote:
>>> I did come to the same conclusion regarding the platform data breakage.
>>> I'm expecting that the use of platform data will go away, at least on
>>> ARM, since we are all aggressively moving what used to be in platform
>>> data into the device tree.  Do other platforms use this driver?
>>
>> I can see at least 29 users of platform_pwm_backlight_data, all ARM with the
>> exception of one unicore32. I guess at least for the foreseeable future
>> platform data will remain.
>
> I'm not sure how to solve this, then.  Any suggestions?

In one of my (many) attempts to add power sequencing to pwm-backlight, I 
just added a boolean to the platform data that must be explicitly set in 
order to enable control by GPIO. I.e.

	bool			use_enable_gpio
	int			enable_gpio;
	unsigned int		enable_gpio_flags;

enable_gpio and enable_gpio_flags would then only be considered if 
use_enable_gpio is true. Granted, it's not the best solution here but 
that's the only way to handle this correctly with integer GPIOS, and it 
does not pollute the DT anyway (use_enable_gpio will only be set by 
pwm_backlight_parse_dt() if of_get_named_gpio() returned a valid GPIO. 
Btw, you also want to check if the enable-gpio property exists first 
because otherwise probe() will fails if no GPIO is specified).

>> Yes, actually I am doing the GPIO rework. If you are not too much in a hurry
>> you might want for it to happen (should not be too long now that the core
>> has been reworked). At the same time, GPIO descriptors will also enable the
>> power sequences, so if you wait even longer (or help me with it), this patch
>> might not even be needed at all. Of course if you want to support this
>> *now*, this is still the shortest path.
>
> Sadly, I do need this now, and I'd rather do it as cleanly as possible rather
> than maintaining a hack.  The project I am working on is very pedantic.

Well, if you can get this right and make the GPIO optional, I think this 
is a reasonable feature to have in pwm-backlight, until a more generic 
powerseq-backlight driver takes over. ;)

>>> To answer your last question, yes, this single patch does allow me to
>>> enable the backlight on some boards (in particular, the one I'm working
>> on).
>>
>> Cool - may I ask which one? All the NV boards I tried to far required more
>> complex sequences for their panels.
>
> This is for t114-dalmore.  There may be other gpios that are needed that I'm
> not aware of off the top of my head.  For the backlight itself, this seems to
> be the only one.

I don't know the details of Dalmore but would think there must also be 
at least one regulator involved. If it is set to be always on in the DT, 
then your solution of using an enable GPIO should work then, even if not 
necessarily optimal wrt power usage.

Alex.

