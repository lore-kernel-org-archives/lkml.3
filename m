Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043AbaBTMrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:47:03 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54296 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297AbaBTMrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:47:00 -0500
Message-ID: <5305F898.6020401@ti.com>
Date: Thu, 20 Feb 2014 14:44:08 +0200
From: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "grygorii.strashko@ti.com" <grygorii.strashko@ti.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "nsekhar@ti.com" <nsekhar@ti.com>
Subject: Re: [PATCH v5 2/2] memory: ti-aemif: add bindings for AEMIF driver
References: <1392817210-14312-1-git-send-email-ivan.khoronzhuk@ti.com> <1392817210-14312-3-git-send-email-ivan.khoronzhuk@ti.com> <20140219181152.GG25079@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140219181152.GG25079@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/19/2014 08:11 PM, Mark Rutland wrote:
> On Wed, Feb 19, 2014 at 01:40:10PM +0000, Ivan Khoronzhuk wrote:
>> Add bindings for TI Async External Memory Interface (AEMIF) controller.
>>
>> The Async External Memory Interface (EMIF16/AEMIF) controller is intended to
>> provide a glue-less interface to a variety of asynchronous memory devices like
>> ASRA M, NOR and NAND memory. A total of 256M bytes of any of these memories
>> can be accessed via 4 chip selects with 64M byte access per chip select.
>>
>> We are not encoding CS number in reg property, it's memory partition number.
>> The CS number is encoded for Davinci NAND node using standalone property
>> "ti,davinci-chipselect" and we need to provide two memory ranges to it,
>> as result we can't encode CS number in "reg" for AEMIF child devices
>> (NAND/NOR/etc), as it will break bindings compatibility.
>>
>> In this patch, NAND node is used just as an example of child node.
>>
>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>> ---
>>   .../bindings/memory-controllers/ti-aemif.txt       | 210 +++++++++++++++++++++
>>   1 file changed, 210 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/memory-controllers/ti-aemif.txt
> [...]
>
>> +- ranges:		Contains memory regions. There are two types of
>> +			ranges/partitions:
>> +			- CS-specific partition/range. If continuous, must be
>> +			set up to reflect the memory layout for 4 chipselects,
>> +			if not then additional range/partition can be added and
>> +			child device can select the proper one.
>> +			- control partition which is common for all CS
>> +			interfaces.
> This really doesn't sound anything like the typical meaning of ranges on
> a bus.
>
> Why isn't this information encoded in reg properties on the child nodes?
>
> [...]

Note that we do not introduce NAND device bindings here.
The Davinci NAND bindings was introduced and accepted more then one year ago.
And the CS number is encoded for Davinci NAND node using standalone property
"ti,davinci-chipselect" and we need to provide two memory ranges to it,
as result we can't encode CS number in "reg" for AEMIF child devices (NAND/NOR/etc),
as it will break bindings compatibility.

In this document, NAND node is used just as an example of child node.

>> +- ti,cs-ss:		enable/disable select strobe mode
>> +				In select strobe mode chip select behaves as
>> +				the strobe and is active only during the strobe
>> +				period. If present then enable.
>> +
>> +- ti,cs-ew:		enable/disable extended wait mode
>> +				if set, the controller monitors the EMIFWAIT pin
>> +				mapped to that chip select to determine if the
>> +				device wants to extend the strobe period. If
>> +				present then enable.
> When would you have these two in the DT and when wouldn't you? Why can't
> the driver decide?

These are properties of cs node, not the driver itself.
The driver cannot know what child device you are going to attach to cs node
, as result it cannot decide what settings you are using for particular 
cs node.

> These names are also opaque. We can clearly do better.

I propose the following names?:

ti,cs-ss  --> ti,cs-select-strobe-mode
ti,cs-ew --> ti,cs-extended-waite-mode

Are you OK with it?

>> +
>> +- ti,cs-ta:		minimum turn around time, ns
>> +				Time between the end of one asynchronous memory
>> +				access and the start of another asynchronous
>> +				memory access. This delay is not incurred
>> +				between a read followed by read or a write
>> +				followed by a write to same chip select.
> The name is opaque. How about ti,min-turnaround-time-ns ?

I like without -ns suffix and with cs- prefix:
ti,cs-ta --> ti,cs-min-turnaround-time

Is it OK?

>> +
>> +- ti,cs-rsetup:		read setup width, ns
>> +				Time between the beginning of a memory cycle
>> +				and the activation of read strobe.
>> +				Minimum value is 1 (0 treated as 1).
>> +
>> +- ti,cs-rstobe:		read strobe width, ns
>> +				Time between the activation and deactivation of
>> +				the read strobe.
>> +				Minimum value is 1 (0 treated as 1).
>> +
>> +- ti,cs-rhold:		read hold width, ns
>> +				Time between the deactivation of the read
>> +				strobe and the end of the cycle (which may be
>> +				either an address change or the deactivation of
>> +				the chip select signal.
>> +				Minimum value is 1 (0 treated as 1).
>> +
>> +- ti,cs-wsetup:		write setup width, ns
>> +				Time between the beginning of a memory cycle
>> +				and the activation of write strobe.
>> +				Minimum value is 1 (0 treated as 1).
>> +
>> +- ti,cs-wstrobe:	write strobe width, ns
>> +				Time between the activation and deactivation of
>> +				the write strobe.
>> +				Minimum value is 1 (0 treated as 1).
>> +
>> +- ti,cs-whold:		write hold width, ns
>> +				Time between the deactivation of the write
>> +				strobe and the end of the cycle (which may be
>> +				either an address change or the deactivation of
>> +				the chip select signal.
>> +				Minimum value is 1 (0 treated as 1).
> Likewise I think these can be given more descriptive names.

Ok. How about:

ti,cs-rsetup --> ti,cs-read-setup-time
ti,cs-rstobe --> ti,cs-read-strobe-time
ti,cs-rhold  --> ti,cs-read-hold-time
ti,cs-wsetup --> ti,cs-write-setup-time
ti,cs-wstrobe --> ti,cs-write-strobe-time
ti,cs-whold --> ti,cs-write-hold-time

Thanks

-- 
Regards,
Ivan Khoronzhuk

