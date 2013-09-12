Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab3ILUs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:48:27 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:55855 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756609Ab3ILUsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:48:25 -0400
Message-ID: <5232288F.4070904@vmware.com>
Date: Thu, 12 Sep 2013 22:48:15 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Peter Zijlstra <peterz@infradead.org>, Dave Airlie <airlied@linux.ie>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [BUG] completely bonkers use of set_need_resched + VM_FAULT_NOPAGE
References: <20130912150645.GZ31370@twins.programming.kicks-ass.net> <CAKMK7uFF2GkYapa2_DLv4WYAd0t+POaT+Vy9HG=HQhzMmtH9nA@mail.gmail.com> <20130912154329.GB31370@twins.programming.kicks-ass.net> <CAKMK7uFTYB-E5ksVNEBqGJusJ5TKJv5X4hiPv1mno9tJKuUAdA@mail.gmail.com> <20130912162210.GE31370@twins.programming.kicks-ass.net> <CAKMK7uGsgYOtKQrCoq26RV9a_8na14sbpanUxM2_3EBwz-3vVw@mail.gmail.com> <alpine.DEB.2.02.1309122157300.4089@ionos.tec.linutronix.de> <CAKMK7uHJansZzKxrr8p0c2X5pEeb-BSxLa6=tnsDmwo-k__Xcg@mail.gmail.com> <alpine.DEB.2.02.1309122219370.4089@ionos.tec.linutronix.de> <CAKMK7uHqufs64=pD=o--958Ns+NAsrwUTNpcd2_WGQnoJRnfOQ@mail.gmail.com> <alpine.DEB.2.02.1309122238430.4089@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1309122238430.4089@ionos.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 10:39 PM, Thomas Gleixner wrote:
> On Thu, 12 Sep 2013, Daniel Vetter wrote:
>
>> On Thu, Sep 12, 2013 at 10:20 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>>>> I think for ttm drivers it's just execbuf being exploitable. But on
>>>> drm/i915 we've
>>>> had the same issue with the pwrite/pread ioctls, so a simple
>>>> glBufferData(glMap) kind of recursion from gl clients blew the kernel
>>>> to pieces ...
>>> And the only answer you folks came up with is set_need_resched() and
>>> yield()? Oh well....
>> The yield was for a different lifelock, and that one is also fixed by
>> now. The fault handler deadlock was fixed in the usual "drop locks and
>> jump into slowpath" fasion, at least in drm/i915.
> So we can remove that whole yield/set_need_resched() mess completely ?
>
> Thanks,
>
> 	tglx
No.

The while(trylock) is there to address a potential locking inversion 
deadlock. If the trylock fails, the code returns to user-space which 
retries the fault. This code needs to stay until we can come up with 
either a way to drop the mmap_sem and sleep before returning to 
user-space, or a bunch of code is fixed with a different locking order.

The set_need_resched() can (and should according to Peter) go.

/Thomas
