Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032Ab3KJJ3Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 04:29:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:14166 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab3KJJ3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 04:29:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,671,1378882800"; 
   d="scan'208";a="425053336"
Date: Sun, 10 Nov 2013 17:29:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [vfsmounts] WARNING: CPU: 1 PID: 479 at fs/dcache.c:385
 d_lru_del()
Message-ID: <20131110092907.GA21120@localhost>
References: <20131109030636.GA13464@localhost>
 <20131109051931.GT13318@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109051931.GT13318@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 05:19:31AM +0000, Al Viro wrote:
> On Sat, Nov 09, 2013 at 11:06:36AM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > I got the below dmesg and the first bad commit is
> > 
> > commit 84550b9356af50c7cbd6b6ce6e8fd06585eebf14
> > Author: Al Viro <viro@zeniv.linux.org.uk>
> > Date:   Sun Sep 29 22:06:07 2013 -0400
> 
> 	Got it...  See if the following fixes the problem - it's
> shrink_dcache_for_umount() needing to be careful after possible
> run of d_genocide(); we are left with dentries that have zero
> refcount and are not on any LRU.  And yes, it's d_genocide() being
> not nice, exactly because it relies upon shrink_dcache_for_umount()
> coming right after it to sweep the garbage.  So we'd better be
> ready to deal with said garbage...
> 
> 	Diff below fixes that junk here.  Folded and re-pushed...

Thanks! I can confirm that it fixed the bug.

Tested-by: Fengguang Wu <fengguang.wu@intel.com>

> diff --git a/fs/dcache.c b/fs/dcache.c
> index 50d4357..72c99b8 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1391,7 +1391,8 @@ static enum d_walk_ret umount_collect(void *_data, struct dentry *dentry)
>  		 * need to get the global LRU lock and do the
>  		 * LRU accounting.
>  		 */
> -		d_lru_del(dentry);
> +		if (dentry->d_flags & DCACHE_LRU_LIST)
> +			d_lru_del(dentry);
>  		d_shrink_add(dentry, &data->dispose);
>  		data->found++;
>  		ret = D_WALK_NORETRY;
