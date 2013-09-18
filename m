Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab3IRIzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 04:55:14 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:52728 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab3IRIzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 04:55:11 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20130917212359.GJ13318@ZenIV.linux.org.uk>
References: <1379335925-30858-3-git-send-email-miklos@szeredi.hu>
	<20130916181938.GD13318@ZenIV.linux.org.uk>
	<CAJfpegt3mAKVE7ToZbvPpFQCY1EAZ3tKfn__kfpGz4HeXWr8fw@mail.gmail.com>
	<20130916195003.GE13318@ZenIV.linux.org.uk>
	<CAJfpegsLeuw55Diw0yDmiFR+7qkSkOrW2fUbjmzFC9OxVsrAkQ@mail.gmail.com>
	<20130916220241.GF13318@ZenIV.linux.org.uk>
	<20130916232810.GG13318@ZenIV.linux.org.uk>
	<CAJfpegtJwgFNNQQB3AX9umsK+RacpQFSoakAMs++w6TT9x0yGw@mail.gmail.com>
	<20130917114404.GI13318@ZenIV.linux.org.uk>
	<CAJfpegtSVYStQQuJvd6CWAy-ZM6v8tmTcL5uz=iA1aHM72TeQQ@mail.gmail.com>
	<20130917212359.GJ13318@ZenIV.linux.org.uk>
Date: Wed, 18 Sep 2013 10:55:09 +0200
Message-ID: <CAJfpegvi-97o5c5MAjHFW=i5OZV7vpqF_cG5xTfFGfvSwZ8u9A@mail.gmail.com>
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

On Tue, Sep 17, 2013 at 11:23 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Sep 17, 2013 at 05:36:49PM +0200, Miklos Szeredi wrote:
>> On Tue, Sep 17, 2013 at 1:44 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> > On Tue, Sep 17, 2013 at 12:16:56PM +0200, Miklos Szeredi wrote:
>> >
>> >> Just one. This needs to be removed, since this condition is now
>> >> explicitly allowed and later checked for:
>> >>
>> >>     if (WARN_ON(excl && !(*opened & FILE_CREATED)))
>> >>         *opened |= FILE_CREATED;
>> >
>> > D'oh...  Fixed and pushed.
>>
>> Okay, but moving the fsnotify_create()  to after the no-open section
>> is wrong, I think,  It's needed for the case of ->atomic_open() doing
>> lookup/create/no_open too.
>
> What a mess...  It's actually even uglier than that - which dentry should
> we pass to fsnotify_create() in case where finish_no_open() has been given
> a non-NULL dentry other than one we had passed to ->atomic_open()?  I think
> that version in mainline is actually broken in that respect as far as fuse
> is concerned, not that anybody sane could expect ...notify to work on fuse.

Yeah, your version is definitely nicer.  The correctness of the old
version could be argued thus:  if FILE_CREATED was set, then the file
didn't exist before, so there's no sense in reusing or allocating
another dentry.  But yes, the API allows it.

Thanks,
Miklos
