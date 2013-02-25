Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351Ab3BYR3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 12:29:42 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60286 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab3BYR3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:29:41 -0500
Message-ID: <512B9D8C.3090506@linux.vnet.ibm.com>
Date: Mon, 25 Feb 2013 11:21:16 -0600
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
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
        Cody P Schafer <cody@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCHv6 4/8] zswap: add to mm/
References: <1361397888-14863-1-git-send-email-sjenning@linux.vnet.ibm.com> <1361397888-14863-5-git-send-email-sjenning@linux.vnet.ibm.com> <20130225043551.GA12158@lge.com>
In-Reply-To: <20130225043551.GA12158@lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022517-7182-0000-0000-0000058059FC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2013 10:35 PM, Joonsoo Kim wrote:
> Hello, Seth.
> Here comes minor comments.
> 
<snip>
>> +static int __zswap_cpu_notifier(unsigned long action, unsigned long cpu)
>> +{
>> +	struct crypto_comp *tfm;
>> +	u8 *dst;
>> +
>> +	switch (action) {
>> +	case CPU_UP_PREPARE:
>> +		tfm = crypto_alloc_comp(zswap_compressor, 0, 0);
>> +		if (IS_ERR(tfm)) {
>> +			pr_err("can't allocate compressor transform\n");
>> +			return NOTIFY_BAD;
>> +		}
>> +		*per_cpu_ptr(zswap_comp_pcpu_tfms, cpu) = tfm;
>> +		dst = (u8 *)__get_free_pages(GFP_KERNEL, 1);
> 
> Order 1 is really needed?
> Following code uses only PAGE_SIZE, not 2 * PAGE_SIZE.

Yes, probably should add a comment here.

Some compression modules in the kernel, notably LZO, do not guard
against buffer overrun during compression.  In cases where LZO tries
to compress a page with high entropy (e.g. a page containing already
compressed data like JPEG), the compressed result can actually be
larger than the original data.  In this case, if the compression
buffer is only one page, we overrun.  I actually encountered this
during development.

> 
>> +		if (!dst) {
>> +			pr_err("can't allocate compressor buffer\n");
>> +			crypto_free_comp(tfm);
>> +			*per_cpu_ptr(zswap_comp_pcpu_tfms, cpu) = NULL;
>> +			return NOTIFY_BAD;
>> +		}
<snip>
>> +	buf = zs_map_object(tree->pool, handle, ZS_MM_WO);
>> +	memcpy(buf, dst, dlen);
>> +	zs_unmap_object(tree->pool, handle);
>> +	put_cpu_var(zswap_dstmem);
>> +
>> +	/* allocate entry */
>> +	entry = zswap_entry_cache_alloc(GFP_KERNEL);
>> +	if (!entry) {
>> +		zs_free(tree->pool, handle);
>> +		zswap_reject_kmemcache_fail++;
>> +		ret = -ENOMEM;
>> +		goto reject;
>> +	}
> 
> How about moving up zswap_entry_cache_alloc()?
> It can save compression processing time
> if zswap_entry_cache_alloc() is failed.

Will do.

> 
>> +
>> +	/* populate entry */
>> +	entry->type = type;
>> +	entry->offset = offset;
>> +	entry->handle = handle;
>> +	entry->length = dlen;
>> +
<snip>
>> +/* invalidates all pages for the given swap type */
>> +static void zswap_frontswap_invalidate_area(unsigned type)
>> +{
>> +	struct zswap_tree *tree = zswap_trees[type];
>> +	struct rb_node *node;
>> +	struct zswap_entry *entry;
>> +
>> +	if (!tree)
>> +		return;
>> +
>> +	/* walk the tree and free everything */
>> +	spin_lock(&tree->lock);
>> +	/*
>> +	 * TODO: Even though this code should not be executed because
>> +	 * the try_to_unuse() in swapoff should have emptied the tree,
>> +	 * it is very wasteful to rebalance the tree after every
>> +	 * removal when we are freeing the whole tree.
>> +	 *
>> +	 * If post-order traversal code is ever added to the rbtree
>> +	 * implementation, it should be used here.
>> +	 */
>> +	while ((node = rb_first(&tree->rbroot))) {
>> +		entry = rb_entry(node, struct zswap_entry, rbnode);
>> +		rb_erase(&entry->rbnode, &tree->rbroot);
>> +		zs_free(tree->pool, entry->handle);
>> +		zswap_entry_cache_free(entry);
>> +	}
> 
> You should decrease zswap_stored_pages in while loop.

Yes. Will do.

Thanks,
Seth

