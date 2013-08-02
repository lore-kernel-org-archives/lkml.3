Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab3HBRCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 13:02:24 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:6909
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937Ab3HBRCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 13:02:22 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zzbb2dI98dI9371I103dK1432I1447Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1f5fh783m1155h)
X-WSS-ID: 0MQWXZO-01-04G-02
X-M-MSG: 
Message-ID: <51FBE613.7080204@amd.com>
Date: Fri, 2 Aug 2013 12:02:11 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <dougthompson@xmission.com>, <bhelgaas@google.com>,
        <jbeulich@suse.com>, <linux-kernel@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 1/1] EDAC, AMD64_EDAC: Add ECC decoding support for newer
 F15h models.
References: <1375457592-2194-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <1375457592-2194-2-git-send-email-Aravind.Gopalakrishnan@amd.com> <20130802162525.GA15392@pd.tnic>
In-Reply-To: <20130802162525.GA15392@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.181.55.254]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/2/2013 11:25 AM, Borislav Petkov wrote:
> On Fri, Aug 02, 2013 at 10:33:12AM -0500, Aravind Gopalakrishnan wrote:
>> Adding support for handling ECC error decoding for new F15 models.
>> On newer models, support has been included for upto 4 DCT's,
>> however, only DCT0 and DCT3 are currently configured. (Refer BKDG Section 2.10)
>> There is also a new "Routing DRAM Requests" algorithm for this model.
>>
>> Tested on Fam15h M30h with ECC turned on using mce_amd_inj facility and
>> verified to be functionally correct.
> This patch is huge and before we do any serious reviewing, it needs
> splitting.
>
> So I'm gonna go over it and give you only rough points what needs
> changing.
>
>> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
>>
>> diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
>> index 3048ded..3ee7a4d 100644
>> --- a/arch/x86/kernel/amd_nb.c
>> +++ b/arch/x86/kernel/amd_nb.c
>> @@ -20,6 +20,7 @@ const struct pci_device_id amd_nb_misc_ids[] = {
>>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
>>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
>>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
>> +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
>>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
>>   	{}
>>   };
>> @@ -27,6 +28,7 @@ EXPORT_SYMBOL(amd_nb_misc_ids);
>>   
>>   static const struct pci_device_id amd_nb_link_ids[] = {
>>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
>> +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F4) },
>>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
>>   	{}
>>   };
>> @@ -81,13 +83,21 @@ int amd_cache_northbridges(void)
>>   			next_northbridge(misc, amd_nb_misc_ids);
>>   		node_to_amd_nb(i)->link = link =
>>   			next_northbridge(link, amd_nb_link_ids);
>> -        }
>> +	}
>>   
>> +	/* GART present only on Fam15h upto model 0fh */
>>   	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
>> -	    boot_cpu_data.x86 == 0x15)
>> +	    (boot_cpu_data.x86 == 0x15 && boot_cpu_data.x86_model < 0x10))
>>   		amd_northbridges.flags |= AMD_NB_GART;
>>   
>>   	/*
>> +	 * Check CPUID Fn8000_0006_EDX: L3 Cache Identifiers.
>> +	 * If == 0, then no need to proceed as there is no L3.
>> +	 */
>> +	if (cpuid_edx(0x80000006) == 0)
>> +		return 0;
> Is this for real? Model 0x30 can have no L3 cache?!
AFAIK, Yes. But I'll double check this..

