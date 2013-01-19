Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab3ASAj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 19:39:29 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:59229 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab3ASAj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 19:39:28 -0500
Date: Fri, 18 Jan 2013 16:39:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Dan Williams <djbw@fb.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHSET] async: reimplement synchronization
Message-ID: <20130119003923.GH24579@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

Synchronization in async got messy as more features were added and
while being converted to workqueue.  It currently has a global list of
pending async items and per-domain running lists.  Per-domain sync has
to search through the global pending list and global sync has to
iterate over all active registered domains.

This patchset reimplements async synchronization such that async items
stay on two pending lists - global and per-domain - the whole time
till completion, which simplifies both execution and synchronization.
There's no need to moving around items on execution and both domain
and global sync can look at the head of the list to determine the
lowest cookie in flight.

This patchset contains the following four patches.

 0001-async-bring-sanity-to-the-use-of-words-domain-and-ru.patch
 0002-async-use-ULLONG_MAX-for-infinity-cookie-value.patch
 0003-async-keep-pending-tasks-on-async_domain-and-remove-.patch
 0004-async-replace-list-of-active-domains-with-global-lis.patch

0001 is a prep patch.  0002 fixes a theoretical problem, which also
helps the reimplemntation.

0003-0004 reimplement synchronization.

This patch is on top of linus#master and "[PATCH] async: fix
__lowest_in_progress()"

  http://thread.gmane.org/gmane.linux.kernel/1420814/focus=1423758

Once the __lowest_in_progress() fix patch is merged, I can route this
series through a workqueue branch for 3.9.

diffstat follows.

 include/linux/async.h |    9 --
 kernel/async.c        |  151 ++++++++++++++++++--------------------------------
 2 files changed, 59 insertions(+), 101 deletions(-)

Thanks.

-- 
tejun
