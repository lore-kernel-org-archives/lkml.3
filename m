Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab3CNLPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:15:09 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:55955 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693Ab3CNLPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:15:07 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20130313154431.e39aed27efb095f9183bc123@linux-foundation.org>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<1363184193-1796-2-git-send-email-miklos@szeredi.hu>
	<20130313154431.e39aed27efb095f9183bc123@linux-foundation.org>
Date: Thu, 14 Mar 2013 12:15:04 +0100
Message-ID: <CAJfpegvGDTu3RUqC05EPNJA5zZrU5rgaBqWpXVz=B-JGoV_cog@mail.gmail.com>
Subject: Re: [PATCH 1/9] vfs: add i_op->dentry_open()
From: Miklos Szeredi <miklos@szeredi.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, apw@canonical.com, nbd@openwrt.org, neilb@suse.de,
        jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu, dhowells@redhat.com,
        sedat.dilek@googlemail.com, hooanon05@yahoo.co.jp, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 11:44 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 13 Mar 2013 15:16:25 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> Add a new inode operation i_op->dentry_open().  This is for stacked filesystems
>> that want to return a struct file from a different filesystem.
>>
>> ...
>>
>> +/**
>> + * vfs_open - open the file at the given path
>> + * @path: path to open
>> + * @filp: newly allocated file with f_flag initialized
>> + * @cred: credentials to use
>> + */
>> +int vfs_open(const struct path *path, struct file *filp,
>> +          const struct cred *cred)
>> +{
>> +     struct inode *inode = path->dentry->d_inode;
>> +
>> +     if (inode->i_op->dentry_open)
>> +             return inode->i_op->dentry_open(path->dentry, filp, cred);
>> +     else {
>> +             filp->f_path = *path;
>> +             return do_dentry_open(filp, NULL, cred);
>> +     }
>> +}
>
> This looks like it will add some overhead to dentry_open().  That long
> walk path->dentry->d_inode->i_op->dentry_open, particularly.  Can we do
> anything?  Using filp->f_inode might save a tad.

filp->f_inode is initialized in do_dentry_open.  But we can move that
to callers.

Adding an IOP_DENTRY_OPEN flag should take care of the rest.

> It's unfortunate and a bit ugly that ->dentry_open() and
> do_dentry_open() don't have the same arguments.  One would expect and
> like them to do so, and this difference raises suspicions about design
> warts.

Hmm, the basic reason for the difference is that filesystems should
not have access to the vfsmount part of the path.

Otherwise it would be trivial to make them match up.

>
> If they _did_ have the same signature then we could perhaps populate
> ->dentry_open with do_dentry_open by default and avoid the `if'.

Except there's no way to add a default i_op, AFAIK.

>
> The test of inode->i_op->dentry_open could do with an unlikely(), but
> that won't save us :(
>
>> +EXPORT_SYMBOL(vfs_open);
>
> Did you consider EXPORT_SYMBOL_GPL()?

It is not clear to me what to base that decision on.  Either one is fine by me.

Thanks,
Miklos
