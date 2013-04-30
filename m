Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760663Ab3D3N3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 09:29:46 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:54076 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760460Ab3D3N3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 09:29:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAG6tG3wrHKTJBOu69XiV6BAPfvmK-QqJkBVpzkmkrLdLV5jRwQ@mail.gmail.com>
References: <CAJsYZ5kk=J_Sc7w5dbMbkWWv8dXEU0ojKjEKNqH=Q6Tf2f7mQg@mail.gmail.com>
	<20130422142218.GA26760@mwanda>
	<CAG6tG3xc3RHD7sZXaEbg1vLRhFj+6d1wY=us4BfxBfi5y0o4zg@mail.gmail.com>
	<CAJsYZ5nQg9g73r5yLicq6gAGbKEXVAFqtF2av=heeNtrNSPSWg@mail.gmail.com>
	<CAG6tG3zcOdkA5QOBhaDzmMvcFSCwbfRAyKuRwXdn6ipOJhTVZQ@mail.gmail.com>
	<CAJsYZ5mpukCM6TpFb27tJt6G7ZufugEP4kx8wzGxhRwAO46cCw@mail.gmail.com>
	<CAG6tG3wrHKTJBOu69XiV6BAPfvmK-QqJkBVpzkmkrLdLV5jRwQ@mail.gmail.com>
Date: Tue, 30 Apr 2013 18:59:44 +0530
Message-ID: <CAJsYZ5kchksgObAS66T5b-4VPrjp4Mhn4HG0DHyWBgRXib3JTw@mail.gmail.com>
Subject: Re: [BUG] staging: android: ashmem: Deadlock during ashmem_shrink
From: Shankar Brahadeeswaran <shankoo77@gmail.com>
To: Robert Love <rlove@google.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, devel@driverdev.osuosl.org,
        Hugh Dickins <hughd@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anjana V Kumar <anjanavk12@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Robert,
Thanks for the patch. In the first email in this thread I was
proposing the same solution and had asked whether doing this has any
side effects.
That is how this discussion started. I did some experiments and have
got the answers for that. Just for every ones benefit I've re-worded
the question again
and put the details of the experiment below.

Question:
On occasions when we return because of the lock unavailability, what
could be the worst case number of ashmem pages that are left
unfreed (lru_count). Will it be very huge and have side effects?

To get the answer for this question, I added some instrumentation code
to ashmem_shrink function on top of the patch. I ran Android monkey
tests with lot of memory hungry applications so as to hit the Low
Memory situation more frequently. After running this for almost a day
I did not see a situation where the shrinker did not have the mutex.
In fact what I found is that (in this use case at-least) most of the
time the "lru_count" is zero, which means the application has not
unpinned the pages. So the shrinker has no job to do (basically
shrink_slab does not call ashmem_shrinker second time). So worst case
if we hit a scenario where the shrinker is called I'm sure the
lru_count would be very low. So even if the shrinker returns without
freeing them (because of unavailability of the lock) its not going to
be costly.

After this experiment, I too think that this patch (returning from
ashmem_shrink if the lock is not available) is good enough and does
not seem to have any major side effects.

PS: Any plans of submitting this patch formally?

Warm Regards,
Shankar
