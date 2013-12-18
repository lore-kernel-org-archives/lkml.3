Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab3LRXVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 18:21:10 -0500
Received: from smtp206.alice.it ([82.57.200.102]:15235 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134Ab3LRXVH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 18:21:07 -0500
Date: Thu, 19 Dec 2013 00:21:01 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Input Tools <input-tools@lists.freedesktop.org>
Subject: Re: [PATCH 2/4] Input: introduce ABS_MAX2/CNT2 and friends
Message-Id: <20131219002101.08a12c6a3779f02018fc2a7c@studenti.unina.it>
In-Reply-To: <CANq1E4RNa6XBaUTy=ur7Yig0iJSEaUbLzvi-Dn-hyxS2OLnyPw@mail.gmail.com>
References: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
	<1387295334-1744-3-git-send-email-dh.herrmann@gmail.com>
	<20131218152731.0222ae3b3807601b7756c937@studenti.unina.it>
	<CANq1E4RNa6XBaUTy=ur7Yig0iJSEaUbLzvi-Dn-hyxS2OLnyPw@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013 15:44:48 +0100
David Herrmann <dh.herrmann@gmail.com> wrote:

> Hi
> 
> On Wed, Dec 18, 2013 at 3:27 PM, Antonio Ospite
> <ospite@studenti.unina.it> wrote:
> > Hi David,
> >
> > thanks for the update.
> >
> > On Tue, 17 Dec 2013 16:48:52 +0100
> > David Herrmann <dh.herrmann@gmail.com> wrote:
> >
> >> As we painfully noticed during the 3.12 merge-window our
> >> EVIOCGABS/EVIOCSABS API is limited to ABS_MAX<=0x3f. We tried several
> >> hacks to work around it but if we ever decide to increase ABS_MAX, the
> >> EVIOCSABS ioctl ABI might overflow into the next byte causing horrible
> >> misinterpretations in the kernel that we cannot catch.
> >>
> >> Therefore, we decided to go with ABS_MAX2/CNT2 and introduce two new
> >> ioctls to get/set abs-params. They no longer encode the ABS code in the
> >> ioctl number and thus allow up to 4 billion ABS codes.
> >>
> >
> > Just a question: did you consider the possibility of not exposing _MAX2
> > and _CNT2 in a header file at all but let those be queried? Or maybe
> > this is not necessary if we assume that userspace programs are supposed
> > to know what is the MAX _they_ support?
> >
> > BTW I was thinking for instance to a program compiled with ABS_MAX2 =
> > 0x4f but working with future kernels with an increased value, it still
> > won't be able to support values greater than 0x4f.
> 
> Why would a program that was compiled with ABS_MAX2=0x4f want to use
> ABS_* values greater than 0x4f? It doesn't know of any new values so
> even if it could query ABS_MAX2, it could never know anything about
> the new constants. The only place where it is useful is for generic
> programs that just foward ABS_* codes. But these can just ignore
> ABS_MAX2 entirely and use the whole int32_t range for codes.
>

OK, that makes sense, thanks.

> If there is a specific use-case that'd require a dynamic way to
> retrieve ABS_MAX2, I can consider changing the API. But unless there's
> such a use-case, I'd like to keep it the same as for KEY_*, SW_*, ...
> 
> >> The new API also allows to query multiple ABS values with one call. To
> >> allow EVIOCSABS2(code = 0, cnt = ABS_CNT2) we need to silently ignore
> >> writes to ABS_MT_SLOT. Furthermore, for better compatibility with
> >> newer user-space, we ignore writes to unknown codes. Hence, if we ever
> >> increase ABS_MAX2, new user-space will work with code=0,cnt=ABS_CNT2 just
> >> fine even on old kernels.
> >>
> >
> > To my inexperienced eye it's not obvious why ABS_MT_SLOT must be handled
> > as a special case. Maybe because I don't even know what
> > code=0,cnt=ABS_CNT2 is used for.
> 
> ABS_MT_SLOT describes the current MT-slot that is reported via
> ABS_MT_* bits. It is read-only so we cannot let user-space write to
> it.
>

I see.

> >> Note that we also need to increase EV_VERSION so user-space can reliably
> >> know whether ABS2 is supported. Unfortunately, we return EINVAL instead of
> >> ENOSYS for unknown evdev ioctls so it's nearly impossible to catch
> >> reliably without EVIOCGVERSION.
> >>
> >
> > I'll check how to use that in evtest.
> >
> > Just one more comment below.
> >
> >> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> >> ---
> >>  drivers/hid/hid-debug.c                  |  2 +-
> >>  drivers/hid/hid-input.c                  |  2 +-
> >>  drivers/input/evdev.c                    | 95 +++++++++++++++++++++++++++++++-
> >>  drivers/input/input.c                    | 14 ++---
> >>  drivers/input/keyboard/goldfish_events.c |  6 +-
> >>  drivers/input/keyboard/hil_kbd.c         |  2 +-
> >>  drivers/input/misc/uinput.c              |  6 +-
> >>  include/linux/hid.h                      |  2 +-
> >>  include/linux/input.h                    |  6 +-
> >>  include/uapi/linux/input.h               | 42 +++++++++++++-
> >>  include/uapi/linux/uinput.h              |  2 +-
> >>  11 files changed, 155 insertions(+), 24 deletions(-)
> >>
> >
> > [...]
> >> diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
> >> index bd24470..1856461 100644
> >> --- a/include/uapi/linux/input.h
> >> +++ b/include/uapi/linux/input.h
> > [...]
> >>
> >>  /*
> >> + * Due to API restrictions the legacy evdev API only supports ABS values up to
> >> + * ABS_MAX/CNT. Use the extended *ABS2 ioctls to operate on any ABS values in
> >> + * between ABS_MAX and ABS_MAX2.
> >> + */
> >> +#define ABS_MAX2             0x3f
> >> +#define ABS_CNT2             (ABS_MAX2+1)
> >> +
> >
> > Maybe it's just my English, but when you say "between ABS_MAX and
> > ABS_MAX2" it sounds like the old protocol still _must_ be used for
> > values <= ABS_MAX.
> >
> > IIUC this is true "only" for compatibility with older kernels right?
> > If a program decides to support only newer kernels it can check the
> > protocol version and use only the new ioctls, right?
> >
> > Maybe you can be more explicit about that in the comment?
> 
> See the comment on "struct input_absinfo2". It describes the API, this
> comment just describes the ABS_* values. But if anyone has a better
> phrase to use here, I will gladly adjust it.
> 

That comment says:

	EVIOC[G/S]ABS2 ioctls [...] do the same as the old EVIOC
	[G/S]ABS ioctls but...

My bad, I was confused by the fact that the new ioctls are presented as
a replacement for the old ones, but then I interpreted the later comment
as suggesting to use them only for values between ABS_MAX and ABS_MAX2.

Looking at how you use both mechanisms combined in libevdev it is clear
they can be used together for backward compatibility.

I like keywords, so I'd stress in the commit message that the new
protocol can either _replace_ or _extend_ the old one.

Ciao,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
