Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab3KDPeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 10:34:12 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789Ab3KDPeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 10:34:11 -0500
Message-ID: <5277BE6D.1040002@suse.cz>
Date: Mon, 04 Nov 2013 16:34:05 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Robert Jennings <rcj@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave@sr71.net>, Matt Helsley <matt.helsley@gmail.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Michael Roth <mdroth@linux.vnet.ibm.com>,
        Lei Li <lilei@linux.vnet.ibm.com>,
        Leonardo Garcia <lagarcia@linux.vnet.ibm.com>,
        Simon Jin <simonjin@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 0/2] vmpslice support for zero-copy gifting of pages
References: <1382715984-10558-1-git-send-email-rcj@linux.vnet.ibm.com>
In-Reply-To: <1382715984-10558-1-git-send-email-rcj@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2013 05:46 PM, Robert Jennings wrote:
> From: Robert C Jennings <rcj@linux.vnet.ibm.com>
> 
> This patch set would add the ability to move anonymous user pages from one
> process to another through vmsplice without copying data.  Moving pages
> rather than copying is implemented for a narrow case in this RFC to meet
> the needs of QEMU's usage (below).
> 
> Among the restrictions the source address and destination addresses must
> be page aligned, the size argument must be a multiple of page size,
> and by the time the reader calls vmsplice, the page must no longer be
> mapped in the source.  If a move is not possible the code transparently
> falls back to copying data.
> 
> This comes from work in QEMU[1] to migrate a VM from one QEMU instance
> to another with minimal down-time for the VM.  This would allow for an
> update of the QEMU executable under the VM.

Hello,

since this seems somewhat narrow use case for a syscall change, it would
be helpful if you included a larger discussion of considered existing
alternatives, with benchmark results justifying the changed syscall. E.g.:
- Cross Memory Attach comes to mind as one alternative to vmsplice.
Although it does perform a single copy, there are results suggesting
zero-copy doesn't necessarily add that much gain:
  http://marc.info/?l=linux-mm&m=130105930902915&w=2
- Would it be possible for QEMU to use shared memory to begin with?
Since you are already restricting this to page-aligned regions.

Ideally the benchmark results would also include the THP support when
complete.

Thanks,
Vlastimil

> New flag usage
> This introduces use of the SPLICE_F_MOVE flag for vmsplice, previously
> unused.  Proposed usage is as follows:
> 
>  Writer gifts pages to pipe, can not access original contents after gift:
>     vmsplice(fd, iov, nr_segs, (SPLICE_F_GIFT | SPLICE_F_MOVE);
>  Reader asks kernel to move pages from pipe to memory described by iovec:
>     vmsplice(fd, iov, nr_segs, SPLICE_F_MOVE);
> 
> Moving pages rather than copying is implemented for a narrow case in
> this RFC to meet the needs of QEMU's usage.  If a move is not possible
> the code transparently falls back to copying data.
> 
> For older kernels the SPLICE_F_MOVE would be ignored and a copy would occur.
> 
> [1] QEMU localhost live migration:
> http://lists.gnu.org/archive/html/qemu-devel/2013-10/msg02787.html
> 
> Changes from V1:
>  - Cleanup zap coalescing in splice_to_pipe for readability
>  - Field added to struct partial_page in v1 was unnecessary, using
>    private field instead.
>  - Read-side code in pipe_to_user pulled out into a new function
>  - Improved documentation of read-side flipping code
>  - Fixed locking issue in read-size flipping code found by sparse
>  - Updated vmsplice comments for vmsplice_to_user(),
>    vmsplice_to_pipe, and vmsplice syscall
> _______________________________________________________
> 
>   vmsplice: unmap gifted pages for recipient
>   vmsplice: Add limited zero copy to vmsplice
> 
>  fs/splice.c | 159 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 150 insertions(+), 9 deletions(-)
> 

