Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3KSOaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:30:06 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:56865 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab3KSOaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:30:02 -0500
MIME-Version: 1.0
In-Reply-To: <20131119122656.GF26487@arm.com>
References: <1384678169-28228-1-git-send-email-acourbot@nvidia.com>
 <CAHkRjk5LBOFx3ir49RgEsaFwvp5UCpTjYFWto+URXebAsOP0RA@mail.gmail.com>
 <52898417.80601@nvidia.com> <20131118115842.GE4050@arm.com>
 <528AD11F.7060009@nvidia.com> <20131119122656.GF26487@arm.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 19 Nov 2013 23:29:39 +0900
Message-ID: <CAAVeFuLkGGfUqVV88U44f1gN_3umD=PoTgHw241hLVLy4FRoLQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: move firmware_ops to drivers/firmware
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alex Courbot <acourbot@nvidia.com>, Russell King <linux@arm.linux.org.uk>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 9:26 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Tue, Nov 19, 2013 at 02:46:55AM +0000, Alex Courbot wrote:
>> On 11/18/2013 08:58 PM, Catalin Marinas wrote:
>> > On Mon, Nov 18, 2013 at 03:05:59AM +0000, Alex Courbot wrote:
>> >> On 11/18/2013 12:59 AM, Catalin Marinas wrote:
>> >>> On 17 November 2013 08:49, Alexandre Courbot <acourbot@nvidia.com> wrote:
>> >>>> The ARM tree includes a firmware_ops interface that is designed to
>> >>>> implement support for simple, TrustZone-based firmwares but could
>> >>>> also cover other use-cases. It has been suggested that this
>> >>>> interface might be useful to other architectures (e.g. arm64) and
>> >>>> that it should be moved out of arch/arm.
>> >>>
>> >>> NAK. I'm for code sharing with arm via common locations but this API
>> >>> goes against the ARMv8 firmware standardisation efforts like PSCI,
>> >>> encouraging each platform to define there own non-standard interface.
>> >>
>> >> I have to say, I pretty much agree with your NAK.
>> >>
>> >> The reason for this patch is that the suggestion to move firmware_ops
>> >> out of arch/arm is the last (I hope) thing that prevents my Trusted
>> >> Foundation support series from being merged.
>> >
>> > Moving it into drivers shouldn't be a workaround. Nice try ;).
>>
>> Hehe. I thought that just sending a patch would settle the issue one way
>> or the other and avoid a huge discussion. Woke up this morning to see
>> how wrong I was.
>
> It's a sensitive topic ;).
>
>> > BTW, is legacy code the reason for not converting the SMC # to PSCI?
>> > It's already supported on ARMv7, so you may not have much code left to
>> > merge in the kernel ;).
>>
>> The problem here is twofold:
>>
>> 1) we are just consumers of the TrustZone secure monitor who receive a
>> binary and do not have any control over its calling conventions. I agree
>> that it would be trivial to make it compatible with PSCI, but it's just
>> not something we can make by ourselves (TF does not even follow the SMC
>> calling convention). If this problem is to be addressed, it should be
>> done by forcing the TrustZone secure monitors providers to follow PSCI.
>
> I agree and such discussions do happen ('forcing' is a bit harder, more
> like 'strongly recommending'). On my side, I voice this message via the
> Linux channels, so SoC vendors can also encourage their secure provider
> in this direction. The benefit is that the Linux changes are minimal
> afterwards, single image is easier.
>
> But as I replied to Stephen, make sure you separate the secure OS (EL1)
> from the secure firmware (EL3). The latter (or parts of it) are provided
> by the SoC vendor (e.g. NVidia) and may be eventually linked into a big
> blob by the secure OS provider. ARM is encouraging separation here and a
> multi-stage firmware loading approach (and ARM started a public generic
> firmware project, it's in the early days now).

Will keep that in mind and check whether that could apply to future
devices, thanks.

>
>> 2) devices have already shipped with this firmware. Are we going to just
>> renounce supporting them, even though the necessary support is
>> lightweight and fits within already existing interfaces?
>
> I'm talking only about ARMv8 here. Please see my reply to Stephen for
> the details of (not) reusing existing firmware.
>
>> I certainly do hope that for ARMv8 things will be different and more
>> standardized. But that's not something that can be guaranteed unless ARM
>> strongly enforces it to firmware vendors. In case such a non-standard
>> firmware gets used again, I *do* hope that using cpu_ops will be
>> preferred over saying "this device cannot be supported in mainline, ever".
>
> cpu_ops or firmware_ops is just a name and can be unified (TBD what
> common functionality it contains). What I don't want to encourage is
> each SoC registering its own firmware interface.

Sorry, are you talking about interface as in SMC interface, or as in
cpu_operations/firmware_ops?

>
>> The kernel already supports non-standard hardware, BIOS, ACPI through
>> hacks that are *way* more horrible than that. This should certainly not
>> be encouraged, but that's not a valid reason to forbid otherwise
>> perfectly fine devices to run mainline IMHO.
>
> So you say we should just stop trying to standardise anything because
> people don't care anyway. Why do we even bother with DT (or ACPI) since
> board files were fine in the past (with a bit more code)?

Oh no, that's not what I am saying at all. Standardization is good.
PSCI is good. Of course I would prefer that the secure monitor we use
follow established conventions - that'd be less work to support it and
less hassle to get my patches merged.

I may have misunderstood you, but I felt your mail sounded a bit like
"we won't merge support for firmwares that do not follow PSCI". I
agree that whenever it is possible to support a firmware through a
standard interface, this should be done - no discussion. But right now
I have two devices that are good representatives of Tegra 4 and
available in stores, which I would like to see supported in mainline
to satisfy requests from the community for Tegra development
platforms, and also initiate the habit to support future
NVIDIA-branded devices in mainline. Their secure monitor unfortunately
does not follow PSCI or the SMC convention and needs a custom
firmware_ops. Are they unworthy of mainline?

And if, by sheer misfortune, the same thing happened on an ARMv8
device (despite the EL1/EL3 separation), what would be the outcome?

IMHO, more devices in mainline is beneficial to everybody, and
actually *encourages* SoC vendors/firmware providers to follow
conventions. Banning devices is what triggers the kind of "screw it"
reactions mentioned earlier, and on the contrary once a device is in,
you tend to make sure the next ones follow the kernel trends because
you know you will need to support them in mainline as well and it will
make your life easier.

>
>> >> * that should a need to move it (for whatever reason) occur later, it
>> >> will be easy to do (as this patch hopefully demonstrates).
>> >
>> > I agree, it's not hard to unify this but so far I haven't seen a good
>> > reason.
>>
>> Same here. arm64 has its own cpu_operations. Other archs have different
>> needs and if we move this to a common place it will just become a messy
>> placeholder for function pointers from which each arch will only use a
>> subset.
>
> That was my initial point but it turned into a thread against PSCI
> (again ;)).

Not at all, hurray for PSCI! :) But let the uncool devices get some
mainline love too!
