Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab3IMIcx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 04:32:53 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:63211 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab3IMIct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 04:32:49 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <5232CB66.6000906@vmware.com>
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net>
	<CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com>
	<5231E18D.7070306@canonical.com>
	<5231EF5A.7010901@vmware.com>
	<52323734.4070908@canonical.com>
	<5232B44C.9010408@vmware.com>
	<5232BBE1.5030509@canonical.com>
	<5232C2BB.9070303@vmware.com>
	<5232C3E8.2050501@canonical.com>
	<5232CB66.6000906@vmware.com>
Date: Fri, 13 Sep 2013 10:32:48 +0200
Message-ID: <CAKMK7uFkav0b+8AYkm_3eT=d6T6wvstHuOXkTwFt_Do4YmijQA@mail.gmail.com>
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

On Fri, Sep 13, 2013 at 10:23 AM, Thomas Hellstrom
<thellstrom@vmware.com> wrote:
> As previously mentioned, copy_from_user should return -EFAULT, since the
> VMAs are marked with VM_IO. It should not recurse into fault(), so evil
> user-space looses.

I haven't put a printk in the code to prove this, but gem mmap also
sets VM_IO in drm_gem_mmap_obj. And we can very much hit our own fault
handler and deadlock ....

On a _very_ quick reading (and definitely not enough coffee yet for
reading mm/* stuff) it looks like it's get_user_pages that will return
an -EFAULT when hitting upon a VM_IO mapping (which makes sense since
there's really no page backing it). Actually using get_user_pages was
the original slowpath we've had in a few places until we've noticed
that for pwrite that breaks legit userspace (the glBufferData(glMap))
use-case), so we've switched to lock dropping and proper slowpaths
using copy_*_user everywhere instead of trying to pin the userspace
storage with get_user_pages.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
