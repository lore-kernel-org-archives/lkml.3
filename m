Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab3KHKUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:20:20 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39781 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab3KHKUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:20:18 -0500
Message-ID: <527CBAE0.4070301@linaro.org>
Date: Fri, 08 Nov 2013 11:20:16 +0100
From: Ard <ard.biesheuvel@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>
CC: x86@kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, tglx@linutronix.de,
        Ingo Molnar <mingo@kernel.org>, Steve Capper <steve.capper@linaro.org>
Subject: Re: [RFC PATCH 0/4] wire up CPU features to udev based module loading
References: <1383844657-17487-1-git-send-email-ard.biesheuvel@linaro.org>	<527C0195.50008@zytor.com>	<20131107213944.GJ1962@tassilo.jf.intel.com> <CAKv+Gu9W-Pu4DGgB-85A3D4Ps9_FLSQgyK3EM7=k7KE1=xsnwg@mail.gmail.com> <527C1911.9030900@zytor.com>
In-Reply-To: <527C1911.9030900@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 11:49 PM, H. Peter Anvin wrote:
> On 11/07/2013 02:15 PM, Ard Biesheuvel wrote:
>>
>> That would involve repurposing/generalizing a bit more of the existing
>> x86-only code than I did the first time around, but if you (as x86
>> maintainers) are happy with that, I'm all for it.
>>
>> I do have a couple of questions then - the module aliases host tool has
>> no arch specific dependencies at all except having x86cpu as one of the
>> entries: would you mind dropping the x86 prefix there? Or rather add
>> dependencies on $ARCH? (If we drop it there, we basically end up with
>> 'cpu:' everywhere)
>
> I think it makes sense to indicate what kind of CPU the string refers to,
> as the top-level indicator of what is going on.  This might be possible to
> macroize the generation of this prefix, though.
>
>> - in the vendor/family/model case, it may be preferable to drop these
>> fields entirely from certain modules' aliases if they match on 'any'
>> (provided that the module tools permit this) rather than add
>> architecture, variant, revision, etc  fields for all architectures if
>> they can only ever match on one
>
> I think that can be CPU dependent.
>
>> - some of the X86_ macros would probable be redefined in terms of the
>> generic macros rather than the other way around, which would result in
>> some changes under arch/x86 as well, is that acceptable for you?
>
> If you are talking about X86_FEATURE_* then almost certainly no, although
> I'm willing to listen to what you have in mind.
>

Actually, this should not be necessary at all, if we are happy to put up with
distinct types for x86_cpu_id, generic_cpu_id, and perhaps other arch based
ones in the future.

So what I have in mind for x86 is this (and this way, no other changes are
needed to the existing x86 bits)

diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index ab6082a..82e92b2 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -56,8 +56,7 @@ ssize_t arch_print_cpu_modalias(struct device *dev,
         int i, n;
         char *buf = bufptr;

-       n = snprintf(buf, size, "x86cpu:vendor:%04X:family:%04X:"
-                    "model:%04X:feature:",
+       n = snprintf(buf, size, "cpu:type:x86,ven%04Xfam%04Xmod%04X:feature:",
                 boot_cpu_data.x86_vendor,
                 boot_cpu_data.x86,
                 boot_cpu_data.x86_model);
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index 2370863..dea263a 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1110,7 +1110,7 @@ static int do_amba_entry(const char *filename,
  }
  ADD_TO_DEVTABLE("amba", amba_id, do_amba_entry);

-/* LOOKS like x86cpu:vendor:VVVV:family:FFFF:model:MMMM:feature:*,FEAT,*
+/* LOOKS like cpu:type:x86,venVVVVfamFFFFmodMMMM:feature:*,FEAT,*
   * All fields are numbers. It would be nicer to use strings for vendor
   * and feature, but getting those out of the build system here is too
   * complicated.
@@ -1124,10 +1124,10 @@ static int do_x86cpu_entry(const char *filename, void
*symval,
         DEF_FIELD(symval, x86_cpu_id, model);
         DEF_FIELD(symval, x86_cpu_id, vendor);

-       strcpy(alias, "x86cpu:");
-       ADD(alias, "vendor:",  vendor != X86_VENDOR_ANY, vendor);
-       ADD(alias, ":family:", family != X86_FAMILY_ANY, family);
-       ADD(alias, ":model:",  model  != X86_MODEL_ANY,  model);
+       strcpy(alias, "cpu:type:x86,");
+       ADD(alias, "ven", vendor != X86_VENDOR_ANY, vendor);
+       ADD(alias, "fam", family != X86_FAMILY_ANY, family);
+       ADD(alias, "mod", model  != X86_MODEL_ANY,  model);
         strcat(alias, ":feature:*");
         if (feature != X86_FEATURE_ANY)
                 sprintf(alias + strlen(alias), "%04X*", feature);

The way I intend this to work is that, for instance, arm64 will emit something
like

cpu:type:arm64:features:,0000,0001,0002

when the cpu uevent is raised, but as it is unclear whether we will want to
match on variant, revision etc on arm64, we could use a generic
MODULE_DEVICE_TABLE(cpu, ...) [as in patch #2 of this series] which would
produce something like

cpu:type:*:features:*00xx*

as a modalias to match on feature xx, whereas a plain X86_FEATURE_MATCH() will
produce something like

cpu:type:x86,ven*fam*mod*:features:*00xx*

Does this look like a reasonable approach to you?

Regards,
Ard.
