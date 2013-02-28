Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756464Ab3B1PzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:55:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38348 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab3B1PzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:55:24 -0500
Message-ID: <512F7D88.4090703@zytor.com>
Date: Thu, 28 Feb 2013 07:53:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, mingo@redhat.com,
        tglx@linutronix.de, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, samu.kallio@aberdeencloud.com,
        kraman@redhat.com, jwboyer@redhat.com
Subject: Re: Is: x86: mm: Fix vmalloc_fault oops during lazy MMU updates Was:
 Re: [PATCH] mm/x86: Flush lazy MMU when DEBUG_PAGEALLOC is set
References: <91983d94-7b7d-4a0b-9470-e7cd823ba139@default> <512E8B41.8000504@zytor.com> <20130227230009.GA32465@kroah.com> <512E91B7.6060102@zytor.com> <20130228142910.GA32354@phenom.dumpdata.com> <20130228153846.GA9782@pd.tnic>
In-Reply-To: <20130228153846.GA9782@pd.tnic>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2013 07:38 AM, Borislav Petkov wrote:
> On Thu, Feb 28, 2013 at 09:29:10AM -0500, Konrad Rzeszutek Wilk wrote:
>> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
>> index fb674fd..4f7d793 100644
>> --- a/arch/x86/mm/fault.c
>> +++ b/arch/x86/mm/fault.c
>> @@ -378,10 +378,12 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
>>  	if (pgd_none(*pgd_ref))
>>  		return -1;
>>  
>> -	if (pgd_none(*pgd))
>> +	if (pgd_none(*pgd)) {
>>  		set_pgd(pgd, *pgd_ref);
>> -	else
>> +		arch_flush_lazy_mmu_mode();
> 
> Do I understand it correctly that this would cost us a
> "preempt_disable(); preempt_enable()" needlessly on baremetal when
> running with CONFIG_PARAVIRT enabled?
> 

OK, this is mind-boggingly crazy and these things that just drives me
batty about PV.

arch_flush_lazy_mmu_mode() involves a function call and preemption off
*before it even tests for being a noop*.  On bare metal this function
doesn't do anything, and cannot do anything.

At the very least we should have an early filter for the **COMMON!**
case that we are not on a PV platform.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

