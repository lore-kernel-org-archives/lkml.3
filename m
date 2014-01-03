Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785AbaACL3Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 06:29:16 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:13456 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaACL3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 06:29:15 -0500
X-IronPort-AV: E=Sophos;i="4.95,597,1384300800"; 
   d="scan'208";a="87314429"
Message-ID: <52C69F09.5010407@citrix.com>
Date: Fri, 3 Jan 2014 11:29:13 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH v12 03/18] xen/pvh: Early bootup changes in PV code (v2).
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>	<1388550945-25499-4-git-send-email-konrad.wilk@oracle.com>	<52C58691.4040502@citrix.com>	<20140102183221.GD3021@pegasus.dumpdata.com> <20140102173438.40612127@mantra.us.oracle.com>
In-Reply-To: <20140102173438.40612127@mantra.us.oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/14 01:34, Mukesh Rathor wrote:
> On Thu, 2 Jan 2014 13:32:21 -0500
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
>> On Thu, Jan 02, 2014 at 03:32:33PM +0000, David Vrabel wrote:
>>> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
>>>> From: Mukesh Rathor <mukesh.rathor@oracle.com>
>>>>
>>>> In the bootup code for PVH we can trap cpuid via vmexit, so don't
>>>> need to use emulated prefix call. We also check for vector
>>>> callback early on, as it is a required feature. PVH also runs at
>>>> default kernel IOPL.
>>>>
>>>> Finally, pure PV settings are moved to a separate function that
>>>> are only called for pure PV, ie, pv with pvmmu. They are also
>>>> #ifdef with CONFIG_XEN_PVMMU.
>>> [...]
>>>> @@ -331,12 +333,15 @@ static void xen_cpuid(unsigned int *ax,
>>>> unsigned int *bx, break;
>>>>  	}
>>>>  
>>>> -	asm(XEN_EMULATE_PREFIX "cpuid"
>>>> -		: "=a" (*ax),
>>>> -		  "=b" (*bx),
>>>> -		  "=c" (*cx),
>>>> -		  "=d" (*dx)
>>>> -		: "0" (*ax), "2" (*cx));
>>>> +	if (xen_pvh_domain())
>>>> +		native_cpuid(ax, bx, cx, dx);
>>>> +	else
>>>> +		asm(XEN_EMULATE_PREFIX "cpuid"
>>>> +			: "=a" (*ax),
>>>> +			"=b" (*bx),
>>>> +			"=c" (*cx),
>>>> +			"=d" (*dx)
>>>> +			: "0" (*ax), "2" (*cx));
>>>
>>> For this one off cpuid call it seems preferrable to me to use the
>>> emulate prefix rather than diverge from PV.
>>
>> This was before the PV cpuid was deemed OK to be used on PVH.
>> Will rip this out to use the same version.
> 
> Whats wrong with using native cpuid? That is one of the benefits that
> cpuid can be trapped via vmexit, and also there is talk of making PV
> cpuid trap obsolete in the future. I suggest leaving it native.

It should either use the PV interface or the HVM one, not a hybrid of
the two.

David
