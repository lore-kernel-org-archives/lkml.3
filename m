Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab3EJQHX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 12:07:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:30328 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab3EJQHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 12:07:21 -0400
Message-ID: <518D1B16.9080904@oracle.com>
Date: Fri, 10 May 2013 12:06:46 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130429 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 7/9] liblockdep: Support using LD_PRELOAD
References: <1368115089-8909-1-git-send-email-sasha.levin@oracle.com> <1368115089-8909-8-git-send-email-sasha.levin@oracle.com> <20130510135716.GA304@dyad.programming.kicks-ass.net>
In-Reply-To: <20130510135716.GA304@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 09:57 AM, Peter Zijlstra wrote:
> So you're doing instance tracking and not creating classes like the kernel
> lockdep does? While that reduces false positives it also greatly reduces the
> effectiveness of lockdep.
> 
> The power of lock-classes is that it increases the chance of catching potential
> deadlocks without there ever actually being a deadlock.

Originally I had classes working as you've pointed out, until the first time I've
tried running lockdep on qemu.

They appear to have wrappers for every api call known to man, including all the
posix locking apis.

Basically, instead of directly calling pthread_mutex_lock() for example, there's
a wrapper named qemu_mutex_lock() that calls the api above:

	void qemu_mutex_lock(QemuMutex *mutex)
	{
	    int err;
	
	    err = pthread_mutex_lock(&mutex->lock);
	    if (err)
	        error_exit(err, __func__);
	}

So as you might imagine, the first time I ran it my log exploded with warnings.

I've poked around the source of other big projects, and the example above is
somewhat common with projects that wrap everything to be compatible with different
architectures or apis - which is something that doesn't happen in the kernel.


Thanks,
Sasha