>> +
>> +	/*
>>   	 * Some CPU families support L3 Cache Index Disable. There are some
>>   	 * limitations because of E382 and E388 on family 0x10.
>>   	 */
> Whatever it is, the amd_nb.c stuff needs to be a separate patch.
>
>> diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
>> index 8b6a034..365beda 100644
>> --- a/drivers/edac/amd64_edac.c
>> +++ b/drivers/edac/amd64_edac.c
>> @@ -123,7 +123,11 @@ static void f15h_select_dct(struct amd64_pvt *pvt, u8 dct)
>>   	u32 reg = 0;
>>   
>>   	amd64_read_pci_cfg(pvt->F1, DCT_CFG_SEL, &reg);
>> -	reg &= 0xfffffffe;
>> +	/*
>> +	 * If Fam15h M30h, mask out last two bits for programming dct.
>> +	 * Else, only mask out the last bit.
>> +	 */
>> +	reg &= is_f15h_m30h ? 0xfffffffc : 0xfffffff8;
>>   	reg |= dct;
>>   	amd64_write_pci_cfg(pvt->F1, DCT_CFG_SEL, reg);
>>   }
>> @@ -133,8 +137,12 @@ static int f15_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
>>   {
>>   	u8 dct  = 0;
>>   
>> +	/*
>> +	 * For F15 M30h, the second dct is DCT 3.
>> +	 * Refer BKDG Section 2.10
>> +	 */
>>   	if (addr >= 0x140 && addr <= 0x1a0) {
>> -		dct   = 1;
>> +		dct = is_f15h_m30h ? 3 : 1;
>>   		addr -= 0x100;
>>   	}
>>   
>> @@ -205,8 +213,9 @@ static int amd64_set_scrub_rate(struct mem_ctl_info *mci, u32 bw)
>>   	if (boot_cpu_data.x86 == 0xf)
>>   		min_scrubrate = 0x0;
>>   
>> -	/* F15h Erratum #505 */
>> -	if (boot_cpu_data.x86 == 0x15)
>> +	/* F15h Models 0x00 - 0x0f Erratum #505 */
>> +	if (boot_cpu_data.x86 == 0x15 &&
>> +		boot_cpu_data.x86_model != 0x30)
>>   		f15h_select_dct(pvt, 0);
>>   
>>   	return __amd64_set_scrub_rate(pvt->F3, bw, min_scrubrate);
>> @@ -218,8 +227,9 @@ static int amd64_get_scrub_rate(struct mem_ctl_info *mci)
>>   	u32 scrubval = 0;
>>   	int i, retval = -EINVAL;
>>   
>> -	/* F15h Erratum #505 */
>> -	if (boot_cpu_data.x86 == 0x15)
>> +	/* F15h Models 0x00 - 0x0f Erratum #505 */
>> +	if (boot_cpu_data.x86 == 0x15 &&
>> +		boot_cpu_data.x86_model != 0x30)
>>   		f15h_select_dct(pvt, 0);
>>   
>>   	amd64_read_pci_cfg(pvt->F3, SCRCTRL, &scrubval);
>> @@ -343,10 +353,10 @@ static void get_cs_base_and_mask(struct amd64_pvt *pvt, int csrow, u8 dct,
>>   		addr_shift	= 4;
>>   
>>   	/*
>> -	* F16h needs two addr_shift values: 8 for high and 6 for low
>> -	* (cf. F16h BKDG).
>> +	* F16h and F15h(model 30h) needs two addr_shift values:
>> +	* 8 for high and 6 for low (cf. F16h BKDG).
>>   	*/
>> -	} else if (boot_cpu_data.x86 == 0x16) {
>> +	} else if (boot_cpu_data.x86 == 0x16 || is_f15h_m30h) {
>>   		csbase          = pvt->csels[dct].csbases[csrow];
>>   		csmask          = pvt->csels[dct].csmasks[csrow >> 1];
>>   
>> @@ -743,6 +753,9 @@ static void prep_chip_selects(struct amd64_pvt *pvt)
>>   	if (boot_cpu_data.x86 == 0xf && pvt->ext_model < K8_REV_F) {
>>   		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
>>   		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 8;
>> +	} else if (is_f15h_m30h) {
>> +		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 4;
>> +		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 2;
>>   	} else {
>>   		pvt->csels[0].b_cnt = pvt->csels[1].b_cnt = 8;
>>   		pvt->csels[0].m_cnt = pvt->csels[1].m_cnt = 4;
>> @@ -850,9 +863,9 @@ static u64 get_error_address(struct mce *m)
>>   	addr = m->addr & GENMASK(start_bit, end_bit);
>>   
>>   	/*
>> -	 * Erratum 637 workaround
>> +	 * Erratum 637 workaround for F15h Models 0x00 - 0x0f
>>   	 */
>> -	if (c->x86 == 0x15) {
>> +	if (c->x86 == 0x15 && boot_cpu_data.x86_model != 0x30) {
> Huh,
>
> 	c->x86_model is there too, you know.

Oops.. I'll fix this.

>>   		struct amd64_pvt *pvt;
>>   		u64 cc6_base, tmp_addr;
>>   		u32 tmp;
>> @@ -942,7 +955,15 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
>>   		return;
>>   
>>   	misc = nb->misc;
>> -	f1 = pci_get_related_function(misc->vendor, PCI_DEVICE_ID_AMD_15H_NB_F1, misc);
>> +
>> +	if (c->x86_model == 0x30)
>> +		f1 = pci_get_related_function(misc->vendor,
>> +					PCI_DEVICE_ID_AMD_15H_M30H_NB_F1,
>> +					misc);
> Indentation.
>
>> +	else
>> +		f1 = pci_get_related_function(misc->vendor,
>> +				      PCI_DEVICE_ID_AMD_15H_NB_F1,
>> +				      misc);
> Simpler:
>
> 	pci_func = (pvt->x86_model == 0x30 ? PCI_DEVICE_ID_AMD_15H_M30H_NB_F1
> 					   : PCI_DEVICE_ID_AMD_15H_NB_F1);
>
> 	f1 = pci_get_related_function(misc->vendor, pci_func, misc);

Yes, I'll fix this.

>>   	if (WARN_ON(!f1))
>>   		return;
>>   
>> @@ -1173,7 +1194,8 @@ static int f15_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
>>   }
>>   
>>   /*
>> - * F16h has only limited cs_modes
>> + * F16h has only limited cs_modes.
>> + * F15 M30h follows the same pattern.
>>    */
>>   static int f16_dbam_to_chip_select(struct amd64_pvt *pvt, u8 dct,
>>   				unsigned cs_mode)
>> @@ -1218,6 +1240,65 @@ static void read_dram_ctl_register(struct amd64_pvt *pvt)
>>   }
>>   
>>   /*
>> + * Determine channel (DCT) based on the interleaving mode:
>> + * F15h M30h BKDG, 2.10.12 Memory Interleaving Modes.
>> + */
>> +static u8 f15_m30h_determine_channel(struct amd64_pvt *pvt, u64 sys_addr,
>> +				u8 intlv_en, int num_dcts_intlv, u32 dct_sel)
>> +{
>> +	u8 channel = 0;
>> +	u8 select;
>> +	u8 intlv_addr = dct_sel_interleave_addr(pvt);
>> +
>> +	if (!(intlv_en))
>> +		return (u8)(dct_sel);
>> +	/*
>> +	* If num_dcts_intlv == 2, them consider addr bit 8 or addr bit 9
>> +	* depending on intlv_addr, then return either channel = 0/1/2/3.
>> +	* If num_dcts_intlv == 4, consider either bits[8:9] or bits[9:10]
>> +	* depending on intlv_addr, then return the value obtained.
>> +	*/
>> +
>> +	if (num_dcts_intlv == 2) {
>> +		if (intlv_addr == 0x4)
>> +			select = (sys_addr >> 8) & BIT(0);
>> +		else if (intlv_addr == 0x5)
>> +			select = (sys_addr >> 9) & BIT(0);
>> +		else
>> +			return -EINVAL;
>> +
>> +		/* Upper DCT selected */
>> +		if (select > 0) {
>> +			if (intlv_en & 0x8)
>> +				channel =  0x3;
>> +			else if (intlv_en & 0x4)
>> +				channel =  0x2;
>> +			else
>> +				channel =  0x1;
> Can intlv_en be a three-bit field with only one bit set? If so, we have
> these functions like fls() for example which should give you what you
> want. IOW:
>
> 		if (select)
> 			channel = fls(intlv_en);
>
>> +		} else {
>> +			/* Lower DCT selected */
>> +			if (intlv_en & BIT(0))
>> +				channel = 0;
>> +			else if (intlv_en & 0x2)
>> +				channel = 0x1;
>> +			else
>> +				channel = 0x2;
> I'm sure you can come up with a similar thing here :)

Okay, thanks for the pointer!

>> +		}
>> +	} else if (num_dcts_intlv == 4) {
>> +		if (intlv_addr == 0x4)
>> +			select =  (sys_addr >> 8) & 0x3;
>> +		else if (intlv_addr == 0x5)
>> +			select = (sys_addr >> 9) & 0x3;
>> +		else
>> +			return -EINVAL;
> You know that this function cannot return an error, right? Look at
> f1x_lookup_addr_in_dct() for example.
>
> I can see that you handle this but is there any possibility not to be
> able to determine the channel?

Some bits are reserved.. Hence the safety of returning error value..
(In case hardware programs the bits wrongly)

>> +
>> +		channel = select;
>> +	}
>> +
>> +	return channel;
>> +}
>> +
>> +/*
>>    * Determine channel (DCT) based on the interleaving mode: F10h BKDG, 2.8.9 Memory
>>    * Interleaving Modes.
>>    */
>> @@ -1366,6 +1447,10 @@ static int f1x_lookup_addr_in_dct(u64 in_addr, u8 nid, u8 dct)
>>   			 (in_addr & cs_mask), (cs_base & cs_mask));
>>   
>>   		if ((in_addr & cs_mask) == (cs_base & cs_mask)) {
>> +			if (is_f15h_m30h) {
>> +				cs_found =  csrow;
>> +				break;
>> +			}
>>   			cs_found = f10_process_possible_spare(pvt, dct, csrow);
>>   
>>   			edac_dbg(1, " MATCH csrow=%d\n", cs_found);
>> @@ -1492,20 +1577,147 @@ static int f1x_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
>>   	return cs_found;
>>   }
>>   
>> -static int f1x_translate_sysaddr_to_cs(struct amd64_pvt *pvt, u64 sys_addr,
>> -				       int *chan_sel)
>> +/*
>> + * Routing DRAM Requests algorithm is different for F15h M30h.
>> + * It is cleaner to use a brand new function rather than
>> + * adding quirks in the more generic 'f1x_match_to_this_node'.
>> + * Refer "2.10.5 DRAM Routing Requests" in BKDG for info.
>> + */
>> +static int f15_m30h_match_to_this_node(struct amd64_pvt *pvt, unsigned range,
>> +				  u64 sys_addr, int *chan_sel)
>> +{
>> +	int cs_found = -EINVAL;
>> +	int num_dcts_intlv = 0;
>> +	u8 leg_mmio_hole;
>> +	u64 chan_addr, chan_offset, high_addr_offset;
>> +	u64 dct_base, dct_limit;
>> +	u8 channel, alias_channel;
>> +
>> +	/*
>> +	 * Read DRAM Control registers specific to F15 M30h.
>> +	 */
>> +	u64 dhar_offset		= f10_dhar_offset(pvt);
>> +	u8 dct_offset_en	= f15_m30h_dct_offset_en(pvt);
>> +	u8 dct_sel		= f15_m30h_dct_sel(pvt);
>> +	u8 intlv_addr		= dct_sel_interleave_addr(pvt);
>> +	u8 node_id		= dram_dst_node(pvt, range);
>> +	u8 intlv_en		= dram_intlv_en(pvt, range);
>> +
>> +	edac_dbg(1, "(range %d) SystemAddr= 0x%llx Limit=0x%llx\n",
>> +		 range, sys_addr, get_dram_limit(pvt, range));
>> +
>> +	if (!(get_dram_base(pvt, range)  <= sys_addr) &&
>> +	    !(get_dram_limit(pvt, range) >= sys_addr))
>> +		return -EINVAL;
>> +
>> +	if (dhar_valid(pvt) &&
>> +	    dhar_base(pvt) <= sys_addr &&
>> +	    sys_addr < BIT_64(32)) {
>> +		amd64_warn("Huh? Address is in the MMIO hole: 0x%016llx\n",
>> +			    sys_addr);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* Verify sys_addr is within DCT Range. */
>> +	dct_base = (dct_sel_baseaddr(pvt) << 27);
>> +	dct_limit = (f15_m30h_dct_limit_addr(pvt) << 27) | 0x7FFFFFF;
>> +	if (!(f15_m30h_dct_addr_val(pvt)) &&
>> +			!(dct_base <= sys_addr && dct_limit >= sys_addr)) {
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* Verify number of dct's that participate in channel interleaving. */
>> +	num_dcts_intlv = (int) hweight8(intlv_en);
>> +
>> +	if (!(num_dcts_intlv % 2 == 0) || (num_dcts_intlv > 4))
>> +		return -EINVAL;
>> +
>> +	channel = f15_m30h_determine_channel(pvt, sys_addr,
>> +						 intlv_en,
>> +						 num_dcts_intlv,
>> +						 dct_sel);
>> +
>> +	/* Verify if we stay within the MAX number of channels allowed */
>> +	if (channel > 4 || channel < 0)
>> +		return -EINVAL;
>> +
>> +	leg_mmio_hole = f15_m30h_leg_mmio_en(pvt);
>> +
>> +	/* Get normalized DCT addr */
>> +	if (leg_mmio_hole && (sys_addr >= BIT_64(32)))
>> +		chan_offset = dhar_offset;
>> +	else
>> +		chan_offset = dct_base;
>> +
>> +	chan_addr = sys_addr - chan_offset;
>> +
>> +	/* remove channel interleave */
>> +	if (num_dcts_intlv == 2) {
>> +		if (intlv_addr == 0x4)
>> +			chan_addr = ((chan_addr >> 9) << 8) |
>> +						(chan_addr & 0xff);
>> +		else if (intlv_addr == 0x5)
>> +			chan_addr = ((chan_addr >> 10) << 9) |
>> +						(chan_addr & 0x1ff);
>> +		else
>> +			return -EINVAL;
>> +
>> +	} else if (num_dcts_intlv == 4) {
>> +		if (intlv_addr == 0x4)
>> +			chan_addr = ((chan_addr >> 10) << 8) |
>> +							(chan_addr & 0xff);
>> +		else if (intlv_addr == 0x5)
>> +			chan_addr = ((chan_addr >> 11) << 9) |
>> +							(chan_addr & 0x1ff);
>> +		else
>> +			return -EINVAL;
>> +	}
>> +
>> +	if (dct_offset_en) {
>> +		high_addr_offset = f15_m30h_dct_high_offset(pvt, channel);
>> +		chan_addr += high_addr_offset;
>> +	}
>> +
>> +	/* Set DCTCFGSEL = ChannelSelect */
>> +	f15h_select_dct(pvt, channel);
>> +
>> +	edac_dbg(1, "   Normalized DCT addr: 0x%llx\n", chan_addr);
>> +	/* Find the Chip select.. */
>> +	/*
>> +	 * NOTE: if channel = 3, then alias it to 1.
>> +	 * This is because, in F15 M30h, there is support for
>> +	 * 4 DCT's, but only 2 are currently included in the architecture.
>> +	 * They are DCT0 and DCT3. But we have read all registers of DCT3
>> +	 * into pvt->csels[1]. So we need to use '1' here to get correct
>> +	 * info. Refer F15 M30h BKDG Section 2.10 and 2.10.3 for clarifications
>> +	 */
>> +
>> +	alias_channel =  (channel == 3) ? 1 : channel;
>> +
>> +	cs_found = f1x_lookup_addr_in_dct(chan_addr, node_id, alias_channel);
>> +
>> +	if (cs_found >= 0)
>> +		*chan_sel = alias_channel;
>> +
>> +	return cs_found;
>> +}
>> +
>> +static int
>> +f1x_translate_sysaddr_to_cs(struct amd64_pvt *pvt,
>> +			    u64 sys_addr,
>> +			    int *chan_sel)
>>   {
>>   	int cs_found = -EINVAL;
>>   	unsigned range;
>>   
>>   	for (range = 0; range < DRAM_RANGES; range++) {
>> -
>>   		if (!dram_rw(pvt, range))
>>   			continue;
>> -
>> -		if ((get_dram_base(pvt, range)  <= sys_addr) &&
>> -		    (get_dram_limit(pvt, range) >= sys_addr)) {
>> -
>> +		if (is_f15h_m30h)
>> +			cs_found = f15_m30h_match_to_this_node(pvt, range,
>> +							  sys_addr, chan_sel);
>> +		else if ((get_dram_base(pvt, range)  <= sys_addr) &&
>> +			 (get_dram_limit(pvt, range) >= sys_addr)) {
>>   			cs_found = f1x_match_to_this_node(pvt, range,
>>   							  sys_addr, chan_sel);
>>   			if (cs_found >= 0)
>> @@ -1624,6 +1836,17 @@ static struct amd64_family_type amd64_family_types[] = {
>>   			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
>>   		}
>>   	},
>> +	[F15_M30H_CPUS] = {
>> +		.ctl_name = "F15h_M30h",
>> +		.f1_id = PCI_DEVICE_ID_AMD_15H_M30H_NB_F1,
>> +		.f3_id = PCI_DEVICE_ID_AMD_15H_M30H_NB_F3,
>> +		.ops = {
>> +			.early_channel_count	= f1x_early_channel_count,
>> +			.map_sysaddr_to_csrow	= f1x_map_sysaddr_to_csrow,
>> +			.dbam_to_cs		= f16_dbam_to_chip_select,
>> +			.read_dct_pci_cfg	= f15_read_dct_pci_cfg,
>> +		}
>> +	},
>>   	[F16_CPUS] = {
>>   		.ctl_name = "F16h",
>>   		.f1_id = PCI_DEVICE_ID_AMD_16H_NB_F1,
>> @@ -2402,6 +2625,12 @@ static struct amd64_family_type *amd64_per_family_init(struct amd64_pvt *pvt)
>>   		break;
>>   
>>   	case 0x15:
>> +		if (boot_cpu_data.x86_model == 0x30) {
>> +			fam_type	= &amd64_family_types[F15_M30H_CPUS];
>> +			pvt->ops	= &amd64_family_types[F15_M30H_CPUS].ops;
>> +			break;
>> +		}
>> +
>>   		fam_type		= &amd64_family_types[F15_CPUS];
>>   		pvt->ops		= &amd64_family_types[F15_CPUS].ops;
>>   		break;
>> @@ -2638,6 +2867,14 @@ static DEFINE_PCI_DEVICE_TABLE(amd64_pci_table) = {
>>   	},
>>   	{
>>   		.vendor		= PCI_VENDOR_ID_AMD,
>> +		.device		= PCI_DEVICE_ID_AMD_15H_M30H_NB_F2,
>> +		.subvendor	= PCI_ANY_ID,
>> +		.subdevice	= PCI_ANY_ID,
>> +		.class		= 0,
>> +		.class_mask	= 0,
>> +	},
>> +	{
>> +		.vendor		= PCI_VENDOR_ID_AMD,
>>   		.device		= PCI_DEVICE_ID_AMD_16H_NB_F2,
>>   		.subvendor	= PCI_ANY_ID,
>>   		.subdevice	= PCI_ANY_ID,
>> diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
>> index 2c6f113..8ef5ad3 100644
>> --- a/drivers/edac/amd64_edac.h
>> +++ b/drivers/edac/amd64_edac.h
>> @@ -170,6 +170,8 @@
>>   /*
>>    * PCI-defined configuration space registers
>>    */
>> +#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F1 0x141b
>> +#define PCI_DEVICE_ID_AMD_15H_M30H_NB_F2 0x141c
>>   #define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
>>   #define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
>>   #define PCI_DEVICE_ID_AMD_16H_NB_F1	0x1531
>> @@ -181,13 +183,24 @@
>>   #define DRAM_BASE_LO			0x40
>>   #define DRAM_LIMIT_LO			0x44
>>   
>> -#define dram_intlv_en(pvt, i)		((u8)((pvt->ranges[i].base.lo >> 8) & 0x7))
>> +/*
>> + * F15 M30h DRAM Controller Base/Limit
>> + * D18F1x2[1C:00]
>> + */
>> +#define DRAM_CONT_BASE			0x200
>> +#define DRAM_CONT_LIMIT			0x204
>> +
>> +/*
>> + * F15 M30h DRAM Controller High Addre Offset
>> + * D18F1x2[4C:40]
>> + */
>> +#define DRAM_CONT_HIGH_OFF      0x240
>> +
>>   #define dram_rw(pvt, i)			((u8)(pvt->ranges[i].base.lo & 0x3))
>>   #define dram_intlv_sel(pvt, i)		((u8)((pvt->ranges[i].lim.lo >> 8) & 0x7))
>>   #define dram_dst_node(pvt, i)		((u8)(pvt->ranges[i].lim.lo & 0x7))
>>   
>>   #define DHAR				0xf0
>> -#define dhar_valid(pvt)			((pvt)->dhar & BIT(0))
>>   #define dhar_mem_hoist_valid(pvt)	((pvt)->dhar & BIT(1))
>>   #define dhar_base(pvt)			((pvt)->dhar & 0xff000000)
>>   #define k8_dhar_offset(pvt)		(((pvt)->dhar & 0x0000ff00) << 16)
>> @@ -234,8 +247,6 @@
>>   #define DDR3_MODE			BIT(8)
>>   
>>   #define DCT_SEL_LO			0x110
>> -#define dct_sel_baseaddr(pvt)		((pvt)->dct_sel_lo & 0xFFFFF800)
>> -#define dct_sel_interleave_addr(pvt)	(((pvt)->dct_sel_lo >> 6) & 0x3)
>>   #define dct_high_range_enabled(pvt)	((pvt)->dct_sel_lo & BIT(0))
>>   #define dct_interleave_enabled(pvt)	((pvt)->dct_sel_lo & BIT(2))
>>   
>> @@ -293,10 +304,14 @@
>>   /* MSRs */
>>   #define MSR_MCGCTL_NBE			BIT(4)
>>   
>> +/* Helper Macro for F15h M30h */
>> +#define is_f15h_m30h			((boot_cpu_data.x86 == 0x15) && \
>> +					  (boot_cpu_data.x86_model == 0x30))
> This is ugly.
>
> Since most functions have struct amd64_pvt as an argument, you could put
> the family in there in a nice format, which is easy to check. Off the
> top of my head, you can copy c->x86 and c->x86_model u8s and that should
> work.

Okay, Will fix this..

>>   enum amd_families {
>>   	K8_CPUS = 0,
>>   	F10_CPUS,
>>   	F15_CPUS,
>> +	F15_M30H_CPUS,
>>   	F16_CPUS,
>>   	NUM_FAMILIES,
>>   };
>> @@ -414,6 +429,14 @@ static inline u16 extract_syndrome(u64 status)
>>   	return ((status >> 47) & 0xff) | ((status >> 16) & 0xff00);
>>   }
>>   
>> +static inline u8 dct_sel_interleave_addr(struct amd64_pvt *pvt)
>> +{
>> +	if (is_f15h_m30h)
>> +		return (((pvt->dct_sel_hi >> 9) & 0x1) << 2) |
>> +			((pvt->dct_sel_lo >> 6) & 0x3);
>> +
>> +	return	((pvt)->dct_sel_lo >> 6) & 0x3;
>> +}
>>   /*
>>    * per-node ECC settings descriptor
>>    */
>> @@ -504,3 +527,80 @@ static inline void enable_caches(void *dummy)
>>   {
>>   	write_cr0(read_cr0() & ~X86_CR0_CD);
>>   }
>> +
>> +/*
>> + * Introduce helper functions for F15 M30h
>> + */
>> +static inline u8 f15_m30h_dct_offset_en(struct amd64_pvt *pvt)
>> +{
>> +	u32 tmp;
>> +	amd64_read_pci_cfg(pvt->F1, DRAM_CONT_BASE, &tmp);
>> +	return (u8) ((tmp >> 3) & BIT(0));
>> +}
>> +
>> +static inline u8 f15_m30h_dct_sel(struct amd64_pvt *pvt)
>> +{
>> +	u32 tmp;
>> +	amd64_read_pci_cfg(pvt->F1, DRAM_CONT_BASE, &tmp);
>> +	return (u8) ((tmp >> 4) & 0x7);
>> +}
>> +
>> +static inline u32 f15_m30h_dct_limit_addr(struct amd64_pvt *pvt)
>> +{
>> +	u32 tmp;
>> +	amd64_read_pci_cfg(pvt->F1, DRAM_CONT_LIMIT, &tmp);
>> +	return (tmp >> 11) & 0x1FFF;
>> +}
>> +
>> +static inline u8 f15_m30h_leg_mmio_en(struct amd64_pvt *pvt)
>> +{
>> +	u32 tmp;
>> +	amd64_read_pci_cfg(pvt->F1, DRAM_CONT_BASE, &tmp);
>> +	return (u8) ((tmp >> 1) & BIT(0));
>> +}
>> +
>> +static inline u64 f15_m30h_dct_high_offset(struct amd64_pvt *pvt, u8 channel)
>> +{
>> +	u32 tmp;
>> +	amd64_read_pci_cfg(pvt->F1,
>> +			DRAM_CONT_HIGH_OFF + (int) channel * 4,
>> +			&tmp);
>> +	return ((tmp >> 11) & 0xfff) << 27;
>> +}
>> +
>> +static inline int f15_m30h_dct_addr_val(struct amd64_pvt *pvt)
>> +{
>> +	u32 tmp;
>> +	amd64_read_pci_cfg(pvt->F1, DRAM_CONT_BASE, &tmp);
>> +	return tmp & BIT(0);
>> +}
>> +
>> +static inline u8 dram_intlv_en(struct amd64_pvt *pvt, unsigned int i)
>> +{
>> +	u32 tmp;
>> +	if (is_f15h_m30h) {
>> +		amd64_read_pci_cfg(pvt->F1, DRAM_CONT_LIMIT, &tmp);
>> +		return (u8) tmp & 0xF;
>> +	}
>> +	return (u8) (pvt->ranges[i].base.lo >> 8) & 0x7;
>> +}
>> +
>> +static inline u8 dhar_valid(struct amd64_pvt *pvt)
>> +{
>> +	u32 tmp;
>> +	if (is_f15h_m30h) {
>> +		amd64_read_pci_cfg(pvt->F1, DRAM_CONT_BASE, &tmp);
>> +		return (tmp >> 1) & BIT(0);
>> +	}
>> +	return (pvt)->dhar & BIT(0);
>> +}
>> +
>> +static inline u32 dct_sel_baseaddr(struct amd64_pvt *pvt)
>> +{
>> +	u32 tmp;
>> +	if (is_f15h_m30h) {
>> +		amd64_read_pci_cfg(pvt->F1, DRAM_CONT_BASE, &tmp);
>> +		return (tmp >> 11) & 0x1FFF;
>> +	}
>> +	return (pvt)->dct_sel_lo & 0xFFFFF800;
>> +}
> Now this looks like unneeded. Some of those functions are called only
> once so why do you even have those functions?

Hmm.. You are right.. I will remove these too..

> Whatever it is, the amd64_edac.[ch] stuff needs to be a separate patch.
>
> So please split this thing into smaller pieces first.
>
> Thanks.

Thanks! I will split it up and make the necessary changes as you 
suggested and send it out as V2.


