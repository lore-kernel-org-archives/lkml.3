Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbaBDSmp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:42:45 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54398 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBDSmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:42:42 -0500
Date: Tue, 4 Feb 2014 19:41:50 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: David Daney <ddaney@caviumnetworks.com>,
        Ralf Baechle <ralf@linux-mips.org>
Cc: linux-arch@vger.kernel.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: mips octeon memory model questions
Message-ID: <20140204184150.GB5002@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have a number of questions in regards to commit 6b07d38aaa520ce.

Given that the octeon doesn't reorder reads; the following:

"      sync
       ll ...
       .
       .
       .
       sc ...
       .
       .
       sync

  The second SYNC was redundant, but harmless.  "

Still doesn't make sense, because if we need the first sync to stop
writes from being re-ordered with the ll-sc, we also need the second
sync to avoid the same.

Suppose:
   STORE a
   sync
   LL-SC b
   (not a sync)
   STORE c

What avoids this becoming visible as:

  a
  c
  b

?

Then there is:

"       syncw;syncw
        ll
        .
        .
        .
        sc
        .
        .

    Has identical semantics to the first sequence, but is much faster.
    The SYNCW orders the writes, and the SC will not complete successfully
    until the write is committed to the coherent memory system.  So at the
    end all preceeding writes have been committed.  Since Octeon does not
    do speculative reads, this functions as a full barrier."

Read Documentation/memory-barrier.txt:TRANSITIVITY, the above doesn't
sound like syncw is actually multi-copy atomic, and therefore doesn't
provide transitivity, and therefore is not a valid sequence for
operations that are supposed to imply a full memory-barrier.

Please as to explain.
