Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974AbaAFSkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 13:40:39 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:62946 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbaAFSkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:40:35 -0500
Message-ID: <52CAF8A7.6000705@gmail.com>
Date: Mon, 06 Jan 2014 10:40:39 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Paolo Bonzini <pbonzini@redhat.com>
CC: Gleb Natapov <gleb@minantech.com>, Kashyap Chamarthy <kchamart@redhat.com>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: intel_pstate divide error with v3.13-rc4-256-gb7000ad
References: <CA+5PVA6YpKc6kYK5UiTnGLZpB8uts=-QPtyhotAyZ2kuoG8PPQ@mail.gmail.com> <4410803.FiVxaMNxvJ@vostro.rjw.lan> <52CA9180.1020106@redhat.com> <46313552.v2plfSZzzF@vostro.rjw.lan>
In-Reply-To: <46313552.v2plfSZzzF@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 03:37 AM, Rafael J. Wysocki wrote:
> On Monday, January 06, 2014 12:20:32 PM Paolo Bonzini wrote:
>> Il 04/01/2014 22:38, Rafael J. Wysocki ha scritto:
>>> On Saturday, January 04, 2014 07:48:13 PM Gleb Natapov wrote:
>>>> On Sat, Jan 04, 2014 at 06:38:59PM +0100, Paolo Bonzini wrote:
>>>>> Il 04/01/2014 15:38, Rafael J. Wysocki ha scritto:
>>>>>> Well, it's just a sanity check and it makes the problem go away for the reporter.
>>>>>>
>>>>>>>> Your patch is welcome but perhaps it should have a WARN_ON too.
>>>>>> It has been pulled in already, so the WARN_ON() can only be added via a separate
>>>>>> patch now.  Would you like to prepare that patch?
>>>>>
>>>>> Yes, I'll add it together with the CPUID check.  I'll send the patch so
>>>>> that it can get into 3.14.
>>>>>
>>>> CPUID check, while correct, will sweep the problem under the rug. Current
>>>> Linux logic should detect non working pstate in KVM. We should look into
>>>> why this is not happening for nested.
>>>
>>> I agree.  It's better not to use CPUID for that in my opinion.
>>
>> Among hypervisors, RHEL5's Xen is probably one of the oldest in actual
>> use with new hardware and new kernels, and the CPUID bit has been fixed
>> in 2011.  Older versions wouldn't run new kernels due to other CPUID
>> bits not being cleared properly in VMs.
>>
>> Is there real hardware that has the CPUID bit set and non-working
>> pstate?  If there's no such real hardware, CPUID is what the SDM says
>> you should use to detect presence of the APERF/MPERF msrs.
>
> OK
>
>> Having extra safety checks is fine on top of what the SDM says, but IMO
>> they should be WARN_ONs.  Otherwise you are sweeping bugs under the rug
>> just as much.
>
> As I said I'm not against adding WARN_ON()s there. :-)
>

The patch below adds a feature check for APERF/MPERF.  With this patch
you should NOT see "Intel P-state driver initializing." in dmesg for KVM.

commit 4279f36818bd3ac42f077de114b17eb27d81d482
Author: Dirk Brandewie <dirk.j.brandewie@intel.com>
Date:   Mon Jan 6 10:19:38 2014 -0800

     intel_pstate: Add X86_FEATURE_APERFMPERF to cpu match parameters.


     KVM environments do not support APERF/MPERF MSRs. intel_pstate cannot
     operate without these registers.

     The previous validity checks in intel_pstate_msrs_not_valid() are
     insufficent in nested KVMs.

     Fixes:
     https://bugzilla.redhat.com/show_bug.cgi?id=1046317

     Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
---
  drivers/cpufreq/intel_pstate.c | 3 ++-
  1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 0f63f5d..fe91dad 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -619,7 +619,8 @@ static void intel_pstate_timer_func(unsigned long __data)
  }

  #define ICPU(model, policy) \
-	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_ANY, (unsigned long)&policy }
+	{ X86_VENDOR_INTEL, 6, model, X86_FEATURE_APERFMPERF,\
+			(unsigned long)&policy }

  static const struct x86_cpu_id intel_pstate_cpu_ids[] = {
  	ICPU(0x2a, core_params),

