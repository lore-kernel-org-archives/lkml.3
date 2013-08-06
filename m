Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab3HFW6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 18:58:04 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:55055 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab3HFW6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 18:58:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMiq4M-8=CUsKf3bxBnxxiBQMEPc11K8pDePZnzHkv9QTA@mail.gmail.com>
References: <20130731141841.GP5882@titan.lakedaemon.net>
	<20130802083346.GC7656@atomide.com>
	<CAGFynZ-V6CUFXh+iC8M7spwHn3gma6gYgRFBaoAXRYtw1fbgHA@mail.gmail.com>
	<CAOesGMiq4M-8=CUsKf3bxBnxxiBQMEPc11K8pDePZnzHkv9QTA@mail.gmail.com>
Date: Tue, 6 Aug 2013 15:57:59 -0700
Message-ID: <CAGFynZ89h=+teygKAnMepR5Ot5Qf1yjRdRkPSnMfz8BeJmuThQ@mail.gmail.com>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] arch/arm SoC organization
From: Christian Daudt <csd_b@daudt.org>
To: Olof Johansson <olof@lixom.net>
Cc: Tony Lindgren <tony@atomide.com>, Jason Cooper <jason@lakedaemon.net>,
        devicetree@vger.kernel.org,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 10:24 PM, Olof Johansson <olof@lixom.net> wrote:
> On Fri, Aug 2, 2013 at 4:06 PM, Christian Daudt <csd_b@daudt.org> wrote:
>> On Fri, Aug 2, 2013 at 1:33 AM, Tony Lindgren <tony@atomide.com> wrote:
>>> * Jason Cooper <jason@lakedaemon.net> [130731 07:25]:
>>>> So, I'd like to propose we discuss some lessons learned and maybe arrive
>>>> at some best practices.  eg, should we just go with mach-$COMPANY/?  How
>>>> best to handle config symbols for efficient building?  Deprecation path
>>>> for legacy (unconverted) boards?
>>>
>>> A lot of that problem goes away by initializing everything as late
>>> as possible, and making things to live under drivers.
>> One category of items that we haven't found a good place for in this
>> new multiplatform world is where does dt-driven non-driver code reside
>> ? e.g. we have a secure monitor access function that only kicks in if
>> the appropriate dt entry is available . It currently resides in
>> mach-bcm/bcm_kona_smc.c as it seems like the only location for it at
>> the moment, but that doesn't seem like the best place because (a)
>> mach-bcm might end up littered with one-of cases like this and (b)
>> anything in mach-bcm is not visible to arm64 SoCs, and some of those
>> in the future will need to share with their arm32 cousins.
>
> ARM is working on standardizing some of these interfaces through
> things like PSCI. It should take care of _some_ of the SMC needs. I
> know you're already shipping some of these platforms though and
> firmware interfaces might be locked in to something that's not
> PSCI-compatible. :(
>
Agreed, but that is in the future. Most ARMv7 platforms will likely
never see PSCI and they still need to talk to their secure half. Even
when PSCI code gets into mainline, where will it sit ?

>>  But putting in drivers (e.g. drivers/smc) seems like the wrong thing
>> to do also because this is not a driver.
>
> I really don't think we need to migrate everything to drivers/*. At
> some point the need of exorcising code out of arch/arm will reach a
> plateu, and there's some code that just simply belongs in that sub
> directory.
>
Ok, that's why I'm trying to determine. How low do we want to go with
the thinning of mach-* dirs.

> The sharing with arm64 is the obvious sticky point, since the base
> directories aren't the same. Luckily not too many vendors have shipped
> arm64 platforms, and nobody is shipping in volume yet, so there's a
> little time to sort out some of this.
>
>>  We have a couple of other smallish pieces of IP that just need a bit
>> of generic init code to keep them happy, which we were discussing
>> internally where to best land them. At present they are also headed to
>> mach-bcm.
>
> I think the 3.12 merge window will see the introduction of
> drivers/platform/arm. It must not become a dumping ground for
> board-file equivalent code though, so I am a little scared to
> introduce it. Mostly it should contain whatever glue code isn't
> possible or practical to describe with device tree (or ACPI) today,
> and in particular for established consumer devices, i.e. for actual
> product needs. Compare to what's in drivers/platform/x86 to get a feel
> for what we're talking about.
>
So putting things in drivers/platform solves the a32/a64 sharing
problem at least. So it's a positive step.

>>  Ultimately the question is 'what is allowed to reside in mach-<misc>
>> ?' And by extension: 'is there a good home for everything else ?''
>
> Right, and see above about some of my opinions on the matter. arm64
> does complicate things quite a bit since it's no longer easy to share
> code between the architectures.
>
> Having a few concise examples of what code you're looking for a home
> for could be useful for the discussion though. Would you mind
> volunteering a few? :)
Other than the already upstreamed SMC code, this again came up in the
context of a dma mux block that we have. The code needs to do static
configuration of the block @ bringup and then there's nothing else for
it to do. We're trying to figure out where the best place for it is.
Options being:
 a) write a couple of functions in arch/arm/mach-bcm/<filename>.c
which based on dt config do the necessary setup
 b) write those same functions with a bit of driver wrapper to make it
pretend to be a driver (i.e. add a probe/remove) and plunk it into
drivers/dma/<filename>.c
 c) ?


 Thanks,
   csd
