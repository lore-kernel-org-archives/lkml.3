Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195Ab3GSXus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:50:48 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62117 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752057Ab3GSXuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:50:46 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module dependency.
Date: Sat, 20 Jul 2013 02:00:44 +0200
Message-ID: <2745724.Y86yAFA8gy@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130719231630.GC1701@kroah.com>
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp> <4295105.1txhDL4OOg@vostro.rjw.lan> <20130719231630.GC1701@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 19, 2013 04:16:30 PM Greg Kroah-Hartman wrote:
> On Fri, Jul 19, 2013 at 11:38:04PM +0200, Rafael J. Wysocki wrote:
> > Alas, this is not the one I'd like to apply.
> > 
> > With that patch applied, new device objects are created to avoid binding the
> > processor driver directly to the cpu system device objects, because that
> > apparently confuses udev and it starts to ignore the cpu modalias once the
> > driver has been bound to any of those objects.
> > 
> > I've verified in the meantime that this indeed is the case.
> > 
> > A link to the patch in question: https://patchwork.kernel.org/patch/2830561/
> > 
> > Greg, I asked you some time ago whether or not it was possible for udev to stop
> > autoloading modules that matched the cpu modalias after a driver had been bound
> > to the cpu system device objects and you said "no".  However, this time I can
> > say with certainty that that really is the case.  So, the question now is
> > whether or not we can do anything in the kernel to avoid that confusion in udev
> > instead of applying the patch linked above (which is beyond ugly in my not so
> > humble opinion)?
> 
> udev isn't doing any module loading, 'modprobe' is just being called for
> any new module alias that shows up in the system, and all of the drivers
> that match it then get loaded.

The problem is that that doesn't happen when a driver is bound to the
cpu system device objects.  modprobe is just not called for modules that
match the cpu modalias in that case.

If I call modprobe manually for any of the modules in question, it loads
and works no problem.

> How is it a problem if a module is attempted to be loaded that is
> already loaded?  How is it a problem if a different module is loaded for
> a device already bound to a driver?  Both of those should be total
> "no-ops" for the kernel.

Precisely, but that's not what happens in practice, hence my question.

The situation is this:

- With 3.11-rc1 modules that match the CPU modalias are not loaded
  automatically (that is, modprobe is not called for them by udev) after
  the processor module is loaded.
- With 3.10 they are loaded automatically at any time.
- With the patch at https://patchwork.kernel.org/patch/2830561/ on top of
  3.11-rc1 the situation is the same as for 3.10.

Therefore we have a kernel regression from 3.10 (with respect to the existing
user space which is udev) in 3.11-rc1 3.10 and the patch at
https://patchwork.kernel.org/patch/2830561/ makes that regression go away.

However, that patch is totally voodoo programming, so I wonder if there is any
saner alternative or we really need to do voodoo programming in the kernel to
work around udev's confusion.

> But, I don't know anything about the cpu code, how is loading a module
> causing problems?  That sounds like it needs to be fixes, as any root
> user can load modules whenever they want, you can't protect the kernel
> from doing that.

Yes, that needs to be fixed, but I don't know *why* it is a problem in the
first place.  I'd like to understand what's going on, because I don't
right now.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
