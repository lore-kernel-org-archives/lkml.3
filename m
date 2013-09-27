Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab3I0T7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:59:54 -0400
Received: from smtp-out-101.synserver.de ([212.40.185.101]:1078 "EHLO
	smtp-out-096.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753641Ab3I0T7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:59:52 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 28715
Message-ID: <5245E420.2030207@metafoo.de>
Date: Fri, 27 Sep 2013 22:01:36 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-spi@vger.kernel.org, viresh.linux@gmail.com
Subject: Re: [PATCH 1/3] spi: Add a spi_w8r16be() helper
References: <1380292469-17347-1-git-send-email-lars@metafoo.de> <20130927183456.GM19304@sirena.org.uk> <5245D2A0.4090909@metafoo.de> <20130927192233.GN19304@sirena.org.uk>
In-Reply-To: <20130927192233.GN19304@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 09:22 PM, Mark Brown wrote:
> On Fri, Sep 27, 2013 at 08:46:56PM +0200, Lars-Peter Clausen wrote:
> 
>> According to the documentation of spi_w8r16() it is a feature.
> 
>> 	* The number is returned in wire-order, which is at least sometimes
>>  	* big-endian.
> 
> Indeed.  I don't think that's terribly well thought through though,
> especially not now we have annotations for endianness (as you noticed!).

I wouldn't mind updating spi_w8r16() to do the conversion to big-endian.
Especially considering that a driver using the function will probably always
need to do a endian conversion anyway to work correctly on both
endiannesses. We can add a LE variant if we should ever need it.

> 
>> There seem to be at least two users though which assume that the result is
>> in native endianness drivers/hwmon/ads7871.c and drivers/mfd/stmpe-spi.c
> 
> Yeah, I saw.  The ads7871 is just going to break when run on the
> opposite endianness to the one it was (hopefully) tested on since it
> doesn't make any effort I saw to cope with endianness.  Looking at the
> history it's not terribly obvious which that was but it'd be surprising
> to see a little endian register...
> 
> STMPE is doing a byte swap so it's another user for your function -
> it's for ARM systems so it'll be assuming that little endian is the
> native format.

The STMPE driver might be a candidate for regmap. Considering that the
driver was tested on a LE system it looks as if the driver first writes a 8
bit word for the address then reads a 16 bit word and ignores the upper bits
(of the BE word) and returns the lower 8 bits as the result. But the way I
understand the datasheet the 8-bit data word would follow right after the
8-bit address has been written, so I'm not sure what's going on there.
Viresh maybe you can shed some light on this. Btw. the register write
function of the STMPE driver also seems to be not endian safe.

- Lars

