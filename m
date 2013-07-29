Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab3G2TTo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:19:44 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39280 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753103Ab3G2TTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:19:42 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 0/5] Add rbtree postorder iteration functions, runtime tests, and update zswap to use
Date: Mon, 29 Jul 2013 12:19:25 -0700
Message-Id: <1375125570-9401-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072919-5806-0000-0000-0000223A17D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Postorder iteration yields all of a node's children prior to yielding the node
itself, and this particular implementation also avoids examining the leaf links
in a node after that node has been yielded.

In what I expect will be its most common usage, postorder iteration allows the
deletion of every node in an rbtree without modifying the rbtree nodes (no
_requirement_ that they be nulled) while avoiding referencing child nodes after
they have been "deleted" (most commonly, freed).

I have only updated zswap to use this functionality at this point, but numerous
bits of code (most notably in the filesystem drivers) use a hand rolled
postorder iteration that NULLs child links as it traverses the tree. Each of
those instances could be replaced with this common implementation.

1 & 2 add rbtree postorder iteration functions.
3 adds testing of the iteration to the rbtree runtime tests
4 allows building the rbtree runtime tests as builtins
5 updates zswap.

--
since v1:
	- spacing
	- s/it's/its/
	- remove now unused var in zswap code.
	- Reviewed-by: Seth Jennings <sjenning@linux.vnet.ibm.com>


Cody P Schafer (5):
  rbtree: add postorder iteration functions
  rbtree: add rbtree_postorder_for_each_entry_safe() helper
  rbtree_test: add test for postorder iteration
  rbtree: allow tests to run as builtin
  mm/zswap: use postorder iteration when destroying rbtree

 include/linux/rbtree.h | 22 ++++++++++++++++++++++
 lib/Kconfig.debug      |  2 +-
 lib/rbtree.c           | 40 ++++++++++++++++++++++++++++++++++++++++
 lib/rbtree_test.c      | 12 ++++++++++++
 mm/zswap.c             | 16 ++--------------
 5 files changed, 77 insertions(+), 15 deletions(-)

-- 
1.8.3.4

