Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaJWKLm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:11:42 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:30191 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750799AbaJWKLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:11:40 -0400
X-IronPort-AV: E=Sophos;i="5.04,774,1406563200"; 
   d="scan'208";a="37816269"
Message-ID: <5448D515.90006@cn.fujitsu.com>
Date: Thu, 23 Oct 2014 18:14:45 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <torvalds@linux-foundation.org>, <paulmck@linux.vnet.ibm.com>,
        <tglx@linutronix.de>, <akpm@linux-foundation.org>, <riel@redhat.com>,
        <mgorman@suse.de>, <oleg@redhat.com>, <mingo@redhat.com>,
        <minchan@kernel.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <viro@zeniv.linux.org.uk>, <dave@stgolabs.net>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 4/6] SRCU free VMAs
References: <20141020215633.717315139@infradead.org> <20141020222841.419869904@infradead.org>
In-Reply-To: <20141020222841.419869904@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>  
> +struct vm_area_struct *find_vma_srcu(struct mm_struct *mm, unsigned long addr)
> +{
> +	struct vm_area_struct *vma;
> +	unsigned int seq;
> +
> +	WARN_ON_ONCE(!srcu_read_lock_held(&vma_srcu));
> +
> +	do {
> +		seq = read_seqbegin(&mm->mm_seq);
> +		vma = __find_vma(mm, addr);

will the __find_vma() loops for ever due to the rotations in the RBtree?

> +	} while (read_seqretry(&mm->mm_seq, seq));
> +
> +	return vma;
> +}
