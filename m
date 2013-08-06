Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3HFU6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 16:58:32 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:22529 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751837Ab3HFU6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 16:58:30 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zzbb2dI98dI9371I103dK1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh668h839h93fhe5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1765h18e1h190ch1946h19b4h19c3h19ceh1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1889i783m1155h)
X-WSS-ID: 0MR4NLD-01-9CV-02
X-M-MSG: 
Message-ID: <52016370.1000502@amd.com>
Date: Tue, 6 Aug 2013 15:58:24 -0500
From: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <dougthompson@xmission.com>, <bhelgaas@google.com>,
        <jbeulich@suse.com>, <linux-kernel@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 2/3 V2] EDAC, AMD64_EDAC: Add relevant condition checks
 as F15h M30h does not support GART or L3.
References: <1375483384-2302-1-git-send-email-Aravind.Gopalakrishnan@amd.com> <1375483384-2302-3-git-send-email-Aravind.Gopalakrishnan@amd.com> <20130806201925.GG14891@pd.tnic>
In-Reply-To: <20130806201925.GG14891@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.181.55.254]
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/6/2013 3:19 PM, Borislav Petkov wrote:
> On Fri, Aug 02, 2013 at 05:43:03PM -0500, Aravind Gopalakrishnan wrote:
>> Adding code to check for specific model (F15h, M30h) and if yes,
>> do not add flag AMD_NB_GART. Also check cpuid_edx(0x80000006) for
>> prescence of L3. If no L3, do not add any L3 flags.
>>
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
> This comment explains the code. Just sit down and think about it: does
> it make any sense to have that in a comment?
>> +	 */
>> +	if (cpuid_edx(0x80000006) == 0)
>> +		return 0;
>> +
>> +	/*
>>   	 * Some CPU families support L3 Cache Index Disable. There are some
>>   	 * limitations because of E382 and E388 on family 0x10.
>>   	 */
>> --
> I fixed it up like this:
>
> commit a0cb1bab68823648def0fda19bf307ad08eb25d2
> Author: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> Date:   Fri Aug 2 17:43:03 2013 -0500
>
>      x86, amd_nb: Clarify F15h, model 30h GART and L3 support
>      
>      F15h, models 0x30 and later don't have a GART. Note that. Also check
>      cpuid_edx(0x80000006) for prescence of L3 because there are models which
>      don't sport an L3.
>      
>      Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
>      [ Boris: rewrite commit message, cleanup comments. ]
>      Signed-off-by: Borislav Petkov <bp@suse.de>

Okay, Thanks!
> diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
> index 3048ded1b598..59554dca96ec 100644
> --- a/arch/x86/kernel/amd_nb.c
> +++ b/arch/x86/kernel/amd_nb.c
> @@ -20,6 +20,7 @@ const struct pci_device_id amd_nb_misc_ids[] = {
>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
>   	{}
>   };
> @@ -27,6 +28,7 @@ EXPORT_SYMBOL(amd_nb_misc_ids);
>   
>   static const struct pci_device_id amd_nb_link_ids[] = {
>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4) },
> +	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F4) },
>   	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_16H_NB_F4) },
>   	{}
>   };
> @@ -81,13 +83,20 @@ int amd_cache_northbridges(void)
>   			next_northbridge(misc, amd_nb_misc_ids);
>   		node_to_amd_nb(i)->link = link =
>   			next_northbridge(link, amd_nb_link_ids);
> -        }
> +	}
>   
> +	/* GART present only on Fam15h upto model 0fh */
>   	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
> -	    boot_cpu_data.x86 == 0x15)
> +	    (boot_cpu_data.x86 == 0x15 && boot_cpu_data.x86_model < 0x10))
>   		amd_northbridges.flags |= AMD_NB_GART;
>   
>   	/*
> +	 * Check for L3 cache presence.
> +	 */
> +	if (!cpuid_edx(0x80000006))
> +		return 0;
> +
> +	/*
>   	 * Some CPU families support L3 Cache Index Disable. There are some
>   	 * limitations because of E382 and E388 on family 0x10.
>   	 */
>
>
>


