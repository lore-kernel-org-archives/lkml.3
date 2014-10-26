Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751211AbaJZD5L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 23:57:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41857 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaJZD5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 23:57:09 -0400
Date: Sun, 26 Oct 2014 03:57:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: fs: lockup on rename_mutex in fs/dcache.c:1035
Message-ID: <20141026035705.GP7996@ZenIV.linux.org.uk>
References: <544C50CB.4090408@oracle.com>
 <87siibttyi.fsf@x220.int.ebiederm.org>
 <20141026030608.GN7996@ZenIV.linux.org.uk>
 <20141026035100.GO7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141026035100.GO7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[context for Linus]

Fuzzer has triggered deadlock in d_walk() with rename_lock taken twice.
AFAICS, the plausible scenario is
                         (child->d_flags & DCACHE_DENTRY_KILLED) ||
triggering while ascending to parent, on the pass with rename_lock already
held exclusive.  In that case we go to rename_retry and either return without
unlocking rename_lock, or try to take in exclusive one more time, again
without unlocking it first.

> Hmm...  Actually, the comment in there is simply wrong - if the child
> got killed between unlocking the child and locking the parent, it's
> not ascending to the wrong parent, it's having no way to find the next
> sibling.
> 
> OK, so basically it came from Nick's "fs: dcache avoid starvation in dcache
> multi-step operations" and mistake was in the assumption that once we
> hold rename_lock, nothing is going to need rename_retry.  Which isn't
> true - dentry_kill() on child while we are trying to get ->d_lock on
> parent requires a restart and that isn't excluded by rename_lock at
> all.
> 
> Well, brute-force fix would be this, but I wonder if it's going to
> create livelocks...
> 
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 3ffef7f..e3d8499 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1118,6 +1118,7 @@ out_unlock:
>  	return;
>  
>  rename_retry:
> +	done_seqretry(&rename_lock, seq);
>  	if (!retry)
>  		return;
>  	seq = 1;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
