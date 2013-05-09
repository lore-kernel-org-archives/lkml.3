Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718Ab3EIIne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 04:43:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57479 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab3EIInb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 04:43:31 -0400
MIME-Version: 1.0
In-Reply-To: <s5hmws4y5h7.wl%tiwai@suse.de>
References: <1367996197-32748-1-git-send-email-tiwai@suse.de>
	<1367996197-32748-2-git-send-email-tiwai@suse.de>
	<CACVXFVM2ZFYeJND7nxGhyGU7cG08Hta5qBZMAz+rDhxM1kRWZA@mail.gmail.com>
	<s5hd2t1wih4.wl%tiwai@suse.de>
	<s5h38txwhqq.wl%tiwai@suse.de>
	<s5hsj1xxsv2.wl%tiwai@suse.de>
	<CACVXFVPH1W8ogaus49WNyU17xcbbZ=_2F2FD4Yv_DJcdDov8EQ@mail.gmail.com>
	<s5hmws4y5h7.wl%tiwai@suse.de>
Date: Thu, 9 May 2013 16:43:28 +0800
Message-ID: <CACVXFVPRLiP3wFL6CZbKxS73JRDybtig83vhjQ6q-yoM8uLPyg@mail.gmail.com>
Subject: Re: [PATCH 1/3] firmware: Avoid superfluous usermodehelper lock
From: Ming Lei <ming.lei@canonical.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 9, 2013 at 3:31 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Thu, 9 May 2013 09:25:35 +0800,
> Ming Lei wrote:
>>
>> On Thu, May 9, 2013 at 1:51 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> >> In other words, the first patch is no essential part of the fix.
>> >> I can revisit the second patch without this one and resend if
>> >> preferred.
>> >
>> > FWIW, below is the revised patch.
>> > It's alone without the patch 1 in the previous series.
>>
>> The root cause is that your user space loader doesn't follow the
>> current firmware loader interface.
>
> There is not necessarily a user space "loader".  It's declared as
> non-hotplug, thus it can be a manual operation by human.
>
>> IMO, the patch is unnecessary since we already have the timeout
>> abort(just need one patch to enable it for nowait api)
>
> Well, you cannot know any sane value for such human's operation.
> If it's a system response, then we can assume something.  But the
> invocation of request_firmware_nowait() with non-hotplug means that
> you can never know the actual use case, thus you cannot know any sane

I think the use case should be driver specific, and the loading is triggered
from user space in dell_rbu(write sysfs file to trigger BIOS update), so the
user has been ready for loading the image.

For another usage(lattice-ecp3-config.c), it is merged recently and very
specific(maybe only for personal use), and can be easily to change to
trigger loading from user space like dell.

I think both the two usages choose FW_ACTION_NOHOTPLUG
because they have out of tree firmware images.  So looks enabling
timeout won't be a big deal for them.

> timeout, too.
>
> And secondly, I don't think it's good to rely on the timeout.  Why
> does the system have to wait for minute for shutdown?  The system is

It won't if the user space follows the rules.

> in shutdown, and it's triggered by user.  It's more natural to abort
> the pending f/w loading because you don't want to handle it any
> longer after the system shuts down.

There is still risk to force killing the loader before shutdown or
suspend.  Maybe some devices depend its firmware in shutdown
or suspend callback to configure power setting.

Thanks,
--
Ming Lei
