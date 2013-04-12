Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab3DLVj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 17:39:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36824 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab3DLVjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 17:39:24 -0400
Date: Fri, 12 Apr 2013 17:39:22 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: rbriggs@redhat.com, jjaburek@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: fix audit_inode call in O_CREAT case of do_last
Message-ID: <20130412173922.72cf60b4@tlielax.poochiereds.net>
In-Reply-To: <1365794192-9471-1-git-send-email-jlayton@redhat.com>
References: <1365794192-9471-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Apr 2013 15:16:32 -0400
Jeff Layton <jlayton@redhat.com> wrote:

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
> 
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

BTW, there are a couple of other calls to audit_inode earlier in this
function (the LAST_BIND and LAST_ROOT cases). I suspect those also need
similar treatment, but I've left them alone for now since I didn't have
a clear way to verify it. Let me know if you'd like me to respin this
with those changed as well.

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>
