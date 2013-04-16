Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965085Ab3DPRPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:15:51 -0400
Received: from co1ehsobe001.messaging.microsoft.com ([216.32.180.184]:34490
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965022Ab3DPRPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:15:48 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(z551bizbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1155h)
X-WSS-ID: 0MLCYM4-02-CM3-02
X-M-MSG: 
Message-ID: <516D8743.4080206@amd.com>
Date: Tue, 16 Apr 2013 12:15:47 -0500
From: Aravind <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <dougthompson@xmission.com>, <jbarnes@virtuousgeek.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-edac@vger.kernel.org>
Subject: Re: [PATCH v3] edac: Handle EDAC ECC errors for Family 16h
References: <1366052160-3091-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <20130416142432.GF5332@pd.tnic>
In-Reply-To: <20130416142432.GF5332@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.181.55.254]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 09:24 AM, Borislav Petkov wrote:
> On Mon, Apr 15, 2013 at 01:56:00PM -0500, Aravind Gopalakrishnan wrote:
>> Add code to handle ECC decoding for fam16h. Support exists for
>> previous families already, so code has been reused werever applicable
>> and some code has been added to handle fam16h specific operations.
>>
>> The patch was tested on Fam16h with ECC turned on
>> using the mce_amd_inj facility and works fine.
>>
>> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
>> ---
>>   arch/x86/kernel/amd_nb.c  |    4 +-
>>   drivers/edac/amd64_edac.c |   96 +++++++++++++++++++++++++++++++++++++++++++--
>>   drivers/edac/amd64_edac.h |    4 +-
>>   include/linux/pci_ids.h   |    2 +
>>   4 files changed, 101 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
>> index 4c39baa..a8bbcf6 100644
>> --- a/arch/x86/kernel/amd_nb.c
>> +++ b/arch/x86/kernel/amd_nb.c
>> @@ -16,12 +16,14 @@ const struct pci_device_id amd_nb_misc_ids[] = {
>>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
>>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
>>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
>> +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
> This chunk doesn't apply even on current Linus. For the future,
> if you're sending x86 patches, always create them against current
> tip/master which contains the latest x86 patch queue.
>
> This one case in point, please redo it against tip/master.

     I had based off bp.git's master... and it misses an additional 
'PCI_DEVICE' line (Hence the conflict)
     I shall redo it against Linus's tree..
>>   	{}
>>   };
>>   EXPORT_SYMBOL(amd_nb_misc_ids);
>>   
>>   static struct pci_device_id amd_nb_link_ids[] = {
>>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
>> +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
>>   	{}
>>   };
>>   
>> @@ -77,7 +79,7 @@ int amd_cache_northbridges(void)
>>   			next_northbridge(link, amd_nb_link_ids);
>>           }
>>   
>> -	/* some CPU families (e.g. family 0x11) do not support GART */
>> +	/* some CPU families (e.g. family 0x11, 0x16) do not support GART */
>>   	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
>>   	    boot_cpu_data.x86 == 0x15)
>>   		amd_northbridges.flags |= AMD_NB_GART;
>> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
>> index 9a8bebc..9173173 100644
>> --- a/drivers/edac/amd64_edac.c
>> +++ b/drivers/edac/amd64_edac.c
>> @@ -98,6 +98,7 @@ int __amd64_write_pci_cfg_dword(struct pci_dev *pdev, int offset,
>>    *
>>    * F15h: we select which DCT we access using F1x10C[DctCfgSel]
>>    *
>> + * F16h has only 1 DCT
>>    */
>>   static int k8_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
>>   			       const char *func)
>> @@ -133,6 +134,15 @@ static int f15_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
>>   	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
>>   }
>>   
>> +static int f16_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
>> +				const char *func)
>> +{
>> +	if (addr >= 0x100)
>> +		return -EINVAL;
> I'm very sceptical F16h doesn't have F2 extended PCI config addresses.
> Please check the BKDG.
>
> If it does have, use f10_read_dct_pci_cfg, if it doesn't, use
> k8_read_dct_pci_cfg without introducing a new accessor while the other
> ones can be used.
>
> Whichever one you take, please add a comment somewhere explaining why it
> is ok to use it on F16h.

     Here, What I really wanted to do was to restrict the access to only 
1 DCT (as fam16 does not have a DCT1 and hence not allow any     addr > 
=0x100). Yes, for this I can modify the code to just use 
f10_read_dct_pci_cfg or k8_read_dct_pci_cfg.
     However, looking up BKDG once again, I see that the DCT config 
select register is similar to fam15's except there are extended bits     
for D18F2x10C[DctCfgSel].
     While there was one bit (bit 0) for fam15, it is 3 bits (bits 2:0) 
for fam16.
     There is only 1 DCT in F16h, hence only the value '000b' is 
accepted while '111b to 0001b' are reserved. Due to this, there is 
another     way to handle this in the code:
     * Have a seperate accesor for fam16h which does this:

static void f15h_select_dct(struct amd64_pvt *pvt, u8 dct)
{
         u32 reg = 0;

         amd64_read_pci_cfg(pvt->F1, DCT_CFG_SEL, &reg);
         reg &= 0xfffffff8;
         reg |= dct;
         amd64_write_pci_cfg(pvt->F1, DCT_CFG_SEL, reg);
}

static int f16_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
                                  const char *func)
{
         u32 reg = 0;
         u8 dct  = 0;

         if (addr >= 0x100) {
             return -EINVAL;
         }

         f15_select_dct(pvt, 0);

         return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
}

     1. Generalise f15h_select_dct function by doing 'reg &= 0xfffffff8'
     2. Call this with 'dct' value of 0

     Do let me know what might be the preferred method..

