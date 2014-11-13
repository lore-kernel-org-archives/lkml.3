Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932347AbaKMIwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:52:09 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:57774 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932116AbaKMIwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:52:08 -0500
Message-ID: <54647133.1030801@mm-sol.com>
Date: Thu, 13 Nov 2014 10:52:03 +0200
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        =?windows-1252?Q?DATACOM_-_=C9rico_Nunes?= 
	<erico.nunes@datacom.ind.br>
CC: robh+dt@kernel.org, devicetree@vger.kernel.org, sameo@linux.intel.com,
        lee.jones@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: Creating a new platform_bus inside a spi_driver
References: <545BD3EC.6050503@datacom.ind.br>	<707686811.tbHdnxXMgE@wuerfel> <545CF546.8090703@datacom.ind.br>	<2501338.EAyTJJ482M@wuerfel> <20141111110757.3DFFAC40D48@trevor.secretlab.ca>
In-Reply-To: <20141111110757.3DFFAC40D48@trevor.secretlab.ca>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant, Arnd and Erico

On 11/11/2014 01:07 PM, Grant Likely wrote:
> On Fri, 07 Nov 2014 18:04:35 +0100
> , Arnd Bergmann <arnd@arndb.de>
>  wrote:
>> On Friday 07 November 2014 14:37:26 DATACOM - Érico Nunes wrote:
>>> Hello Arnd and all,
>>>
>>> On 11/07/2014 08:04 AM, Arnd Bergmann wrote:
>>>> On Thursday 06 November 2014 18:02:52 DATACOM - Érico Nunes wrote:
>>>>> The idea is that "fpga-spi" is a spi_driver which instantiates all of the
>>>>> "fpga-deviceN" as platform_devices, through the use of
>>>>> of_platform_populate(dev->of_node, NULL, NULL, dev).
>>>>>
>>>>> The visible problem we're facing with this approach is that, as the internal
>>>>> platform_devices have a "reg" property, of_platform_populate() eventually
>>>>> triggers an address translation which is apparently trying to translate the
>>>>> addresses of the internal platform_bus to addresses of the processor memory
>>>>> map.
>>>>> This translation is however not part of our intention, as we intend to have an
>>>>> internal bus with its own memory map.
>>>>> This fails when __of_translate_address() reaches the spi-master boundary
>>>>> because (as it seems to make sense) it isn't possible to translate them past
>>>>> that.
>>>>> A KERN_ERR rated message like
>>>>> "prom_parse: Bad cell count for /soc@f0000000/spi@2000/fpga@1"
>>>>> is thrown by __of_translate_address() and later it is not possible to obtain
>>>>> the "reg" address with platform_get_resource().
>>>>>
>>>>> On this scenario, we have a few questions and, depending on the outcome of
>>>>> these, possibly a patch.
>>>>>
>>>>> 1. Is it possible to have an internal platform_bus with a different memory map
>>>>> as we intended? Or are platform_busses and platform_devices supposed to always
>>>>> be mapped on the processor memory map?
>>>> It's inconsistent. We have some code that assumes that platform devices
>>>> are always memory mapped, and some other code that breaks this assumption.
>>>
>>> By this I take that the platform subsystem could be made generic so it can be
>>> used in both ways (mapped to processor memory map or mapped to a private memory
>>> map). There seems to be no strict requirement enforcing it to be processor
>>> memory map.
>>>
>>> Is this correct?
>>
>> It could be, but I'm sure if that is a good idea or not. It might complicate
>> things elsewhere, so it would at least need careful testing and consensus
>> among a broader group of developers.
> 
> I don't think it is a good idea. I would prefer to make the behaviour of
> of_platform_populate() generic so it could work for multiple bus
> types rather than reusing/abusing platform_device in this way.
> 
> If the devices on the FPGA were memory mapped, it would be a different
> situation, but being behind an SPI bus where the access to those devices
> must always be mediated by the SPI controller, it would be better to
> have a separate bus type and a separate pool of drivers for those
> devices.
> 

This is exactly the same problem that we have on Qualcomm SPMI PMIC mfd
driver. We had a discussion at [1] where we tried to solve it by
IORESOURCE_REG. Unfortunately there is no conclusion yet.

I'm glad to see that someone else have the same issue, maybe it is time
to restart the discussion. The last proposal from Grant was to implement
dev_get_localbus_address() API in drivers/base.

regards
Stan

[1] https://lkml.org/lkml/2014/7/29/252
