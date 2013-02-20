Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516Ab3BTWIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:08:31 -0500
Received: from li44-10.members.linode.com ([72.14.181.10]:49358 "EHLO
	plausible.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab3BTWI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:08:29 -0500
Message-ID: <51254959.1020309@windriver.com>
Date: Wed, 20 Feb 2013 14:08:25 -0800
From: Andy Ross <andy.ross@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiri Slaby <jslaby@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2] vt: add init_hide parameter to suppress boot output
References: <1361289224-10678-1-git-send-email-kirill.shutemov@linux.intel.com> <20130220014512.GC31018@kroah.com> <51244B35.8090006@windriver.com> <20130220044506.GA2728@kroah.com> <5124FFD7.8070708@windriver.com> <20130220205737.GB6597@xo-6d-61-c0.localdomain>
In-Reply-To: <20130220205737.GB6597@xo-6d-61-c0.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 12:57 PM, Pavel Machek wrote:
> I'm sure something creative can be done with fake init that shuts
> the console up then execs previous init. No need to add more kernel
> knobs, I'd say.

Fair enough, but some last words:

That's argument is the "it's about logging" hypothesis again.  Even if
it were possible to completely shut up console output (something
that's awfully hard in the general case when running on PC hardware,
and IMHO from a developer's perspective not even a good thing), that's
not the whole problem.  The framebuffer console initialization does a
buffer clear and mode set, and that clobbers anything the bootloader
might have left on the screen prematurely, before userspace is ready
to throw up its own splash.  Splash screens may be a silly
requirement, but they're still a requirement.

And the suspend console problem is likewise at work: ideally you'd
like to know, for example, that the panel backlight is off before
suspending.  But what happens in practice is that the kernel does a VT
switch to/from console 63 and the backlight wakes up (I'm not going to
pretend I have this bit completely figured out, but the problem is/was
real and this patch fixed it by suppressing the console visibility).

Now, the point that an in-kernel console is "going away" and thus not
worth augmenting with new APIs is valid.  And this is a small patch
that's unlikely to be difficult to maintain in a custom tree.  And as
we all agree there are other mechanisms that can be used here (even if
AFAICT they don't completely solve the problem), and indeed I'd love
to get surfaceflinger working with VT_ACTIVATE et. al. if I get a
chance.  So I'm not going to cry if this isn't worth mainline.

But at the same time: all that other stuff doesn't quite meet the
requirements (which in this case are basically "nothing happens
visually between bootloader handoff and the surfaceflinger splash").
What you get with that is something like what you get with desktop
distros: you "mostly" never see the console, except when you do.

Andy
