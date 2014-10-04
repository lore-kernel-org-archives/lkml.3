Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaJDKHf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 06:07:35 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:40713 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758AbaJDKHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 06:07:33 -0400
Message-ID: <542FC6CC.4000507@c-s.fr>
Date: Sat, 04 Oct 2014 12:07:08 +0200
From: christophe leroy <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Mark Brown <broonie@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] spi: fsl-spi: Allow dynamic allocation of CPM1
 parameter RAM
References: <20141003164917.397871AB276@localhost.localdomain> <1412365908.13320.429.camel@snotra.buserror.net>
In-Reply-To: <1412365908.13320.429.camel@snotra.buserror.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Antivirus: avast! (VPS 141004-0, 04/10/2014), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 03/10/2014 21:51, Scott Wood a écrit :
> On Fri, 2014-10-03 at 18:49 +0200, Christophe Leroy wrote:
>> On CPM1, the SPI parameter RAM has a default location. In order to use SPI while
>> using SCC2 with features like QMC or Ethernet, it is necessary to relocate SPI
>> parameter RAM in a free location in the CPM dual port RAM.
> Please explain in more detail why it's necessary.
SCC2 parameter RAM is located at offset 0x1D00 inside the CPM dual port RAM.
SPI parameter RAM is located at offset 0x1D80.
When using SCC2 in Ethernet Mode, the parameter RAM size is 0xA4.
When using SCC2 in QMC mode, the parameter RAM size is 0xAC.
Therefore in both case, it overlaps the SPI parameter RAM which shall 
then be relocated.
On MPC860 this can only be done using an additional microcode. 
Therefore, the relocation configuration is managed within 
arch/powerpc/sysdep/micropatch.c
On MPC866 and MPC885 (at least) no microcode is needed. Therefore, if we 
want to relocate the SPI param, we must handle that outside of micropatch.c
Since the SPI driver already handle dynamic parameter RAM allocation for 
CPM2, I though it was the good place to do it also for CPM1.
>
>>   With this patch,
>> when "fsl,cpm1-spi-reloc" instead of "fsl,cpm1-spi" compatible is set in the
>> device tree, the parameter RAM for SPI is dynamically allocated
>> with cpm_muram_alloc().
>>
>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>
>> ---
>> Changes from v1 to v2: using OF compatible instead of compile time option
>>
>>   drivers/spi/spi-fsl-cpm.c   | 3 +++
>>   drivers/spi/spi-fsl-lib.c   | 2 ++
>>   include/linux/fsl_devices.h | 1 +
>>   3 files changed, 6 insertions(+)
>>
>> diff --git a/drivers/spi/spi-fsl-cpm.c b/drivers/spi/spi-fsl-cpm.c
>> index 0f3a912..048ca5f 100644
>> --- a/drivers/spi/spi-fsl-cpm.c
>> +++ b/drivers/spi/spi-fsl-cpm.c
>> @@ -261,6 +261,9 @@ static unsigned long fsl_spi_cpm_get_pram(struct mpc8xxx_spi *mspi)
>>   	if (mspi->flags & SPI_CPM2) {
>>   		pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
>>   		out_be16(spi_base, pram_ofs);
>> +	} else if (mspi->flags & SPI_CPM1_RELOC) {
>> +		pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 32);
>> +		out_be16(spi_base, pram_ofs);
>>   	} else {
>>   		u16 rpbase = in_be16(spi_base);
>>   
>> diff --git a/drivers/spi/spi-fsl-lib.c b/drivers/spi/spi-fsl-lib.c
>> index c3f7802..e9db4c5 100644
>> --- a/drivers/spi/spi-fsl-lib.c
>> +++ b/drivers/spi/spi-fsl-lib.c
>> @@ -227,6 +227,8 @@ int of_mpc8xxx_spi_probe(struct platform_device *ofdev)
>>   		pdata->flags = SPI_CPM_MODE | SPI_CPM2;
>>   	else if (of_device_is_compatible(np, "fsl,cpm1-spi"))
>>   		pdata->flags = SPI_CPM_MODE | SPI_CPM1;
>> +	else if (of_device_is_compatible(np, "fsl,cpm1-spi-reloc"))
>> +		pdata->flags = SPI_CPM_MODE | SPI_CPM1 | SPI_CPM1_RELOC;
> Where's the binding and device tree update for this?  What specific
> aspect of hardware does it describe?
Well, the intension was not really to describe any specific aspect of 
hardware, but to provide an easy way to tell the driver that we want 
dynamic reallocation of the parameter RAM.
On CPM2, dynamic allocation of parameter RAM is the only way.
On CPM1:
* The parameter RAM has a default location.
* When the SPI relocation micropatch is applied, the kernel reallocate 
it just after the patch, when loading the patch. This is not good for 
using QMC, because it is within the part of dual port RAM used by the 
QMC, therefore it reduce even more the number of channels that the QMC 
can use.

The bindings for that driver are described in 
Documentation/devicetree/bindings/spi/fsl-spi.txt. But it seems that it 
doesn't describe anything related to those compatibles. The driver has a 
match on "fsl,fsl-spi" only, and for using it with CPM you have to add 
"fsl,cpm1-spi" or "fsl,cpm2-spi" to tell the driver that it is CPM 
(existing code below).

     prop = of_get_property(np, "mode", NULL);
     if (prop && !strcmp(prop, "cpu-qe"))
         pdata->flags = SPI_QE_CPU_MODE;
     else if (prop && !strcmp(prop, "qe"))
         pdata->flags = SPI_CPM_MODE | SPI_QE;
     else if (of_device_is_compatible(np, "fsl,cpm2-spi"))
         pdata->flags = SPI_CPM_MODE | SPI_CPM2;
     else if (of_device_is_compatible(np, "fsl,cpm1-spi"))
         pdata->flags = SPI_CPM_MODE | SPI_CPM1;


Christophe

---
Ce courrier électronique ne contient aucun virus ou logiciel malveillant parce que la protection avast! Antivirus est active.
http://www.avast.com

