Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231AbaJKNLj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 09:11:39 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:16456 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaJKNLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 09:11:38 -0400
Message-ID: <54392C79.4010607@oracle.com>
Date: Sat, 11 Oct 2014 09:11:21 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH 3/3] f2fs: refactor flush_nat_entries to remove costly
 reorganizing ops
References: <1411447990-37919-1-git-send-email-jaegeuk@kernel.org> <1411447990-37919-3-git-send-email-jaegeuk@kernel.org>
In-Reply-To: <1411447990-37919-3-git-send-email-jaegeuk@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2014 12:53 AM, Jaegeuk Kim wrote:
> +static void __set_nat_cache_dirty(struct f2fs_nm_info *nm_i,
> +						struct nat_entry *ne)
> +{
> +	nid_t set = ne->ni.nid / NAT_ENTRY_PER_BLOCK;
> +	struct nat_entry_set *head;
> +
> +	if (get_nat_flag(ne, IS_DIRTY))
> +		return;
> +retry:
> +	head = radix_tree_lookup(&nm_i->nat_set_root, set);
> +	if (!head) {
> +		head = f2fs_kmem_cache_alloc(nat_entry_set_slab, GFP_ATOMIC);

This is funny, you call f2fs_kmem_cache_alloc() here with GFP_ATOMIC because
of disabled preemption, but f2fs_kmem_cache_alloc() will attempt to
cond_resched() in case of failed allocations:

	retry:
	        entry = kmem_cache_alloc(cachep, flags);
	        if (!entry) {
	                cond_resched();
	                goto retry;
	        }

So in reality, f2fs_kmem_cache_alloc can't really work with GFP_ATOMIC,
and right now there are two different locations that call it with that
flag.


Thanks,
Sasha
