Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3DSUc6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 16:32:58 -0400
Received: from relay2.blacknight.com ([78.153.203.205]:50967 "EHLO
	relay2.blacknight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab3DSUc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 16:32:57 -0400
Message-ID: <5171AA86.604@nexus-software.ie>
Date: Fri, 19 Apr 2013 21:35:18 +0100
From: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: hpa@zytor.com, linux-kernel@vger.kernel.org, x86@kernel.org,
        fenghua.yu@intel.com
Subject: Re: [PATCH] x86: Add check for P5 to microcode_intel_early
References: <1366392183-4149-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <20130419191128.GA21991@pd.tnic>
In-Reply-To: <20130419191128.GA21991@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/04/13 20:11, Borislav Petkov wrote:
> On Fri, Apr 19, 2013 at 06:23:03PM +0100, Bryan O'Donoghue wrote:
>> Architectural MSRs associated with microcode are for P6 or higher.
>> Add a check to early microcode to detect<  P6.
>>
>> Without a check for<  P6 - we end up reading from unimplemented MSRs
>> on Pentium.
>
> Is this something you're actually seeing on some box or just found by
> staring at the code?

We actually see this on a P5 alright.
The code path is reachable, no question.

> In any case, the family checks should go into the ucode driver entry
> points in arch/x86/kernel/microcode_core_early.c. AFAICT, x86_vendor()
> is a good candidate to be taught to read out the family too and return
> X86_VENDOR_UNKNOWN if<  P6. Or something to that effect.

Hmm

Just returning X86_VENDOR_UNKNOWN - won't fix the bug though - after all 
MSR_IA32_UCODE_REV is also x86_family() >= 6

x86 = get_x86_family(csig.sig);
x86_model = get_x86_model(csig.sig);

if (x86 < 6)
	return UCODE_ERROR;

if ((x86_model >= 5) || (x86 > 6)) {
	/* get processor flags from MSR 0x17 */
	native_rdmsr(MSR_IA32_PLATFORM_ID, val[0], val[1]);
	csig.pf = 1 << ((val[1] >> 18) & 7);
}

native_wrmsr(MSR_IA32_UCODE_REV, 0, 0);

/* As documented in the SDM: Do a CPUID 1 here */
sync_core();

/* get the current revision from MSR 0x8B */
native_rdmsr(MSR_IA32_UCODE_REV, val[0], val[1]);

Peter - what's your take ?

