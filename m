Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaKEBuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 20:50:46 -0500
Received: from mga02.intel.com ([134.134.136.20]:46853 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaKEBup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 20:50:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,316,1413270000"; 
   d="scan'208";a="602422611"
Message-ID: <54598270.2050302@intel.com>
Date: Wed, 05 Nov 2014 09:50:40 +0800
From: "Chen, Tiejun" <tiejun.chen@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: x86: vmx: avoid returning bool to distinguish success
 from error
References: <1415122394-31986-1-git-send-email-pbonzini@redhat.com> <545980A9.8030405@intel.com>
In-Reply-To: <545980A9.8030405@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/5 9:43, Chen, Tiejun wrote:
> On 2014/11/5 1:33, Paolo Bonzini wrote:
>> Return a negative error code instead, and WARN() when we should be
>> covering
>> the entire 2-bit space of vmcs_field_type's return value.  For increased
>> robustness, add a BUILD_BUG_ON checking the range of
>> vmcs_field_to_offset.
>>
>> Suggested-by: Tiejun Chen <tiejun.chen@intel.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>   arch/x86/kvm/vmx.c | 51

[snip]

>> @@ -6576,6 +6581,9 @@ static void copy_shadow_to_vmcs12(struct
>> vcpu_vmx *vmx)
>>           case VMCS_FIELD_TYPE_NATURAL_WIDTH:
>>               field_value = vmcs_readl(field);
>>               break;
>> +        default:
>> +            WARN_ON(1);
>> +            continue;
>
> 'continue' versus 'break'?
>
> Thanks
> Tiejun
>
>>           }
>>           vmcs12_write_any(&vmx->vcpu, field, field_value);
>>       }
>> @@ -6621,6 +6629,9 @@ static void copy_vmcs12_to_shadow(struct
>> vcpu_vmx *vmx)
>>               case VMCS_FIELD_TYPE_NATURAL_WIDTH:
>>                   vmcs_writel(field, (long)field_value);
>>                   break;
>> +            default:
>> +                WARN_ON(1);
>> +                break;
>>               }
>>           }
>>       }
>> @@ -6659,7 +6670,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>>       /* Decode instruction info and find the field to read */
>>       field = kvm_register_readl(vcpu, (((vmx_instruction_info) >> 28)
>> & 0xf));
>>       /* Read the field, zero-extended to a u64 field_value */
>> -    if (!vmcs12_read_any(vcpu, field, &field_value)) {
>> +    if (vmcs12_read_any(vcpu, field, &field_value) < 0) {
>>           nested_vmx_failValid(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);
>>           skip_emulated_instruction(vcpu);
>>           return 1;
>>

Looks we're missing another place,

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -6601,7 +6601,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)
                 return 1;
         }

-       if (!vmcs12_write_any(vcpu, field, field_value)) {
+       if (vmcs12_write_any(vcpu, field, field_value) < 0) {
                 nested_vmx_failValid(vcpu, 
VMXERR_UNSUPPORTED_VMCS_COMPONENT);
                 skip_emulated_instruction(vcpu);
                 return 1;
Thanks
Tiejun
