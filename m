Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757412AbaGNVd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:33:58 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:52570 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207AbaGNVd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:33:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+or7=2a2sb93Y=z65gFQNKu1G8eQnNQOf1qgUhnyWR8A@mail.gmail.com>
References: <1404245874-350-1-git-send-email-linville@tuxdriver.com>
 <20140702001936.GQ27687@wotan.suse.de> <20140702143003.GA13564@tuxdriver.com>
 <CAB=NE6U3PMsatwcczO6hrfe+2z3mN9n9zcX0tgy5iTbCRNRcmw@mail.gmail.com> <CAGXu5j+or7=2a2sb93Y=z65gFQNKu1G8eQnNQOf1qgUhnyWR8A@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Mon, 14 Jul 2014 14:33:33 -0700
X-Google-Sender-Auth: 9zp6D4HxMwYLhQ6jBSZD1ERPOCM
Message-ID: <CAB=NE6VUXd7LUPLoWAG_YObDE-LC5BijUm9jnhiOoft2x7cWZQ@mail.gmail.com>
Subject: Re: [PATCH] wireless: fixup genregdb.awk for remove of antenna gain
 from wireless-regdb
To: Kees Cook <keescook@chromium.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Janusz Dziedzic <janusz.dziedzic@tieto.com>,
        Ming Lei <ming.lei@canonical.com>, Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>, linux-firmware@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2014 at 2:13 PM, Kees Cook <keescook@chromium.org> wrote:
> On Mon, Jul 14, 2014 at 2:08 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>> On Wed, Jul 2, 2014 at 7:30 AM, John W. Linville <linville@tuxdriver.com> wrote:
>>> On Wed, Jul 02, 2014 at 02:19:36AM +0200, Luis R. Rodriguez wrote:
>>>> On Tue, Jul 01, 2014 at 04:17:54PM -0400, John W. Linville wrote:
>>>> > Since "wireless-regdb: remove antenna gain" was merged in the
>>>> > wireless-regdb tree, this script has been incompatible with the
>>>> > 'official' regulatory database.  Let's fix it up.
>>>> >
>>>> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>>> > ---
>>>> > I think the dfs_cac stuff is still broken, since it does not account
>>>> > for the starting offset of the flags.
>>>>
>>>> Indeed, but that also breaks other stuff too, because the DFS CAC stuff
>>>> is optional it means the flags can now start at different locations, it
>>>> also means that we need to distinguish a flag from a CAC.
>>>>
>>>> Here's a complex example we should test for as an example now:
>>>>
>>>> country US: DFS-FCC
>>>>       (2400 - 2450 @ 40), (100 mW)
>>>>       (2450 - 2500 @ 0), (100 mW), DFS, AUTO-BW
>>>>       (5170 - 5250 @ 80), (100 mW), DFS, AUTO-BW, NO-OUTDOOR
>>>>       (5250 - 5330 @ 0), (20), (60000), DFS, AUTO-BW
>>>>       (5735 - 5835 @ 80), (30)
>>>>       (57240 - 63720 @ 2160), (40)
>>>>
>>>> The changes below seem to address it. I think awk is too fragile to
>>>
>>> Your patch looks almost exactly like what I was thinkg to do.
>>
>> OK I'll resend and update the Kconfig entry to ensure folks are aware
>> of the issues discussed and our resolution on requiring folks deal
>> with issue on the awk parser.
>>
>>>> scale well and keep us sane. A C parser exists but right now it
>>>> ignores the DFS CAC. Having a parser is nice as it allows us to
>>>> modify the db.txt on the fly, however parser still requires a bit
>>>> of an update in code. If we wanted to avoid the parser all together
>>>> we could just merge a CRDA reader at build time and require a
>>>> a regulatory.bin file for reading instead of the db.txt. If we
>>>> had support for that then its really only one step further from
>>>> having full CRDA functionality upstream on the kernel, ie letting
>>>> us read the file at run time rather than just build time. If we
>>>> are to follow the steps from udev with its firmware loader helper
>>>> we might as well merge CRDA upstream, in fact we could just use
>>>> request_firmware_direct() for the reader, what remains questionable
>>>> to me is the signing stuff, but if we already have support module
>>>> signing checks it doesn't seem far fetched to be able to have
>>>> request firmware verify a signature on a file, which probably
>>>> ain't such a bad idea anyway. If we did this we'd have two options:
>>>>
>>>> 1) regulatory.bin reader at build time to build the static regulatory domains
>>>> 2) the same reader code can use request the file at run time via
>>>>    request_firmware_direct() and if we added signature verification
>>>>    it can replace CRDA
>>>>
>>>> We'd eliminate the ASCII representation completely from the build picture
>>>> and peg a regulatory.bin firmware to each kernel then. Thoughts?
>>>
>>> I'll have to digest this -- needs some more discussion, for sure.
>>
>> Some more on this. I stumbled upon Takashi Iwai's November 2012
>> firmware_class Takashi Iwai's signature check series [0] [1]. His
>> second iteration didn't get merged but there weren't any particular
>> NACKs on the threads -- upon following up with him it would seem the
>> way to move this forward though is to integrate this somehow with Kees
>> Cook's work on LSM. I have yet to do that but at least by looking at
>
> I've got LSM hooks built to check incoming firmware. It should be
> trivial to add signature checks to that. For Chrome OS, that would be
> redundant since we use dm-verity to check file contents. All Chrome OS
> needs to know is where the firmware came from. Here's the current
> tree:
>
> https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=fw-restrict

Awesome! Base do a quick glance it seems Android also uses this,
dm-verity [0] uses public keys as well so it would indeed also provide
authenticity / integrity checks which would indeed make firmware
signature checks redundant, the only requirement however is you'd
require the checks on the partition, and I do suspect not all
distributions will want to go down this path. If we can extend the LSM
hooks to give the option for signatures on firmware we'd enable
distributions to pick and choose a strategy. Can we let LSM hooks then
figure out if a digital signature is superfluous if dm-verity is being
used ? I suspect there may be some cases where a module / part of the
kernel may want to *force* the presence of a signature check but I
don't think that this is a requirement for all use cases.

[0] https://source.android.com/devices/tech/security/dm-verity.html

  Luis
