Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698AbaA2UHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 15:07:03 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:42843 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaA2UHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 15:07:01 -0500
Date: Thu, 30 Jan 2014 00:06:57 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, perf, p4: Counter corruption when using lots of
 perf groups
Message-ID: <20140129200657.GJ29846@moon>
References: <1391024270-19469-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391024270-19469-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 02:37:50PM -0500, Don Zickus wrote:
> On a P4 box stressing perf with
> 
> ./perf record -o perf.data ./perf stat -v ./perf bench all
> 
> it was noticed that a slew of unknown NMIs would pop out rather quickly.
> 
> Painfully debugging this ancient platform, led me to notice cross cpu counter
> corruption.
> 
> The P4 machine is special in that it has 18 counters, half are used for cpu0
> and the other half is for cpu1 (or all 18 if hyperthreading is disabled).  But
> the splitting of the counters has to be actively managed by the software.
> 
> In this particular bug, one of the cpu0 specific counters was being used by
> cpu1 and caused all sorts of random unknown nmis.
> 
> I am not entirely sure on the corruption path, but what happens is:
> 
> o perf schedules a group with p4_pmu_schedule_events()
> o inside p4_pmu_schedule_events(), it notices an hwc pointer is being reused
>   but for a different cpu, so it 'swaps' the config bits and returns the
>   updated 'assign' array with a _new_ index.
> o perf schedules another group with p4_pmu_schedule_events()
> o inside p4_pmu_schedule_events(), it notices an hwc pointer is being reused
>   (the same one as above) but for the _same_ cpu [BUG!!], so it updates the
>   'assign' array to use the _old_ (wrong cpu) index because the _new_ index is in
>   an earlier part of the 'assign' array (and hasn't been committed yet).
> o perf commits the transaction using the wrong index and corrupts the other cpu

Thanks for the fix Don! I fear I won't be able to look precisely tonight, so
could it wait until tomorrow? (If it's critical sure such fix should do the
trick).
