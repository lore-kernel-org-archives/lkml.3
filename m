Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933237Ab3GCWeh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 18:34:37 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46852 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755068Ab3GCWeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 18:34:36 -0400
Date: Wed, 3 Jul 2013 15:34:15 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Mark Fasheh <mfasheh@suse.com>,
        ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v3 22/25] ocfs2: Change how dentry's d_lock field is
 accessed
Message-ID: <20130703223414.GA6392@localhost>
Mail-Followup-To: Waiman Long <Waiman.Long@hp.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Andi Kleen <andi@firstfloor.org>,
	"Chandramouleeswaran, Aswin" <aswin@hp.com>,
	"Norton, Scott J" <scott.norton@hp.com>
References: <1372882922-23205-1-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372882922-23205-1-git-send-email-Waiman.Long@hp.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 04:22:02PM -0400, Waiman Long wrote:
> Because of the changes made in dcache.h header file, files that
> use the d_lock field of the dentry structure need to be changed
> accordingly. All the d_lock's spin_lock() and spin_unlock() calls
> are replaced by the corresponding d_lock() and d_unlock() calls.
> There is no change in logic and everything should just work.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>

This looks reasonable, but I'll wait for the followup from Linus' review.

Joel

> ---
>  fs/ocfs2/dcache.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/dcache.c b/fs/ocfs2/dcache.c
> index ef99972..4f72906 100644
> --- a/fs/ocfs2/dcache.c
> +++ b/fs/ocfs2/dcache.c
> @@ -173,17 +173,17 @@ struct dentry *ocfs2_find_local_alias(struct inode *inode,
>  
>  	spin_lock(&inode->i_lock);
>  	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
> -		spin_lock(&dentry->d_lock);
> +		d_lock(dentry);
>  		if (ocfs2_match_dentry(dentry, parent_blkno, skip_unhashed)) {
>  			trace_ocfs2_find_local_alias(dentry->d_name.len,
>  						     dentry->d_name.name);
>  
>  			dget_dlock(dentry);
> -			spin_unlock(&dentry->d_lock);
> +			d_unlock(dentry);
>  			spin_unlock(&inode->i_lock);
>  			return dentry;
>  		}
> -		spin_unlock(&dentry->d_lock);
> +		d_unlock(dentry);
>  	}
>  	spin_unlock(&inode->i_lock);
>  	return NULL;
> -- 
> 1.7.1
> 

-- 

"Where are my angels?
 Where's my golden one?
 And where is my hope
 Now that my heroes are gone?"

			http://www.jlbec.org/
			jlbec@evilplan.org
