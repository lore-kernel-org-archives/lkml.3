Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934477Ab3DPJJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 05:09:06 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:62721 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933899Ab3DPJJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 05:09:04 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20130415181739.GJ4068@ZenIV.linux.org.uk>
References: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
	<CAJfpegsD2iyP2=Z3zL-yb_TjjQxipOBKV7yqpdPPTH9oobQ=bA@mail.gmail.com>
	<CAJfpegtvfunCV4cjezQuWji3PoJRpXXKWgH+y55tYMi0O+TdkQ@mail.gmail.com>
	<20130415181739.GJ4068@ZenIV.linux.org.uk>
Date: Tue, 16 Apr 2013 11:09:02 +0200
Message-ID: <CAJfpegsv7nuXHCFw823dncbBbwQF1eVqv8benbPxGNt+NDgRrg@mail.gmail.com>
Subject: Re: [PATCH 0/5] fuse: close file synchronously
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Maxim Patlasov <mpatlasov@parallels.com>, dev@parallels.com,
        xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org,
        anand.avati@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 8:17 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Apr 15, 2013 at 05:30:41PM +0200, Miklos Szeredi wrote:
>> On Mon, Apr 15, 2013 at 5:08 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> > For example doing a readlink() on a magic symlink under /proc
>> > shouldn't result in a synchronous call to a fuse filesystem.  Making
>> > fput() synchronous may actually end up doing that (even if it's not
>> > very likely).
>>
>> Thinking about this a bit more.  As it is it sounds wrong to rely on a
>> synchronous release, when in fact release is just not synchronous, as
>> indicated by the above example.  Maybe it's the proc code that's buggy
>> and shouldn't do get_file/fput because everyone is assuming release
>> being synchronous with close().  Don't know.
>
> What the hell?  ->release() is not and has never been synchronous with close().
> There is any number of places where the final fput() might be called and no,
> this readlink example is irrelevant - things like munmap()/dup2()/close
> of a socket discarding a datagram with the last reference to struct file in
> it, et sodding cetera.
>
> Hell, another thread might be in the middle of read(2) at the moment when you
> call close().  Result: the final fput() will be done when we are about to
> return from that read(2).

Apparently we do make some pains to make ->release() return before the
syscall that triggered it returns.  Why is that then?

I think the difference between proc symlink and all the rest is that
everything the app does to the file descriptor is its own business.
If it just does single threaded open, read/write, close (which is what
the vast majority of apps do) then close *is* going to be synchronous
with release.  At least most of the time.

Thanks,
Miklos
