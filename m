Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab3BURBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 12:01:14 -0500
Received: from li44-10.members.linode.com ([72.14.181.10]:34908 "EHLO
	plausible.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754845Ab3BURBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 12:01:10 -0500
Message-ID: <512652D3.2060101@windriver.com>
Date: Thu, 21 Feb 2013 09:01:07 -0800
From: Andy Ross <andy.ross@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Pavel Machek <pavel@ucw.cz>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2] vt: add init_hide parameter to suppress boot output
References: <1361289224-10678-1-git-send-email-kirill.shutemov@linux.intel.com> <20130220014512.GC31018@kroah.com> <51244B35.8090006@windriver.com> <20130220044506.GA2728@kroah.com> <5124FFD7.8070708@windriver.com> <20130220205737.GB6597@xo-6d-61-c0.localdomain> <51254959.1020309@windriver.com> <20130221011242.GB4961@kroah.com>
In-Reply-To: <20130221011242.GB4961@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know I said the last words were my last, but this message and
Pavel's gave me some vain hope that I might be able to win this one on
the merits, so I'm trying again just to make the situation clear:

On 02/20/2013 05:12 PM, Greg Kroah-Hartman wrote:
> I don't see why this is even needed for surfaceflinger systems, as
> again, you have full control over the hardware and system so you
> don't even need a framebuffer console at all.

The application here is Android on PC hardware (see 01.org, which is
carrying this patch at the moment), so sadly we don't.  And we want
the framebuffer console anyway; having a console is a good thing.

> if you look most distros have already solved this issue for you,
> [...]  My systems don't drop down to the framebuffer when
> suspending, I think you need to look at using a better distro

That's sorta, kinda, completely incorrect. :)

Just to be sure, I tried again (on my Sony Vaio Z 1311 and an Acer
X700 table, both Ivy Bridge boxes with i915 graphics) with live iso's
for Fedora 18, openSUSE 12.2, and Ubuntu 12.10:

+ Every one of them includes the framebuffer console

+ Every one of them displays at least some console content at boot
   (Ubuntu gets the cookie here for showing only a blinking cursor and
   no actual text).

+ Every one of them displays console content at suspend time (openSUSE
   gets a lemon here for multiple lines of spam, Ubuntu again almost
   gets a pass here because all they have is a cursor unless you have
   manually Alt-Fn'd to a console to put something in the buffer).

+ Every one of them shows console content during shutdown.

It's not like these are ugly, awful glitches.  It's just quick flashes
of text, and I frankly wouldn't care.  But honestly: the level of
support right now for glitch-free boot and suspend (in the presence of
the framebuffer console) just isn't at the level of spit and polish
demanded by consumer devices.

I *assure* you, that if this were as simple as "do what the distros
do" that this patch wouldn't exist. (Seriously: probably half my job
right now consists of picking up an integration glitch and asking "Why
doesn't this happen on Fedora?").  It's a real problem, and has to be
solved with code.

So let me make the case for this particular solution one last time:

1. The framebuffer console is useful and we don't want to disable it.

2. Console *output* is useful.  That junk is helpful sometimes, and in
    any case auditing logging for a whole system is terribly difficult.
    IMHO the correct solution to "I don't want users to see this
    internal detail" is not "no one should ever see this internal
    detail".

3. Console output on the *screen* is the thing that's undesirable, and
    even then only if the user hasn't requested it.

4. There's already a predicate in the console subsystem
    (CON_IS_VISIBLE()) which does exactly what we want.  All this does
    is allow it to be forced false even for the default consoles at
    boot.  But if the user wants to see the output, she just changes to
    a console and it's right there for her (though right now
    surfaceflinger will still fight for the display because it doesn't
    speak the VT_ACTIVATE protocol, but that's a separate bug).

Andy
