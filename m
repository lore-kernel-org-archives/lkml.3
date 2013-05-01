Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab3EAG2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 02:28:36 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:37411 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751769Ab3EAG2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 02:28:25 -0400
Message-ID: <5180B601.8080005@gmail.com>
Date: Wed, 01 May 2013 14:28:17 +0800
From: Will Huck <will.huckk@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Alexey Lyahkov <alexey.lyashkov@gmail.com>,
        Andrew Perepechko <anserper@ya.ru>, Robin Dong <sanbai@taobao.com>,
        Theodore Tso <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Bernd Schubert <bernd.schubert@fastmail.fm>,
        David Howells <dhowells@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux-ext4 <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC PATCH 0/3] Obey mark_page_accessed hint given by filesystems
References: <1367253119-6461-1-git-send-email-mgorman@suse.de>
In-Reply-To: <1367253119-6461-1-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,
On 04/30/2013 12:31 AM, Mel Gorman wrote:
> Andrew Perepechko reported a problem whereby pages are being prematurely
> evicted as the mark_page_accessed() hint is ignored for pages that are
> currently on a pagevec -- http://www.spinics.net/lists/linux-ext4/msg37340.html .
> Alexey Lyahkov and Robin Dong have also reported problems recently that
> could be due to hot pages reaching the end of the inactive list too quickly
> and be reclaimed.

Both shrink_active_list and shrink_inactive_list can call 
lru_add_drain(), why the hot pages can't be mark Actived during this time?

> Rather than addressing this on a per-filesystem basis, this series aims
> to fix the mark_page_accessed() interface by deferring what LRU a page
> is added to pagevec drain time and allowing mark_page_accessed() to call
> SetPageActive on a pagevec page. This opens some important races that
> I think should be harmless but needs double checking. The races and the
> VM_BUG_ON checks that are removed are all described in patch 2.
>
> This series received only very light testing but it did not immediately
> blow up and a debugging patch confirmed that pages are now getting added
> to the active file LRU list that would previously have been added to the
> inactive list.
>
>   fs/cachefiles/rdwr.c    | 30 ++++++------------------
>   fs/nfs/dir.c            |  7 ++----
>   include/linux/pagevec.h | 34 +--------------------------
>   mm/swap.c               | 61 ++++++++++++++++++++++++-------------------------
>   mm/vmscan.c             |  3 ---
>   5 files changed, 40 insertions(+), 95 deletions(-)
>

