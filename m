Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaAGKiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 05:38:17 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:42230 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148AbaAGKiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 05:38:16 -0500
X-Greylist: delayed 94800 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2014 05:38:16 EST
X-Originating-IP: 50.43.14.201
Date: Tue, 7 Jan 2014 02:38:06 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: Re: #pragma once?
Message-ID: <20140107103806.GA4891@leaf>
References: <20140106204706.GA16924@leaf>
 <20140107055532.GA16581@ravnborg.org>
 <CAMuHMdWPq4YgUoxE1GvQbsEJQu-wjhpra2fRDgkNfEZP0sqpVQ@mail.gmail.com>
 <52CBD247.8080508@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52CBD247.8080508@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 11:09:11AM +0100, Michal Marek wrote:
> On 2014-01-07 10:48, Geert Uytterhoeven wrote:
> > Furthermore some userspace may rely on doing #define XXX to avoid
> > including a specific kernel header (yes, it's ugly).
> 
> This pattern is also sometimes used:
> $ head -6 include/linux/spinlock_up.h
> #ifndef __LINUX_SPINLOCK_UP_H
> #define __LINUX_SPINLOCK_UP_H
> 
> #ifndef __LINUX_SPINLOCK_H
> # error "please don't include this file directly"
> #endif
> 
> And there is nothing ugly about it.

That's debatable, but it's certainly reasonable to try to enforce
non-inclusion of "internal" headers directly.  However, for headers not
exposed to userspace, it'd be easy to write that as:

include/linux/spinlock.h:
#pragma once
#define LINUX_SPINLOCK_H_INCLUDED

include/linux/spinlock_up.h:
#pragma once
#ifndef LINUX_SPINLOCK_H_INCLUDED
#error "Only include this file via spinlock.h, never directly"
#endif

> So #pragma once is probably a good
> idea for most headers that are not exposed to userspace. But making it a
> requirement in scripts/checkpatch.pl or Documentation/CodingStyle means
> that it will become hard to defend the few legitimate uses of ifndef
> guards against people who have a printed copy of checkpatch.pl under
> their pillow.

Any mention in CodingStyle or check in checkpatch would need to cover
the two exceptions: uapi, and headers that are intentionally parsed
multiple times for preprocessor magic (TRACE_HEADER_MULTI_READ).

- Josh Triplett
