Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581Ab3JGK6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 06:58:15 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:62356 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab3JGK6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 06:58:10 -0400
MIME-Version: 1.0
In-Reply-To: <20131007013058.GA20549@yabbi.redhat.com>
References: <1380751836-10829-1-git-send-email-dh.herrmann@gmail.com>
	<20131003233223.GA21255@yabbi.bne.redhat.com>
	<20131006074700.GA19155@core.coreip.homeip.net>
	<20131006231955.GA26952@yabbi.redhat.com>
	<f37ea673-a597-4dd2-88b4-bf190d8eeff5@email.android.com>
	<20131007013058.GA20549@yabbi.redhat.com>
Date: Mon, 7 Oct 2013 12:58:09 +0200
Message-ID: <CANq1E4Ta+eTSBupwW1XbF7TR-F5uM6GNxgEPCK0uMMNAMXLyWA@mail.gmail.com>
Subject: Re: [RFC] Input: introduce ABS_MAX2/CNT2 and friends
From: David Herrmann <dh.herrmann@gmail.com>
To: Peter Hutterer <peter.hutterer@who-t.net>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Oct 7, 2013 at 3:30 AM, Peter Hutterer <peter.hutterer@who-t.net> wrote:
> On Sun, Oct 06, 2013 at 05:04:36PM -0700, Dmitry Torokhov wrote:
>> Peter Hutterer <peter.hutterer@who-t.net> wrote:
>> >On Sun, Oct 06, 2013 at 12:47:00AM -0700, Dmitry Torokhov wrote:
>> >> On Fri, Oct 04, 2013 at 09:32:23AM +1000, Peter Hutterer wrote:
>> >> > On Thu, Oct 03, 2013 at 12:10:36AM +0200, David Herrmann wrote:
>> >> > > As we painfully noticed during the 3.12 merge-window our
>> >> > > EVIOCGABS/EVIOCSABS API is limited to ABS_MAX<=0x3f. We tried
>> >several
>> >> > > hacks to work around it but if we ever decide to increase
>> >ABS_MAX, the
>> >> > > EVIOCSABS ioctl ABI might overflow into the next byte causing
>> >horrible
>> >> > > misinterpretations in the kernel that we cannot catch.
>> >> > >
>> >> > > Therefore, we decided to go with ABS_MAX2/CNT2 and introduce two
>> >new
>> >> > > ioctls to get/set abs-params. They no longer encode the ABS code
>> >in the
>> >> > > ioctl number and thus allow up to 4 billion ABS codes.
>> >> > >
>> >> > > Unfortunately, the uinput API also hard-coded the ABS_CNT value
>> >in its
>> >> > > ABI. To avoid any hacks in uinput, we simply introduce a new
>> >> > > uinput_user_dev2 to replace the old one. The new API allows
>> >growing
>> >> > > ABS_CNT2 values without any API changes.
>> >> > >
>> >> > > Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
>> >> > > ---
>> >> > > Hi
>> >> > >
>> >> > > This is only compile-tested but I wanted to get a first revision
>> >out to let
>> >> > > people know what we're working on. Unfortunately, the ABS API has
>> >this horribly
>> >> > > low ABS_MAX limit and we couldn't figure out a way to increase it
>> >while keeping
>> >> > > ABI compatibility.
>> >> > >
>> >> > > Any feedback and review is welcome. And if anyone spots ABI
>> >breakage by this
>> >> > > patch, please let me know. If nothing comes up I will patch
>> >libevdev to use the
>> >> > > new API, write some extensive test-cases and push this forward.
>> >> > >
>> >> > > As a sidenote: I didn't modify joydev to use the new values.
>> >Fortunately, the
>> >> > > joydev API would allow switching to ABS_CNT2 without breaking
>> >API, but it would
>> >> > > limit the new ABS_CNT2 to 16k. This is quite high but nothing
>> >compared to the
>> >> > >  2^32 that we can theoretically support now. If you think 16k
>> >ought to be enough
>> >> > > (probably?) I can adjust the joydev API, too.
>> >> > > All other kernel users were converted to the new values. Nothing
>> >left behind..
>> >> >
>> >> >
>> >> > just a comment from skimming the patch:
>> >> > if you need a new uinput abi anyway, can we add the resolution
>> >here? it's
>> >> > sorely needed for some tests. see also the patch Benjamin sent a
>> >while ago
>> >> > ("input/uinput: support abs resolution", July 15 2013)
>> >>
>> >> Indeed. Also, while we are at it, would it make sense to allow
>> >> requesting a range of ABS infos at once?
>> >
>> >yes, but what API did you have in mind?
>> >
>>
>> I was thinking about specifying the start ABS but and the count and array of absinfo structures to be filled.
>
> yeah, that works for me (I suspect 90% of users will use ABS_MAX anyway :)

And how exactly should this look like? Like this:

#define EVIOCGABS2(cnt)             _IOR('E', 0x92, struct
input_absinfo2 * (cnt))

Or like this:

struct input_absinfo3 {
  size_t cnt;
  struct input_absinfo2[];
};

#define EVIOCGABS2             _IOR('E', 0x92, struct input_absinfo3)

btw., resolution added and uinput changes split off into separate patch.

Thanks
David
