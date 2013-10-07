Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab3JGUWA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 16:22:00 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:43172 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab3JGUV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 16:21:58 -0400
From: Robert C Jennings <rcj@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave@sr71.net>,
        Robert C Jennings <rcj@linux.vnet.ibm.com>,
        Matt Helsley <matt.helsley@gmail.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Lei Li <lilei@linux.vnet.ibm.com>,
        Leonardo Garcia <lagarcia@linux.vnet.ibm.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 0/2] vmpslice support for zero-copy gifting of pages
Date: Mon,  7 Oct 2013 15:21:31 -0500
Message-Id: <1381177293-27125-1-git-send-email-rcj@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.2
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100720-5490-0000-0000-00000445A29E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set would add the ability to move anonymous user pages from one
process to another through vmsplice without copying data.  Moving pages
rather than copying is implemented for a narrow case in this RFC to meet
the needs of QEMU's usage (below).

Among the restrictions the source address and destination addresses must
be page aligned, the size argument must be a multiple of page size,
and by the time the reader calls vmsplice, the page must no longer be
mapped in the source.  If a move is not possible the code transparently
falls back to copying data.

This comes from work in QEMU[1] to migrate a VM from one QEMU instance
to another with minimal down-time for the VM.  This would allow for an
update of the QEMU executable under the VM.

New flag usage
This introduces use of the SPLICE_F_MOVE flag for vmsplice, previously
unused.  Proposed usage is as follows:

 Writer gifts pages to pipe, can not access original contents after gift:
    vmsplice(fd, iov, nr_segs, (SPLICE_F_GIFT | SPLICE_F_MOVE);
 Reader asks kernel to move pages from pipe to memory described by iovec:
    vmsplice(fd, iov, nr_segs, SPLICE_F_MOVE);

Moving pages rather than copying is implemented for a narrow case in
this RFC to meet the needs of QEMU's usage.  If a move is not possible
the code transparently falls back to copying data.

For older kernels the SPLICE_F_MOVE would be ignored and a copy would occur.

[1] QEMU localhost live migration:
      http://lists.gnu.org/archive/html/qemu-devel/2013-06/msg02540.html
      http://lists.gnu.org/archive/html/qemu-devel/2013-06/msg02577.html
_______________________________________________________

  vmsplice: Add limited zero copy to vmsplice
  vmsplice: unmap gifted pages for recipient

 fs/splice.c            | 114 ++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/splice.h |   1 +
 2 files changed, 114 insertions(+), 1 deletion(-)

-- 
1.8.1.2

