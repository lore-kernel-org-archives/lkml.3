Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177AbaCMUEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 16:04:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678AbaCMUEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 16:04:24 -0400
Date: Thu, 13 Mar 2014 16:03:52 -0400
From: Don Zickus <dzickus@redhat.com>
To: peterz@infradead.org
Cc: eranian@google.com, jmario@redhat.com, jolsa@redhat.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, lwoodman@redhat.com
Subject: perf MMAP2 interface and COW faults
Message-ID: <20140313200352.GU25953@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

So we found another corner case with MMAP2 interface.  I don't think it is
a big hurdle to overcome, just wanted a suggestion.

Joe ran specjbb2013 (which creates about 10,000 java threads across 9
processes) and our c2c tool turned up some cacheline collision data on
libjvm.so.  This didn't make sense because you shouldn't be able to write
to a shared library.

Even worse, our tool said it affected all the java process and a majority
of the threads.  Which again didn't make sense because this shared library
should be local to each pid's memory.

Anyway, what we determined is that the shared library had mmap data that
was non-zero (because it was backed by a file, libjvm.so).  So the
assumption was if the major, minor, inode and inode generation numbers
were non-zero, this memory segment was shared across processes.

So perf setup its map files for the mmap area and then started sampling data
addresses.  A few hundred HITMs were to a virtual address that fell into
the libjvm.so memory segment (which was assumed to be mmap'd across
processes).

Coalescing all the data suggested that multiple pids/tids were contending
for a cacheline in a shared library.

After talking with Larry Woodman, we realized when you write to a 'data' or
'bss' segment of a shared library, you incur a COW fault that maps to an
anonymous page in the pid's memory.  However, perf doesn't see this.

So when all the tids start writing to this 'data' or 'bss' segment they
generate HITMs within their pid (which is fine).  However the tool thinks
it affects other pids (which is not fine).

My question is, how can our tool determine if a virtual address is private
to a pid or not?  Originally it had to have a zero for maj, min, ino, and
ino gen.  But for file map'd libraries this doesn't always work because we
don't see COW faults in perf (and we may not want too :-) ).

Is there another technique we can use?  Perhaps during the reading of
/proc/<pid>/maps, if the protection is marked 'p' for private, we just tell
the sort algorithm to sort locally to the process but a 's' for shared can
be sorted globally based on data addresses?

Or something else that tells us that a virtual address has changed its
mapping?  Thoughts?

Cheers,
Don
