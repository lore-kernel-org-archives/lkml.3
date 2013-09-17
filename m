Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3IQVYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 17:24:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60149 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab3IQVYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 17:24:06 -0400
Date: Tue, 17 Sep 2013 22:23:59 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        "M. Mohan Kumar" <mohan@in.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH 02/11] 9p: fix dentry leak in v9fs_vfs_atomic_open_dotl()
Message-ID: <20130917212359.GJ13318@ZenIV.linux.org.uk>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtSVYStQQuJvd6CWAy-ZM6v8tmTcL5uz=iA1aHM72TeQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 17, 2013 at 05:36:49PM +0200, Miklos Szeredi wrote:
> On Tue, Sep 17, 2013 at 1:44 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Tue, Sep 17, 2013 at 12:16:56PM +0200, Miklos Szeredi wrote:
> >
> >> Just one. This needs to be removed, since this condition is now
> >> explicitly allowed and later checked for:
> >>
> >>     if (WARN_ON(excl && !(*opened & FILE_CREATED)))
> >>         *opened |= FILE_CREATED;
> >
> > D'oh...  Fixed and pushed.
> 
> Okay, but moving the fsnotify_create()  to after the no-open section
> is wrong, I think,  It's needed for the case of ->atomic_open() doing
> lookup/create/no_open too.

What a mess...  It's actually even uglier than that - which dentry should
we pass to fsnotify_create() in case where finish_no_open() has been given
a non-NULL dentry other than one we had passed to ->atomic_open()?  I think
that version in mainline is actually broken in that respect as far as fuse
is concerned, not that anybody sane could expect ...notify to work on fuse.

Anyway, I've pushed what I think is a sane fix.  Please, review and test -
I don't have a setup for testing fsnotify on fuse.
