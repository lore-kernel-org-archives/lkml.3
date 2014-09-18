Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbaIRCT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 22:19:26 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:41592 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570AbaIRCTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 22:19:25 -0400
Message-ID: <541A40B6.30507@huawei.com>
Date: Thu, 18 Sep 2014 10:17:26 +0800
From: hujianyang <hujianyang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <rgb@redhat.com>
CC: <viro@zeniv.linux.org.uk>, <eparis@redhat.com>, <jlayton@primarydata.com>
Subject: Re: [PATCH v2] audit: vfs: fix audit records error when write to
 a file
References: <540E6722.6000107@huawei.com>
In-Reply-To: <540E6722.6000107@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.68.144]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020201.541A411D.001D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 65bc767b7b8d0d7597071a1427d1cd91
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Could you add me to your Cc: list on this thread, please?  I'm
> interested in the outcome...  Thanks!
>

Hi Richard,

I've resend a v2 patch and now quote it in the end of this mail
for you.

I'm sorry to say the previously work of mine seems useless. Moving
audit_inode() to the O_CREAT case in lookup_open() may miss some
conditions when we create a file.

fs/namei.c lookup_open() line 2828
"""
        if ((nd->flags & LOOKUP_OPEN) && dir_inode->i_op->atomic_open) {
                return atomic_open(nd, dentry, path, file, op, got_write,
                                   need_lookup, opened);
        }
"""

We will miss this branch and other potential cases if we apply my
patch.

There is something wrong with audit, I think. But I don't know where.
One good way to solve this problem is go back to commit bfcec708 as
Jeff mentioned in commit 33e2208a and find the reason why the audit
of create operations is wrong. Do we have another way to fix it than
changing the third parameter of audit_inode() to LOOKUP_PARENT which
lead the audit of write confused?

I don't know much about audit. One of my colleagues is dealing with
this problem now. I'm very glad if someone else could help us.

Thanks~!

Hu


On 2014/9/9 10:34, hujianyang wrote:
> Changes from v1:
> 
>    * Move audit_inode() to the beginning of O_CREAT case in
>      lookup_open() to avoid missing audit for ROFS error. This
>      lack is spotted by Jeff Layton <jeff.layton@primarydata.com>
> 
> commit 33e2208acfc1
> 
> audit: vfs: fix audit_inode call in O_CREAT case of do_last
> 
> fix a regression in auditing of open(..., O_CREAT) syscalls but
> introduce a new problem which lead the records of write operation
> confusion.
> 
> This error can be reproduced by these steps:
> 
> 	touch /etc/test
> 	echo "-w /etc/test" >>/etc/audit/audit.rules
> 	/etc/init.d/auditd restart
> 
> 	echo "abc" >> /etc/test
> 
> audit_name records are:
> 
> type=PATH msg=audit(1409764556.196:67): item=0 name="/etc/" inode=5097 dev=00:01 mode=040755 ouid=0 ogid=0 rdev=00:00 nametype=PARENT
> type=PATH msg=audit(1409764556.196:67): item=1 name=(null) inode=23161 dev=00:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 nametype=NORMAL
> type=PATH msg=audit(1409764556.196:67): item=2 name=(null) inode=23161 dev=00:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 nametype=NORMAL
> 
> but if we revert commit 33e2208acfc1, records are correct:
> 
> type=PATH msg=audit(1409763058.192:219): item=0 name="/etc/test" inode=1275 dev=00:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 nametype=NORMAL
> 
> We shouldn't leave audit_inode(.., LOOKUP_PARENT) in O_CREAT case
> of do_last() because this branch don't really know if vfs need to
> create a new file. There is no need to do vfs_create() if we open
> an existing file with O_CREAT flag and write to it. But this
> audit_inode() in O_CREAT case will record a msg as we create a new
> file and confuse the records of write.
> 
> This patch moves the audit for create operation to where a file
> really need to be created, the O_CREAT case in lookup_open().
> We have to add the pointer of struct filename as a parameter of
> lookup_open(). By doing this, the records of both create and write
> are correct.
> 
> Signed-off-by: hujianyang <hujianyang@huawei.com>
> ---
>  fs/namei.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index a996bb4..ca4a831 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2808,7 +2808,8 @@ looked_up:
>  static int lookup_open(struct nameidata *nd, struct path *path,
>  			struct file *file,
>  			const struct open_flags *op,
> -			bool got_write, int *opened)
> +			bool got_write, int *opened,
> +			struct filename *name)
>  {
>  	struct dentry *dir = nd->path.dentry;
>  	struct inode *dir_inode = dir->d_inode;
> @@ -2841,6 +2842,8 @@ static int lookup_open(struct nameidata *nd, struct path *path,
>  	/* Negative dentry, just create the file */
>  	if (!dentry->d_inode && (op->open_flag & O_CREAT)) {
>  		umode_t mode = op->mode;
> +
> +		audit_inode(name, dir, LOOKUP_PARENT);
>  		if (!IS_POSIXACL(dir->d_inode))
>  			mode &= ~current_umask();
>  		/*
> @@ -2926,7 +2929,6 @@ static int do_last(struct nameidata *nd, struct path *path,
>  		if (error)
>  			return error;
> 
> -		audit_inode(name, dir, LOOKUP_PARENT);
>  		error = -EISDIR;
>  		/* trailing slashes? */
>  		if (nd->last.name[nd->last.len])
> @@ -2945,7 +2947,7 @@ retry_lookup:
>  		 */
>  	}
>  	mutex_lock(&dir->d_inode->i_mutex);
> -	error = lookup_open(nd, path, file, op, got_write, opened);
> +	error = lookup_open(nd, path, file, op, got_write, opened, name);
>  	mutex_unlock(&dir->d_inode->i_mutex);
> 
>  	if (error <= 0) {
> 


