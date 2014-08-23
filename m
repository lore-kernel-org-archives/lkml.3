Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaHWPKV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 11:10:21 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60101 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaHWPKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 11:10:20 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53F8AED8.8010908@roeck-us.net>
Date: Sat, 23 Aug 2014 08:10:16 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>, atull@opensource.altera.com
CC: jdelvare@suse.de, lm-sensors@lm-sensors.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v2 2/2] pmbus: ltc2978: add regulator gating
References: <1408741894-24879-1-git-send-email-atull@opensource.altera.com> <1408741894-24879-3-git-send-email-atull@opensource.altera.com> <20140822214546.GD24407@sirena.org.uk>
In-Reply-To: <20140822214546.GD24407@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2014 02:45 PM, Mark Brown wrote:
> On Fri, Aug 22, 2014 at 04:11:34PM -0500, atull@opensource.altera.com wrote:
>> From: Alan Tull <atull@opensource.altera.com>
>>
>> Add regulator with support for enabling or disabling all
>> supplies.
>
> Reviwed-by: Mark Brown <broonie@linaro.org>
>
> though it still looks like you should be able to create generic
> functions for the operations.
>
Sorry I didn't have time to review the code myself. I'll have
to check the datasheet about turning regulators on and off.
Using page 0xff for the lm2978 looks wrong, as the chip supports
up to 8 channels which should be controlled separately
(I would assume) instead of turning them all on and off in
one go. Maybe I am missing something, but my assumption would
have been to have a separate regulator for each channel, and
that each channel would have its own regulator which would be
turned on and off separately. So I don't really understand the
change between v1 and v2 of the core patch, which dropped the
per-channel regulators. Someone will have to explain to me
why that makes sense, especially since it means that I won't
be able to use the regulator expansion in my system (which
would require per-channel regulators, and which does not always
have all channels enabled on a given chip).

In respect to generic functions, that really depends on the scope
of the regulators. As written, where all regulators are turned on
in a single operation, per-chip functions are needed. I thought
we would only need per-chip configuration values, but that only
applies if regulators are turned on one by one, not all in one go.

Either case, a wrapper for ltc2978_write_pmbus_operation needs to
be added to pmbus_core.c as pmbus_write_byte_data and exported
(as a separate patch). For paged reads, the existing
pmbus_read_byte_data should be used. In general, avoid direct
accesses to paged registers and use API functions instead
if possible.

Thanks,
Guenter

