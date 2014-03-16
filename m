Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560AbaCPCqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 22:46:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:11263 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877AbaCPCqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 22:46:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,662,1389772800"; 
   d="scan'208";a="499538070"
Date: Sat, 15 Mar 2014 22:46:13 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Toshi Kani <toshi.kani@hp.com>, kirill.shutemov@linux.intel.com,
        david@fromorbit.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH] Support map_pages() for DAX
Message-ID: <20140316024613.GF6091@linux.intel.com>
References: <1394838199-29102-1-git-send-email-toshi.kani@hp.com>
 <20140314233233.GA8310@node.dhcp.inet.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314233233.GA8310@node.dhcp.inet.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 01:32:33AM +0200, Kirill A. Shutemov wrote:
> Side note: I'm sceptical about whole idea to use i_mmap_mutux to protect
> against truncate. It will not scale good enough comparing lock_page()
> with its granularity.

I'm actually working on this now.  The basic idea is to put an entry in
the radix tree for each page.  For zero pages, that's a pagecache page.
For pages that map to the media, it's an exceptional entry.  Radix tree
exceptional entries take two bits, leaving us with 30 or 62 bits depending
on sizeof(void *).  We can then take two more bits for Dirty and Lock,
leaving 28 or 60 bits that we can use to cache the PFN on the page,
meaning that we won't have to call the filesystem's get_block as often.

This means that shmem_find_get_pages_and_swap() moves from the shmem code
to filemap and gets renamed to find_get_rtes().  Next step is making
the truncate code use it so that the truncate code locks against DAX
code paths as well as pagecache codepaths.
