Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212Ab3D2Qcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 12:32:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54662 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757497Ab3D2Qca (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 12:32:30 -0400
From: Mel Gorman <mgorman@suse.de>
To: Alexey Lyahkov <alexey.lyashkov@gmail.com>,
        Andrew Perepechko <anserper@ya.ru>, Robin Dong <sanbai@taobao.com>
Cc: Theodore Tso <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Bernd Schubert <bernd.schubert@fastmail.fm>,
        David Howells <dhowells@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux-ext4 <linux-ext4@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [RFC PATCH 0/3] Obey mark_page_accessed hint given by filesystems
Date: Mon, 29 Apr 2013 17:31:56 +0100
Message-Id: <1367253119-6461-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Perepechko reported a problem whereby pages are being prematurely
evicted as the mark_page_accessed() hint is ignored for pages that are
currently on a pagevec -- http://www.spinics.net/lists/linux-ext4/msg37340.html .
Alexey Lyahkov and Robin Dong have also reported problems recently that
could be due to hot pages reaching the end of the inactive list too quickly
and be reclaimed.

Rather than addressing this on a per-filesystem basis, this series aims
to fix the mark_page_accessed() interface by deferring what LRU a page
is added to pagevec drain time and allowing mark_page_accessed() to call
SetPageActive on a pagevec page. This opens some important races that
I think should be harmless but needs double checking. The races and the
VM_BUG_ON checks that are removed are all described in patch 2.

This series received only very light testing but it did not immediately
blow up and a debugging patch confirmed that pages are now getting added
to the active file LRU list that would previously have been added to the
inactive list.

 fs/cachefiles/rdwr.c    | 30 ++++++------------------
 fs/nfs/dir.c            |  7 ++----
 include/linux/pagevec.h | 34 +--------------------------
 mm/swap.c               | 61 ++++++++++++++++++++++++-------------------------
 mm/vmscan.c             |  3 ---
 5 files changed, 40 insertions(+), 95 deletions(-)

-- 
1.8.1.4

