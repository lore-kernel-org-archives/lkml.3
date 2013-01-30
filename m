Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab3A3WHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 17:07:21 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:60483 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756038Ab3A3WHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 17:07:18 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20130130215211.GA28418@flint.arm.linux.org.uk>
References: <20130130200648.GA13298@flint.arm.linux.org.uk>
	<20130130215211.GA28418@flint.arm.linux.org.uk>
Date: Wed, 30 Jan 2013 23:07:16 +0100
Message-ID: <CAKMK7uHEggaGfLTq4c3MfY7csQSFpb=kRwdbJUQMN9Cz9K=V4A@mail.gmail.com>
Subject: Re: BUG: circular locking dependency detected
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 10:52 PM, Russell King <rmk@arm.linux.org.uk> wrote:
> Also adding Greg and Daniel to this as Daniel introduced the lockdep
> checking.
>
> This looks extremely horrid to be to solve - the paths are rather deep
> where the dependency occurs.  The two paths between the locks are:
>
> console_lock+0x5c/0x70
> register_con_driver+0x44/0x150
> take_over_console+0x24/0x3b4
> fbcon_takeover+0x70/0xd4
> fbcon_event_notify+0x7c8/0x818
> notifier_call_chain+0x4c/0x8c
> __blocking_notifier_call_chain+0x50/0x68
> blocking_notifier_call_chain+0x20/0x28
>
> and
>
> __blocking_notifier_call_chain+0x34/0x68
> blocking_notifier_call_chain+0x20/0x28
> fb_notifier_call_chain+0x20/0x28
> fb_blank+0x40/0xac
> fbcon_blank+0x1f4/0x29c
> do_blank_screen+0x1b8/0x270
> console_callback+0x74/0x138

You want Dave Airlie's pile of locking reworks, which fixes all
currently known offenders around console_lock and fb_notifier. Patches
won't go into 3.9 since it took a few rounds until they did not cause
regression by making these deadlocks easier to hit.

http://cgit.freedesktop.org/~airlied/linux/log/?h=fbcon-locking-fixes

Long term solution would be to abolish the fb_notifier, at least for
the purpose of linking fbdevs up with the fbcon and just replace those
with direct function calls. But that requires that we no longer allow
fbdev drivers and the fbcon to be loaded in any arbitrary order. Or
just force fbcon to be built-in if enabled, imo the sane choice (no
one's bothering with config_vt=m either, after all).

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
