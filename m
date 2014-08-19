Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaHSCQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 22:16:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:62926 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752545AbaHSCQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 22:16:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="374048643"
Date: Tue, 19 Aug 2014 10:17:41 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] KVM: vmx: fix ept reserved bits for 1-GByte page
Message-ID: <20140819021741.GA2003@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1408355431-115633-1-git-send-email-wanpeng.li@linux.intel.com>
 <53F1D313.5010108@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F1D313.5010108@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On Mon, Aug 18, 2014 at 12:18:59PM +0200, Paolo Bonzini wrote:
>Il 18/08/2014 11:50, Wanpeng Li ha scritto:
>> EPT misconfig handler in kvm will check which reason lead to EPT 
>> misconfiguration after vmexit. One of the reasons is that an EPT 
>> paging-structure entry is configured with settings reserved for 
>> future functionality. However, the handler can't identify if 
>> paging-structure entry of reserved bits for 1-GByte page are 
>> configured, since PDPTE which point to 1-GByte page will reserve 
>> bits 29:12 instead of bits 7:3 which are reserved for PDPTE that 
>> references an EPT Page Directory. This patch fix it by reserve 
>> bits 29:12 for 1-GByte page. 
>> 
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>>  arch/x86/kvm/vmx.c | 14 ++++++++++----
>>  1 file changed, 10 insertions(+), 4 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index bfe11cf..71cbee5 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -5521,9 +5521,14 @@ static u64 ept_rsvd_mask(u64 spte, int level)
>>  	for (i = 51; i > boot_cpu_data.x86_phys_bits; i--)
>>  		mask |= (1ULL << i);
>>  
>> -	if (level > 2)
>> -		/* bits 7:3 reserved */
>> -		mask |= 0xf8;
>> +	if (level > 2) {
>
>level can be 4 here.  You have to return 0xf8 for level == 4.
>
>The same "if" statement then can cover both 2MB and 1GB pages, like
>
>                if (spte & (1ULL << 7))
>                        /* 1GB/2MB page, bits 29:12 or 20:12 reserved respectively */
>                        mask |= (PAGE_SIZE << ((level - 1) * 9)) - PAGE_SIZE;
>                else
>                        /* bits 6:3 reserved */
>                        mask |= 0x78;
>
>> -		if (level == 1 || (level == 2 && (spte & (1ULL << 7)))) {
>> +		if (level == 1 || ((level == 3 || level == 2)
>> +				&& (spte & (1ULL << 7)))) {
>
>This condition can be simplified by checking the return value of ept_rsvd_mask.
>If it includes 0x38, this is a large page.  Otherwise it is a leaf page and
>you can go down the "if".

As you know, 5:3 bits which used for EPT MT are not reserved bits, so 
I fail to understand why check the return value of ept_rsvd_mask and 
it's a large page if includes 0x38. Could you eplain in more details? ;-)

Regards,
Wanpeng Li 

>
>Paolo
>
>>  			u64 ept_mem_type = (spte & 0x38) >> 3;
>>  
>>  			if (ept_mem_type == 2 || ept_mem_type == 3 ||
>> 
