Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965331AbaFQV0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:26:45 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:43669 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964980AbaFQV0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:26:43 -0400
Message-ID: <53A0B27E.5010708@gmail.com>
Date: Tue, 17 Jun 2014 23:26:22 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        mark.brown@linaro.org
CC: Tomasz Figa <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>, linux-kernel@vger.kernel.org,
        joshi@samsung.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH RFC] mfd: syscon: Decouple syscon interface from syscon
 devices
References: <53A05E2D.6020702@samsung.com> <1403019164-12514-1-git-send-email-t.figa@samsung.com> <5027740.B7iVUcUX2T@wuerfel>
In-Reply-To: <5027740.B7iVUcUX2T@wuerfel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 17.06.2014 17:42, Arnd Bergmann wrote:
> On Tuesday 17 June 2014 17:32:44 Tomasz Figa wrote:
>> Currently a syscon entity can be only registered directly through a
>> platform device that binds to a dedicated driver. However in certain use
>> cases it is desirable to make a device used with another driver a syscon
>> interface provider. For example, certain SoCs (e.g. Exynos) contain
>> system controller blocks which perform various functions such as power
>> domain control, CPU power management, low power mode control, but in
>> addition contain certain IP integration glue, such as various signal
>> masks, coprocessor power control, etc. In such case, there is a need to
>> have a dedicated driver for such system controller but also share
>> registers with other drivers. The latter is where the syscon interface
>> is helpful.
>>
>> This patch decouples syscon object from syscon driver, so that it can be
>> registered from any driver in addition to the original "syscon" platform
>> driver.
>>
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
> 
> Hi Tomasz,
> 
> This seems like a reasonable way of solving the problem, but I think
> there is an even better one that we have about in the past: if we
> promote syscon from a platform driver into a a drivers/base/ helper
> that is independent of the platform device matching, we can use
> call syscon_regmap_lookup_* for any device node, whether it's already
> bound to a driver or not, which do what you need. It would also make
> it easier to call the syscon code before the platform_device
> infrastructure gets initialized, which is something a number of
> people have asked for, e.g. for using regmap to do SMP bringup
> or for clock registration.

Basically, unless I'm missing your point, this is what my patch does,
except that I don't move it to drivers/base/ and the registration
function I added require a pointer to struct device. Indeed, decoupling
it further from the driver model, by adding of_syscon_register() should
be useful for early users.

Should I move this to drivers/base/, even though from current location
it can be used outside the platform driver anyway?

Best regards,
Tomasz
