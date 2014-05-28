Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbaE1Daw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 23:30:52 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:63926 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbaE1Dat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 23:30:49 -0400
Message-ID: <53855867.7050800@linaro.org>
Date: Tue, 27 May 2014 22:30:47 -0500
From: Alex Elder <elder@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: "mporter@linaro.org" <mporter@linaro.org>,
        "bcm@fixthebug.org" <bcm@fixthebug.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "sboyd@codeaurora.org" <sboyd@codeaurora.org>,
        "bcm-kernel-feedback-list@broadcom.com" 
	<bcm-kernel-feedback-list@broadcom.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <Pawel.Moll@arm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "rjui@broadcom.com" <rjui@broadcom.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "rvaswani@codeaurora.org" <rvaswani@codeaurora.org>
Subject: Re: [PATCH v4 1/5] devicetree: bindings: document Broadcom CPU enable
 method
References: <1400607830-10989-1-git-send-email-elder@linaro.org> <1400607830-10989-2-git-send-email-elder@linaro.org> <20140527114958.GC18476@e102568-lin.cambridge.arm.com>
In-Reply-To: <20140527114958.GC18476@e102568-lin.cambridge.arm.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2014 06:49 AM, Lorenzo Pieralisi wrote:
> On Tue, May 20, 2014 at 06:43:46PM +0100, Alex Elder wrote:
>> Broadcom mobile SoCs use a ROM-implemented holding pen for
>> controlled boot of secondary cores.  A special register is
>> used to communicate to the ROM that a secondary core should
>> start executing kernel code.  This enable method is currently
>> used for members of the bcm281xx and bcm21664 SoC families.
>>
>> The use of an enable method also allows the SMP operation vector to
>> be assigned as a result of device tree content for these SoCs.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
> 
> This is getting out of control, it is absolutely ghastly. I wonder how
> I can manage to keep cpus.txt updated if anyone with a boot method
> du jour adds into cpus.txt, and honestly in this specific case it is even
> hard to understand why.

OK, in this message I'll focus on the particulars of this
proposed binding.

> Can't it be done with bindings for the relative register address space
> (regmap ?) and platform code just calls the registers driver to set-up the
> jump address ? It is platform specific code anyway there is no way you
> can make this generic.

I want to clarify what you're after here.

My aim is to add SMP support for a class of Broadcom SMP
machines.  To do so, I'm told I need to use the technique
of assigning the SMP operations vector as a result of
identifying an enable method in the DT.

For 32-bit ARM, there are no generic "enable-method" values.
(I did attempt to create one for "spin-table" but that was
rejected by Russell King.)  For the machines I'm trying to
enable, secondary CPUS start out spinning in a ROM-based
holding pen, and there is no need for a kernel-based one.

However, like a spin-table/holding pen enable method, a
memory location is required for coordination between the
boot CPU running kernel code and secondary CPUs running ROM
code.  My proposal specifies it using a special numeric
property value named "secondary-boot-reg" in the "cpus"
node in the DT.

And as I understand it, the issue you have relates to how
this memory location is specified.

You suggest regmap.  I'm using a single 32-bit register,
only at very early boot time, and thereafter access to
it is meaningless.  It seems like overkill if it's only
used for this purpose.  I could hide the register values
in the code, but with the exception of that, the code I'm
using is generic (in the context of this class of Broadcom
machine).  I could specify the register differently somehow,
in a different node, or with a different property.

The bottom line here is I'm not sure whether I understand
what you're suggesting, or perhaps why what you suggest is
preferable.  I'm very open to suggestions, I just need it
laid out a bit more detail in order to respond directly.

Thanks.

					-Alex

> I really do not see the point in cluttering cpus.txt with this stuff, it
> is a platform specific hack, and do not belong in generic bindings in my
> opinion.
> 
> Thanks,
> Lorenzo
> 
>> ---
>>  Documentation/devicetree/bindings/arm/cpus.txt | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
>> index 333f4ae..c6a2411 100644
>> --- a/Documentation/devicetree/bindings/arm/cpus.txt
>> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
>> @@ -185,6 +185,7 @@ nodes to be present and contain the properties described below.
>>  			    "qcom,gcc-msm8660"
>>  			    "qcom,kpss-acc-v1"
>>  			    "qcom,kpss-acc-v2"
>> +			    "brcm,bcm11351-cpu-method"
>>  
>>  	- cpu-release-addr
>>  		Usage: required for systems that have an "enable-method"
>> @@ -209,6 +210,17 @@ nodes to be present and contain the properties described below.
>>  		Value type: <phandle>
>>  		Definition: Specifies the ACC[2] node associated with this CPU.
>>  
>> +	- secondary-boot-reg
>> +		Usage:
>> +			Required for systems that have an "enable-method"
>> +			property value of "brcm,bcm11351-cpu-method".
>> +		Value type: <u32>
>> +		Definition:
>> +			Specifies the physical address of the register used to
>> +			request the ROM holding pen code release a secondary
>> +			CPU.  The value written to the register is formed by
>> +			encoding the target CPU id into the low bits of the
>> +			physical start address it should jump to.
>>  
>>  Example 1 (dual-cluster big.LITTLE system 32-bit):
>>  
>> -- 
>> 1.9.1
>>
>>
> 

