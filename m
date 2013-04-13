Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab3DMG05 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 02:26:57 -0400
Received: from elvis.mu.org ([192.203.228.196]:18291 "EHLO elvis.mu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab3DMG04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 02:26:56 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Apr 2013 02:26:56 EDT
Subject: Re: [PATCHv9 4/8] zswap: add to mm/
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
In-Reply-To: <1365617940-21623-5-git-send-email-sjenning@linux.vnet.ibm.com>
Date: Fri, 12 Apr 2013 23:20:27 -0700
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Content-Transfer-Encoding: 7bit
Message-Id: <D33AB581-608A-43DD-B47F-AA93DC9CA432@FreeBSD.org>
References: <1365617940-21623-1-git-send-email-sjenning@linux.vnet.ibm.com> <1365617940-21623-5-git-send-email-sjenning@linux.vnet.ibm.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Apr 10, 2013, at 11:18 , Seth Jennings wrote:

> +/* invalidates all pages for the given swap type */
> +static void zswap_frontswap_invalidate_area(unsigned type)
> +{
> +	struct zswap_tree *tree = zswap_trees[type];
> +	struct rb_node *node;
> +	struct zswap_entry *entry;
> +
> +	if (!tree)
> +		return;
> +
> +	/* walk the tree and free everything */
> +	spin_lock(&tree->lock);
> +	/*
> +	 * TODO: Even though this code should not be executed because
> +	 * the try_to_unuse() in swapoff should have emptied the tree,
> +	 * it is very wasteful to rebalance the tree after every
> +	 * removal when we are freeing the whole tree.
> +	 *
> +	 * If post-order traversal code is ever added to the rbtree
> +	 * implementation, it should be used here.
> +	 */
> +	while ((node = rb_first(&tree->rbroot))) {
> +		entry = rb_entry(node, struct zswap_entry, rbnode);
> +		rb_erase(&entry->rbnode, &tree->rbroot);
> +		zs_free(tree->pool, entry->handle);
> +		zswap_entry_cache_free(entry);
> +	}
> +	tree->rbroot = RB_ROOT;
> +	spin_unlock(&tree->lock);
> +}

Should both the pool and the tree also be freed, here?

-- Suleiman
