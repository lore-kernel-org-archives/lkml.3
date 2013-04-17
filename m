Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759221Ab3DQT5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:57:01 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:27442 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758273Ab3DQT46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:56:58 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z551bizbb2dI98dI9371I1432I4015Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275dhz2dh668h839h93fhd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1155h)
X-WSS-ID: 0MLF0QQ-02-263-02
X-M-MSG: 
Message-ID: <516EFE96.5040305@amd.com>
Date: Wed, 17 Apr 2013 14:57:10 -0500
From: Aravind <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <dougthompson@xmission.com>, <jbarnes@virtuousgeek.org>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-edac@vger.kernel.org>
Subject: Re: [PATCH v3] edac: Handle EDAC ECC errors for Family 16h
References: <1366052160-3091-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <20130416142432.GF5332@pd.tnic> <516D8743.4080206@amd.com> <20130416181802.GI5332@pd.tnic>
In-Reply-To: <20130416181802.GI5332@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.181.55.254]
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2013 01:18 PM, Borislav Petkov wrote:
> On Tue, Apr 16, 2013 at 12:15:47PM -0500, Aravind wrote:
>>> This one case in point, please redo it against tip/master.
>>      I had based off bp.git's master... and it misses an additional
>> 'PCI_DEVICE' line (Hence the conflict)
>>      I shall redo it against Linus's tree..
> No, against tip/master, please.
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git, the master branch.

     Okay.

>>>> @@ -133,6 +134,15 @@ static int f15_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
>>>>   	return __amd64_read_pci_cfg_dword(pvt->F2, addr, val, func);
>>>>   }
>>>> +static int f16_read_dct_pci_cfg(struct amd64_pvt *pvt, int addr, u32 *val,
>>>> +				const char *func)
>>>> +{
>>>> +	if (addr >= 0x100)
>>>> +		return -EINVAL;
>>> I'm very sceptical F16h doesn't have F2 extended PCI config addresses.
>>> Please check the BKDG.
>>>
>>> If it does have, use f10_read_dct_pci_cfg, if it doesn't, use
>>> k8_read_dct_pci_cfg without introducing a new accessor while the other
>>> ones can be used.
>>>
>>> Whichever one you take, please add a comment somewhere explaining why it
>>> is ok to use it on F16h.
>>      Here, What I really wanted to do was to restrict the access to
>> only 1 DCT (as fam16 does not have a DCT1 and hence not allow any
>> addr > =0x100).
> What are you talking about?
>
> I'm sure it has, say, D18F2x110 DRAM Controller Select Low, for example.
> And this address is > 0x100.
>
> So for F16h you can simply take the F10h methods and ignore DctCfgSel
> because it always will be 0.
>

     Wrong assumption on my part here. (Apologies)

>> Yes, for this I can modify the code to just use f10_read_dct_pci_cfg
>> or k8_read_dct_pci_cfg.
> Yes, please do that.
>
>>>> +		u64 base_bits_low, base_bits_high;
>>>> +		u64 mask_bits_low, mask_bits_high;
>>>> +		u8 addr_shift_low, addr_shift_high;
>>>> +
>>>> +		csbase          = pvt->csels[dct].csbases[csrow];
>>>> +		csmask          = pvt->csels[dct].csmasks[csrow >> 1];
>>>> +		base_bits_low = mask_bits_low = GENMASK(5 , 15);
>>>> +		base_bits_high = mask_bits_high = GENMASK(19 , 30);
>>>> +		addr_shift_low = 6;
>>>> +		addr_shift_high = 8;
>>> Hold on, are you saying "D18F2x[5C:40]_dct[1:0] DRAM CS Base Address"
>>> register definitions in the F16h BKDG has this:
>>>
>>> 30:19 -> BaseAddr[38:27]: normalized physical base address bits [38:27]
>>>
>>> and
>>>
>>> 15:5  -> BaseAddr[21:11]: normalized physical base address bits [21:11]
>>>
>>> ?
>>>
>>> Please verify with BKDG authors whether those numbers are correct
>>> because the diff of 8 address bits has always been this up until now.
>>      That is correct. (I have verified it internally too..)
> Ok, then do the following:
>
> Read the low bits, shift them by 2 so that they're at the right position
> to be shifted by 8 like the high bits:
>
> 	*base =  (csbase & GENMASK(5, 15)) << 2;
> 	*mask =  (csmask & GENMASK(5, 15)) << 2;
>
> 	*base |= (csbase & GENMASK(19, 30)) << 8;
> 	*mask |= (csmask & GENMASK(19, 30)) << 8;
>
> 	return;
>
> AFAICT, this looks much simpler. Also, add a small comment why the
> special handling for F16h.

I have reworked this code in an attempt to make it simpler..
Here is how I did it:
(for base)
+               *base = (csbase & GENMASK(5 , 15)) << 6;
+               *base |= (csbase & GENMASK(19 , 30)) << 8;
(for mask)
+               *mask = ~0ULL;
+               /* holes for the csmask */
+               *mask &= ~((GENMASK(19 , 30) << 8) |
+                          (GENMASK(5 , 15) << 6));
+               *mask |= (csmask & GENMASK(5 , 15)) << 6;
+               *mask |= (csmask & GENMASK(19 , 30)) << 8;
I have added some comment around the code to clarify the operation to be 
performed..
Since I have directly GENMASK'd it, we can get rid of the local variables
I was using before...
Do let me know if this is acceptable..

> Thanks.
>
Sending it out as V4 of the patch..

Thanks,
-Aravind.

