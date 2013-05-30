Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388Ab3E3UAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 16:00:23 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:38313 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932824Ab3E3UAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 16:00:16 -0400
MIME-Version: 1.0
In-Reply-To: <2434dea05a7fda7e7ccf48f70124bd65f2556b2d.1369935749.git.aquini@redhat.com>
References: <2434dea05a7fda7e7ccf48f70124bd65f2556b2d.1369935749.git.aquini@redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Thu, 30 May 2013 15:59:53 -0400
X-Google-Sender-Auth: DYy9dhewkwVNIW2YxEjSdwEuj1s
Message-ID: <CAHGf_=qdow5GNHG+AQyfoKgga=Bqf5-x8ir4JmHrzaJs9pX2NQ@mail.gmail.com>
Subject: Re: [PATCH] swap: avoid read_swap_cache_async() race to deadlock
 while waiting on discard I/O compeletion
To: Rafael Aquini <aquini@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, shli@kernel.org,
        "riel@redhat.com" <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 30, 2013 at 2:05 PM, Rafael Aquini <aquini@redhat.com> wrote:
> read_swap_cache_async() can race against get_swap_page(), and stumble across
> a SWAP_HAS_CACHE entry in the swap map whose page wasn't brought into the
> swapcache yet. This transient swap_map state is expected to be transitory,
> but the actual placement of discard at scan_swap_map() inserts a wait for
> I/O completion thus making the thread at read_swap_cache_async() to loop
> around its -EEXIST case, while the other end at get_swap_page()
> is scheduled away at scan_swap_map(). This can leave the system deadlocked
> if the I/O completion happens to be waiting on the CPU workqueue where
> read_swap_cache_async() is busy looping and !CONFIG_PREEMPT.
>
> This patch introduces a cond_resched() call to make the aforementioned
> read_swap_cache_async() busy loop condition to bail out when necessary,
> thus avoiding the subtle race window.
>
> Signed-off-by: Rafael Aquini <aquini@redhat.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
