Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab3DBO5K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:57:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55630 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760714Ab3DBO5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:57:09 -0400
Message-ID: <515AF1C1.7080508@canonical.com>
Date: Tue, 02 Apr 2013 16:57:05 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        daniel.vetter@ffwll.ch, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, tglx@linutronix.de, mingo@elte.hu,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v2 2/3] mutex: add support for reservation style locks,
 v2
References: <20130228102452.15191.22673.stgit@patser>  <20130228102502.15191.14146.stgit@patser> <1364900432.18374.24.camel@laptop>
In-Reply-To: <1364900432.18374.24.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Thanks for reviewing.

Op 02-04-13 13:00, Peter Zijlstra schreef:
> On Thu, 2013-02-28 at 11:25 +0100, Maarten Lankhorst wrote:
>> +Reservation type mutexes
>> +struct ticket_mutex {
>> +extern int __must_check _mutex_reserve_lock(struct ticket_mutex *lock,
> That's two different names and two different forms of one (for a total
> of 3 variants) for the same scheme.
>
> FAIL...
It's been hard since I haven't seen anything similar in the kernel, I originally went with tickets
since that's what ttm originally called it, and tried to kill as many references as I could
when I noticed ticket mutexes already being taken.

I'll fix up the ticket_mutex -> reservation_mutex, and mutex_reserve_* -> reserve_mutex_*

> On Thu, 2013-02-28 at 11:25 +0100, Maarten Lankhorst wrote:
>> +mutex_reserve_lock_slow and mutex_reserve_lock_intr_slow:
>> +  Similar to mutex_reserve_lock, except it won't backoff with
>> -EAGAIN.
>> +  This is useful when mutex_reserve_lock failed with -EAGAIN, and you
>> +  unreserved all reservation_locks so no deadlock can occur.
>> +
> I don't particularly like these function names, with lock
> implementations the _slow post-fix is typically used for slow path
> implementations, not API type interfaces.
 I didn't intend for drivers to use the new calls directly, but rather through a wrapper,
for example by ttm_eu_reserve_buffers in drivers/gpu/drm/ttm/ttm_execbuf_util.c

> Also, is there anything in CS literature that comes close to this? I'd
> think the DBMS people would have something similar with their
> transactional systems. What do they call it?
I didn't study cs, but judging from your phrasing I guess you mean you want me to call it transaction_mutexes instead?

> Head hurts, needs more time to ponder. It would be good if someone else
> (this would probably be you maarten) would also consider this and
> explore
> this 'interesting' problem space :-)
My head too, evil priority stuff!

Hacky but pragmatical workaround for now: use a real mutex around all the reserve_mutex_lock* calls instead of a virtual lock.
It can be unlocked as soon as all locks have been taken, before any actual work is done.

It only slightly kills the point of having a reservation in the first place, but at least it won't break completely -rt completely for now.

~Maarten

