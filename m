Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393AbaJHQV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:21:59 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:16165 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbaJHQV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:21:57 -0400
Message-ID: <5435649F.5070908@c-s.fr>
Date: Wed, 08 Oct 2014 18:21:51 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Mark Brown <broonie@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org
Subject: Re: [PATCH v2 1/2] spi: fsl-spi: Fix parameter ram offset setup for
 CPM1
References: <20141003164916.DBD631AAFA2@localhost.localdomain>	 <1412368198.13320.434.camel@snotra.buserror.net> <542FE1C4.7000403@c-s.fr> <1412640953.13320.502.camel@snotra.buserror.net>
In-Reply-To: <1412640953.13320.502.camel@snotra.buserror.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 07/10/2014 02:15, Scott Wood a écrit :
> On Sat, 2014-10-04 at 14:02 +0200, christophe leroy wrote:
>> Le 03/10/2014 22:29, Scott Wood a écrit :
>>> On Fri, 2014-10-03 at 18:49 +0200, Christophe Leroy wrote:
>>>> On CPM1, the SPI parameter RAM has a default location. In fsl_spi_cpm_get_pram()
>>>> there was a confusion between the SPI_BASE register and the base of the SPI
>>>> parameter RAM. Fortunatly, it was working properly with MPC866 and MPC885
>>>> because they do set SPI_BASE, but on MPC860 and other old MPC8xx that doesn't
>>>> set SPI_BASE, pram_ofs was not properly set. This patch fixes this confusion.
>>>>
>>>> Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
>>>>
>>>> ---
>>>> Changes from v1 to v2: none
>>>>
>>>>    drivers/spi/spi-fsl-cpm.c | 9 ++++-----
>>>>    1 file changed, 4 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/spi/spi-fsl-cpm.c b/drivers/spi/spi-fsl-cpm.c
>>>> index 54b0637..0f3a912 100644
>>>> --- a/drivers/spi/spi-fsl-cpm.c
>>>> +++ b/drivers/spi/spi-fsl-cpm.c
>>>> @@ -262,15 +262,14 @@ static unsigned long fsl_spi_cpm_get_pram(struct mpc8xxx_spi *mspi)
>>>>    		pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
>>>>    		out_be16(spi_base, pram_ofs);
>>>>    	} else {
>>>> -		struct spi_pram __iomem *pram = spi_base;
>>>> -		u16 rpbase = in_be16(&pram->rpbase);
>>>> +		u16 rpbase = in_be16(spi_base);
>>>>    
>>>> -		/* Microcode relocation patch applied? */
>>>> +		/* Microcode relocation patch applied | rpbase set by default */
>>>>    		if (rpbase) {
>>>>    			pram_ofs = rpbase;
>>>>    		} else {
>>>> -			pram_ofs = cpm_muram_alloc(SPI_PRAM_SIZE, 64);
>>>> -			out_be16(spi_base, pram_ofs);
>>>> +			pram_ofs = offsetof(cpm8xx_t, cp_dparam[PROFF_SPI]) -
>>>> +				   offsetof(cpm8xx_t, cp_dpmem[0]);
>>>>    		}
>>>>    	}
>>> Why is PROFF_SPI not coming from the device tree?
>> That's where it starts to become tricky.
>>
>> PROFF_SPI is defined in cpm1.h which is included by the driver already.
> Yes, but those values shouldn't be used.  It's a leftover from the old
> way of hardcoding things and describing the hardware with kconfig rather
> than the device tree.
>
>> It provides the default offset from the start of the parameter RAM.
>> Previously I had the following in my device tree, and the last part of
>> the source above (the one for rpbase == 0) could not work.
>>
>>               spi: spi@a80 {
>>                   cell-index = <0>;
>>                   compatible = "fsl,spi", "fsl,cpm1-spi";
>>                   reg = <0xa80 0x30 0x3d80 0x30>;
>>
>> First reg area was the area for SPI registers. Second area was the
>> parameter RAM zone, which was just mapped to get access to the SPI_BASE
>> pointer (rpbase)
>>
>> Now I have
>>
>>                   compatible = "fsl,spi", "fsl,cpm1-spi-reloc";
>>                   reg = <0xa80 0x30 0x3dac 0x2>;
>>
>> First reg area is the area for SPI registers. Second area is the
>> SPI_BASE, as for the CPM2.
>>
>> On recent 8xx (885 and 866 at least) it contains the offset (=0x1D80) of
>> the parameter RAM. But on old ones (860, ...) it contains 0. Therefore
>> we have to get the default index in another way.
>> What I wanted was to keep something similar to what's done with CPM2.
>>
>> What should it look like if that offset had to be in the device tree ?
> If the offset is not relocatable or discoverable, it should stay in the
> device tree.  If you have an old chip you wouldn't have
> fsl,cpm1-spi-reloc and thus you'd still have "0x3d80 0x30" in reg.
This index is from the start of the dual port RAM. It is 0x2000 above 
the start of the CPM area.
In the DTS, we have:

     soc@ff000000 {
         compatible = "fsl,mpc885", "fsl,pq1-soc";
         #address-cells = <1>;
         #size-cells = <1>;
         device_type = "soc";
         ranges = <0x0 0xff000000 0x28000>;
         bus-frequency = <0>;
         clock-frequency = <0>;

         cpm@9c0 {
             #address-cells = <1>;
             #size-cells = <1>;
             compatible = "fsl,mpc885-cpm", "fsl,cpm1";
             ranges;
             reg = <0x9c0 0x40>;
             brg-frequency = <0>;
             interrupts = <0>;    // cpm error interrupt
             interrupt-parent = <&CPM_PIC>;

             muram@2000 {
                 #address-cells = <1>;
                 #size-cells = <1>;
                 ranges = <0x0 0x2000 0x2000>;

                 data@0 {
                     compatible = "fsl,cpm-muram-data";
                     reg = <0x0 0x1c00>;
                 };
             };

             spi: spi@a80 {
                 #address-cells = <1>;
                 #size-cells = <0>;
                 cell-index = <0>;
                 compatible = "fsl,spi", "fsl,cpm1-spi";
                 reg = <0xa80 0x30 0x3d80 0x30>;
                 interrupts = <5>;
                 interrupt-parent = <&CPM_PIC>;
                 mode = "cpu";


The binding allows me to do an of_iomap() on the parameter RAM, hence to 
get access to the relocation index which is inside it.
But if the relocation index is 0, I have to calculate it by myself 
because the calling function expects it in return.
The binding is also supposed to tell that the muram is at 0xff002000. 
But I don't know how I can get this info and use it to calculate the 
index of my param RAM ? I need to calculate the index which is 1d80 
(0x3d80 - 0x2000)

Christophe

