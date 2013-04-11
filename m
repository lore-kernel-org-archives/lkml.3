Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935744Ab3DKBzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 21:55:25 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50997 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295Ab3DKBzX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 21:55:23 -0400
Date: Wed, 10 Apr 2013 20:55:19 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCHv9 2/8] zsmalloc: add documentation
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Hugh Dickens <hughd@google.com>, Paul Mackerras <paulus@samba.org>,
        Heesub Shin <heesub.shin@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
In-Reply-To: <1365617940-21623-3-git-send-email-sjenning@linux.vnet.ibm.com>
	(from sjenning@linux.vnet.ibm.com on Wed Apr 10 13:18:54 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1365645319.18069.73@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 01:18:54 PM, Seth Jennings wrote:
> This patch adds a documentation file for zsmalloc at
> Documentation/vm/zsmalloc.txt

Docs acked-by: Rob Landley <rob@landley.net>

Literary criticism below:

> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  Documentation/vm/zsmalloc.txt | 68  
> +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 68 insertions(+)
>  create mode 100644 Documentation/vm/zsmalloc.txt
> 
> diff --git a/Documentation/vm/zsmalloc.txt  
> b/Documentation/vm/zsmalloc.txt
> new file mode 100644
> index 0000000..85aa617
> --- /dev/null
> +++ b/Documentation/vm/zsmalloc.txt
> @@ -0,0 +1,68 @@
> +zsmalloc Memory Allocator
> +
> +Overview
> +
> +zmalloc a new slab-based memory allocator,
> +zsmalloc, for storing compressed pages.

zmalloc a new slab-based memory allocator, zsmalloc? (How does one  
zmalloc zsmalloc?)

Out of curiosity, what does zsmalloc stand for, anyway?

>  It is designed for
> +low fragmentation and high allocation success rate on
> +large object, but <= PAGE_SIZE allocations.

1) objects

2) maybe "large objects for <= PAGE_SIZE"...

> +zsmalloc differs from the kernel slab allocator in two primary
> +ways to achieve these design goals.
> +
> +zsmalloc never requires high order page allocations to back
> +slabs, or "size classes" in zsmalloc terms. Instead it allows
> +multiple single-order pages to be stitched together into a
> +"zspage" which backs the slab.  This allows for higher allocation
> +success rate under memory pressure.
> +
> +Also, zsmalloc allows objects to span page boundaries within the
> +zspage.  This allows for lower fragmentation than could be had
> +with the kernel slab allocator for objects between PAGE_SIZE/2
> +and PAGE_SIZE.  With the kernel slab allocator, if a page compresses
> +to 60% of it original size, the memory savings gained through
> +compression is lost in fragmentation because another object of

I lean towards "are lost", but it's debatable. (Savings are plural, but  
savings could also be treated as a mass noun like water/air/bison that  
doesn't get pluralized because you can't count instances of a liquid.  
No idea which is more common.)

> +the same size can't be stored in the leftover space.
> +
> +This ability to span pages results in zsmalloc allocations not being
> +directly addressable by the user.  The user is given an
> +non-dereferencable handle in response to an allocation request.
> +That handle must be mapped, using zs_map_object(), which returns
> +a pointer to the mapped region that can be used.  The mapping is
> +necessary since the object data may reside in two different
> +noncontigious pages.

Presumably this allows packing of unmapped entities if you detect  
fragmentation and are up for a latency spike?

Rob