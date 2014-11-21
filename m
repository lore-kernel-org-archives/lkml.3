Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbaKUQNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 11:13:40 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:64532 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099AbaKUQNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 11:13:38 -0500
MIME-Version: 1.0
In-Reply-To: <546F606D.40407@oracle.com>
References: <1416546149-24799-1-git-send-email-gregkh@linuxfoundation.org>
	<1416546149-24799-7-git-send-email-gregkh@linuxfoundation.org>
	<546F606D.40407@oracle.com>
Date: Fri, 21 Nov 2014 17:13:26 +0100
Message-ID: <CANq1E4QkXv9Ak6eT+NZPsy+5nTGKE8oypLvdr97cFcvmtigS_A@mail.gmail.com>
Subject: Re: kdbus: add node and filesystem implementation
From: David Herrmann <dh.herrmann@gmail.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, ebiederm@xmission.com,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Tom Gundersen <teg@jklm.no>, Jiri Kosina <jkosina@suse.cz>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux API <linux-api@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Daniel Mack <daniel@zonque.org>, Djalal Harouni <tixxdz@opendz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, Nov 21, 2014 at 4:55 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
> On 11/21/2014 12:02 AM, Greg Kroah-Hartman wrote:
>> +static struct dentry *fs_dir_iop_lookup(struct inode *dir,
>> +                                     struct dentry *dentry,
>> +                                     unsigned int flags)
>> +{
>> +     struct dentry *dnew = NULL;
>> +     struct kdbus_node *parent;
>> +     struct kdbus_node *node;
>> +     struct inode *inode;
>> +
>> +     parent = kdbus_node_from_dentry(dentry->d_parent);
>> +     if (!kdbus_node_acquire(parent))
>> +             return NULL;
>> +
>> +     /* returns reference to _acquired_ child node */
>> +     node = kdbus_node_find_child(parent, dentry->d_name.name);
>> +     if (node) {
>> +             dentry->d_fsdata = node;
>> +             inode = fs_inode_get(dir->i_sb, node);
>> +             if (IS_ERR(inode))
>> +                     dnew = ERR_CAST(inode);
>> +             else
>> +                     dnew = d_materialise_unique(dentry, inode);
>
> d_materialise_unique() is gone in Al's fs tree:
>
> [mandatory]
>         d_materialise_unique() is gone; d_splice_alias() does everything you
>         need now.  Remember that they have opposite orders of arguments ;-/

That was actually pushed after we prepared v2, so I haven't seen it
yet. I now rebased on top of vfs.git#for-next, with
d_materialise_unique() -> d_splice_alias(). Thanks for the hint!

> Maybe it's worth basing your git tree on top of Al's rather than a random
> -rc, since it's now a filesystem?

Sure, sounds good.

Thanks
David
