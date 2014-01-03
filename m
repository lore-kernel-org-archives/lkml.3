Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaACUAB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 15:00:01 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:40434 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbaACT77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 14:59:59 -0500
Message-ID: <52C716C1.6070704@gmail.com>
Date: Fri, 03 Jan 2014 12:00:01 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@kernel.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Kashyap Chamarthy <kchamart@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: intel_pstate divide error with v3.13-rc4-256-gb7000ad
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com> <4794554.Hmd2RUNYDT@vostro.rjw.lan> <52C18A23.10703@redhat.com> <3710588.K8glfx1cYs@vostro.rjw.lan> <52C6F3B4.3050904@gmail.com> <20140103180435.GK10961@minantech.com>
In-Reply-To: <20140103180435.GK10961@minantech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2014 10:04 AM, Gleb Natapov wrote:
> On Fri, Jan 03, 2014 at 09:30:28AM -0800, Dirk Brandewie wrote:
>> Hi All,
>>
>> Sorry for being late to the party but I just got back from vacation.
>>
>> There is something deeply wrong here.  We should have never gotten to
>> intel_pstate_init_cpu().  The VM had to have returned value from the read
>> of the max pstate at driver init time and 0 when the CPU was being brought up.
>>
>> intel_pstate_msrs_not_valid() was added to solve this issue early on
>> if I remember correctly it was Josh that reported it then.  Is there
>> a definative way to detect whether we are running in a VM?
>>
> Checking for VM is a wrong thing to do here. KVM should behave like it
> does not support p-state.
>
>> Can some one tell me how the nested environment differs in regards to
>> reading MSRs?
>>
> It shouldn't differ, but there may be bug somewhere in nested emulation.
> We shouldn't try and hind the bug by doing more checks in Linux but
> rather fixing KVM bug that causes Linux to behave incorrectly.

Based on the unhandled MSR messages in the host dmesg the following patch
should make sure the correct values are returned for PLAT_FORM_INFO, APERF
and MPERF.  intel_pstate and turbostat are the only users of these registers.

Could you try the folloinw patch minus Rafael's patch please.
Compile tested only.

TIA
--Dirk

commit 5594b89bee7f83200c1a70bf95d50ac35e4fe3f8
Author: Dirk Brandewie <dirk.j.brandewie@intel.com>
Date:   Fri Jan 3 11:44:15 2014 -0800

     x86/kvm: Handle MSR_PLATFORM_INFO, MSR_IA32_MPERF and MSR_IA32_APERF MSRs

     Handle MSRs correctly when read from a nested KVM

     Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
  arch/x86/kvm/x86.c | 3 +++
  1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5d004da..390ef27 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2336,6 +2336,9 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, u32 msr, u64 
*pdata)

  	switch (msr) {
  	case MSR_IA32_PLATFORM_ID:
+	case MSR_IA32_MPERF:
+	case MSR_IA32_APERF:
+	case MSR_PLATFORM_INFO:
  	case MSR_IA32_EBL_CR_POWERON:
  	case MSR_IA32_DEBUGCTLMSR:
  	case MSR_IA32_LASTBRANCHFROMIP:

