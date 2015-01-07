Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbbAGT7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 14:59:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbbAGT7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 14:59:53 -0500
Message-ID: <54AD8FF2.60407@redhat.com>
Date: Wed, 07 Jan 2015 14:58:42 -0500
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>, Mark Brown <broonie@kernel.org>
CC: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robh@kernel.org>, Randy Dunlap <rdunlap@infradead.org>,
        Robert Richter <rric@kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Robert Moore <robert.moore@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lv Zheng <lv.zheng@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [Linaro-acpi] [PATCH v5 18/18] Documentation: ACPI for ARM64
References: <1413553034-20956-1-git-send-email-hanjun.guo@linaro.org> <2161376.07iV9ANMSk@wuerfel> <20150107115039.GA2199@e104818-lin.cambridge.arm.com> <1520439.Y1rXzXY1eS@wuerfel> <20150107172741.GY2634@sirena.org.uk> <20150107184158.GO24989@titan.lakedaemon.net>
In-Reply-To: <20150107184158.GO24989@titan.lakedaemon.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2015 01:41 PM, Jason Cooper wrote:
> On Wed, Jan 07, 2015 at 05:27:41PM +0000, Mark Brown wrote:
>> On Wed, Jan 07, 2015 at 02:06:28PM +0100, Arnd Bergmann wrote:
>>> On Wednesday 07 January 2015 11:50:39 Catalin Marinas wrote:
>>
>>>> From what I gathered so far, the main reason for _some_ vendors is not
>>>> support for "other" OS but actually features that ACPI has and DT
>>>> doesn't (like AML; I deliberately ignore statements like "industry
>>>> standard"). _If_ such reasons are sound, maybe they have a case for
>>>> ACPI-only machines targeted primarily at Linux.
>>
>>> What I got from the replies from HP, Huawei and from earlier discussions
>>> with Jon is that they all hope to get to the point of relying on AML
>>> alone to bridge the differences between SoC families. However, I don't
>>> see that happening with the limited hardware compatibility that the
>>> existing SBSA provides:
>>
>> I tend to agree with you that it's an overreach to think that this is
>> going to completely abstract away the differences between SoCs from
>> different vendors without substantial further standardization work.
>> However it does seem reasonable to expect that features like AML are
>> going to be more successful in handling board differences and
>> incremental revisions of SoCs - things like interactions with system
>> power controllers for example.  That seems like a useful win in and of
>> itself, and one that's worth supporting.
> 
> This piqued my interest, so I did a little research and found the
> following to describe AML (second para under "What does this mean?")
> 
>   http://community.arm.com/groups/processors/blog/2014/05/01/let-s-talk-acpi-for-servers
> 
> iiuc, AML are basically drivers for some low-level functions provided as
> binary blobs via the ACPI tables.

AML isn't a "driver" per se. Think of it as providing a couple of
methods for doing things like turning on a device, where the interpreted
code might cause e.g. a memory address to be written with a value that
causes a side effect (e.g. talking with a system configuration
co-processor hidden inside the SoC the adjusts the clocking, enables
power, configures PHY parameters, etc.). Most of the "AML" that you see
on servers is actually just informational, or methods that return data
describing the hardware installed.

> How does this work in a trusted boot scenario?

No different than on x86.

> Can the ACPI tables, and these binary blobs with it, be updated from userspace?

Tables are baked into the firmware and are updated as a result of normal
firmware updates (which already has a defined process). There are
secondary tables that can augment things like the primary DSDT but those
are also provided by the platform. There are only two ways the "OS"
might provide a DSDT, but only including here for pedantry:

1). If you compile a kernel specially with an embedded DSDT within the
image itself (nobody does this one any more AFAIK).

2). If you attach a special update test DSDT into your initramfs in a
particular way, in which case I believe secure boot already is disabled.

But these are all developer/debug things, not intended for users running
in a secure boot environment.

> If so, is there an authentication mechanism (including for non-secure boot scenarios)?

It's no different than scenarios on x86, which are well covered.

> One of the reasons I've really enjoyed working with ARM platforms and DT
> is the absence of this type of 'feature'.  I honestly don't care whether
> the kernel gets the board configuration info from DT or ACPI or FOO, as
> long as we can avoid the security mistakes of the past:
> 
>   http://www.spiegel.de/international/world/catalog-reveals-nsa-has-back-doors-for-numerous-devices-a-940994.html

ACPI is not the great satan. I'm aware certain others in the community
have written missinformed blog posts and G+ rants equating ACPI with SMI
and even with various other system firmware. I can't force someone to
become informed on a topic, especially if it's politically useful to
them to hate on ACPI and use the security paranoia handwavy argument.

> I'm not advocating "throw out AML and ACPI with it!", rather I'd like to
> see a serious, open, discussion about the security implications of a
> convenience feature such as AML.

AML is in (almost) every server you're using today. What you want to be
worried about is hidden firmware, especially what might be running
inside a Trusted environment or inside an SMI context, or the radio
firmware on your phone that the NSA have backdoored. Once we've solved
every other issue, we can come back to whether the extremely limited
capabilities of AML are what the evil bad guys are using to infiltrate
our minds and make us think that we all want to use ACPI.

Jon.

