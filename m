Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965588Ab3CZQUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:20:23 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:38896 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964853Ab3CZQUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 12:20:17 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <5151C94B.7000407@canonical.com>
References: <5151C94B.7000407@canonical.com>
Date: Tue, 26 Mar 2013 17:20:16 +0100
Message-ID: <CAKMK7uFT1Xj0=WY4bq1oo7M8rgNh1VSEPjfKwt9Y1dtkc3zVwQ@mail.gmail.com>
Subject: Re: [PATCH] lockdep/selftest: Add tests for the mixed read-write case.
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 5:14 PM, Maarten Lankhorst
<maarten.lankhorst@canonical.com> wrote:
> rlock_AA5 will pass unexpectedly, marking the test as FAILED and breaking lockdep for everyone.
>
> The following test should make lockdep complain, but currently doesn't:
>
> lock(a); readlock(x);
>
> writelock(x); lock(a);
>
> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

Note that workqueues use readlock annotations to supposed catch
deadlocks around flush_workqueue. But it doesn't really work, and
we've been bitten by that in drm/i915 pretty badly. See the commit
note in

commit b4a98e57fc27854b5938fc8b08b68e5e68b91e1f
Author: Chris Wilson <chris@chris-wilson.co.uk>
Date:   Thu Nov 1 09:26:26 2012 +0000

    drm/i915: Flush outstanding unpin tasks before pageflipping

    If we accumulate unpin tasks because we are pageflipping faster than the
    system can schedule its workers, we can effectively create a
    pin-leak. The solution taken here is to limit the number of unpin tasks
    we have per-crtc and to flush those outstanding tasks if we accumulate
    too many. This should prevent any jitter in the normal case, and also
    prevent the hang if we should run too fast.

    Note: It is important that we switch from the system workqueue to our
    own dev_priv->wq since all work items on that queue are guaranteed to
    only need the dev->struct_mutex and not any modeset resources. For
    otherwise if we have a work item ahead in the queue which needs the
    modeset lock (like the output detect work used by both polling or
    hpd), this work and so the unpin work will never execute since the
    pageflip code already holds that lock. Unfortunately there's no
    lockdep support for this scenario in the workqueue code.

    Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=46991
    Reported-and-tested-by: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
    Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
    [danvet: Added note about workqueu deadlock.]
    Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=56337
    Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Later investigations showed that there _is_ lockdep support, it just
doesn't work. Maarten's patch here boils the failure scenario down to
its essence.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
