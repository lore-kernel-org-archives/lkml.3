Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375Ab3EGVT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 17:19:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:3907 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820Ab3EGVTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 17:19:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,629,1363158000"; 
   d="scan'208";a="330482062"
Subject: [RFC][PATCH 0/7] mm: Batch page reclamation under shink_page_list
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mgorman@suse.de,
        tim.c.chen@linux.intel.com, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 07 May 2013 14:19:54 -0700
Message-Id: <20130507211954.9815F9D1@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are an update of Tim Chen's earlier work:

	http://lkml.kernel.org/r/1347293960.9977.70.camel@schen9-DESK

I broke the patches up a bit more, and tried to incorporate some
changes based on some feedback from Mel and Andrew.

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
