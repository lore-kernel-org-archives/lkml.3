Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670AbaD3XD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 19:03:57 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:59276 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759041AbaD3XDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 19:03:54 -0400
MIME-Version: 1.0
In-Reply-To: <20140430070042.GN32718@rric.localhost>
References: <20140420075936.GA19672@pd.tnic>
	<CAL-B5D1rJmf9vLSnV2izsXcbCu1idXsTsnSwoFRKFNTM7BnyfA@mail.gmail.com>
	<20140426091031.GA10166@pd.tnic>
	<CAErSpo4Jqo_opj=QqjcquS_6HqckZfP5-oQHkmY5FSAyyLNYMg@mail.gmail.com>
	<20140428214036.GA32143@pd.tnic>
	<20140429073309.GE10997@alberich>
	<20140429102013.GA4726@pd.tnic>
	<535FC269.2000808@amd.com>
	<20140429191454.GB4726@pd.tnic>
	<CAL-B5D2Z7AvJZ3G2JLY6ZOZBRe4DGgO27RVJ_HHotGrnKL7Y1A@mail.gmail.com>
	<20140430070042.GN32718@rric.localhost>
Date: Wed, 30 Apr 2014 17:03:53 -0600
Message-ID: <CAL-B5D1ee2t--f3=u4TW3wvUaiUN0n=0X-E7ZEEPkdhtBxi2ZA@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] x86/PCI: Support additional MMIO range capabilities
From: Myron Stowe <myron.stowe@gmail.com>
To: Robert Richter <rric@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Borislav Petkov <bp@suse.de>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>, kim.naru@amd.com,
        Daniel J Blueman <daniel@numascale.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>,
        Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 1:00 AM, Robert Richter <rric@kernel.org> wrote:
