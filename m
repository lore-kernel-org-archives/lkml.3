Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbaEVXtD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:49:03 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:60639 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430AbaEVXtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:49:01 -0400
MIME-Version: 1.0
In-Reply-To: <1400233673-11477-1-git-send-email-vbabka@suse.cz>
References: <1399904111-23520-1-git-send-email-vbabka@suse.cz>
	<1400233673-11477-1-git-send-email-vbabka@suse.cz>
Date: Thu, 22 May 2014 16:49:00 -0700
Message-ID: <CAGa+x87-NRyK6kUiXNL_bRNEGm+DR6M3HPSLYEoq4t6Nrtnd_g@mail.gmail.com>
Subject: Re: [PATCH v2] mm, compaction: properly signal and act upon lock and
 need_sched() contention
From: Kevin Hilman <khilman@linaro.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Greg Thelen <gthelen@google.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 2:47 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
> Compaction uses compact_checklock_irqsave() function to periodically check for
> lock contention and need_resched() to either abort async compaction, or to
> free the lock, schedule and retake the lock. When aborting, cc->contended is
> set to signal the contended state to the caller. Two problems have been
> identified in this mechanism.

This patch (or later version) has hit next-20140522 (in the form
commit 645ceea9331bfd851bc21eea456dda27862a10f4) and according to my
bisect, appears to be the culprit of several boot failures on ARM
platforms.

Unfortunately, there isn't much useful in the logs of the boot
failures/hangs since they mostly silently hang.  However, on one
platform (Marvell Armada 370 Mirabox), it reports a failure to
allocate memory, and the RCU stall detection kicks in:

[    1.298234] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    1.303485] xhci_hcd 0000:02:00.0: new USB bus registered, assigned
bus number 1
[    1.310966] xhci_hcd 0000:02:00.0: Couldn't initialize memory
[   22.245395] INFO: rcu_sched detected stalls on CPUs/tasks: {}
(detected by 0, t=2102 jiffies, g=-282, c=-283, q=16)
[   22.255886] INFO: Stall ended before state dump start
[   48.095396] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s!
[swapper/0:1]

Reverting this commit makes them all happy again.

Kevin
