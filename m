Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbaBCWME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:12:04 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:50716 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbaBCWMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:12:01 -0500
MIME-Version: 1.0
In-Reply-To: <20140203215908.GD10323@ZenIV.linux.org.uk>
References: <CALFYKtDCNWK+9m5m3P01dcxOOV7iHFeNaOH=Q=6Pffuo8gmrMQ@mail.gmail.com>
	<1391013467-7598-1-git-send-email-ilya.dryomov@inktank.com>
	<CA+55aFwTuBDHgQoTymr8OtE-+k=+pX0T_eb+fff0K+Pa3C-g-Q@mail.gmail.com>
	<20140130075421.GA10050@infradead.org>
	<CA+55aFxbVFpy8Y8P5fMCmmTSGbFxU9dTbOj9uTH+fKWGUzwgNg@mail.gmail.com>
	<20140203102943.GF11829@infradead.org>
	<CA+55aFytvTPdBsv6BwSomUGWXZ_tKP=BxaeJ7FXBft0JNnjBCQ@mail.gmail.com>
	<20140203215908.GD10323@ZenIV.linux.org.uk>
Date: Mon, 3 Feb 2014 14:12:00 -0800
X-Google-Sender-Auth: kYEzAi10lGHzNAeC_9bREWNiW3w
Message-ID: <CA+55aFz3PyyCqOLs_SBRS3cbGxWd5ez4Svz2+xK+4KtCez8iGw@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix posix ACL hooks
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>,
        Ilya Dryomov <ilya.dryomov@inktank.com>, Sage Weil <sage@inktank.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Guangliang Zhao <lucienchao@gmail.com>,
        Li Wang <li.wang@ubuntykylin.com>, zheng.z.yan@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 3, 2014 at 1:59 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Feb 03, 2014 at 01:03:32PM -0800, Linus Torvalds wrote:
>
>> -     err = vfs_mkdir(path.dentry->d_inode, dentry, mode);
>> +     err = vfs_mkdir(path.dentry, dentry, mode);
>
> Pointless - path.dentry == dentry->d_parent anyway.

Heh. It's no less redundant than it used to be.

But if you want to clean up the vfs_xyzzy() ones further, I'm
perfectly fine with that.

>> -     err = ll_vfs_rename(dir->d_inode, dchild_old, mnt,
>> -                         dir->d_inode, dchild_new, mnt, NULL);
>> +     err = ll_vfs_rename(dir, dchild_old, mnt,
>> +                         dir, dchild_new, mnt, NULL);
>
>
> ... and again, that's completely pointless.

Minimal patch.. I really didn't want to check what the heck lustre
does with the insane ll_vfs thing.

>> -int afs_permission(struct inode *inode, int mask)
>> +int afs_permission(struct dentry *dentry, struct inode *inode, int mask)
>
> Oh, _lovely_.  So not only do we pass dentry, the arguments are redundant
> as well.

Note that *not* passing in inode would make the patch much bigger,
because now every filesystem would have to add the

       struct inode *inode = dentry->d_inode;

at the top.

Also, I'm not actually convinced it is redundant at all. Remember the
RCU lookup case? dentry->d_inode is not safe.

The RCU case actually does

  inode_permission(nd->path.dentry, nd->inode, ..)

and here the difference between nd->inode and dentry->d_inode are
relevant, I think.

>> +static int gfs2_vfs_permission(struct dentry *dentry, struct inode *inode, int mask)
>> +{
>> +     return gfs2_permission(inode, mask);
>> +}
>
> Er...  You do realize that callers of gfs2_permission() tend to have
> the dentry in question, either directly or as ->d_parent of something
> they have?

Not true. Look closer.

Look at gfs2_lookupi() in particular, and check how it is called.

I did hate that part of the patch, and I did mention the kinds of
problems this will cause if the next phase passes in dentry to
"generic_permission()".

                Linus
