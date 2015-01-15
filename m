Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbbAOVC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 16:02:29 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:15663 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752534AbbAOVC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 16:02:28 -0500
To: akpm@linux-foundation.org, famz@redhat.com
Cc: normalperson@yhbt.net, nzimmer@sgi.com, viro@zeniv.linux.org.uk,
        davidel@xmailserver.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Message-Id: <cover.1421337657.git.jbaron@akamai.com>
From: Jason Baron <jbaron@akamai.com>
Subject: [RFC PATCH 0/5] Remove global locks from epoll
Date: Thu, 15 Jan 2015 21:02:27 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There are a number of 'global' locks taken in epoll. The first two patches
remove taking these in the poll() and wakeup paths, since we're already
preventing loops, and excessive wakeup paths during EPOLL_CTL_ADD. The
final 3 introduce the idea of breaking up the current global 'epmutex' by
keeping track of the files that make up a connected epoll set. In this way
we can limit locking to be within in a connected component as opposed to
the current design which limits things globally. This will mostly help
workloads that are doing deeper than 1 level epoll nesting (which may
that be that common), since we currently don't take the 'epmutex' for
EPOLL_CTL_ADD when there is only 1 level of nesting. However, we do eliminate
the global 'epmutex' from the close() path. There is more detail on this
in the patch descriptions.

One aspect that I'd like to improve is that these patches add a 'struct
list_head' and a pointer to the 'struct file', so essentially 3 pointers. I
think there are ways to reduce this (for example, by using single-link
lists where approriate), but I wanted to get general feedback on the approach
before attempting this.

Previous changes in this area showed really good improvements on SPECjbb,
see commit: 67347fe4e6326338ee217d7eb826bedf30b2e155. However, I don't think
that this patch series will improve things that much, as its mostly going
to help deeper epoll nesting setups. The motivation for these patches was that
it was bothering me that we were still taking some global locks in some
fairly hot paths (namely close()).

Patches are fairly lightly tested at this point (and need a lot more testing),
but I'm not aware of any outstanding issues.

Finally, I'd also like to potentially co-ordinate this series with the recent
syscall enhancements from Fam Zheng: http://lwn.net/Articles/628828/ since these
patches are somewhat invasive.

Thanks,

-Jason

Jason Baron (5):
  epoll: Remove ep_call_nested() from ep_eventpoll_poll()
  epoll: Remove ep_call_nested() from ep_poll_safewake()
  epoll: Add ep_call_nested_nolock()
  epoll: Allow topology checks to be parallelized
  epoll: Introduce epoll connected components (remove the epmutex)

 fs/eventpoll.c            | 596 +++++++++++++++++++++++++++++++---------------
 include/linux/eventpoll.h |  52 ++--
 include/linux/fs.h        |   3 +
 3 files changed, 442 insertions(+), 209 deletions(-)

-- 
1.8.2.rc2

