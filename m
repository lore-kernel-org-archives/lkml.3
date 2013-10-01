Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248Ab3JARJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:09:07 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:11662 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751764Ab3JARII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:08:08 -0400
To: akpm@linux-foundation.org
Cc: normalperson@yhbt.net, nzimmer@sgi.com, viro@zeniv.linux.org.uk,
        nelhage@nelhage.com, davidel@xmailserver.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-Id: <cover.1380645717.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH 0/2 v2] epoll: reduce 'epmutex' lock contention
Date: Tue,  1 Oct 2013 17:08:07 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Updated series, using a 'union' for the rcu callback.

Nathan Zimmer found that once we get over 10+ cpus, the scalability of
SPECjbb falls over due to the contention on the global 'epmutex', which
is taken in on EPOLL_CTL_ADD and EPOLL_CTL_DEL operations.

Patch #1 removes the 'epmutex' lock completely from the EPOLL_CTL_DEL path by
using rcu to guard against any concurrent traversals.

Patch #2 remove the 'epmutex' lock from EPOLL_CTL_ADD operations for simple
topologies. IE when adding a link from an epoll file descriptor to a wakeup
source, where the epoll file descriptor is not nested.

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

Thanks,

-Jason

Changes in v2:
-use a union for rcu callback and drop patch #3

v1:
http://marc.info/?l=linux-kernel&m=138057995316598&w=2

Jason Baron (2):
  epoll: optimize EPOLL_CTL_DEL using rcu
  epoll: Do not take global 'epmutex' for simple topologies

 fs/eventpoll.c | 153 +++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 106 insertions(+), 47 deletions(-)

-- 
1.8.2

