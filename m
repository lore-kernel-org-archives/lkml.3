Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab3H2Sg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:36:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:61545 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756971Ab3H2SgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:36:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,984,1367996400"; 
   d="scan'208";a="395528762"
Message-ID: <521F949A.2020908@intel.com>
Date: Thu, 29 Aug 2013 11:36:10 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: Dave Chinner <david@fromorbit.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid useless inodes and dentries reclamation
References: <1377726732.3625.31.camel@schen9-DESK>  <20130829110741.GA23571@dastard> <1377799676.3625.69.camel@schen9-DESK>
In-Reply-To: <1377799676.3625.69.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new shrinker infrastructure in mmotm looks like it will make this
problem worse.

old code:
shrink_slab()
	for_each_shrinker {
		do_shrinker_shrink(); // one per batch
			prune_super()
				grab_super_passive()
	}
}

Which means we've got at _most_ one grab_super_passive() per batch.  The
new code is something like this:

shrink_slab()
{
	list_for_each_entry(shrinker, &shrinker_list, list) {
                for_each_node_mask(... shrinkctl->nodes_to_scan) {
			shrink_slab_node()
		}
	}
}

shrink_slab_node()
{
        max_pass = shrinker->count_objects(shrinker, shrinkctl);
	// ^^ does grab_super_passive()
	...
	while (total_scan >= batch_size) {
		ret = shrinker->scan_objects(shrinker, shrinkctl);
		// ^^ does grab_super_passive()
	}
}

We've got an extra grab_super_passive()s in the case where we are
actually doing a scan, plus we've got the extra for_each_node_mask()
loop.  That means even more lock acquisitions in the multi-node NUMA
case, which is exactly where we want to get rid of global lock acquisitions.

