Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaIOOqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:46:03 -0400
Received: from smtp.citrix.com ([66.165.176.89]:51033 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbaIOOqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:46:00 -0400
X-IronPort-AV: E=Sophos;i="5.04,528,1406592000"; 
   d="scan'208";a="171564783"
Message-ID: <5416FBA1.2060902@citrix.com>
Date: Mon, 15 Sep 2014 15:45:53 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mukesh Rathor <mukesh.rathor@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [V5 PATCH 1/1] x86/xen: Set EFER.NX and EFER.SCE
 in PVH guests
References: <1410392166-16388-1-git-send-email-mukesh.rathor@oracle.com>	<1410392166-16388-2-git-send-email-mukesh.rathor@oracle.com> <20140912204258.GA24846@laptop.dumpdata.com>
In-Reply-To: <20140912204258.GA24846@laptop.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/14 21:42, Konrad Rzeszutek Wilk wrote:
> On Wed, Sep 10, 2014 at 04:36:06PM -0700, Mukesh Rathor wrote:
>> 
>> @@ -413,15 +417,18 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
>>  					(unsigned long)xen_failsafe_callback;
>>  		ctxt->user_regs.cs = __KERNEL_CS;
>>  		per_cpu(xen_cr3, cpu) = __pa(swapper_pg_dir);
>> -#ifdef CONFIG_X86_32
>>  	}
>> -#else
>> -	} else
>> -		/* N.B. The user_regs.eip (cpu_bringup_and_idle) is called with
>> -		 * %rdi having the cpu number - which means are passing in
>> -		 * as the first parameter the cpu. Subtle!
>> +#ifdef CONFIG_XEN_PVH
>> +	else {
>> +		/*
>> +		 * The vcpu comes on kernel page tables which have the NX pte
>> +		 * bit set. This means before DS/SS is touched, NX in
>> +		 * EFER must be set. Hence the following assembly glue code.
> 
> And you ripped out the nice 'N.B' comment I added. Sad :-(

I think I removed that.

I don't think passing parameters to a function is particularly subtle
and this comment is largely superseded by the comment for
xen_pvh_early_cpu_init() itself.

>> +#ifdef CONFIG_XEN_PVH
>> +/*
>> + * xen_pvh_early_cpu_init() - early PVH VCPU initialization
>> + * @cpu: this cpu number (%rdi)
>> + * @flag: boolean flag true to indicate this is a secondary vcpu coming up
>> + *        on this entry point or the primary cpu coming back online.
> 
> Why do we do this? Why not just piggyback on the first parameter - the 'cpu'?
> 
> If it is zero it is boot CPU.

"Changes in v5 (Mukesh):
  - Jan reminded us that vcpu 0 could go offline/online. So, add flag back"

David
