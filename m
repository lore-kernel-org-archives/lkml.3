Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965687Ab3DQDC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 23:02:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936277Ab3DQDC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 23:02:28 -0400
Date: Tue, 16 Apr 2013 23:02:19 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        jjaburek@redhat.com, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix audit_inode call in O_CREAT case of do_last
Message-ID: <20130417030219.GC7233@madcap2.tricolour.ca>
References: <1365794192-9471-1-git-send-email-jlayton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365794192-9471-1-git-send-email-jlayton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 03:16:32PM -0400, Jeff Layton wrote:
> Jiri reported a regression in auditing of open(..., O_CREAT) syscalls.
> In older kernels, creating a file with open(..., O_CREAT) created
> audit_name records that looked like this:
> 
> type=PATH msg=audit(1360255720.628:64): item=1 name="/abc/foo" inode=138810 dev=fd:00 mode=0100640 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:default_t:s0
> type=PATH msg=audit(1360255720.628:64): item=0 name="/abc/" inode=138635 dev=fd:00 mode=040750 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:default_t:s0
> 
> ...in recent kernels though, they look like this:
> 
> type=PATH msg=audit(1360255402.886:12574): item=2 name=(null) inode=264599 dev=fd:00 mode=0100640 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:default_t:s0
> type=PATH msg=audit(1360255402.886:12574): item=1 name=(null) inode=264598 dev=fd:00 mode=040750 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:default_t:s0
> type=PATH msg=audit(1360255402.886:12574): item=0 name="/abc/foo" inode=264598 dev=fd:00 mode=040750 ouid=0 ogid=0 rdev=00:00 obj=unconfined_u:object_r:default_t:s0
> 
> Richard bisected to determine that the problems started with commit
> bfcec708, but the log messages have changed with some later
> audit-related patches.
> 
> The problem is that this audit_inode call is passing in the parent of
> the dentry being opened, but audit_inode is being called with the parent
> flag false. This causes later audit_inode and audit_inode_child calls to
> match the wrong entry in the audit_names list.
> 
> This patch simply sets the flag to properly indicate that this inode
> represents the parent. With this, the audit_names entries are back to
> looking like they did before.

This patch fixes the problem for me.

Tested-by: Richard Guy Briggs <rbriggs@redhat.com>

> Cc: <stable@vger.kernel.org> # v3.7+
> Cc: Richard Guy Briggs <rbriggs@redhat.com>
> Reported-by: Jiri Jaburek <jjaburek@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/namei.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 57ae9c8..85e40d1 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2740,7 +2740,7 @@ static int do_last(struct nameidata *nd, struct path *path,
>  		if (error)
>  			return error;
>  
> -		audit_inode(name, dir, 0);
> +		audit_inode(name, dir, LOOKUP_PARENT);
>  		error = -EISDIR;
>  		/* trailing slashes? */
>  		if (nd->last.name[nd->last.len])
> -- 
> 1.7.1
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
AMER ENG Base Operating Systems
Remote, Canada, Ottawa
Voice: 1.647.777.2635
Internal: (81) 32635
