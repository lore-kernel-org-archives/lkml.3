Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753082AbaFXAGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 20:06:09 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:54059 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaFXAGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 20:06:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140623202615.GA29199@kroah.com>
References: <20140621180201.GA4621@amd.pavel.ucw.cz>
	<CAKb7UvhOCiBHcsB6a0qKBNsC3c9pmb=Wc7zucbBuP6vt-tx2eA@mail.gmail.com>
	<20140621194538.GA4903@kroah.com>
	<CAKb7UvjhOystpeRy1nQx49Nspve4wHQPb+e7gJQ-RT-HseK4Cw@mail.gmail.com>
	<20140623130259.GA29809@amd.pavel.ucw.cz>
	<CAKb7UvhmatCtu2rEHgVOjitN1gAPTsgfaUmA2iOLX2Qwhi+Yxg@mail.gmail.com>
	<20140623201503.GA4551@amd.pavel.ucw.cz>
	<CAKb7UvjU+MvW+rXi8488GE64Exuxj3+H5V+E8fzfL5fTb1CGMA@mail.gmail.com>
	<20140623202615.GA29199@kroah.com>
Date: Tue, 24 Jun 2014 10:06:06 +1000
Message-ID: <CACAvsv7t4A6o_-TQxz-jXAvm0fwOLSidpo1Jw01kVCdX3EpaaQ@mail.gmail.com>
Subject: Re: unparseable, undocumented /sys/class/drm/.../pstate
From: Ben Skeggs <skeggsb@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>,
        kernel list <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>, Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 6:26 AM, Greg KH <greg@kroah.com> wrote:
> On Mon, Jun 23, 2014 at 04:18:39PM -0400, Ilia Mirkin wrote:
>> On Mon, Jun 23, 2014 at 4:15 PM, Pavel Machek <pavel@ucw.cz> wrote:
>> > Hi!
>> >
>> >> >> >> > I guess better interface would be something like
>> >> >> >> >
>> >> >> >> > pstate/07/core_clock_min
>> >> >> >> >           core_clock_max
>> >> >> >> >           memory_clock_min
>> >> >> >> >           memory_clock_max
>> >> >> >> >
>> >> >> >> > and then pstate/active containing just the number of active state?
>> >> >
>> >> >> Could we just say that the format of this file is one-per-line of
>> >> >>
>> >> >> level: information-for-the-user
>> >> >
>> >> > But it is not.
>> >>
>> >> But it is...
>> >>
>> >> > Management tools will want to parse it, sooner or
>> >> > later.  What is wrong with solution described above?
>> >>
>> >> It is complex and annoying to the people that will actually use it.
>> >
>> > grep -r . pstate/ is actually not that bad...
>>
>> While that's a clever trick that anyone who's done a bunch of stuff
>> with sysfs knows, I doubt the average linux user could come up with
>> that on their own. I know I didn't.
>
> That's fine, why would an "average" Linux user ever need to poke around
> in sysfs?  Again, please describe what you are wanting to have exported
> to userspace, and what userspace is supposed to do with that
> information, before worrying about the actual sysfs file layout.
Because, at the moment, we can't by default give any kind of automatic
clock management policy due to the fact that in a great number of
cases, we'll likely hang the GPU when changing clock speeds.  The
VBIOS defaults aren't sufficient for more demanding games etc, and
people might want to try/risk selecting the highest level anyway to
see if it'll work for them.  When things actually work, this will all
automagically happen based on load and users should never need to
touch it.

So, we want a file users can write the level identifier into.  Which,
shockingly, is exactly what the file currently does.

I, however, also decided that people might actually want to know what
this "0x0a" they're echoing into the file actually means; So, in the
output (which is a list of valid identifiers), after the identifier
there's a bunch of "<name> <value>" pairs giving an overview of that
this mysterious "0x0a" is.

Sure, we can remove the information and have the informationless list
of identifiers and we'd suddenly be strictly obeying the rules, then
we've also made any potential userspace tool that we're worried about
a lot more useless (what's it going to do, a drop-down list of 0x07,
0x0a, 0x0e, 0x0f?).

Sure, we can split this all up into a directory structure; and make it
a lot more cumbersome for the intended target of the user who just
wants to override an unfortunate but currently necessary default.  I'm
not sure how exactly one-per-line "<id>: <name> <min>-<max> ..." is
hard for userspace to deal with (scanf anyone?), but a directory
structure won't be any easier, the available files will still differ
with each card generation etc and userspace will just have to loop
over a directory list instead of each line of a single file.

But, as I said on IRC yesterday, let's just move this to debugfs to
save this waste of time argument, and move on.

Ben.


>
> greg k-h
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
