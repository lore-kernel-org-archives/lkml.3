Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab3GZVO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:14:57 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52715 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979Ab3GZVOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:14:51 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 0/5] Add rbtree postorder iteration functions, runtime tests, and update zswap to use.
Date: Fri, 26 Jul 2013 14:13:38 -0700
Message-Id: <1374873223-25557-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072621-4834-0000-0000-000009717691
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Postorder iteration yields all of a node's children prior to yielding the node
itself, and this particular implementation also avoids examining the leaf links
in a node after that node has been yielded.

In what I expect will be it's most common usage, postorder iteration allows the
deletion of every node in an rbtree without modifying the rbtree nodes (no
_requirement_ that they be nulled) while avoiding referencing child nodes after
they have been "deleted" (most commonly, freed).

I have only updated zswap to use this functionality at this point, but numerous
bits of code (most notably in the filesystem drivers) use a hand rolled
postorder iteration that NULLs child links as it traverses the tree. Each of
those instances could be replaced with this common implementation.

Cody P Schafer (5):
  rbtree: add postorder iteration functions.
  rbtree: add rbtree_postorder_for_each_entry_safe() helper.
  rbtree_test: add test for postorder iteration.
  rbtree: allow tests to run as builtin
  mm/zswap: use postorder iteration when destroying rbtree

 include/linux/rbtree.h | 21 +++++++++++++++++++++
 lib/Kconfig.debug      |  2 +-
 lib/rbtree.c           | 40 ++++++++++++++++++++++++++++++++++++++++
 lib/rbtree_test.c      | 12 ++++++++++++
 mm/zswap.c             | 15 ++-------------
 5 files changed, 76 insertions(+), 14 deletions(-)

-- 
1.8.3.4

