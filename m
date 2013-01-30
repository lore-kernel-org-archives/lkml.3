Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086Ab3A3WUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 17:20:00 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59440 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab3A3WT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 17:19:58 -0500
Date: Wed, 30 Jan 2013 22:19:46 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>
Subject: Re: BUG: circular locking dependency detected
Message-ID: <20130130221946.GA14801@flint.arm.linux.org.uk>
References: <20130130200648.GA13298@flint.arm.linux.org.uk> <20130130215211.GA28418@flint.arm.linux.org.uk> <CAKMK7uHEggaGfLTq4c3MfY7csQSFpb=kRwdbJUQMN9Cz9K=V4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uHEggaGfLTq4c3MfY7csQSFpb=kRwdbJUQMN9Cz9K=V4A@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 11:07:16PM +0100, Daniel Vetter wrote:
> On Wed, Jan 30, 2013 at 10:52 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> > Also adding Greg and Daniel to this as Daniel introduced the lockdep
> > checking.
> >
> > This looks extremely horrid to be to solve - the paths are rather deep
> > where the dependency occurs.  The two paths between the locks are:
> >
> > console_lock+0x5c/0x70
> > register_con_driver+0x44/0x150
> > take_over_console+0x24/0x3b4
> > fbcon_takeover+0x70/0xd4
> > fbcon_event_notify+0x7c8/0x818
> > notifier_call_chain+0x4c/0x8c
> > __blocking_notifier_call_chain+0x50/0x68
> > blocking_notifier_call_chain+0x20/0x28
> >
> > and
> >
> > __blocking_notifier_call_chain+0x34/0x68
> > blocking_notifier_call_chain+0x20/0x28
> > fb_notifier_call_chain+0x20/0x28
> > fb_blank+0x40/0xac
> > fbcon_blank+0x1f4/0x29c
> > do_blank_screen+0x1b8/0x270
> > console_callback+0x74/0x138
> 
> You want Dave Airlie's pile of locking reworks, which fixes all
> currently known offenders around console_lock and fb_notifier. Patches
> won't go into 3.9 since it took a few rounds until they did not cause
> regression by making these deadlocks easier to hit.
> 
> http://cgit.freedesktop.org/~airlied/linux/log/?h=fbcon-locking-fixes
> 
> Long term solution would be to abolish the fb_notifier, at least for
> the purpose of linking fbdevs up with the fbcon and just replace those
> with direct function calls. But that requires that we no longer allow
> fbdev drivers and the fbcon to be loaded in any arbitrary order. Or
> just force fbcon to be built-in if enabled, imo the sane choice (no
> one's bothering with config_vt=m either, after all).

So... what you seem to be telling me is that 3.9 is going to be a
release which issues lockdep complaints when the console blanks, and
you think that's acceptable?

Adding Linus and Andrew so they're aware of this issue...

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
