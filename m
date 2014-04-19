Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191AbaDSGzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 02:55:22 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:10793 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaDSGzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 02:55:21 -0400
Message-ID: <1397890512.19331.21.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc/shm: Increase the defaults for SHMALL, SHMMAX to
 infinity
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, gthelen@google.com,
        aswin@hp.com, linux-mm@kvack.org, mtk.manpages@gmail.com
Date: Fri, 18 Apr 2014 23:55:12 -0700
In-Reply-To: <1397812720-5629-1-git-send-email-manfred@colorfullife.com>
References: <1397812720-5629-1-git-send-email-manfred@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-18 at 11:18 +0200, Manfred Spraul wrote:
> System V shared memory
> 
> a) can be abused to trigger out-of-memory conditions and the standard
>    measures against out-of-memory do not work:
> 
>     - it is not possible to use setrlimit to limit the size of shm segments.
> 
>     - segments can exist without association with any processes, thus
>       the oom-killer is unable to free that memory.
> 
> b) is typically used for shared information - today often multiple GB.
>    (e.g. database shared buffers)
> 
> The current default is a maximum segment size of 32 MB and a maximum total
> size of 8 GB. This is often too much for a) and not enough for b), which
> means that lots of users must change the defaults.
> 
> This patch increases the default limits to ULONG_MAX, which is perfect for
> case b). The defaults are used after boot and as the initial value for
> each new namespace.
> 
> Admins/distros that need a protection against a) should reduce the limits
> and/or enable shm_rmid_forced.
> 
> Further notes:
> - The patch only changes the boot time default, overrides behave as before:
> 	# sysctl kernel/shmall=33554432
>   would recreate the previous limit for SHMMAX (for the current namespace).
> 
> - Disabling sysv shm allocation is possible with:
> 	# sysctl kernel.shmall=0
>   (not a new feature, also per-namespace)
> 
> - ULONG_MAX is not really infinity, but 18 Exabyte segment size and
>   75 Zettabyte total size. This should be enough for the next few weeks.
>   (assuming a 64-bit system with 4k pages)
> 
> Risks:
> - The patch breaks installations that use "take current value and increase
>   it a bit". [seems to exist, http://marc.info/?l=linux-mm&m=139638334330127]

This really scares me. The probability of occurrence is now much higher,
and not just theoretical. It would legitimately break userspace.