>> +	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
>> +}
>> +
>>   /*
>>    * Memory scrubber control interface. For K8, memory scrubbing is handled by
>>    * hardware and can involve L2 cache, dcache as well as the main memory. With
>> @@ -326,7 +336,42 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
>>   		base_bits	= GENMASK(21, 31) | GENMASK(9, 15);
>>   		mask_bits	= GENMASK(21, 29) | GENMASK(9, 15);
>>   		addr_shift	= 4;
>> -	} else {
>> +	}
>> +
>> +	/*
>> +	* there are two addr_shift values for F16h.
>> +	* addr_shift of 8 for high bits and addr_shift of 6
>> +	* for low bits. So handle it differently.
>> +	*/
>> +	else if (boot_cpu_data.x86 == 0x16) {
>> +		/* variables specific to F16h */
> Well, no need for that comment - we know what local variables are.
>
>> +		u64 base_bits_low, base_bits_high;
>> +		u64 mask_bits_low, mask_bits_high;
>> +		u8 addr_shift_low, addr_shift_high;
>> +
>> +		csbase          = pvt->csels[dct].csbases[csrow];
>> +		csmask          = pvt->csels[dct].csmasks[csrow >> 1];
>> +		base_bits_low = mask_bits_low = GENMASK(5 , 15);
>> +		base_bits_high = mask_bits_high = GENMASK(19 , 30);
>> +		addr_shift_low = 6;
>> +		addr_shift_high = 8;
> Hold on, are you saying "D18F2x[5C:40]_dct[1:0] DRAM CS Base Address"
> register definitions in the F16h BKDG has this:
>
> 30:19 -> BaseAddr[38:27]: normalized physical base address bits [38:27]
>
> and
>
> 15:5  -> BaseAddr[21:11]: normalized physical base address bits [21:11]
>
> ?
>
> Please verify with BKDG authors whether those numbers are correct
> because the diff of 8 address bits has always been this up until now.

     That is correct. (I have verified it internally too..)

>> +		*base = (((csbase & base_bits_high)
>> +				<< addr_shift_high) |
>> +			((csbase & base_bits_low)
>> +				<< addr_shift_low));
>> +		*mask = ~0ULL;
>> +		*mask &= ~((mask_bits_high
>> +				<< addr_shift_high) |
>> +				(mask_bits_low
>> +				<< addr_shift_low));
>> +		*mask |= (((csmask & mask_bits_high)
>> +				<< addr_shift_high) |
>> +			 ((csmask & mask_bits_low)
>> +				<< addr_shift_low));
>> +		return;
>> +	}
>> +
>> +	 else {
>>   		csbase		= pvt->csels[dct].csbases[csrow];
>>   		csmask		= pvt->csels[dct].csmasks[csrow >> 1];
>>   		addr_shift	= 8;
>> @@ -1224,6 +1269,23 @@ static int f15_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
>>   	return ddr3_cs_size(cs_mode, false);
>>   }
>>   
>> +/*
>> + * F16h supports 64 bit DCT interfaces
>> + * and has only limited cs_modes
>> + */
>> +static int f16_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
>> +				unsigned cs_mode)
>> +{
>> +	WARN_ON(cs_mode > 12);
>> +
>> +	if (cs_mode == 0 || cs_mode == 3 || cs_mode == 4
> Those are already caught by ddr3_cs_size().
>
>> +		|| cs_mode == 6 || cs_mode == 8 || cs_mode == 9
>> +		|| cs_mode == 12)
> ... which simplifies this check a bit.

     Yes, I will make the necessary changes here..

>> +		return -1;
>> +	else
>> +		return ddr3_cs_size(cs_mode, false);
>> +}
>> +
>>   static void read_dram_ctl_register(struct amd64_pvt *pvt)
>>   {
>>   
>> @@ -1681,6 +1743,17 @@ static struct amd64_family_type amd64_family_types[] = {
>>   			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
>>   		}
>>   	},
>> +	[F16_CPUS] = {
>> +		.ctl_name = "F16h",
>> +		.f1_id = PCI_DEVICE_ID_AMD_16H_NB_F1,
>> +		.f3_id = PCI_DEVICE_ID_AMD_16H_NB_F3,
>> +		.ops = {
>> +			.early_channel_count	= f1x_early_channel_count,
>> +			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
>> +			.dbam_to_cs		= f16_dbam_to_chip_select,
>> +			.read_dct_pci_cfg	= f16_read_dct_pci_cfg,
>> +		}
>> +	},
>>   };
>>   
>>   static struct pci_dev *pci_get_related_function(unsigned int vendor,
>> @@ -2071,8 +2144,12 @@ static void read_mc_regs(struct amd64_pvt *pvt)
>>   	pvt->ecc_sym_sz = 4;
>>   
>>   	if (c->x86 >= 0x10) {
>> -		amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
>> -		amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
>> +
>> +		/* F16h has only one DCT, hence cannot read DCT1 reg. */
>> +		if (c->x86 != 0x16) {
>> +			amd64_read_pci_cfg(pvt->F3, EXT_NB_MCA_CFG, &tmp);
>> +			amd64_read_dct_pci_cfg(pvt, DBAM1, &pvt->dbam1);
>> +		}
>>   
>>   		/* F10h, revD and later can do x8 ECC too */
>>   		if ((c->x86 > 0x10 || c->x86_model > 7) && tmp & BIT(25))
>> 			pvt->ecc_sym_sz = 8;
> This won't work on F16h because this last check above relies on tmp but
> with your change above, tmp will be uninitialized.
>
> If F16h supports x8 ECC too, you need to take the detection of
> ->ecc_sym_sz out of this family ">= 0x10" check.

     You are right again! I shall fix this up too..

> Thanks.
>


