Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179AbaGWCpJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 22:45:09 -0400
Received: from mga14.intel.com ([192.55.52.115]:45070 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754537AbaGWCfu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 22:35:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,714,1400050800"; 
   d="scan'208";a="565812388"
From: "Ren, Qiaowei" <qiaowei.ren@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
CC: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH v7 03/10] x86, mpx: add macro cpu_has_mpx
Thread-Topic: [PATCH v7 03/10] x86, mpx: add macro cpu_has_mpx
Thread-Index: AQHPpKaZ7P+lz+nalUOxAx0M9XXWLpurwdcAgAEwxJA=
Date: Wed, 23 Jul 2014 02:35:42 +0000
Message-ID: <9E0BE1322F2F2246BD820DA9FC397ADE0170079E@shsmsx102.ccr.corp.intel.com>
References: <1405921124-4230-1-git-send-email-qiaowei.ren@intel.com>
 <1405921124-4230-4-git-send-email-qiaowei.ren@intel.com>
 <53CE8EEC.2090402@intel.com>
In-Reply-To: <53CE8EEC.2090402@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014-07-23, Hansen, Dave wrote:
> On 07/20/2014 10:38 PM, Qiaowei Ren wrote:
>> +#ifdef CONFIG_X86_INTEL_MPX
>> +#define cpu_has_mpx boot_cpu_has(X86_FEATURE_MPX) #else #define
>> +cpu_has_mpx 0 #endif /* CONFIG_X86_INTEL_MPX */
> 
> Is this enough checking?  Looking at the extension reference, it says:
> 
>> 9.3.3 Enabling of Intel MPX States An OS can enable Intel MPX states to
>> support software operation using bounds registers with the following
>> steps: * Verify the processor supports XSAVE/XRSTOR/XSETBV/XGETBV
>> instructions and XCR0 by checking CPUID.1.ECX.XSAVE[bit 26]=1.
> 
> That, I assume the xsave code is already doing.
> 
>> * Verify the processor supports both Intel MPX states by checking
> CPUID.(EAX=0x0D, ECX=0):EAX[4:3] is 11b.
> 
> I see these bits _attempting_ to get set in pcntxt_mask via XCNTXT_MASK.
>  But, I don't see us ever actually checking that they _do_ get set.
> For instance, we do this for:
> 
>>         if ((pcntxt_mask & XSTATE_FPSSE) != XSTATE_FPSSE) {
>>                 pr_err("FP/SSE not shown under xsave features
> 0x%llx\n",
>>                        pcntxt_mask);
>>                 BUG();
>>         }

The checking about MPX feature should be as follow:

        if (pcntxt_mask & XSTATE_EAGER) {
                if (eagerfpu == DISABLE) {
                        pr_err("eagerfpu not present, disabling some xstate features: 0x%llx\n",
                                        pcntxt_mask & XSTATE_EAGER);
                        pcntxt_mask &= ~XSTATE_EAGER;
                } else {
                        eagerfpu = ENABLE;
                }
        }

This patch was merged into kernel the ending of last year (https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=e7d820a5e549b3eb6c3f9467507566565646a669 )

Thanks,
Qiaowei

