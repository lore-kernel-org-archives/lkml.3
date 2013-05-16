Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3EPUe3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:34:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:61512 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780Ab3EPUe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:34:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,686,1363158000"; 
   d="scan'208";a="314843356"
Subject: [RFCv2][PATCH 0/5] mm: Batch page reclamation under shink_page_list
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mgorman@suse.de,
        tim.c.chen@linux.intel.com, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Thu, 16 May 2013 13:34:27 -0700
Message-Id: <20130516203427.E3386936@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are an update of Tim Chen's earlier work:

	http://lkml.kernel.org/r/1347293960.9977.70.camel@schen9-DESK

I broke the patches up a bit more, and tried to incorporate some
changes based on some feedback from Mel and Andrew.

Changes for v2:
 * use page_mapping() accessor instead of direct access
   to page->mapping (could cause crashes when running in
   to swap cache pages.
 * group the batch function's introduction patch with
   its first use
 * rename a few functions as suggested by Mel
 * Ran some single-threaded tests to look for regressions
   caused by the batching.  If there is overhead, it is only
   in the worst-case scenarios, and then only in hundreths of
   a percent of CPU time.

If you're curious how effective the batching is, I have a quick
and dirty patch to keep some stats:

	https://www.sr71.net/~dave/intel/rmb-stats-only.patch

--

To do page reclamation in shrink_page_list function, there are
two locks taken on a page by page basis.  One is the tree lock
protecting the radix tree of the page mapping and the other is
the mapping->i_mmap_mutex protecting the mapped pages.  This set
deals only with mapping->tree_lock.

Tim managed to get 14% throughput improvement when with a workload
putting heavy pressure of page cache by reading many large mmaped
files simultaneously on a 8 socket Westmere server.

I've been testing these by running large parallel kernel compiles
on systems that are under memory pressure.  During development,
I caught quite a few races on smaller setups, and it's being
quite stable that large (160 logical CPU / 1TB) system.
