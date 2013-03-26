Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3CZWSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:18:41 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:54145 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3CZWSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:18:40 -0400
MIME-Version: 1.0
X-Originating-IP: [212.159.75.221]
In-Reply-To: <20130326191848.GW21522@ZenIV.linux.org.uk>
References: <1364311169-3413-1-git-send-email-james.hogan@imgtec.com>
	<20130326191848.GW21522@ZenIV.linux.org.uk>
Date: Tue, 26 Mar 2013 22:18:38 +0000
X-Google-Sender-Auth: rkFvlD3njhqzsEQsG1ynAWulS4A
Message-ID: <CAAG0J9_k=qiisWi0OBXzNEfdZB9G1az3ThfPO5jRsgWkq0pgTw@mail.gmail.com>
Subject: Re: [PATCH v6] fs: imgdafs: Add IMG DAFS filesystem for metag
From: James Hogan <james.hogan@imgtec.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reviewing Al...

On 26 March 2013 19:18, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Mar 26, 2013 at 03:19:29PM +0000, James Hogan wrote:
>> +struct da_finddata {
>> +     unsigned long size;
>> +     unsigned long attrib;
>> +     char name[260];
>> +};
>
> ... especially for this - unlike int and short, long really is arch-dependent.
> And yes, I realize that this thing is arch-specific, but...

Yes, agreed.

>
>> +struct dafs_inode_info {
>> +     int fd;
>> +     int mode;
>
> umm... int or fmode_t?

Indeed. The same update to hostfs during v2.6.28 was missed :-(

>
>> +     struct inode vfs_inode;
>> +};
>
>> +#define DAFS_SUPER_MAGIC 0xdadadaf5
>
> -> linux/magic.h

Okay. hostfs has the same problem.

>
>> +static char *dentry_name(struct dentry *dentry)
>> +{
>> +     char *name = __getname();
>> +     if (!name)
>> +             return NULL;
>> +
>> +     return __dentry_name(dentry, name); /* will unlock */
>
> will unlock what?

The change adding this was based on hostfs, which had the comment
added by you in e9193059b1b3733695d5b80e667778311695aa73 ("hostfs: fix
races in dentry_name() and inode_name()"), along with a spin_lock just
before it. The spin_lock (and unlock in __dentry_name) was
subsequently removed in ec2447c278ee973d35f38e53ca16ba7f965ae33d
("hostfs: simplify locking"), so the comment is no longer relevant.
I'll remove it.

>
>> +     hi = kzalloc(sizeof(*hi), GFP_KERNEL);
>> +     if (hi == NULL)
>> +             return NULL;
>> +
>> +     hi->fd = -1;
>> +     inode_init_once(&hi->vfs_inode);
>> +     return &hi->vfs_inode;
>
> Umm...  kzalloc() looks odd, seeing that you proceed to initialize two
> fields out of 3 (including the really big one) explicitly...

Agreed, another issue in common with hostfs. I'll fix.

>
>> +static int open_dir(char *path, struct da_finddata *finddata, int *fserrno)
>> +{
>> +     int len = strlen(path);
>> +     char buf[len + 3];
>
> Bad idea, considering that strlen(path) is user-controlled and can
> theoretically go up to 4Kb...

Ouch yes, I'll convert it to use kmalloc/kfree (the fs operations are
horribly slow anyway so it's never a performance issue).

>
>> +static int dafs_readdir(struct file *file, void *ent, filldir_t filldir)
>> +{
>> +     struct inode *inode = file->f_path.dentry->d_inode;
>
> minor nit, but... that's file_inode(file)

Ooh yes.

>
>> +     name = dentry_name(file->f_path.dentry);
>> +     if (name == NULL)
>> +             return -ENOMEM;
>> +     handle = open_dir(name, &finddata, &fserrno);
>
> ... and what if the sucker's parent gets renamed between dentry_name() and
> open_dir()?  The same goes for the rest of dentry_name() users, actually.

It would seem impossible to protect against this happening from the
file server side, and as for the Linux side...

>
>> +static int dafs_rename(struct inode *from_ino, struct dentry *from,
>> +               struct inode *to_ino, struct dentry *to)
>> +{
>> +     char *from_name, *to_name;
>> +     int err;
>> +
>> +     from_name = dentry_name(from);
>> +     if (from_name == NULL)
>> +             return -ENOMEM;
>> +     to_name = dentry_name(to);
>> +     if (to_name == NULL) {
>> +             __putname(from_name);
>> +             return -ENOMEM;
>> +     }
>> +     err = -EINVAL;
>> +     __putname(from_name);
>> +     __putname(to_name);
>> +     return err;
>> +}
>
> Aha.  No rename(2), IOW.  Is one planned?

Hmm, indeed it appears a rename DAFS operation hasn't been defined.
I'll double check that tomorrow. DAFS is usually used for just copying
data to/from a target (e.g. an fpga with no other connectivity) so the
lack of rename isn't usually a problem.

I'll fix up these issues (and do some separate patches for hostfs too).

Thanks
James
