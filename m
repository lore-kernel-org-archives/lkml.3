Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab3IXRyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 13:54:05 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:48286 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753032Ab3IXRyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 13:54:02 -0400
Message-ID: <5241D1B5.90707@vmware.com>
Date: Tue, 24 Sep 2013 19:53:57 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [RFC PATCH] drm/nouveau: fix nested locking in mmap handler
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net> <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com> <5231E18D.7070306@canonical.com> <5231EF5A.7010901@vmware.com> <52323734.4070908@canonical.com> <5232B44C.9010408@vmware.com> <5232BBE1.5030509@canonical.com> <5232C2BB.9070303@vmware.com> <20130913082933.GH31370@twins.programming.kicks-ass.net> <CAKMK7uHh_pKh1JpQ_nA7gvWMUsvQoTKAcBXpdcwpVGSddHE9mQ@mail.gmail.com> <20130913090000.GJ31370@twins.programming.kicks-ass.net> <52405F3E.4000609@canonical.com> <52413DA9.4050000@vmware.com> <5241409B.6010102@canonical.com> <52415569.6020602@vmware.com> <52415EDD.6030508@canonical.com>
In-Reply-To: <52415EDD.6030508@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 11:43 AM, Maarten Lankhorst wrote:
> Op 24-09-13 11:03, Thomas Hellstrom schreef:
>> On 09/24/2013 09:34 AM, Maarten Lankhorst wrote:
>>> Op 24-09-13 09:22, Thomas Hellstrom schreef:
>>>> Actually, it's not the locking order bo:reserve -> mmap_sem that triggers the lockdep warning, right? but the fact that copy_from_user could recurse into the fault handler? Grabbing bo:reseves recursively? which should leave us free to choose locking order at this point.
>>> Same thing.
>>>
>>> When PROVE_LOCKING is enabled the might_fault calls in copy_to/from_user do a fake locking of mmap_sem, which means all locking errors, provided that the reservation lock is taken at least once with mmap_sem held (eg the ttm fault handler is called at least once, it can be done separately, it doesn't need to be done in the same syscall). So any bugs will be found. The only thing to worry about is that lockdep turns off after finding 1 error, so you have to make sure it doesn't bomb out before completing tests, which is sometimes a problem on early rc kernels. ;)
>> My point was that when we only have copy_[to|from]_user_inatomic inside any bo:reservations, the might_fault would never be called inside any reservations and we should, in principle, be free to choose locking order, provided of course it could be done cleanly in fault()?
> I think it makes sense to keep mmap_sem the outer lock here, and not do scary things in fault. Especially if the mm locking is going to be changed in the future. But you're correct, if holding reservations only inatomic should be used.
>
> ~Maarten

Now that we after all were forced to enter the dark realm of copy-user 
slowpaths, I don't really have a strong opinion anymore, other than that 
we should try to avoid building too much code in that depends on either 
locking order, so that we could change it if _really_ needed.

/Thomas
