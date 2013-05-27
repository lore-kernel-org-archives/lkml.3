Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab3E0I0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:26:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49343 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756974Ab3E0I0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:26:43 -0400
Message-ID: <51A318BF.7010109@canonical.com>
Date: Mon, 27 May 2013 10:26:39 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, x86@kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        robclark@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-media@vger.kernel.org,
        Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH v3 2/3] mutex: add support for wound/wait style locks,
 v3
References: <20130428165914.17075.57751.stgit@patser> <20130428170407.17075.80082.stgit@patser> <20130430191422.GA5763@phenom.ffwll.local> <519CA976.9000109@canonical.com> <20130522161831.GQ18810@twins.programming.kicks-ass.net> <519CFF56.90600@canonical.com> <20130527080019.GD2781@laptop>
In-Reply-To: <20130527080019.GD2781@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 27-05-13 10:00, Peter Zijlstra schreef:
> On Wed, May 22, 2013 at 07:24:38PM +0200, Maarten Lankhorst wrote:
>>>> +- Functions to only acquire a single w/w mutex, which results in the exact same
>>>> +  semantics as a normal mutex. These functions have the _single postfix.
>>> This is missing rationale.
>> trylock_single is useful when iterating over a list, and you want to evict a bo, but only the first one that can be acquired.
>> lock_single is useful when only a single bo needs to be acquired, for example to lock a buffer during mmap.
> OK, so given that its still early, monday and I haven't actually spend
> much time thinking on this; would it be possible to make:
> ww_mutex_lock(.ctx=NULL) act like ww_mutex_lock_single()?
>
> The idea is that if we don't provide a ctx, we'll get a different
> lockdep annotation; mutex_lock() vs mutex_lock_nest_lock(). So if we
> then go and make a mistake, lockdep should warn us.
>
> Would that work or should I stock up on morning juice?
>
It's easy to merge unlock_single and unlock, which I did in the next version I'll post.
Lockdep will already warn if ww_mutex_lock and ww_mutex_lock_single are both
used. ww_test_block_context and ww_test_context_block in lib/locking-selftest.c
are the testcases for this.

The locking paths are too different, it will end up with doing "if (ctx == NULL) mutex_lock(); else ww_mutex_lock();"

~Maarten

