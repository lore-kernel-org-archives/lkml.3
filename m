Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751148Ab3IPUJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 16:09:52 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:45472 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab3IPUJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 16:09:48 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20130916195003.GE13318@ZenIV.linux.org.uk>
References: <1379335925-30858-1-git-send-email-miklos@szeredi.hu>
	<1379335925-30858-3-git-send-email-miklos@szeredi.hu>
	<20130916181938.GD13318@ZenIV.linux.org.uk>
	<CAJfpegt3mAKVE7ToZbvPpFQCY1EAZ3tKfn__kfpGz4HeXWr8fw@mail.gmail.com>
	<20130916195003.GE13318@ZenIV.linux.org.uk>
Date: Mon, 16 Sep 2013 22:09:46 +0200
Message-ID: <CAJfpegsLeuw55Diw0yDmiFR+7qkSkOrW2fUbjmzFC9OxVsrAkQ@mail.gmail.com>
Subject: Re: [PATCH 02/11] 9p: fix dentry leak in v9fs_vfs_atomic_open_dotl()
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        "M. Mohan Kumar" <mohan@in.ibm.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 9:50 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Sep 16, 2013 at 09:03:25PM +0200, Miklos Szeredi wrote:
>> On Mon, Sep 16, 2013 at 8:19 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > On Mon, Sep 16, 2013 at 02:51:56PM +0200, Miklos Szeredi wrote:
>> >> From: Miklos Szeredi <mszeredi@suse.cz>
>> >>
>> >> commit b6f4bee02f "fs/9p: Fix atomic_open" fixed the O_EXCL behavior, but
>> >> results in a dentry leak if v9fs_vfs_lookup() returns non-NULL.
>> >
>> > Frankly, I would prefer to deal with that in fs/namei.c:atomic_open()
>> > instead.  I.e. let it call finish_no_open() as it used to do and
>> > turn
>> >                 if (create_error && dentry->d_inode == NULL) {
>> >                         error = create_error;
>> >                         goto out;
>> >                 }
>> > in fs/namei.c:atomic_open() into
>> >                 if (!dentry->d_inode) {
>> >                         if (create_error) {
>> >                                 error = create_error;
>> >                                 goto out;
>> >                         }
>> >                 } else if ((open_flag & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL)) {
>> >                         error = -EEXIST;
>> >                         goto out;
>> >                 }
>> >
>> > rather than try to deal with that crap in each instance of ->atomic_open()...
>> > Objections?
>>
>> ->atomic_open() could be any one of
>>
>>  lookup
>>  lookup+create
>>  lookup+create+open
>>
>> If it's the second one then the above is wrong.  Sure, we could check
>> FILE_CREATED as well, and if file wasn't created yet dentry is
>> positive then we return EEXIST.  But for that to be correct we need
>> the last patch in the series, preventing FILE_CREATED from being set
>> unconditionally.
>
> You mean, lookup + create + return finish_no_open()?  Does anything actually
> do that?

Fuse does.

>  I agree that we want your "deal with setting FILE_CREATED in
> filesystems", BTW, and I'm fine with putting it in front of the rest of
> the queue.
>
> I would definitely prefer EEXIST logics dealt with in fs/namei.c - if nothing
> else, it had been done wrong in too many instances...

Okay.

Thanks,
Miklos
