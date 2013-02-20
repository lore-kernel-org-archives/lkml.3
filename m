Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479Ab3BTWSr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:18:47 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53594 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab3BTWSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:18:46 -0500
Date: Wed, 20 Feb 2013 23:18:28 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andy Ross <andy.ross@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2] vt: add init_hide parameter to suppress boot output
Message-ID: <20130220221828.GB23856@xo-6d-61-c0.localdomain>
References: <1361289224-10678-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130220014512.GC31018@kroah.com>
 <51244B35.8090006@windriver.com>
 <20130220044506.GA2728@kroah.com>
 <5124FFD7.8070708@windriver.com>
 <20130220205737.GB6597@xo-6d-61-c0.localdomain>
 <51254959.1020309@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51254959.1020309@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2013-02-20 14:08:25, Andy Ross wrote:
> On 02/20/2013 12:57 PM, Pavel Machek wrote:
> >I'm sure something creative can be done with fake init that shuts
> >the console up then execs previous init. No need to add more kernel
> >knobs, I'd say.
> 
> Fair enough, but some last words:
> 
> That's argument is the "it's about logging" hypothesis again.  Even if
> it were possible to completely shut up console output (something
> that's awfully hard in the general case when running on PC hardware,
> and IMHO from a developer's perspective not even a good thing), that's

Is it really so hard? ... ... ... I'll comment below.

> not the whole problem.  The framebuffer console initialization does a
> buffer clear and mode set, and that clobbers anything the bootloader
> might have left on the screen prematurely, before userspace is ready
> to throw up its own splash.  Splash screens may be a silly
> requirement, but they're still a requirement.

Ok. "quiet" option already leaves the display as is, including tests on it -
at least in VGA text mode case. Would it make sense to behave the same on
framebuffers you care about?

That patch could be quite accepteble, AFAICT. It does not add a new interface,
just makes framebuffers behave similar way to legacy vga.

And now... how to shut off the logging.

/sbin/init:
chvt 99
cat /share/splash > /dev/fb0
exec /sbin/init

...here you go. No flickering, no distro messages on the screen. You have
to display your splash from /sbin/init, but that should not be bad. Hmm?

> And the suspend console problem is likewise at work: ideally you'd
> like to know, for example, that the panel backlight is off before
> suspending.  But what happens in practice is that the kernel does a VT
> switch to/from console 63 and the backlight wakes up (I'm not going to
> pretend I have this bit completely figured out, but the problem is/was
> real and this patch fixed it by suppressing the console visibility).

I believe someone is already fixing this for suspend. rjw would know more.
Lets treat it as separate problem?

> But at the same time: all that other stuff doesn't quite meet the
> requirements (which in this case are basically "nothing happens
> visually between bootloader handoff and the surfaceflinger splash").
> What you get with that is something like what you get with desktop
> distros: you "mostly" never see the console, except when you do.

I don't know what surfaceflinger splash is; if you can display it from
init (as above) or very soon after that you should be fine.
								Pavel
--
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
