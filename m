Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964879Ab3IEJL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:11:27 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:40943 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763319Ab3IEJLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:11:24 -0400
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <20130904175834.GI13318@ZenIV.linux.org.uk>
References: <1378303556-7220-1-git-send-email-miklos@szeredi.hu>
	<1378303556-7220-3-git-send-email-miklos@szeredi.hu>
	<20130904175834.GI13318@ZenIV.linux.org.uk>
Date: Thu, 5 Sep 2013 11:11:23 +0200
Message-ID: <CAJfpegsQ=COW0kGKLmZ_q7t3qTD2TXuFMGL8sSDSOvcRZQU4Gg@mail.gmail.com>
Subject: Re: [PATCH 02/10] vfs: check submounts and drop atomically
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Ric Wheeler <rwheeler@redhat.com>, Anand Avati <avati@redhat.com>,
        Brian Foster <bfoster@redhat.com>, David Howells <dhowells@redhat.com>,
        Eric Paris <eparis@redhat.com>, Ian Kent <raven@themaw.net>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 7:58 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Wed, Sep 04, 2013 at 04:05:48PM +0200, Miklos Szeredi wrote:
>
>> +static void check_and_drop(void *_data, struct dentry *dentry)
>> +{
>> +     struct select_data *data = _data;
>> +
>> +     /* We're only interested in the root of this subtree */
>> +     if (data->start == dentry) {
>> +             if (d_mountpoint(dentry))
>> +                     data->found = -EBUSY;
>> +             if (!data->found)
>> +                     __d_drop(dentry);
>> +     }
>> +}
>
> Wouldn't it be better to do that in caller?

It needs to stay under d_lock.  Moving the unlock to caller would be
rather awkward (if we quit walking the start dentry is not even
locked, etc..)  So instead of a ->leave() callback, I just added a
->finish() callback which is called once, when the walk was finished
successfully.

Fixed your other comments too.  I'll do a quick testing and then post
the changed patches.

Thanks,
Miklos
