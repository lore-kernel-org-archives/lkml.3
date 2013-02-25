Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003Ab3BYRjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:39:25 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46600 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758907Ab3BYRjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:39:19 -0500
Message-ID: <512BA147.2090308@linux.vnet.ibm.com>
Date: Mon, 25 Feb 2013 11:37:11 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jenifer Hopper <jhopper@us.ibm.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Joe Perches <joe@perches.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv5 7/8] zswap: add swap page writeback support
References: <1360780731-11708-1-git-send-email-sjenning@linux.vnet.ibm.com> <1360780731-11708-8-git-send-email-sjenning@linux.vnet.ibm.com> <20130225025403.GB6498@blaptop>
In-Reply-To: <20130225025403.GB6498@blaptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022517-2876-0000-0000-000005B45100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2013 08:54 PM, Minchan Kim wrote:
> Hi Seth,
> 
> On Wed, Feb 13, 2013 at 12:38:50PM -0600, Seth Jennings wrote:
>> This patch adds support for evicting swap pages that are currently
>> compressed in zswap to the swap device.  This functionality is very
>> important and make zswap a true cache in that, once the cache is full
>> or can't grow due to memory pressure, the oldest pages can be moved
>> out of zswap to the swap device so newer pages can be compressed and
>> stored in zswap.
>>
>> This introduces a good amount of new code to guarantee coherency.
>> Most notably, and LRU list is added to the zswap_tree structure,
>> and refcounts are added to each entry to ensure that one code path
>> doesn't free then entry while another code path is operating on it.
>>
>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> 
> In this time, I didn't review the code in detail yet but it seems
> resolve of all review point in previous interation. Thanks!
> But unfortunately, I couldn't find anything related to tmppage handling
> so I'd like to ask.
> 
> The reason of tmppage is temporal buffer to keep compressed data during
> writeback to avoid unnecessary compressing again when we retry?

Yes.

> Is it really critical about performance?

It's hard to measure.  There is no guarantee that
zswap_flush_entries() has made room for the allocation so if we fail
again, we've compressed the page twice and still fail

So my motivation was to prevent the second compression.  It does add
significant complexity though without a completely clear (i.e.
measurable) benefit.


What's the wrong if we remove
> tmppage handling?
> 
> zswap_frontswap_store
> retry:
>         get_cpu_var(zswap_dstmem);
>         zswap_com_op(COMPRESS)
>         zs_malloc()
>         if (!handle) {
>                 put_cpu_var(zswap_dstmem);
>                 if (retry > MAX_RETRY)
>                         goto error_nomem;
>                 zswap_flush_entries()
>                 goto retry;
>         }

I dislike "jump up" labels, but yes, something like this could be done.

Thanks,
Seth

