Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbbAFOoF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:44:05 -0500
Received: from mail-oi0-f42.google.com ([209.85.218.42]:55099 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbbAFOoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:44:03 -0500
MIME-Version: 1.0
In-Reply-To: <20150106143729.GN31830@ulmo.nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
	<1419331204-26679-10-git-send-email-vinceh@nvidia.com>
	<54A20F4D.4040100@gmail.com>
	<54A2198A.4000707@nvidia.com>
	<20150105153252.GI12010@ulmo.nvidia.com>
	<CAAVeFuK-SgUbtHADX4-pXN5_ayzvEd+1KxJOBcRe2tmDfHaLEA@mail.gmail.com>
	<20150106114953.GD31830@ulmo.nvidia.com>
	<54ABD49A.6080501@nvidia.com>
	<20150106143729.GN31830@ulmo.nvidia.com>
Date: Tue, 6 Jan 2015 09:44:01 -0500
X-Google-Sender-Auth: FFNgpRFbK85j5bccLUJUgdNp_sU
Message-ID: <CAKb7UvgomyQkiwfGTdyuU-muE-_pPxOSmeXh9uQ6-ri0HHxLrQ@mail.gmail.com>
Subject: Re: [Nouveau] [PATCH nouveau 09/11] drm: export some variable and
 functions to resue the PM functions
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Vince Hsu <vinceh@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Roy Spliet <seven@nimrod-online.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 6, 2015 at 9:37 AM, Thierry Reding <thierry.reding@gmail.com> wrote:
> On Tue, Jan 06, 2015 at 08:27:06PM +0800, Vince Hsu wrote:
>>
>> On 01/06/2015 07:49 PM, Thierry Reding wrote:
>> >* PGP Signed by an unknown key
>> >
>> >On Mon, Jan 05, 2015 at 08:50:18PM +0100, Alexandre Courbot wrote:
>> >>On Mon, Jan 5, 2015 at 4:32 PM, Thierry Reding <thierry.reding@gmail.com> wrote:
>> >>>On Tue, Dec 30, 2014 at 11:18:34AM +0800, Vince Hsu wrote:
>> >>>>Hi Emil,
>> >>>>
>> >>>>On 12/30/2014 10:34 AM, Emil Velikov wrote:
>> >>>>>On 23/12/14 10:40, Vince Hsu wrote:
>> >>>>>>This patch adds some checks in the suspend/resume functions to distinguish
>> >>>>>>the dGPU and mobile GPU and exports some variables/functions so that the
>> >>>>>>nouveau platform device can reuse them.
>> >>>>>>
>> >>>>>Hi Vince,
>> >>>>>
>> >>>>>Afaiu one needs to export a symbol as it's used by another module or
>> >>>>>subsystem. With the follow up two patches you are not doing either one,
>> >>>>>so I'd assume that you can just omit the EXPORT_* changes.
>> >>>>The nouveau platform device driver is built as another module -
>> >>>>nouveau_platform.ko. :)
>> >>>I'd like to hear the opinion of the nouveau people and Alex, but I'd
>> >>>very much prefer if nouveau_platform.o was simply linked into the
>> >>>nouveau.ko module. I don't see any good reason to keep it separate.
>> >>Yep, I agree. The decision to host platform support in a separate
>> >>module looks misleaded if it results in additional exports that we
>> >>would otherwise avoid. IIUC I did this to be able to use the module
>> >>convenience macros to register the platform driver.
>> >>
>> >>>Something like the attached patch (untested) ought to do it.
>> >>This patch alone won't be enough for the reason I mentioned above.
>> >>However, if Vince doesn't mind handling the platform driver
>> >>registration manually in nouveau_drm_init/nouveau_drm_exit, I agree
>> >>this would be the way to go.
>> >If we do the conversion to generic power domains, the only Tegra-
>> >specific API remaining will be the access to the fuse registers for the
>> >speedo value. At that point we wouldn't need the ARCH_TEGRA dependency
>> >any longer and could always build the platform driver along with the PCI
>> >driver.
>> Do we really want the platform driver always built with the PCI driver even
>> there is no dependency between them. Actually I have some patches to
>> build the platform driver with !CONFIG_PCI and would like to post them maybe
>> later.
>
> I do see some advantage in making Nouveau build with !CONFIG_PCI because
> it allows building the driver for an SoC without PCI. But I think always
> compiling whatever is available won't hurt. Nouveau itself is rather big
> (~1 MiB of text and ~120 KiB of data) whereas the platform code weighs
> in at around 1.5 KiB of text and 108 B of data. I suspect that the PCI
> glue is equally negligible.

The much bigger reductions in size would be from getting rid of all
the stuff that's not used at all on a GK20A, like all the firmware,
and a whole bunch of logic. I had a series that split things up into
nv04/nv50/nvc0 categories. I believe it was considered undesirable due
to increased build complexity. (It wasn't a nice modularized
separation but rather just a compile-time setting.) Shouldn't be too
hard to regenerate though.

  -ilia
