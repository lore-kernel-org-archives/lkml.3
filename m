Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaIVNpf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 09:45:35 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:39527 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671AbaIVNpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 09:45:33 -0400
Message-ID: <542027F6.4050205@de.ibm.com>
Date: Mon, 22 Sep 2014 15:45:26 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.8.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, David Matlack <dmatlack@google.com>,
        Gleb Natapov <gleb@kernel.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: don't take vcpu mutex for obviously invalid vcpu
 ioctls
References: <1411167805-2458-1-git-send-email-dmatlack@google.com> <541FFEDE.9030800@redhat.com>
In-Reply-To: <541FFEDE.9030800@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092213-0342-0000-0000-000001255BE0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2014 12:50 PM, Paolo Bonzini wrote:
> Il 20/09/2014 01:03, David Matlack ha scritto:
>> vcpu ioctls can hang the calling thread if issued while a vcpu is
>> running. If we know ioctl is going to be rejected as invalid anyway,
>> we can fail before trying to take the vcpu mutex.
>>
>> This patch does not change functionality, it just makes invalid ioctls
>> fail faster.
>>
>> Signed-off-by: David Matlack <dmatlack@google.com>
>> ---
>>  virt/kvm/kvm_main.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 96ec622..f9234e5 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -52,6 +52,7 @@
>>  
>>  #include <asm/processor.h>
>>  #include <asm/io.h>
>> +#include <asm/ioctl.h>
>>  #include <asm/uaccess.h>
>>  #include <asm/pgtable.h>
>>  
>> @@ -1975,6 +1976,9 @@ static long kvm_vcpu_ioctl(struct file *filp,
>>  	if (vcpu->kvm->mm != current->mm)
>>  		return -EIO;
>>  
>> +	if (unlikely(_IOC_TYPE(ioctl) != KVMIO))
>> +		return -EINVAL;
>> +
>>  #if defined(CONFIG_S390) || defined(CONFIG_PPC) || defined(CONFIG_MIPS)
>>  	/*
>>  	 * Special cases: vcpu ioctls that are asynchronous to vcpu execution,
>>
> 
> Thanks, applying this patch.

Isnt that the wrong trade off?

We now have an extra condition check for every valid ioctl, to make an error case go faster.
I know, the extra check is just a 1 or 2 cycles if branch prediction is right, but still.

Christian

