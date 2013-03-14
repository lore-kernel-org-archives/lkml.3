Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757975Ab3CNN2u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 09:28:50 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:56636 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab3CNN2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 09:28:48 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20130313154811.191d970b8376f80ea98195a0@linux-foundation.org>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<1363184193-1796-5-git-send-email-miklos@szeredi.hu>
	<20130313154811.191d970b8376f80ea98195a0@linux-foundation.org>
Date: Thu, 14 Mar 2013 14:28:46 +0100
Message-ID: <CAJfpegswKPfYvyX2ejuBC_ojHDejDWU7zrUQTUoJTx26jVPJZg@mail.gmail.com>
Subject: Re: [PATCH 4/9] vfs: introduce clone_private_mount()
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

On Wed, Mar 13, 2013 at 11:48 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 13 Mar 2013 15:16:28 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:
>
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> Overlayfs needs a private clone of the mount, so create a function for
>> this and export to modules.
>>
>> ...
>>
>> +struct vfsmount *clone_private_mount(struct path *path)
>> +{
>> +     struct mount *old_mnt = real_mount(path->mnt);
>> +     struct mount *new_mnt;
>> +
>> +     if (IS_MNT_UNBINDABLE(old_mnt))
>> +             return ERR_PTR(-EINVAL);
>> +
>> +     down_read(&namespace_sem);
>> +     new_mnt = clone_mnt(old_mnt, path->dentry, CL_PRIVATE);
>> +     up_read(&namespace_sem);
>> +     if (!new_mnt)
>> +             return ERR_PTR(-ENOMEM);
>> +
>> +     return &new_mnt->mnt;
>> +}
>> +EXPORT_SYMBOL_GPL(clone_private_mount);
>
> So this one gets the _GPL?
>
> This is a new, exported-to-modules kernel interface function.  And it
> is undocumented?

Following documentation added:

/**
 * clone_private_mount - create a private clone of a path
 *
 * This creates a new vfsmount, which will be the clone of @path.  The new will
 * not be attached anywhere in the namespace and will be private (i.e. changes
 * to the originating mount won't be propagated into this).
 *
 * Release with mntput().
 */
