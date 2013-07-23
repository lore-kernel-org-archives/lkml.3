Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab3GWLQ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 07:16:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756727Ab3GWLQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 07:16:27 -0400
Message-ID: <51EE65F4.3000703@redhat.com>
Date: Tue, 23 Jul 2013 13:16:04 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jason Wang <jasowang@redhat.com>, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, gleb@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] x86: introduce hypervisor_cpuid_base()
References: <1374572465-15278-1-git-send-email-jasowang@redhat.com> <51EE553C.40305@zytor.com>
In-Reply-To: <51EE553C.40305@zytor.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 23/07/2013 12:04, H. Peter Anvin ha scritto:
> On 07/23/2013 02:41 AM, Jason Wang wrote:
>>  
>> +static inline uint32_t hypervisor_cpuid_base(const char *sig, uint32_t leaves)
>> +{
>> +	uint32_t base, eax, ebx, ecx, edx;
>> +	char signature[13];
>> +
>> +	for (base = 0x40000000; base < 0x40010000; base += 0x100) {
>> +		cpuid(base, &eax, &ebx, &ecx, &edx);
>> +		*(uint32_t *)(signature + 0) = ebx;
>> +		*(uint32_t *)(signature + 4) = ecx;
>> +		*(uint32_t *)(signature + 8) = edx;
>> +		signature[12] = 0;
>> +
>> +		if (!strcmp(sig, signature) &&
>> +		    (leaves == 0 || ((eax - base) >= leaves)))
>> +			return base;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
> 
> Hmm... how about:
> 
> uint32_t sign[3];
> 
> 	cpuid(base, &eax, &sign[0], &sign[1], &sign[2]);
> 
> 	if (!memcmp(sig, sign, 12) && ...);

That's nicer, though strcmp is what the replaced code used to do in
patches 2 and 3.

Note that memcmp requires the caller to use "KVMKVMKVM\0\0" as the
signature (or alternatively hypervisor_cpuid_base can copy the argument
into another 12-byte local variable).

Paolo
