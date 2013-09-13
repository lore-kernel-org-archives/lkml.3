Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab3IMI0w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 04:26:52 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:43041 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab3IMI0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 04:26:47 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <5232A39B.5040205@vmware.com>
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net>
	<CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com>
	<5231E18D.7070306@canonical.com>
	<5231EF5A.7010901@vmware.com>
	<52323734.4070908@canonical.com>
	<5232A39B.5040205@vmware.com>
Date: Fri, 13 Sep 2013 10:26:47 +0200
Message-ID: <CAKMK7uFu8wp0r2NvLFQR9u4HQiC4v=r_UBYkpZsfEvMj+XYjJQ@mail.gmail.com>
Subject: Re: [BUG] completely bonkers use of set_need_resched + VM_FAULT_NOPAGE
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Peter Zijlstra <peterz@infradead.org>, Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 7:33 AM, Thomas Hellstrom <thellstrom@vmware.com> wrote:
> Given that all copy_to_user / copy_from_user paths are actually hit during
> testing, right?

Ime it requires a bit of ingenuity to properly test this from
userspace. We're using a few tricks in drm/i915 kernel testing:
- When we hand a gtt mmap pointer to execbuf or other ioctls we upload
the data in there through pwrite (or if you don't have that use the
gpu to blt it there). This way you can careful control when the
pagefault will happen. Also since we supply correct data we can make
sure that the kernel actually does the right thing and not just
whether it'll blow up.
- We have a module parameter which can be changed at runtime to
disable all the prefaulting we're doing.
- We have a debugfs interface to drop caches/evict lrus. If you have a
parallel thread that regularly forces the inactive list to be evicted
we can force a refault even after the first fault already happend.
That's useful to test the slowpath after a slowpath already happened,
e.g. when trying to copy reloc offset out to userspace after execbuf
completed.

With these tricks we have imo great test coverage for i915.ko and more
important good assurance that any regressions in this tricky code will
get caught.

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
