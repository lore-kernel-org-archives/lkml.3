Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbaIQSnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 14:43:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755699AbaIQSno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 14:43:44 -0400
Date: Wed, 17 Sep 2014 14:43:30 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: =?utf-8?B?6IOh5YmR6Ziz?= <hujyang@gmail.com>
Cc: Jeff Layton <jeff.layton@primarydata.com>,
        hujianyang <hujianyang@huawei.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        eparis@redhat.com, jlayton@redhat.com
Subject: Re: [PATCH] audit: vfs: fix audit records error when write to a file
Message-ID: <20140917184330.GO4462@madcap2.tricolour.ca>
References: <54095E79.9010306@huawei.com>
 <20140905065013.21111541@tlielax.poochiereds.net>
 <CABMCRV897Vc26C_yG7YUzUgDEfKEPkDYGS7GmBTOGmdR2c=-Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABMCRV897Vc26C_yG7YUzUgDEfKEPkDYGS7GmBTOGmdR2c=-Kg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/09/05, 胡剑阳 wrote:
> Hi Jeff,

Hello gentlemen,

> I don't know if we can keep audit_inode() in do_last(). I've tried
> this but found
> the only way to enable both write() and create() is moving it to lookup_open().
> I know this is not good, but I think we have no choice.
> 
> The current patch really miss the ROFS condition as you said. How about
> moving audit_inode() to the beginning of the O_CREAT case in lookup_open()?
> That's my mistake. After this, it seems no creating records will be missing.
> 
> I would like to change this and resend a new patch. I'm worry about if we miss
> something. Before I do this, do you have any suggestions? Or do you have a
> better way to keep audit_inode() in do_last()?

Could you add me to your Cc: list on this thread, please?  I'm
interested in the outcome...  Thanks!

> Thank you~!
> 
> Hu
> 
> 2014-09-05 18:50 GMT+08:00 Jeff Layton <jeff.layton@primarydata.com>:
> > On Fri, 5 Sep 2014 14:55:53 +0800
> > hujianyang <hujianyang@huawei.com> wrote:
> >
> >> commit 33e2208acfc1
> >>
> >> audit: vfs: fix audit_inode call in O_CREAT case of do_last
> >>
> >> fix a regression in auditing of open(..., O_CREAT) syscalls but
> >> import a new problem which lead the records of write operation
> >> confusion.
> >>
> >> This error can be reproduced by these steps:
> >>
> >>       touch /etc/test
> >>       echo "-w /etc/test" >>/etc/audit/audit.rules
> >>       /etc/init.d/auditd restart
> >>
> >>       echo "abc" >> /etc/test
> >>
> >> audit_name records are:
> >>
> >> type=PATH msg=audit(1409764556.196:67): item=0 name="/etc/" inode=5097 dev=00:01 mode=040755 ouid=0 ogid=0 rdev=00:00 nametype=PARENT
> >> type=PATH msg=audit(1409764556.196:67): item=1 name=(null) inode=23161 dev=00:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 nametype=NORMAL
> >> type=PATH msg=audit(1409764556.196:67): item=2 name=(null) inode=23161 dev=00:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 nametype=NORMAL
> >>
> >> but if we revert commit 33e2208acfc1, records are correct:
> >>
> >> type=PATH msg=audit(1409763058.192:219): item=0 name="/etc/test" inode=1275 dev=00:01 mode=0100644 ouid=0 ogid=0 rdev=00:00 nametype=NORMAL
> >>
> >> We shouldn't leave audit_inode(.., LOOKUP_PARENT) in O_CREAT case
> >> of do_last() because this branch don't really know if vfs need to
> >> create a new file. There is no need to do vfs_create() if we open
> >> an existing file with O_CREAT flag and write to it. But this
> >> audit_inode() in O_CREAT case will record a msg as we create a new
> >> file and confuse the records of write.
> >>
> >> This patch moves the audit for create operation to where a file
> >> really need to be created, the O_CREAT case in lookup_open().
> >> We have to add the pointer of struct filename as a parameter of
> >> lookup_open(). By doing this, the records of both create and write
> >> are correct.
> >>
> >> Signed-off-by: hujianyang <hujianyang@huawei.com>
> >> ---
> >>  fs/namei.c | 9 ++++++---
> >>  1 file changed, 6 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/namei.c b/fs/namei.c
> >> index a996bb4..0bc7734 100644
> >> --- a/fs/namei.c
> >> +++ b/fs/namei.c
> >> @@ -2808,7 +2808,8 @@ looked_up:
> >>  static int lookup_open(struct nameidata *nd, struct path *path,
> >>                       struct file *file,
> >>                       const struct open_flags *op,
> >> -                     bool got_write, int *opened)
> >> +                     bool got_write, int *opened,
> >> +                     struct filename *name)
> >>  {
> >>       struct dentry *dir = nd->path.dentry;
> >>       struct inode *dir_inode = dir->d_inode;
> >> @@ -2854,6 +2855,9 @@ static int lookup_open(struct nameidata *nd, struct path *path,
> >>                       error = -EROFS;
> >>                       goto out_dput;
> >>               }
> >> +
> >> +             audit_inode(name, dir, LOOKUP_PARENT);
> >> +
> >>               *opened |= FILE_CREATED;
> >>               error = security_path_mknod(&nd->path, dentry, mode, 0);
> >>               if (error)
> >> @@ -2926,7 +2930,6 @@ static int do_last(struct nameidata *nd, struct path *path,
> >>               if (error)
> >>                       return error;
> >>
> >> -             audit_inode(name, dir, LOOKUP_PARENT);
> >>               error = -EISDIR;
> >>               /* trailing slashes? */
> >>               if (nd->last.name[nd->last.len])
> >> @@ -2945,7 +2948,7 @@ retry_lookup:
> >>                */
> >>       }
> >>       mutex_lock(&dir->d_inode->i_mutex);
> >> -     error = lookup_open(nd, path, file, op, got_write, opened);
> >> +     error = lookup_open(nd, path, file, op, got_write, opened, name);
> >>       mutex_unlock(&dir->d_inode->i_mutex);
> >>
> >>       if (error <= 0) {
> >
> > I'm not sure about this. Won't this cause us to miss creating audit
> > records in some error conditions?
> >
> > For instance, if you end up not being able to create the file due to
> > the fs being read-only, then I think this patch would make you miss the
> > audit record for the parent.
> >
> > Might it be better to not plumb an extra pointer into lookup_open and
> > just move the audit_inode calls around do_last in the appropriate
> > places instead?
> >
> > --
> > Jeff Layton <jlayton@primarydata.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
