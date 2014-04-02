Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbaDBTve (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:51:34 -0400
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:55825 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057AbaDBTva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:51:30 -0400
Message-ID: <533C69A9.8090804@hp.com>
Date: Wed, 02 Apr 2014 13:48:57 -0600
From: Thavatchai Makphaibulchoke <thavatchai.makpahibulchoke@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>, T Makphaibulchoke <tmac@hp.com>
CC: tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, aswin@hp.com
Subject: Re: [PATCH v2] fs/ext4: increase parallelism in updating ext4 orphan
 list
References: <1380728283-61038-1-git-send-email-tmac@hp.com> <1396456148-20455-1-git-send-email-tmac@hp.com> <20140402174109.GD8657@quack.suse.cz>
In-Reply-To: <20140402174109.GD8657@quack.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 11:41 AM, Jan Kara wrote:
>   Thanks for the patches and measurements! So I agree we contend a lot on
> orphan list changes in ext4. But what you do seems to be unnecessarily
> complicated and somewhat hiding the real substance of the patch. If I
> understand your patch correctly, all it does is that it does the
> preliminary work (ext4_reserve_inode_write(),
> ext4_journal_get_write_access()) without the global orphan mutex (under the
> hashed mutex).
> 

Thanks Jan for the comments.  Yes, doing some of the preliminary work with grabbing the global mutex is part of the patch's strategy.

> However orphan operations on a single inode are already serialized by
> i_mutex so there's no need to introduce any new hashed lock. Just add
> assertion mutex_locked(&inode->i_mutex) to ext4_orphan_add() and
> ext4_orphan_del() - you might need to lock i_mutex around the code in
> fs/ext4/migrate.c and in ext4_tmpfile() but that should be fine.
> 

As you pointed out, sounds like there may still be some code path that did not acquire the i_mutex.  It probably would be better to acquire the i_mutex if it is not already acquired.

> Also I'm somewhat failing to see what the spinlock s_orphan_lock brings us.
> I'd guess that the mutex could still protect also the in-memory list and we
> have to grab it in all the relevant cases anyway (in some rare cases we
> could avoid taking the mutex and spinlock would be enough but these
> shouldn't be performance relevant). Please correct me if I'm wrong here, I
> didn't look at the code for that long.
> 

Yes, you are correct.  In the error or previous error case, we only need to update the in memory orphan list, which spinlock seems to be a better mechanism for serialization. Using a separate spinlock would also allow simultanoue operations of both the error and non-error cases.  As you said, if this is a very rare case, it should not make much different.  I'll rerun and ompare the benchmark results using a single mutex.

> Finally (and I somewhat miss this in your patch), I'd think we might need
> to use list_empty_careful() when checking inode's orphan list without
> global orphan list lock.
> 
> 								Honza
> 

Since we already serialize orphan operation with a single inode, the only race condition is an orphan operation on other inodes moving the inode within the orphan list.  In this case head->next should not equal head.  But yes, it is probably safer to use the list_empty_careful().

Thanks,
Mak.

