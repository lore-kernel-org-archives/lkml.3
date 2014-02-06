Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaBFX6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:58:22 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:59258 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbaBFX6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:58:19 -0500
Date: Thu, 6 Feb 2014 15:58:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Damien Ramonda <damien.ramonda@intel.com>, Jan Kara <jack@suse.cz>,
        Linus <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH V5] mm readahead: Fix readahead fail for no local
 memory and limit readahead pages
In-Reply-To: <alpine.DEB.2.02.1402061537180.3441@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.02.1402061557210.5061@chino.kir.corp.google.com>
References: <1390388025-1418-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20140206145105.27dec37b16f24e4ac5fd90ce@linux-foundation.org> <alpine.DEB.2.02.1402061456290.31828@chino.kir.corp.google.com> <20140206152219.45c2039e5092c8ea1c31fd38@linux-foundation.org>
 <alpine.DEB.2.02.1402061537180.3441@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Feb 2014, David Rientjes wrote:

> > > > > +#define MAX_REMOTE_READAHEAD   4096UL

> Normally it wouldn't matter because there's no significant downside to it 
> racing, things like mempolicies which use numa_node_id() extensively would 
> result in, oops, a page allocation on the wrong node.
> 
> This stands out to me, though, because you're expecting the calculation to 
> be correct for a specific node.
> 
> The patch is still wrong, though, it should just do
> 
> 	int node = ACCESS_ONCE(numa_mem_id());
> 	return min(nr, (node_page_state(node, NR_INACTIVE_FILE) +
> 		        node_page_state(node, NR_FREE_PAGES)) / 2);
> 
> since we want to readahead based on the cpu's local node, the comment 
> saying we're reading ahead onto "remote memory" is wrong since a 
> memoryless node has local affinity to numa_mem_id().
> 

Oops, forgot about the MAX_REMOTE_READAHEAD which needs to be factored in 
as well, but this handles the bound on local node's statistics.
