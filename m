Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162Ab3LQAR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 19:17:59 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:56481 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3LQAR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 19:17:57 -0500
MIME-Version: 1.0
In-Reply-To: <1387229564-19517-4-git-send-email-john.stultz@linaro.org>
References: <1387229564-19517-1-git-send-email-john.stultz@linaro.org>
	<1387229564-19517-4-git-send-email-john.stultz@linaro.org>
Date: Mon, 16 Dec 2013 16:17:57 -0800
X-Google-Sender-Auth: XUrhZeOvUIVRiKpuoFUDQbUCX90
Message-ID: <CAMbhsRQOWKWBjQJWndr57Cz_Xf0EeU8jNMJOyiOEBHFRf=Tt=Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/3] staging: ion: Avoid using rt_mutexes directly.
From: Colin Cross <ccross@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 1:32 PM, John Stultz <john.stultz@linaro.org> wrote:
> RT_MUTEXES can be configured out of the kernel, causing compile
> problems with ION.
>
> Since there is no documentation as to why directly using rt_mutexes
> is necessary (and very few drivers directly use rt_mutexes), simply
> convert the ion_heap lock to a normal mutex.

rt_mutexes were added with the deferred freeing feature.  Heaps need
to return zeroed memory to userspace, but zeroing the memory on every
allocation was causing performance issues.  We added a SCHED_IDLE
thread to zero memory in the background after freeing, but locking the
heap from the SCHED_IDLE thread might block a high priority allocation
thread for a long time.

The lock is only used to protect the heap's free_list and
free_list_size members, and is not held for any long or sleeping
operations.  Converting to a spinlock should prevent priority
inversion without using the rt_mutex.  I'd also rename it to free_lock
to so it doesn't get used as a general heap lock.
