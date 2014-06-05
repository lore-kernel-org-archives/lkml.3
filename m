Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915AbaFEOYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:24:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58007 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428AbaFEOYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:24:53 -0400
MIME-Version: 1.0
In-Reply-To: <s5hbnu71mf1.wl%tiwai@suse.de>
References: <1401896895-14262-1-git-send-email-tiwai@suse.de>
	<CACVXFVPpmdXJV2CC-U=bsA820VD42i2-OqBfNfTPPaMergu8TQ@mail.gmail.com>
	<CAG-2HqU=LAXr0o2e9RRCmrX1eWouhepEZHaPfBjrs64xUeb=gw@mail.gmail.com>
	<CACVXFVP1uS7szLqvabtMbiaUgd13bWoYXv5q-Az7wBia=ogf7Q@mail.gmail.com>
	<s5hfvjj1n90.wl%tiwai@suse.de>
	<CACVXFVP5CSNoyThAcsmihYg_bkq2wn1JtiFJ_7ehpxwjBSaZxQ@mail.gmail.com>
	<s5hbnu71mf1.wl%tiwai@suse.de>
Date: Thu, 5 Jun 2014 22:24:50 +0800
Message-ID: <CACVXFVPWq93u5KmLhr+g23t4AiGAnLfd+hX3viajzR_KN+sMrw@mail.gmail.com>
Subject: Re: [PATCH v2] firmware loader: allow disabling of udev as firmware loader
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Tom Gundersen <teg@jklm.no>, LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Stefan Roese <sr@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Abhay Salunke <Abhay_Salunke@dell.com>,
        Kay Sievers <kay@vrfy.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 10:05 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 5 Jun 2014 21:59:52 +0800,
