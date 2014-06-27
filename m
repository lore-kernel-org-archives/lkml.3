Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaF0AiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 20:38:00 -0400
Received: from mga01.intel.com ([192.55.52.88]:22040 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273AbaF0Ah7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 20:37:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="357730442"
Message-ID: <53ACBCE1.8010408@linux.intel.com>
Date: Fri, 27 Jun 2014 08:37:53 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Tang, Feng" <feng.tang@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [Patch] x86: intel-mid: fix conflicts between 78a3bb9e408b and
 9f354b0252b8
References: <20140622084227.GA13974@gmail.com> <1403490643-26187-1-git-send-email-jiang.liu@linux.intel.com> <20140623173807.GA27942@psi-dev26.jf.intel.com> <20140626193333.GA24934@psi-dev26.jf.intel.com>
In-Reply-To: <20140626193333.GA24934@psi-dev26.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, David!

On 2014/6/27 3:33, David Cohen wrote:
> On Mon, Jun 23, 2014 at 10:38:07AM -0700, David Cohen wrote:
>> Hi Jiang,
>>
>> On Mon, Jun 23, 2014 at 10:30:35AM +0800, Jiang Liu wrote:
>>> Commit 9f354b0252b8 "x86, irq: Clean up unused IOAPIC interface" kills
>>> interface io_apic_set_pci_routing(), so change arch/x86/platform/
>>> intel-mid/device_libs/platform_wdt.c to use new interfaces.
>>>
>>> Due to hardware resource restriction, this patch only passes compilation
>>> without functional tests.
>>
>> I'll test this patch.
> 
> It sounds good.
> Acked-by: David Cohen <david.a.cohen@linux.intel.com>
> 
>>
>> BR, David
>>
>>>
>>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>>> ---
>>>  .../platform/intel-mid/device_libs/platform_wdt.c  |   22 ++++++--------------
>>>  1 file changed, 6 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
>>> index 973cf3bfa9fd..0b283d4d0ad7 100644
>>> --- a/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
>>> +++ b/arch/x86/platform/intel-mid/device_libs/platform_wdt.c
>>> @@ -26,28 +26,18 @@ static struct platform_device wdt_dev = {
>>>  
>>>  static int tangier_probe(struct platform_device *pdev)
>>>  {
>>> -	int ioapic;
>>> -	int irq;
>>> +	int gsi;
>>>  	struct intel_mid_wdt_pdata *pdata = pdev->dev.platform_data;
>>> -	struct io_apic_irq_attr irq_attr = { 0 };
>>>  
>>>  	if (!pdata)
>>>  		return -EINVAL;
>>>  
>>> -	irq = pdata->irq;
>>> -	ioapic = mp_find_ioapic(irq);
>>> -	if (ioapic >= 0) {
>>> -		int ret;
>>> -		irq_attr.ioapic = ioapic;
>>> -		irq_attr.ioapic_pin = irq;
>>> -		irq_attr.trigger = 1;
>>> -		/* irq_attr.polarity = 0; -> Active high */
>>> -		ret = io_apic_set_pci_routing(NULL, irq, &irq_attr);
>>> -		if (ret)
>>> -			return ret;
>>> -	} else {
>>> +	/* IOAPIC builds identity mapping between GSI and IRQ on MID */
>>> +	gsi = pdata->irq;
>>> +	if (mp_set_gsi_attr(gsi, 1, 0, cpu_to_node(0)) ||
>>> +	    mp_map_gsi_to_irq(gsi, IOAPIC_MAP_ALLOC) <= 0) {
>>>  		dev_warn(&pdev->dev, "cannot find interrupt %d in ioapic\n",
>>> -			 irq);
>>> +			 gsi);
>>>  		return -EINVAL;
>>>  	}
>>>  
>>> -- 
>>> 1.7.10.4
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
