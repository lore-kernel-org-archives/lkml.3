Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933509AbaJVXBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 19:01:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:49654 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932743AbaJVXB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 19:01:29 -0400
Message-ID: <54483746.9060104@codeaurora.org>
Date: Wed, 22 Oct 2014 16:01:26 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
CC: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robherring2@gmail.com>,
        Rob Herring <rob.herring@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] RFC: add function for localbus address
References: <20140729234522.E9FF1C40738@trevor.secretlab.ca>	<1409672700-21697-1-git-send-email-svarbanov@mm-sol.com>	<20140908145204.8ADC2C40AE5@trevor.secretlab.ca>	<540E1014.8090102@codeaurora.org> <20140914044610.913E9C4102A@trevor.secretlab.ca>
In-Reply-To: <20140914044610.913E9C4102A@trevor.secretlab.ca>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2014 09:46 PM, Grant Likely wrote:
> On Mon, 08 Sep 2014 13:22:44 -0700, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>
>> Where is this described? From the commit text that introduces
>> IORESOURCE_REG I see:
>>
>> "Currently a bunch of I2C/SPI MFD drivers are using IORESOURCE_IO for
>> register address ranges. Since this causes some confusion due to the
>> primary use of this resource type for PCI/ISA I/O ports create a new
>> resource type IORESOURCE_REG."
> Sorry, I mistook IORESOURCE_REG or IORESOURCE_IO. You're right, this
> isn't an issue.
>
> I'm still concerned about the implications of automatically populating
> platform_devices with this resource type. I'll talk to Mark about it
> face to fact at Connect this week.
>
>

Where did this end up? When we talked at Connect I think we settled on
exploring a driver core specific API like dev_get_localbus_address()
that calls of_get_localbus_address() for devices with an of_node and in
the future it could call something like acpi_get_localbus_address() when
there's an acpi_node. I believe the biggest concern is that we're making
an API that is OF or platform bus specific when it doesn't need to be.
Making a driver core specific API avoids this problem by making it bus
agnostic.

That's fine, but I still think we want to have the IORESOURCE_REG
resources given that we have drivers in-flight and some already merged
that are using the IORESOURCE_REG resource. Furthermore, ACPI is using
the platform bus for MFDs so it's not like we're going to be using a
different bus in the future for these pmic sub-device drivers if we
decide to do pmic devices in ACPI (looks like there is at least
precedence for that with Intel's i2c pmic). Supporting this on ACPI is
going to take the same effort if we plumb it into the resource table or
we plumb it into a new driver core API, so the bus agnostic angle isn't
looking all that convincing. Not to say I'm opposed to some driver core
specific API (that's similar to the proposed device_property_read_*()
API) but I don't see any benefit for something that is already "unified"
between ACPI and OF via the platform bus resources table. If the
resources table didn't already exist I'd be more inclined to say we
should use some new driver core API.

So what's the way forward? I see a few options:

1) Take this patch after some minor tweaks
2) Add a driver core API and fixup all drivers to use it
3) Layer the platform resource stuff on top of a driver core API

I'd prefer we went with option #1.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

