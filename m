Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbaDJV70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 17:59:26 -0400
Received: from mail.cybernetics.com ([173.71.130.66]:53031 "EHLO
	mail.cybernetics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaDJV7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 17:59:24 -0400
X-Greylist: delayed 1709 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Apr 2014 17:59:24 EDT
Message-ID: <53470E26.2030306@cybernetics.com>
Date: Thu, 10 Apr 2014 17:33:26 -0400
From: Tony Battersby <tonyb@cybernetics.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 2/6] shm: add sealing API
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(reposted from my comments at http://lwn.net/Articles/593918/)

I may have thought of a way to subvert SEAL_WRITE using O_DIRECT and
asynchronous I/O.  I am not sure if this is a real problem or not, but
better to ask, right?

The exploit would go like this:

1) mmap() the shared memory
2) open some *other* file with O_DIRECT
3) prepare a read-type iocb for the *other* file pointing to the
mmap()ed memory
4) io_submit(), but don't wait for it to complete
5) munmap() the shared memory
6) SEAL_WRITE the shared memory
7) the "sealed" memory is overwritten by DMA from the disk drive at some
point in the future when the I/O completes

So this exploit effectively changes the contents of the supposedly
write-protected memory after SEAL_WRITE is granted.

For O_DIRECT the kernel pins the submitted pages in memory for DMA by
incrementing the page reference counts when the I/O is submitted,
allowing the pages to be modified by DMA even if they are no longer
mapped in the address space of the process.  This is different from a
regular read(), which uses the CPU to copy the data and will fail if the
pages are not mapped.

I am sure there are also other direct I/O mechanisms in the kernel that
can be used to setup a DMA transfer to change the contents of unmapped
memory; the SCSI generic driver comes to mind.

I suppose SEAL_WRITE could iterate over all the pages in the file and
check to make sure no page refcount is greater than the "expected"
value, and return an error instead of granting the seal if a page is
found with an unexpected extra reference that might have been added by
e.g. get_user_pages() for direct I/O. But looking over shmem_set_seals()
in patch 2/6, it doesn't seem to do that.

Tony Battersby
Cybernetics
