Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3FEJ4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 05:56:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab3FEJ4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 05:56:32 -0400
Date: Wed, 5 Jun 2013 11:56:30 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Frank Mehnert <frank.mehnert@oracle.com>
Cc: Robin Holt <holt@sgi.com>, linux-mm@kvack.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: Handling NUMA page migration
Message-ID: <20130605095630.GL15997@dhcp22.suse.cz>
References: <201306040922.10235.frank.mehnert@oracle.com>
 <201306051034.19959.frank.mehnert@oracle.com>
 <20130605091048.GI15997@dhcp22.suse.cz>
 <201306051132.15788.frank.mehnert@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201306051132.15788.frank.mehnert@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05-06-13 11:32:15, Frank Mehnert wrote:
[...]
> Thank you very much for your help. As I said, this problem happens _only_
> with NUMA_BALANCING enabled. I understand that you treat the VirtualBox
> code as untrusted but the reason for the problem is that some assumption
> is obviously not met: The VirtualBox code assumes that the memory it
> allocates using case A and case B is
> 
>  1. always present and
>  2. will always be backed by the same phyiscal memory
> 
> over the entire life time. Enabling NUMA_BALANCING seems to make this
> assumption false. I only want to know why.

As I said earlier. Both the manual node migration and numa_fault handler
do not migrate pages with elevated ref count (your A case) and pages
that are not on the LRU. So if your Referenced pages might be on the LRU
then you probably have to look into numamigrate_isolate_page and do an
exception for PageReserved pages. But I am a bit suspicious this is the
cause because the reclaim doesn't consider PageReserved pages either so
they could get reclaimed. Or maybe you have handled that path in your
kernel.

Or the other option is that you depend on a timing or something like
that which doesn't hold anymore. That would be hard to debug though.
 
> I see, you don't believe me. I will add more code to the kernel logging
> which pages were migrated.

Simple test for PageReserved flag in numamigrate_isolate_page should
tell you more.

This would cover the migration part. Another potential problem could be
that the page might get unmapped and marked for the numa fault (see
do_numa_page). So maybe your code just assumes that the page even
doesn't get unmapped?
-- 
Michal Hocko
SUSE Labs
