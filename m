Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaKGQhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:37:31 -0500
Received: from mx.datacom.ind.br ([177.66.5.10]:33029 "EHLO
	mail.datacom.ind.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751519AbaKGQh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:37:29 -0500
Message-ID: <545CF546.8090703@datacom.ind.br>
Date: Fri, 07 Nov 2014 14:37:26 -0200
From: =?windows-1252?Q?DATACOM_-_=C9rico_Nunes?= 
	<erico.nunes@datacom.ind.br>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: grant.likely@linaro.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        sameo@linux.intel.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: Creating a new platform_bus inside a spi_driver
References: <545BD3EC.6050503@datacom.ind.br> <707686811.tbHdnxXMgE@wuerfel>
In-Reply-To: <707686811.tbHdnxXMgE@wuerfel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Arnd and all,

On 11/07/2014 08:04 AM, Arnd Bergmann wrote:
> On Thursday 06 November 2014 18:02:52 DATACOM - Érico Nunes wrote:
>> The idea is that "fpga-spi" is a spi_driver which instantiates all of the
>> "fpga-deviceN" as platform_devices, through the use of
>> of_platform_populate(dev->of_node, NULL, NULL, dev).
>>
>> The visible problem we're facing with this approach is that, as the internal
>> platform_devices have a "reg" property, of_platform_populate() eventually
>> triggers an address translation which is apparently trying to translate the
>> addresses of the internal platform_bus to addresses of the processor memory
>> map.
>> This translation is however not part of our intention, as we intend to have an
>> internal bus with its own memory map.
>> This fails when __of_translate_address() reaches the spi-master boundary
>> because (as it seems to make sense) it isn't possible to translate them past
>> that.
>> A KERN_ERR rated message like
>> "prom_parse: Bad cell count for /soc@f0000000/spi@2000/fpga@1"
>> is thrown by __of_translate_address() and later it is not possible to obtain
>> the "reg" address with platform_get_resource().
>>
>> On this scenario, we have a few questions and, depending on the outcome of
>> these, possibly a patch.
>>
>> 1. Is it possible to have an internal platform_bus with a different memory map
>> as we intended? Or are platform_busses and platform_devices supposed to always
>> be mapped on the processor memory map?
> It's inconsistent. We have some code that assumes that platform devices
> are always memory mapped, and some other code that breaks this assumption.

By this I take that the platform subsystem could be made generic so it can be
used in both ways (mapped to processor memory map or mapped to a private memory
map). There seems to be no strict requirement enforcing it to be processor
memory map.

Is this correct?

>> 2. If platform_bus and platform_device were actually designed to always be
>> mappable to the processor memory map, what would be a different approach to
>> this problem?  One alternative considered was to define a new "fpga_bus" and
>> "fpga_device" but that seemed as an overkill approach to the problem.
> I think the existing mfd framework should do what you need, when you call
> mfd_add_devices() and pass a table of cells with the compatible strings
> for your devices, it should create the platform devices you want. If not,
> that can probably be fixed in the mfd core code.
>
>

Thanks for the tip, we were not aware of the purpose of this mfd framework and
we will take a look at this framework now.
However I'm thinking now that eventually it would fall in the same case of
trying to translate the address of any "reg" dts property to the processor
memory map, and fail with the same error for the SPI case.

Considering this and taking the answer to the first question, do you think a
patch fixing the "error" report by the translation function would be
acceptable?
We can prepare/test that under our platform and submit it.

Thanks!


