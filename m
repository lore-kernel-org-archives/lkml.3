Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751575Ab3HTXEW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 19:04:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38647 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275Ab3HTXEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 19:04:21 -0400
Date: Tue, 20 Aug 2013 16:04:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm/pgtable: Fix continue to preallocate pmds
 even if failure occurrence
Message-Id: <20130820160418.5639c4f9975b84dc8dede014@linux-foundation.org>
In-Reply-To: <1376981696-4312-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1376981696-4312-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013 14:54:53 +0800 Wanpeng Li <liwanp@linux.vnet.ibm.com> wrote:

> preallocate_pmds will continue to preallocate pmds even if failure
> occurrence, and then free all the preallocate pmds if there is
> failure, this patch fix it by stop preallocate if failure occurrence
> and go to free path.
>
> ...
>
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -196,21 +196,18 @@ static void free_pmds(pmd_t *pmds[])
>  static int preallocate_pmds(pmd_t *pmds[])
>  {
>  	int i;
> -	bool failed = false;
>  
>  	for(i = 0; i < PREALLOCATED_PMDS; i++) {
>  		pmd_t *pmd = (pmd_t *)__get_free_page(PGALLOC_GFP);
>  		if (pmd == NULL)
> -			failed = true;
> +			goto err;
>  		pmds[i] = pmd;
>  	}
>  
> -	if (failed) {
> -		free_pmds(pmds);
> -		return -ENOMEM;
> -	}
> -
>  	return 0;
> +err:
> +	free_pmds(pmds);
> +	return -ENOMEM;
>  }

Nope.  If the error path is taken, free_pmds() will free uninitialised
items from pmds[], which is a local in pgd_alloc() and contains random
stack junk.  The kernel will crash.

You could pass an nr_pmds argument to free_pmds(), or zero out the
remaining items on the error path.  However, although the current code
is a bit kooky, I don't see that it is harmful in any way.

> Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>

Ahem.