> On 29.04.14 15:40:28, Myron Stowe wrote:
>> On Tue, Apr 29, 2014 at 1:14 PM, Borislav Petkov <bp@alien8.de> wrote:
>> > So sounds to me like we want to get rid of the whole IO ECS deal
>> > altogether then.
>> >
>> > Now, I'm wondering whether we should kill it completely since I don't
>> > think anyone cares about numa node info being correct on K8, or? I'm
>> > specifically turning to our numascale friends who love to have a lot of
>> > nodes. :-)
>
> Maybe I did get you wrong, but IO ECS was introduced with fam10h and
> is not related to k8.
>
>> I think we need to be careful here as there are two unrelated topics
>> being discussed together.  What started this whole thread was the need
>> for sysfs related numa_node information with respect to PCI devices
>> (1).  Without patch 1, platforms with newer AMD CPUs end up having
>> '-1' numa_node values for all PCI devices.
>>
>> IO ECS has no bearing on patch 1, it only comes into play with patch 2
>> which is concerned with MMIO resource information when MCFG doesn't
>> exist.  For the particular issue I'm trying to get resolved, patch 2
>> is not needed.  However, since we have expended time and effort on
>> this subject, perhaps we should get this cleaned up while it has our
>> attention.
>>
>> I'm all for deleting as much of amd_bus.c as possible due to its
>> "perennial maintenance headache".  The obvious choices seem to be all,
>> or some combination, of:
>>   o removing IO ECS logic,
>>   o removing IO/MMIO logic (assuming MCFG issues were long enough ago
>> to no longer be a concern),
>>   o start deprecating amd_bus.c by adding logic to skip if BIOS >= 2015
>
> I don't see any reason for big changes actually. Just bind the IO ECS
> logic to fam10h (either with fam check or pci device depending on the
> implementation, xen's flavor would be pci). This is something stricter
> than 'if BIOS >= 2015'. It leaves code as it is which is maintainable.
>
> You implement the new logic for for newer families. No need for one
> implementation that fits all.

I wasn't explicit enough with respect to "deleting as much of
amd_bus.c as possible ..." so I'll try again.

Earlier in this thread - https://lkml.org/lkml/2014/4/28/524 - Bjorn
expressed the desire to "eliminate the need for kernel changes to
support future systems.  So far we seem to be concentrating on (1) and
neglecting (2), which means we're always reacting to things that are
broken.  ...  I think we should try to get rid of amd_bus.c ...".

Then, again in this thread - https://lkml.org/lkml/2014/4/29/360 -
Suravee noted: "... the existing code, which does many things:
  1. Setup numa_node information (if PXM doesn't exist)
  2. Probe NB for MMIO resources (if MCFG doesn't exist)
  3. Probe NB for IO resources
  4. Setup IO ECS

So let's walk through these.  (1) was put in place to "snoop out, from
the HW" numa_node information.  It is "snooped" and cached.  Then,
later in booting, if the platform does not supply an ACPI _PXM method
corresponding to the hostbridge *and* we are on a AMD based platform,
the "snooped" numa_node information is retrieved and used.  There are
two issues with this approach.  First, "The node numbers used by Linux
are logical and there's no reason they need to be identical to
settings in the CPU registers.  So if we got some node information in
the normal way (from _PXM, SLIT, SRAT, etc.) and some from your patch,
there's no reason to believe they would be compatible." [1].  Second,
there is a architectural agnostic way to get this information; the
ACPI _PXM method.  Looking at numerous 'acpidump' captures, the vast
majority of platform BIOS' are not implementing _PXM methods
corresponding to hostbridges - we need to try and correct this and get
away from this current, error prone, fall-back mechanism (again: see
[1]).

(2) and (3) were put in place for similar reasons but with respect to
MCFG - during its early phases, it was either buggy or BIOS' were not
supplying ACPI MCFG tables.  This was long enough ago that I expect we
are well past those issues with new systems today.  MCFG, _CBA, and
_CRS are again architectural agnostic ways to get MMCONFIG and
resource (I/O Port, and MMIO) information.  With respect to (2) and
(3) we were in a similar situation with Intel based systems and for a
brief period of time had 'intel_bus.c'.  We were encountering the same
"perennial maintenance headache" issues with 'intel_bus.c' and finally
with Bjorn's efforts in implementing _CRS as the default for platforms
with BIOS >= 2008 [2] we were able to obviate 'intel_bus.c' completely
- something we should be similarly striving for here with amd_bus.c.

(4) is a little more interesting.  It seems to be related to Xen, non
MMIO based ECS enabled platforms, and IBS.  Xen has indicated that
they can "decide whether to add the code to the hypervisor instead or
- just like on Intel systems - rely on MCFG being properly
exposed by the firmware." [3].  Again, I expect we are past the early
implementations of platforms that don't have MMIO based ECS enabled.
That leaves IBS which I'm completely unfamiliar with [4].

With the possible exception of (4), there should be ACPI based
architectural agnostic ways to get the information being discussed
here.  MCFG, _CBA, and _CRS are mature and provide solutions to (2)
and (3).  There are platforms in the field, the vast majority
actually, that still do not implement _PXM methods corresponding to
hostbridges (1).  Patch 1 of this series provides a fall-back for that
situation for AMD based platforms only; albeit a solution with
problems itself as expressed above.  For (1), the proper solution is
to get platform BIOS' to implement _PXM methods.

As a result, it seems like we should be pursuing an avenue to move us
out of the current "perennial maintenance headache" design that
amd_bus.c presents.  As such, I'm going to start working on an
additional patch to this series that only runs 'amd_postcore_init()'
for BIOS dates < 2015.

[1] https://lkml.org/lkml/2014/3/17/390
[2] Kernel commit 7bc5e3f  "x86/PCI: use host bridge _CRS info by
default on 2008 and newer machines"
[3] https://lkml.org/lkml/2014/4/29/66
[4]  https://lkml.org/lkml/2014/4/30/153 - "ECS would work there
out-of-the-box (at least after the system brought pci up, ibs is
initialized after pci setup)."

Myron


>
> -Robert
