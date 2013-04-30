Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933918Ab3D3Wc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 18:32:57 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:40574 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932686Ab3D3Wcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 18:32:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAJsYZ5kchksgObAS66T5b-4VPrjp4Mhn4HG0DHyWBgRXib3JTw@mail.gmail.com>
References: <CAJsYZ5kk=J_Sc7w5dbMbkWWv8dXEU0ojKjEKNqH=Q6Tf2f7mQg@mail.gmail.com>
	<20130422142218.GA26760@mwanda>
	<CAG6tG3xc3RHD7sZXaEbg1vLRhFj+6d1wY=us4BfxBfi5y0o4zg@mail.gmail.com>
	<CAJsYZ5nQg9g73r5yLicq6gAGbKEXVAFqtF2av=heeNtrNSPSWg@mail.gmail.com>
	<CAG6tG3zcOdkA5QOBhaDzmMvcFSCwbfRAyKuRwXdn6ipOJhTVZQ@mail.gmail.com>
	<CAJsYZ5mpukCM6TpFb27tJt6G7ZufugEP4kx8wzGxhRwAO46cCw@mail.gmail.com>
	<CAG6tG3wrHKTJBOu69XiV6BAPfvmK-QqJkBVpzkmkrLdLV5jRwQ@mail.gmail.com>
	<CAJsYZ5kchksgObAS66T5b-4VPrjp4Mhn4HG0DHyWBgRXib3JTw@mail.gmail.com>
Date: Tue, 30 Apr 2013 18:32:54 -0400
Message-ID: <CAG6tG3ybiaSRt15s63Dz_33_-jsrrBAamOAV_t7QOW0N_zWueg@mail.gmail.com>
Subject: Re: [BUG] staging: android: ashmem: Deadlock during ashmem_shrink
From: Robert Love <rlove@google.com>
To: Shankar Brahadeeswaran <shankoo77@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, devel@driverdev.osuosl.org,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anjana V Kumar <anjanavk12@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 9:29 AM, Shankar Brahadeeswaran
<shankoo77@gmail.com> wrote:

> Question:
> On occasions when we return because of the lock unavailability, what
> could be the worst case number of ashmem pages that are left
> unfreed (lru_count). Will it be very huge and have side effects?

On that VM shrink path, all of them, but they'll go on the next pass.
Even if they didn't, however, that is fine: The ashmem cache
functionality is advisory. From user-space's point of view, it doesn't
even know when VM pressure will occur, so it can't possibly care.

> To get the answer for this question, I added some instrumentation code
> to ashmem_shrink function on top of the patch. I ran Android monkey
> tests with lot of memory hungry applications so as to hit the Low
> Memory situation more frequently. After running this for almost a day
> I did not see a situation where the shrinker did not have the mutex.
> In fact what I found is that (in this use case at-least) most of the
> time the "lru_count" is zero, which means the application has not
> unpinned the pages. So the shrinker has no job to do (basically
> shrink_slab does not call ashmem_shrinker second time). So worst case
> if we hit a scenario where the shrinker is called I'm sure the
> lru_count would be very low. So even if the shrinker returns without
> freeing them (because of unavailability of the lock) its not going to
> be costly.

That is expected. This race window is very, very small.

> After this experiment, I too think that this patch (returning from
> ashmem_shrink if the lock is not available) is good enough and does
> not seem to have any major side effects.
>
> PS: Any plans of submitting this patch formally?

Sure. Greg? :)

       Robert