> Ming Lei wrote:
>>
>> On Thu, Jun 5, 2014 at 9:47 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Thu, 5 Jun 2014 21:31:56 +0800,
>> > Ming Lei wrote:
>> >>
>> >> On Thu, Jun 5, 2014 at 8:25 PM, Tom Gundersen <teg@jklm.no> wrote:
>> >> >
>> >> > On 5 Jun 2014 14:18, "Ming Lei" <ming.lei@canonical.com> wrote:
>> >> >>
>> >> >> On Wed, Jun 4, 2014 at 11:48 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> >> >> > [The patch was originally proposed by Tom Gundersen, and rewritten
>> >> >> >  afterwards by me; most of changelogs below borrowed from Tom's
>> >> >> >  original patch -- tiwai]
>> >> >> >
>> >> >> > Currently (at least) the dell-rbu driver selects FW_LOADER_USER_HELPER,
>> >> >> > which means that distros can't really stop loading firmware through
>> >> >> > udev without breaking other users (though some have).
>> >> >> >
>> >> >> > Ideally we would remove/disable the udev firmware helper in both the
>> >> >> > kernel and in udev, but if we were to disable it in udev and not the
>> >> >> > kernel, the result would be (seemingly) hung kernels as no one would
>> >> >> > be around to cancel firmware requests.
>> >> >> >
>> >> >> > This patch allows udev firmware loading to be disabled while still
>> >> >> > allowing non-udev firmware loading, as done by the dell-rbu driver, to
>> >> >> > continue working. This is achieved by only using the fallback
>> >> >> > mechanism when the uevent is suppressed.
>> >> >> >
>> >> >> > The patch renames the user-selectable Kconfig from FW_LOADER_USER_HELPER
>> >> >> > to FW_LOADER_USER_HELPER_FALLBACK, and the former is reverse-selected
>> >> >> > by the latter or the drivers that need userhelper like dell-rbu.
>> >> >> >
>> >> >> > Also, the "default y" is removed together with this change, since it's
>> >> >> > been deprecated in udev upstream, thus rather better to disable it
>> >> >> > nowadays.
>> >> >> >
>> >> >> > Tested with
>> >> >> >     FW_LOADER_USER_HELPER=n
>> >> >> >     LATTICE_ECP3_CONFIG=y
>> >> >> >     DELL_RBU=y
>> >> >> > and udev without the firmware loading support, but I don't have the
>> >> >> > hardware to test the lattice/dell drivers, so additional testing would
>> >> >> > be appreciated.
>> >> >> >
>> >> >> > Reviewed-by: Tom Gundersen <teg@jklm.no>
>> >> >> > Cc: Ming Lei <ming.lei@canonical.com>
>> >> >> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> >> >> > Cc: Abhay Salunke <Abhay_Salunke@dell.com>
>> >> >> > Cc: Stefan Roese <sr@denx.de>
>> >> >> > Cc: Arnd Bergmann <arnd@arndb.de>
>> >> >> > Cc: Kay Sievers <kay@vrfy.org>
>> >> >> > Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> >> >> > ---
>> >> >> >  drivers/base/Kconfig          | 10 ++++++++--
>> >> >> >  drivers/base/firmware_class.c | 15 ++++++++++-----
>> >> >> >  include/linux/firmware.h      |  2 +-
>> >> >> >  3 files changed, 19 insertions(+), 8 deletions(-)
>> >> >> >
>> >> >> > diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
>> >> >> > index 8fa8deab6449..d0bb32e4c416 100644
>> >> >> > --- a/drivers/base/Kconfig
>> >> >> > +++ b/drivers/base/Kconfig
>> >> >> > @@ -144,15 +144,21 @@ config EXTRA_FIRMWARE_DIR
>> >> >> >           some other directory containing the firmware files.
>> >> >> >
>> >> >> >  config FW_LOADER_USER_HELPER
>> >> >> > +       bool
>> >> >> > +
>> >> >> > +config FW_LOADER_USER_HELPER_FALLBACK
>> >> >> >         bool "Fallback user-helper invocation for firmware loading"
>> >> >> >         depends on FW_LOADER
>> >> >> > -       default y
>> >> >> > +       select FW_LOADER_USER_HELPER
>> >> >> >         help
>> >> >> >           This option enables / disables the invocation of user-helper
>> >> >> >           (e.g. udev) for loading firmware files as a fallback after the
>> >> >> >           direct file loading in kernel fails.  The user-mode helper is
>> >> >> >           no longer required unless you have a special firmware file
>> >> >> > that
>> >> >> > -         resides in a non-standard path.
>> >> >> > +         resides in a non-standard path. Moreover, the udev support has
>> >> >> > +         been deprecated upstream.
>> >> >> > +
>> >> >> > +         If you are unsure about this, say N here.
>> >> >>
>> >> >> It may be safer to say Y here for fallback if not sure.
>> >> >
>> >> > Saying Y here will be actively harmful if the firmware loader is disabled in
>> >> > udev (which I guess most distros will do as soon as they can), so I think we
>> >>
>> >> If fallback is triggered, it means that the firmware can't be found
>> >> in default direct rootfs path, so it is better to continue to look for it
>> >> from userspace.
>> >>
>> >> Also it won't a big problem for hanging the request user context
>> >> for some while(60sec at default) if udev is disabled, will it?
>> >>
>> >> BTW, are you sure most distros will do that in the near future?
>> >>
>> >> > should advice people to say N unless they really know what they are doing
>> >> > and that their userspace can cope with it.
>> >>
>> >> That is why I suggest to say Y if someone isn't sure.
>> >
>> > For the time being, having default this Y causes more troubles.
>>
>> I am wondering why default Y may cause more troubles, as we
>> know, it has been default Y for long long time.
>
> More trouble = more bug reports.  At least, a handful distros suffer.
> I don't know the situation with Ubuntu, though.

Looks recently not see related report, :-)

>> It only falls back if the request fw is _not_ found from direct loading,
>> so it is reasonable to try to continue to look for it from user space.

> Some drivers fall back to different firmware (e.g. different revision
> suffix) if the requested file isn't found.  So, this happens in
> reality.

So do you think the fallback is better or worse? For CPU microcode
case, maybe it is fine, but for other devices, maybe it is better to
get a firmware for working at least.



Thanks,
--
Ming Lei
