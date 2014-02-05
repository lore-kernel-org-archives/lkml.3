Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903AbaBEOTL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 09:19:11 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:53692 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750971AbaBEOTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 09:19:09 -0500
Message-ID: <52F24858.4020208@hurleysoftware.com>
Date: Wed, 05 Feb 2014 09:19:04 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: Hannes Reinecke <hare@suse.de>,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        Kay Sievers <kay@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [systemd-devel] [PATCH] tty: Set correct tty name in 'active'
 sysfs attribute
References: <1391595106-86957-1-git-send-email-hare@suse.de>	<CANq1E4QM-SwAhBmgGgmKjAHaKW-QZ7GPBkKyrv_=ek1CFmRWEw@mail.gmail.com>	<52F2424A.609@hurleysoftware.com> <CANq1E4Q6A1p4HXvx=ynRhAs+mmedz4tn+dQ9et_jb6SdPAgdsA@mail.gmail.com>
In-Reply-To: <CANq1E4Q6A1p4HXvx=ynRhAs+mmedz4tn+dQ9et_jb6SdPAgdsA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch won't get very far if not addressed to the actual maintainers

[ +cc Greg Kroah-Hartman, Jiri Slaby]

On 02/05/2014 09:05 AM, David Herrmann wrote:
> Hi
>
> On Wed, Feb 5, 2014 at 2:53 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
>> On 02/05/2014 07:53 AM, David Herrmann wrote:
>>>
>>> Hi
>>>
>>> On Wed, Feb 5, 2014 at 11:11 AM, Hannes Reinecke <hare@suse.de> wrote:
>>>>
>>>> The 'active' sysfs attribute should refer to the currently
>>>> active tty devices the console is running on, not the currently
>>>> active console.
>>>> The console structure doesn't refer to any device in sysfs,
>>>> only the tty the console is running on has.
>>>> So we need to print out the tty names in 'active', not
>>>> the console names.
>>>>
>>>> Cc: Lennart Poettering <lennart@poettering.net>
>>>> Cc: Kay Sievers <kay@vrfy.org>
>>>> Signed-off-by: Werner Fink <werner@suse.de>
>>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>>> ---
>>>>    drivers/tty/tty_io.c | 14 ++++++++++++--
>>>>    1 file changed, 12 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
>>>> index c74a00a..17db8ca 100644
>>>> --- a/drivers/tty/tty_io.c
>>>> +++ b/drivers/tty/tty_io.c
>>>> @@ -3545,9 +3545,19 @@ static ssize_t show_cons_active(struct device
>>>> *dev,
>>>>                   if (i >= ARRAY_SIZE(cs))
>>>>                           break;
>>>>           }
>>>> -       while (i--)
>>>> +       while (i--) {
>>>> +               const struct tty_driver *driver;
>>>> +               const char *name = cs[i]->name;
>>>> +               int index = cs[i]->index;
>>>> +
>>>> +               driver = cs[i]->device(cs[i], &index);
>>>> +               if (driver) {
>>>> +                       index += driver->name_base;
>>>> +                       name = driver->name;
>>>> +               }
>>>>                   count += sprintf(buf + count, "%s%d%c",
>>>> -                                cs[i]->name, cs[i]->index, i ? '
>>>> ':'\n');
>>>> +                                name, index, i ? ' ':'\n');
>>>> +       }
>>>
>>>
>>> Nice catch and indeed, systemd already relies on these names to be
>>> identical to their char-dev name. Fortunately, VTs and most serial
>>> devices register the console with the same name as the TTY, so we're
>>> fine.
>>
>>
>> What device did this trip over?
>
> I haven't seen one so far, but to me it's a coincident, not something
> we should rely on.
>
>> Also, this file is not private to systemd. Maybe these changes should
>> be forked into a different sysfs attribute, "active_devices"?
>
> What's the use-case to return the name of the console-driver? There is
> no way for user-space to read active console-drivers anywhere so I
> think returning the TTY makes more sense. We already have working
> user-space that can spawn gettys on active consoles via this file. I
> am open to change this to "active_devices" as the existing interface
> was clearly not designed to return the device-names.
>
> However, given the fact that both matched so far, I think changing the
> existing interface to the only user I am aware of is better than
> adding a new interface just to keep this unused attribute. But
> obviously it's the maintainer's/your decision and you might know
> user-space which requires the console-names instead of the tty-names.
> So please let us know which way to go as we would like to see a
> reliable way to match active consoles to TTY devices for automated
> getty-startup.

Sure, I get it. Just wanted to point out the obvious right up front
so that if it turns out there is another userspace dependency and
this gets rewound, possibly across future -stable kernels, the
fallout could get ugly.

Regards,
Peter Hurley

PS - The "active" attribute won't be unused; old systemd's will
still depend on it, yes?

