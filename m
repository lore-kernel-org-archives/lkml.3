Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab3CTPiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:38:06 -0400
Received: from mail-ia0-f177.google.com ([209.85.210.177]:53844 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3CTPiE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:38:04 -0400
MIME-Version: 1.0
Date: Wed, 20 Mar 2013 21:08:03 +0530
Message-ID: <CAJsYZ5ksvPCR2O39=sj9zeptfppP1w6FM08rw8Aw+L+2dEPCnQ@mail.gmail.com>
Subject: [BUG] staging: android: ashmem: Deadlock during ashmem_mmap and ashmem_read
From: Shankar Brahadeeswaran <shankoo77@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg, Dan,

Few days back I posted a patch to fix a dead lock issue in the ashmem
driver that got merged in staging-next branch
https://lkml.org/lkml/2013/2/20/429

I'm seeing that there exists another path in the ashmem driver that
could lead to the similar issue. But this time I'm unable to think of
a way to fix the problem.

- The objects involved in the deadlock are same, mmap->sem and ashmem_mutex
- Assume that there are two threads T1 and T2 that belong to the same
process space, so they’ll share the mm struct, call it “mm”
- In the context of T1 ashmem_mmap is called
        - Now within the kernel this takes the mmap_sem and sleeps
before it acquires the ashmem_mutex
- Thread T2 runs and calls ashmem_read
         - It takes the ashmem_mutex and invokes file->f_op->read,
which eventually calls file_read_actor
          - The call stack is as below
             ashmem_read (acquires ahsmem_mutex) --> f_op->read -->
do_sync_read -->shmem_file_aio_read --> file_read_actor
          - There is a copy_to_user call in this function
file_read_actor (mm/filemap.c).
          - Now, if there is no physical page allocated for the
address passed from the user space, this copy_to_user would lead to
do_DataAbort --> do_page_fault
          - From do_page_fault it tries to get mmap_sem, but its not
available and is with T1, so waits for the mmap_sem holding
ashmem_mutex
- Thread 1 resumes and tries to acquire the ashmem_mutex (from
ashmem_mmap), which is with T2 and waits.
-  Now we have entered a situation where T1 holds the mmap_sem and
waits for T2 to release ashmem_mutex, while T2 holds the ashmem_mutex
and waits for T1 to release the mmap_sem

Since I'm not very familiar with ashmem_read code flow, not sure on
how to fix this. When I look at things in isolation it all looks OK.
The mmap_sem acquisition from mm/mmap.c and do_page_fault is obvious
no doubts there
ashmem_mutex is the ashmem driver's  lock, so all the driver functions
should hold this to maintain consistency of its data structures
So, i'm not seeing anything wrong in holding this in ashmem_read and
ashmem_mmap. But not sure whether its OK to call the VFS layer call
from ashmem_read.
I'm not aware of the ashmem driver's design goal and what the
developer had in mind while writing this function, so not sure about
any alternate approach.

Really appreciate any suggestions/guidance on how to go about fixing
this problem.

Warm regards,
Shankar
