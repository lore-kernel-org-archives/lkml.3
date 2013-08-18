Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755405Ab3HRIij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 04:38:39 -0400
Received: from mail-vb0-f45.google.com ([209.85.212.45]:34524 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576Ab3HRIih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 04:38:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130816132326.GC2909@localhost.localdomain>
References: <1376360992-1508-1-git-send-email-acourbot@nvidia.com>
 <1376360992-1508-2-git-send-email-acourbot@nvidia.com> <20130815115227.GC2562@localhost.localdomain>
 <520D500C.5070901@wwwdotorg.org> <20130816132326.GC2909@localhost.localdomain>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sun, 18 Aug 2013 17:38:16 +0900
Message-ID: <CAAVeFuK612z6sYYBQNrbV=x3_Uy91qqusW4G+=yNVg4tMbV2Kg@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] ARM: add basic Trusted Foundations support
To: Dave Martin <Dave.Martin@arm.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Joseph Lo <josephl@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 10:23 PM, Dave Martin <Dave.Martin@arm.com> wrote:
> On Thu, Aug 15, 2013 at 04:02:52PM -0600, Stephen Warren wrote:
>> On 08/15/2013 05:52 AM, Dave Martin wrote:
>> > On Tue, Aug 13, 2013 at 11:29:48AM +0900, Alexandre Courbot wrote:
>> >> Trusted Foundations is a TrustZone-based secure monitor for ARM that
>> >> can be invoked  using a consistent smc-based API on all supported
>> >> platforms. This patch adds initial basic support for Trusted
>> >> Foundations using the ARM firmware API. Current features are limited
>> >> to the ability to boot secondary processors.
>>
>> >> diff --git a/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt b/Documentation/devicetree/bindings/arm/firmware/tl,trusted-foundations.txt
>>
>> >> +Required properties:
>> >> +- compatible : "tl,trusted-foundations"
>> >> +- version : Must contain the version number string of the Trusted Foundation
>> >> +  firmware.
>> >
>> > Are you sure there is no low-level way to probe vendor and version info?
>> > If there is, then the DT should describe nothing except the fact that
>> > the probe interface exists.
>> >
>> > I also worry that two integrations on different SoCs might have the
>> > same version number, yet still be different due to vendor-specific
>> > features and options.
>>
>> I would expect HW-specific compatible values also to be present in a DT.
>> For example, perhaps:
>>
>> compatible = "tl,trusted-foundations-nvidia-shield",
>> "tl,trusted-foundations";
>>
>> (nvidia vendor, shield board/implementation)
>>
>> This would allow matching on the specific value
>> "tl,trusted-foundations-nvidia-shield" in the future if some quirking
>> was needed, but if this wasn't needed, drivers could just bind to the
>> generic "tl,trusted-foundations".
>
> That seems reasonable *unless* there is a reliable way to obtain
> a vendor ID from the SMC ABI directly, in which case we should just
> use that.
>
> One could debate whether the extra compatible string should have
> "nvidia," or "tl," but the fact that "nvidia" is in the name at all
> pretty much narrows it down.
>
>>
>> >> +- version : Must contain the version number string of the Trusted Foundation
>> >> +  firmware.
>> >
>> > Are you sure there is no low-level way to probe vendor and version info?
>> > If there is, then the DT should describe nothing except the fact that
>> > the probe interface exists.
>> >
>> > I also worry that two integrations on different SoCs might have the
>> > same version number, yet still be different due to vendor-specific
>> > features and options.
>>
>> Talking of the version - if we do need to represent this in the DT, how
>> about 2 separate cells for major/minor version rather than encoding it
>> into a string? Then, no parsing would be required.
>
> I think the key thing here is to match whatever TF's native notion of
> version is.
>
> If it's truly a string with specific comparison rules, we should leave it
> a string and write code to examine it.  If it's a simple <major minor>
> pair, then putting it in the DT in this form makes sense.

TF's native version is this major/minor pair, and indeed it should be
sensible and harmless to turn it into a pair of cells.

Then there are other components that can be added to build a more
precise "version string". You can have a look at this file to see how
this is done:

http://nv-tegra.nvidia.com/gitweb/?p=linux-2.6.git;a=blob;f=security/tf_driver/s_version.h;h=d75c5f35d32d597b664c9533b1c5a52696e81b49;hb=rel-roth-ota-1

The version string I used to far is the S_VERSION_MAIN macro, since it
is the only one that seems to be platform-independant.
S_VERSION_PLATFORM and S_VERSION_OS can be used to indentify if
Android is used and which version. Then all these strings (plus a few
others) are concatenated to build S_VERSION_STRING which is the
ultimate version, but also considerably more complicated to handle.

At the current level of support, I don't think it makes sense to look
further than S_VERSION_MAIN for the moment. If we switch it to a pair
of integer cells as Stephen suggested, nothing prevents us to extend
the bindings with other properties (for instance version-platform and
version-os) if they become necessary. But at the moment I don't think
it makes sense to overthink versions beyond the main version number,
especially if it can be extended safely if needed in the future.

Thanks,
Alex.
