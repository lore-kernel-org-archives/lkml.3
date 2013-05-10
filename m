Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586Ab3EJBZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 21:25:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35482 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab3EJBZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 21:25:54 -0400
MIME-Version: 1.0
In-Reply-To: <s5hd2t0xexl.wl%tiwai@suse.de>
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
Date: Fri, 10 May 2013 09:25:51 +0800
Message-ID: <CACVXFVMEif3gqkQxzae+ooYofD8pcuJzpgz6gY3Mexch0jpbmA@mail.gmail.com>
Subject: Re: [PATCH 1/3] firmware: Avoid superfluous usermodehelper lock
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 1:04 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 9 May 2013 16:43:28 +0800,
> Ming Lei wrote:
>>
>> On Thu, May 9, 2013 at 3:31 PM, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Thu, 9 May 2013 09:25:35 +0800,
>> > Ming Lei wrote:
>> >>
>> >> On Thu, May 9, 2013 at 1:51 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> >> >> In other words, the first patch is no essential part of the fix.
>> >> >> I can revisit the second patch without this one and resend if
>> >> >> preferred.
>> >> >
>> >> > FWIW, below is the revised patch.
>> >> > It's alone without the patch 1 in the previous series.
>> >>
>> >> The root cause is that your user space loader doesn't follow the
>> >> current firmware loader interface.
>> >
>> > There is not necessarily a user space "loader".  It's declared as
>> > non-hotplug, thus it can be a manual operation by human.
>> >
>> >> IMO, the patch is unnecessary since we already have the timeout
>> >> abort(just need one patch to enable it for nowait api)
>> >
>> > Well, you cannot know any sane value for such human's operation.
>> > If it's a system response, then we can assume something.  But the
>> > invocation of request_firmware_nowait() with non-hotplug means that
>> > you can never know the actual use case, thus you cannot know any sane
>>
>> I think the use case should be driver specific, and the loading is triggered
>> from user space in dell_rbu(write sysfs file to trigger BIOS update), so the
>> user has been ready for loading the image.
>
> Yes, it's ready, but it doesn't guarantee that it's done in which time
> limit.  That's the uncertain point in such an interface.
>
> If it were hotplug via udev, we can assume some sane time limit.
> But in a scenario like the above, with the manual intervention, we
> can't know what is the sane value in a single manner.
>
>> For another usage(lattice-ecp3-config.c), it is merged recently and very
>> specific(maybe only for personal use), and can be easily to change to
>> trigger loading from user space like dell.
>>
>> I think both the two usages choose FW_ACTION_NOHOTPLUG
>> because they have out of tree firmware images.  So looks enabling
>> timeout won't be a big deal for them.
>
> Yeah, but it's a guess.
>
> So, in these use cases, the practical impact would be small, I agree.
> Changing this (adding a timeout unconditionally) eases the shutdown
> stall.  But I still feel this is no essential fix, and in general,
> changing the user-space behavior has to be done really carefully.

If there are lots of drivers which are using FW_ACTION_NOHOTPLUG,
I agree with you. But the fact is that only two, and both uses firmware
images which aren't shipped by distribution, so it isn't a big deal, is it?

>
>> > timeout, too.
>> >
>> > And secondly, I don't think it's good to rely on the timeout.  Why
>> > does the system have to wait for minute for shutdown?  The system is
>>
>> It won't if the user space follows the rules.
>
> Well... what rule?  The kernel shutdown must be blocked when user
> space doesn't write 0 or -1 to /sys/class/firmware/*/loading?

Yes.

> If you meant it, I would say that the rule is wrong.  There is no big

Why?  It has been here for ten years.

> reason to block the *kernel* shutdown by such an action.

The delay just shows that the user doesn't follow the rule.

>
> We're handling the moment where the system should be really shut down,
> already after all user-space things are synced and killed.  For
> example, would we delay the shutdown until all opened files are
> closed even at this point?  The kernel doesn't do so.

shutdown isn't unconditional, for example, page cache must be flushed
to disk.

>
>> > in shutdown, and it's triggered by user.  It's more natural to abort
>> > the pending f/w loading because you don't want to handle it any
>> > longer after the system shuts down.
>>
>> There is still risk to force killing the loader before shutdown or
>> suspend.  Maybe some devices depend its firmware in shutdown
>> or suspend callback to configure power setting.
>
> The firmware loading is never guaranteed to succeed.  If the abort of

Yes, but it is guaranteed that it will be ended in some time, and your
problem is nothing to do with success, just about timing.

> f/w loading at shutdown would cause any problem, it means that the
> driver is fundamentally buggy, and we must fix it inevitably anyway.
>
> Of course, the suspend is a bit different issue.  Maybe better to
> retry the load after resume instead of forcibly aborting.
> My point is that, if such critical kernel behavior like suspend or
> shutdown rely on a timeout of user actions, it's badly designed.

Anyway, if you want to force killing loader, please only kill these
FW_ACTION_NOHOTPLUG before suspend and reboot, and do
not touch FW_ACTION_HOTPLUG. Is it OK for you?

Thanks,
--
Ming Lei
