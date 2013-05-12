Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab3ELNco (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 09:32:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51561 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab3ELNcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 09:32:42 -0400
MIME-Version: 1.0
In-Reply-To: <s5hy5bkwto0.wl%tiwai@suse.de>
References: <1367996197-32748-1-git-send-email-tiwai@suse.de>
	<1367996197-32748-2-git-send-email-tiwai@suse.de>
	<CACVXFVM2ZFYeJND7nxGhyGU7cG08Hta5qBZMAz+rDhxM1kRWZA@mail.gmail.com>
	<s5hd2t1wih4.wl%tiwai@suse.de>
	<s5h38txwhqq.wl%tiwai@suse.de>
	<s5hsj1xxsv2.wl%tiwai@suse.de>
	<CACVXFVPH1W8ogaus49WNyU17xcbbZ=_2F2FD4Yv_DJcdDov8EQ@mail.gmail.com>
	<s5hmws4y5h7.wl%tiwai@suse.de>
	<CACVXFVPRLiP3wFL6CZbKxS73JRDybtig83vhjQ6q-yoM8uLPyg@mail.gmail.com>
	<s5hd2t0xexl.wl%tiwai@suse.de>
	<CACVXFVMEif3gqkQxzae+ooYofD8pcuJzpgz6gY3Mexch0jpbmA@mail.gmail.com>
	<s5hobcjuqmy.wl%tiwai@suse.de>
	<CACVXFVPo7ED5fo1+FT=ibM_HvB2h1Vc7P2e+C_LHGw-BQ9e-tA@mail.gmail.com>
	<s5hy5bkwto0.wl%tiwai@suse.de>
Date: Sun, 12 May 2013 21:32:39 +0800
Message-ID: <CACVXFVOrVFKmB747oYhT1LTPS0AONioSaAvCKSogm9-KYcZrKA@mail.gmail.com>
Subject: Re: [PATCH 1/3] firmware: Avoid superfluous usermodehelper lock
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 12, 2013 at 3:20 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Sat, 11 May 2013 21:01:27 +0800,
> Ming Lei wrote:
>>
>> On Fri, May 10, 2013 at 5:32 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Fri, 10 May 2013 09:25:51 +0800,
>> >>
>> >> Anyway, if you want to force killing loader, please only kill these
>> >> FW_ACTION_NOHOTPLUG before suspend and reboot, and do
>> >> not touch FW_ACTION_HOTPLUG. Is it OK for you?
>> >
>> > Note that, as with my patch, only the shutdown case is handled.  Let's
>> > not mixing up suspend and shutdown behavior for now.
>> >
>> > I see no reason why we need to wait at shutdown even for
>> > FW_ACTION_HOTPLUG.  At that point, there should be no longer
>> > user-space action.  It means that the driver shouldn't get any more
>> > data to finish the f/w loading upon that point.  Thus the only
>>
>> For example, when one ethernet driver is requesting its firmware,
>> the loader is forced to be killed before shutdown, so the driver can't set the
>> WoL any more in its shutdown(), then users start to complain it is a
>> regression.
>
> First off, this can't happen because, as mentioned earlier, the point
> we're discussing is already the moment after user-space is supposed to
> have been finished by init, i.e. there is already no udev.  Thus the

OK, sorry for missing the fact which user-space application may have
been killed before calling sys_reboot(), even though the fact depends on
implementation of user space 'reboot'.

> pending f/w request via usermode helper can never finish.  So, it
> makes no sense to wait for any user-space action at that point.  It
> just locks up.
>
> Secondly, if this would ever work, it's still just a luck.  The
> protection is only about the usermode helper lock in the f/w loading
> code.  This doesn't mean that the whole pending driver work would be
> finished.  In other words, such a driver design is just broken.

A well-implemented driver should make sure the synchronization,
looks it isn't related with firmware loading.

>
>> That is why I suggest you to only kill requests of FW_ACTION_NOHOTPLUG.
>>
>> Also it isn't good to affect all drivers just for fixing two insane drivers.
>>
>> > possible consequence is the timeout, which is equivalent with the
>> > immediate abort of the operation.
>> >
>> > As mentioned earlier, the suspend behavior may be different.  We want
>> > to retry the f/w load.  Ideally, the f/w loader should abort and
>> > automatically retry after resume.  In this case, also there is no big
>>
>> I don't think it is good idea since suspend() may need firmware to
>> change the device's power state. Considered that only two insane
>> drivers use FW_ACTION_NOHOTPLUG, we can kill the two before
>> suspend just like the case of shutdown.
>
> The same argument can be applied.  The protection in f/w loading
> doesn't guarantee that the pending driver action will be finished

The driver itself can make sure any synchronization it needed.(
probe vs. suspend, or open vs. suspend), and nothing to do with
request_firmware().

> before suspend.  It protects only the udev reaction.  But, it doesn't
> protect the action after it.

Also suspend is different with shutdown since usermodehelper lock
is required to be held before freezing processes, so firmware loading
should be completed before suspending.

>
>> > reason to distinguish FW_ACTION_* types.  Even for udev case, the
>> > action can be easily retried.
>> >
>> > Or, a cleaner solution would be to get rid of FW_ACTION_NOHOTPLUG
>> > completely.  As Kay mentioned, this was a big mistake from the very
>>
>> It is still not a good idea, hackers may need FW_ACTION_NOHOTPLUG
>> to debug its driver with private firmwares, or examples like dell's BIOS update.
>
> Oh no, it's a badly designed interface.  It should be never used.

Yes, it is bad, but killing FW_ACTION_NOHOTPLUG may break dell's BIOS
update utility, also how can we meet the demand of drivers which need private
firmwares?

Thanks,
--
Ming Lei
