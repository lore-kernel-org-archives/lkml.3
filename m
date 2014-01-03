Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaACLZX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 06:25:23 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:7921 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbaACLZU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 06:25:20 -0500
X-IronPort-AV: E=Sophos;i="4.95,597,1384300800"; 
   d="scan'208";a="87314045"
Message-ID: <52C69E1E.7090103@citrix.com>
Date: Fri, 3 Jan 2014 11:25:18 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 03/18] xen/pvh: Early bootup changes in PV code (v2).
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-4-git-send-email-konrad.wilk@oracle.com> <52C58691.4040502@citrix.com> <20140102183221.GD3021@pegasus.dumpdata.com>
In-Reply-To: <20140102183221.GD3021@pegasus.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/14 18:32, Konrad Rzeszutek Wilk wrote:
> On Thu, Jan 02, 2014 at 03:32:33PM +0000, David Vrabel wrote:
>> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
>>> From: Mukesh Rathor <mukesh.rathor@oracle.com>
>>>
>>> In the bootup code for PVH we can trap cpuid via vmexit, so don't
>>> need to use emulated prefix call. We also check for vector callback
>>> early on, as it is a required feature. PVH also runs at default kernel
>>> IOPL.
>>>
>>> Finally, pure PV settings are moved to a separate function that are
>>> only called for pure PV, ie, pv with pvmmu. They are also #ifdef
>>> with CONFIG_XEN_PVMMU.
>> [...]
>>> @@ -331,12 +333,15 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
>>>  		break;
>>>  	}
>>>  
>>> -	asm(XEN_EMULATE_PREFIX "cpuid"
>>> -		: "=a" (*ax),
>>> -		  "=b" (*bx),
>>> -		  "=c" (*cx),
>>> -		  "=d" (*dx)
>>> -		: "0" (*ax), "2" (*cx));
>>> +	if (xen_pvh_domain())
>>> +		native_cpuid(ax, bx, cx, dx);
>>> +	else
>>> +		asm(XEN_EMULATE_PREFIX "cpuid"
>>> +			: "=a" (*ax),
>>> +			"=b" (*bx),
>>> +			"=c" (*cx),
>>> +			"=d" (*dx)
>>> +			: "0" (*ax), "2" (*cx));
>>
>> For this one off cpuid call it seems preferrable to me to use the
>> emulate prefix rather than diverge from PV.
> 
> This was before the PV cpuid was deemed OK to be used on PVH.
> Will rip this out to use the same version.
> 
>>
>>> @@ -1431,13 +1449,18 @@ asmlinkage void __init xen_start_kernel(void)
>>>  
>>>  	xen_domain_type = XEN_PV_DOMAIN;
>>>  
>>> +	xen_setup_features();
>>> +	xen_pvh_early_guest_init();
>>>  	xen_setup_machphys_mapping();
>>>  
>>>  	/* Install Xen paravirt ops */
>>>  	pv_info = xen_info;
>>>  	pv_init_ops = xen_init_ops;
>>> -	pv_cpu_ops = xen_cpu_ops;
>>>  	pv_apic_ops = xen_apic_ops;
>>> +	if (xen_pvh_domain())
>>> +		pv_cpu_ops.cpuid = xen_cpuid;
>>> +	else
>>> +		pv_cpu_ops = xen_cpu_ops;
>>
>> If cpuid is trapped for PVH guests why does PVH need non-native cpuid op?
> 
> There are a couple of filtering done on the cpuid. But with HVM I am
> not entirely sure if it is worth preserving those or not.

I think we should behave like HVM for cpuid and any cpuid
policy/filtering should be set up by the toolstack.

> My fear is that if we switch over to the native one without the
> filtering that the kernel does we open up a can of worms that had been
> closed in the past. The reason is that for dom0 - there is no cpuid
> filtering being done. So it gets everything that the hypervisor sees.

I think we should switch to using the native cpuid pv-op and fix up any
problems as we encounter them (by fixing the toolstack to set up the
cpuid stuff properly).

dom0 isn't supported yet so that's not an issue.  In the future dom0
could be handled by either: a) setting the cpuid policy in the
hypervisor during dom0 create; or b) the kernel can set this up during
early boot.  In both cases using native cpuid should do the right thing.

David
