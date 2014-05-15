Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbaEOVUv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 17:20:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46056 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbaEOVUu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 17:20:50 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <53752885.5080306@intel.com>
References: <1399890550-26475-1-git-send-email-david.vrabel@citrix.com> <53752885.5080306@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH] x86: skip check for spurious faults for non-present faults
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 15 May 2014 14:20:15 -0700
To: Dave Hansen <dave.hansen@intel.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Message-ID: <2edd49ee-077e-4126-b09a-077b7f6be553@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to wrap my head around any forward compatibility concerns... if we misidentify a fault as spurious that would be bad.  

On May 15, 2014 1:50:13 PM PDT, Dave Hansen <dave.hansen@intel.com> wrote:
>On 05/12/2014 03:29 AM, David Vrabel wrote:
>> -	/* Reserved-bit violation or user access to kernel space? */
>> -	if (error_code & (PF_USER | PF_RSVD))
>> +	/* Only check for spurious faults on supervisor write or
>> +	   instruction faults. */
>> +	if (error_code != (PF_WRITE | PF_PROT)
>> +	    && error_code != (PF_INSTR | PF_PROT))
>>  		return 0;
>
>This changes the semantics a bit too much for me to feel happy about
>it.
> This is at best missing quite a bit of detail from the changelog.
>
> 1. 'return 0' means "this was not a spurious fault"
> 2. We used to check for the presence of PF_USER|PF_RSVD
> 3. This patch checks now for two _explicit_ conditions, which
>    implicitly check for the _absence_ of the two bits we checked for
>    before.
>
>I do believe your patch is correct, but it took me a bit to convince
>myself that it was the right thing.  Please be explicit (in the
>comment)
>about the exact PTE transitions that you expect to get you here.
>
>Also, I have to wonder if you can just leave the original if() in
>there.
> You're making this _more_ restrictive than it was before, and I wonder
>if it might just be more clear if you have both checks.  The compiler
>might even compile it down to the same code, just changing the
>immediate
>that was generated for the mask that you're checking.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
