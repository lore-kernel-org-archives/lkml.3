Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab3I3WZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 18:25:38 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:29927 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755920Ab3I3WZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 18:25:37 -0400
To: akpm@linux-foundation.org
Cc: normalperson@yhbt.net, nzimmer@sgi.com, viro@zeniv.linux.org.uk,
        nelhage@nelhage.com, davidel@xmailserver.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-Id: <cover.1380577995.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH 0/3] epoll: reduce 'epmutex' lock contention
Date: Mon, 30 Sep 2013 22:25:36 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Nathan Zimmer found that once we get over 10+ cpus, the scalability of
SPECjbb falls over due to the contention on the global 'epmutex', which
is taken in on EPOLL_CTL_ADD and EPOLL_CTL_DEL operations.

Patch #1 removes the 'epmutex' lock completely from the EPOLL_CTL_DEL path by
using rcu to guard against any concurrent traversals.

Patch #2 remove the 'epmutex' lock from EPOLL_CTL_ADD operations for simple
topologies. IE when adding a link from an epoll file descriptor to a wakeup
source, where the epoll file descriptor is not nested.

Patch #3, restores the size of 'struct epitem' to <= 128 bytes, which was
broken in Patch #1. Its a bit hacky, so I decided to break it out as a separate
patch for review purposes.

Performance of SPECjbb improves considerably. From Nathan Zimmer's testing.
Thread: http://marc.info/?l=linux-kernel&m=137908766013329&w=2

"
On the 16 socket run the performance went from 35k jOPS to 125k jOPS.
In addition the benchmark when from scaling well on 10 sockets to scaling well
on just over 40 sockets.

I should also note there system responsiveness of various commands was quite
improved when under the full load of the benchmark.
...


Currently the benchmark stops scaling at around 40-44 sockets but it seems like
I found a second unrelated bottleneck.
"

Jason Baron (3):
  epoll: optimize EPOLL_CTL_DEL using rcu
  epoll: Do not take global 'epmutex' for simple topologies
  epoll: restore 'struct epitem' size

 fs/eventpoll.c | 150 ++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 105 insertions(+), 45 deletions(-)

-- 
1.8.2

