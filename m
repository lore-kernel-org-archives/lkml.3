Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab3BRTYr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 14:24:47 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:41295 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752115Ab3BRTYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 14:24:46 -0500
Message-ID: <51227FDA.7040000@linux.vnet.ibm.com>
Date: Mon, 18 Feb 2013 13:24:10 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ric Mason <ric.masonn@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
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
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCHv5 4/8] zswap: add to mm/
References: <1360780731-11708-1-git-send-email-sjenning@linux.vnet.ibm.com> <1360780731-11708-5-git-send-email-sjenning@linux.vnet.ibm.com> <511F0536.5030802@gmail.com>
In-Reply-To: <511F0536.5030802@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021819-9360-0000-0000-000010BD4191
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 10:04 PM, Ric Mason wrote:
> On 02/14/2013 02:38 AM, Seth Jennings wrote:
<snip>
>> + * The statistics below are not protected from concurrent access for
>> + * performance reasons so they may not be a 100% accurate.  However,
>> + * the do provide useful information on roughly how many times a
> 
> s/the/they

Ah yes, thanks :)

> 
>> + * certain event is occurring.
>> +*/
>> +static u64 zswap_pool_limit_hit;
>> +static u64 zswap_reject_compress_poor;
>> +static u64 zswap_reject_zsmalloc_fail;
>> +static u64 zswap_reject_kmemcache_fail;
>> +static u64 zswap_duplicate_entry;
>> +
>> +/*********************************
>> +* tunables
>> +**********************************/
>> +/* Enable/disable zswap (disabled by default, fixed at boot for
>> now) */
>> +static bool zswap_enabled;
>> +module_param_named(enabled, zswap_enabled, bool, 0);
> 
> please document in Documentation/kernel-parameters.txt.

Will do.

> 
>> +
>> +/* Compressor to be used by zswap (fixed at boot for now) */
>> +#define ZSWAP_COMPRESSOR_DEFAULT "lzo"
>> +static char *zswap_compressor = ZSWAP_COMPRESSOR_DEFAULT;
>> +module_param_named(compressor, zswap_compressor, charp, 0);
> 
> ditto

ditto

> 
>> +
<snip>
>> +/* invalidates all pages for the given swap type */
>> +static void zswap_frontswap_invalidate_area(unsigned type)
>> +{
>> +    struct zswap_tree *tree = zswap_trees[type];
>> +    struct rb_node *node, *next;
>> +    struct zswap_entry *entry;
>> +
>> +    if (!tree)
>> +        return;
>> +
>> +    /* walk the tree and free everything */
>> +    spin_lock(&tree->lock);
>> +    node = rb_first(&tree->rbroot);
>> +    while (node) {
>> +        entry = rb_entry(node, struct zswap_entry, rbnode);
>> +        zs_free(tree->pool, entry->handle);
>> +        next = rb_next(node);
>> +        zswap_entry_cache_free(entry);
>> +        node = next;
>> +    }
>> +    tree->rbroot = RB_ROOT;
> 
> Why don't need rb_erase for every nodes?

We are freeing the entire tree here.  try_to_unuse() in the swapoff
syscall should have already emptied the tree, but this is here for
completeness.

rb_erase() will do things like rebalancing the tree; something that
just wastes time since we are in the process of freeing the whole
tree.  We are holding the tree lock here so we are sure that no one
else is accessing the tree while it is in this transient broken state.

Thanks,
Seth

