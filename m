Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090Ab3EPGT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 02:19:27 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:54873 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3EPGTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 02:19:22 -0400
MIME-Version: 1.0
In-Reply-To: <20130514105119.66a5bc3f@corrin.poochiereds.net>
References: <CAJfpegtADAJ+7-DiFvrgWU1N5Fsd_CCQryT0mpx6VOJ=8ikKsA@mail.gmail.com>
	<20130510102754.184cd90d@corrin.poochiereds.net>
	<20130514105119.66a5bc3f@corrin.poochiereds.net>
Date: Thu, 16 May 2013 10:19:22 +0400
Message-ID: <CAKywueTcQPhxNqTsx9WLkJTg9DkRV-TwqLdiA_PQWtO=M8iDfA@mail.gmail.com>
Subject: Re: Mount failure due to restricted access to a point along the mount path
From: Pavel Shilovsky <piastryyy@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        sjayaraman@novell.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/5/14 Jeff Layton <jlayton@redhat.com>:
> On Fri, 10 May 2013 10:27:54 -0400
> Jeff Layton <jlayton@redhat.com> wrote:
>
>> On Fri, 10 May 2013 16:13:30 +0200
>> Miklos Szeredi <miklos@szeredi.hu> wrote:
>>
>> > Hi,
>> >
>> > A while ago this was discussed:
>> >
>> >   http://thread.gmane.org/gmane.linux.kernel.cifs/7779
>> >
>> > This is essentially a regression introduced by the shared superblock
>> > changes in 3.0 and several SUSE customers are complaining about it.
>> > I've created a temporary fix which reverts 29 commits related to the
>> > shared superblock changes.  It works, but it's obviously not a
>> > permanent fix, especially since we definitely don't want to diverge
>> > from mainline.
>> >
>> > Is this issue being worked on?  Don't other distros have similar reports?
>> >
>> > Thanks,
>> > Miklos
>>
>> I don't know of anyone currently working on it. There are a couple of
>> possible approaches to fixing it, I think:
>>
>> 1) if the dentries to get down to the root of the mount don't already
>> exist, then attach some sort of "placeholder" inode that can be fleshed
>> out later if and when the dentry is accessed via other means.
>>
>> 2) do something like what NFS does (see commit 54ceac45). This becomes
>> a bit more complicated due to the fact that the server may not hand out
>> real inode numbers and we sometimes have to fake them up.
>>
>> #1 is probably simpler to implement, but I'll confess that I haven't
>> thought through all of the potential problems with it.
>>
>
> So, giving this some more thought, I think #2 is really the correct way
> to fix this. Here's the main problem though:
>
> Suppose someone mounts:
>
>     //server/share/foo/bar/baz
>
> We make the sb->s_root point to the top level share, and then create a
> disconnected dentry for "baz" to return from ->mount.
>
> Then, a little while later, //server/share gets mounted separately and
> a user walks down to /foo/bar/baz within the same share.
>
> How do we ensure that we don't end up with two "baz" dentries in this
> situation? With NFS, we can be reasonably sure that there's a 1:1
> correspondance of filehandle to inode.
>
> Under CIFS, it's possible that it's faking up inode numbers if the
> server doesn't provide them via a UniqueID field. The only real
> identifying info we have for the inode in that case is the pathname.
>
> Perhaps we'd be best off to just rip out the sb sharing after all.
> Getting all of the corner cases right when the protocol and server
> implementations are so problematic is really, really difficult.
>
> If we do go that route, then the fscache code will need some work since
> it uses the sharename as a sb cookie.

Another option is to add mount options shared and nonshared (default)
like NFS already has and let users use
sharing capability if the permissions on server allow walking through
a share path to a mount root.

--
Best regards,
Pavel Shilovsky.
