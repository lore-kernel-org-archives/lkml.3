Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934952Ab3GSAv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 20:51:29 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:41473 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933027Ab3GSAv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 20:51:27 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 18 Jul 2013 17:51:06 -0700
Message-ID: <CALCETrVXzXLqvB+S6BMXuFbVGftg5Kwk+fGe1=w1G9S67S_ivA@mail.gmail.com>
Subject: MAP_HUGETLB and MPOL_PREFERRED = SIGBUS
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I mmap anonymous hugepages with MAP_HUGETLB and there are
available (pre-reserved) hugepages available, but only on the wrong
node, things blow up.  The mmap succeeds, as it should (the accounting
here is wrong -- known issue AFAIK, but that's only relevant to
MPOL_BIND or cpusets).  But writing to the resulting page causes a
SIGBUS.

AFAICS the issue is that dequeue_huge_page_vma is calling
huge_zonelist, which returns a single-entry nodemask.  The loop over
allowable zones* will never try other numa zones, and the function
fails.

I'm not sure whether it would be better to try other nodes first or to
try get get a page from the buddy allocator on the preferred node
first, but currently the other nodes' reserved lists are never
checked.  The result is a crash.

Working around this in userspace is going to be a real PITA.  Grr.

* Why is this iterating zones instead of nodes?

--Andy
