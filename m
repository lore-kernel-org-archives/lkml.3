Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaHYDQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 23:16:56 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:48761 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbaHYDQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 23:16:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140824093759.GG18167@minantech.com>
References: <CA+U0gVjxF+o3xHPULUQ26wJs4myW3gxUODnUJ3xaYVT6-mFYdg@mail.gmail.com>
 <20140824093759.GG18167@minantech.com>
From: Dennis Chen <kernel.org.gnu@gmail.com>
Date: Mon, 25 Aug 2014 11:16:34 +0800
Message-ID: <CA+U0gVg13bF_OwRbbH-ZW2Rb9TbYixwgF9m_Utt_cGWb_iH+qQ@mail.gmail.com>
Subject: Re: [PATCH] KVM-Use value reading from MSR when construct the eptp in
 VMX mode
To: Gleb Natapov <gleb@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        "wanpeng.li" <wanpeng.li@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2014 at 5:38 PM, Gleb Natapov <gleb@kernel.org> wrote:
> On Sun, Aug 24, 2014 at 11:54:32AM +0800, Dennis Chen wrote:
>> This patch is used to construct the eptp in vmx mode with values
>> readed from MSR according to the intel x86 software developer's
>> manual.
>>
>>  static u64 construct_eptp(unsigned long root_hpa)
>>  {
>> -    u64 eptp;
>> +    u64 eptp, pwl;
>> +
>> +    if (cpu_has_vmx_ept_4levels())
>> +        pwl = VMX_EPT_DEFAULT_GAW << VMX_EPT_GAW_EPTP_SHIFT;
>> +    else {
>> +        WARN(1, "Unsupported page-walk length of 4.\n");
> Page-walk length of 4 is the only one that is supported.
>
Since there is a bit 6 in IA32_VMX_EPT_VPID_CAP MSR indicating the
support for the page-walk length, I think sanity check is necessary.
But I just checked the code, it's already done in the hardware_setup()
function which will disable ept feature if the page-wake length is not
4. Gleb, any comments for the memory type check part?

>> +        BUG();
>> +    }
>> +
>> +    if (cpu_has_vmx_eptp_writeback())
>> +        eptp = VMX_EPT_DEFAULT_MT | pwl;
>> +    else if (cpu_has_vmx_eptp_uncacheable())
>> +        eptp = VMX_EPT_UC_MT | pwl;
>> +    else {
>> +        WARN(1, "Unsupported memory type config in vmx eptp.\n");
>> +        BUG();
>> +    }
>>
>> -    /* TODO write the value reading from MSR */
>> -    eptp = VMX_EPT_DEFAULT_MT |
>> -        VMX_EPT_DEFAULT_GAW << VMX_EPT_GAW_EPTP_SHIFT;
>>      if (enable_ept_ad_bits)
>>          eptp |= VMX_EPT_AD_ENABLE_BIT;
>>      eptp |= (root_hpa & PAGE_MASK);
>> --
>> 1.7.9.5
>
> --
>                         Gleb.
