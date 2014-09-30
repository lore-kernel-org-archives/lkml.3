Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaI3DPj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 23:15:39 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:62636 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaI3DPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 23:15:37 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <CAJfpegsN8BRE8_RUT9n-h+o7Q5ayaqLtErJ01jSitxoZ7QU-BQ@mail.gmail.com>
References: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
	<CAJfpegsN8BRE8_RUT9n-h+o7Q5ayaqLtErJ01jSitxoZ7QU-BQ@mail.gmail.com>
Date: Tue, 30 Sep 2014 05:15:36 +0200
Message-ID: <CAJfpegv76ZbHec=N3z1LfYazwbsgzwr0UZf6LWd+G=J3EPmi1Q@mail.gmail.com>
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel <fuse-devel@lists.sourceforge.net>,
        Anand Avati <avati@gluster.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 5:28 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> [Adding CC's]
>
> On Thu, Sep 25, 2014 at 2:05 PM, Maxim Patlasov <MPatlasov@parallels.com> wrote:
>
>> In short, the problem is that fuse_release (that's usually called on last
>> user close(2)) sends FUSE_RELEASE to userspace and returns without waiting
>> for ACK from userspace. Consequently, there is a gap when user regards the
>> file released while userspace fuse is still working on it. An attempt to
>> access the file from another node leads to complicated synchronization
>> problems because the first node still "holds" the file.
>>
>> The patch-set resolves the problem by making fuse_release synchronous:
>> wait for ACK from userspace for FUSE_RELEASE if the feature is ON.
>>
>> It must be emphasized that even if the feature is enabled (i.e. fuse_release
>> is synchronous), nothing guarantees that fuse_release() will be called
>> in the context of close(2). In fact, it may happen later, on last fput().
>> However, there are still a lot of use cases when close(2) is synchronous,
>> so the feature must be regarded as an optimization maximizing chances of
>> synchronous behaviour of close(2).
>
> Okay, we have the common case of close -> last-fput ->release.  This
> being synchronous is fine.  Related cases are munmap(), and weird
> corner cases including I/O on file descriptor being done in parallel
> with close() in another thread.  Synchronous behavior is also fine in
> these cases, since the task calling the last fput() is in fact
> responsible for releasing the file.
>
> And then we have the uncommon cases when fput() is called from
> something unrelated.  Take the following DoS example:  malicious app
> creates a socket loop (sockA is sent over sockB and sockB is sent over
> sockA) and in addition it tacks a fuse fd onto one of the sockets.
> The fuse fd is implemented to block forever on release.  In this case
> the loop will persist after the sockets are closed due to refcounting.
> Later, a garbage collection is triggered from a completely unrelated
> socket operation.   This result in the unrelated task being blocked
> forever.
>
> The simplest way to avoid such an attack is to make the sync-release
> feature privileged.  But even if it's privileged, the fact that
> ->release can take a lot of time and a completely unrelated task could
> be waiting for it to finish is not a good thing.
>
> So I'm wondering: could we have some way of distinguishing "good
> release" from "bad release"?  Maybe adding an fput_sync() variant that
> passes an "sync" flag to ->release()?

If we just concentrate on close(2), then there's a much simpler
solution: in fuse_flush() check if file_count(file) is 1.  If it is,
then this is a final close and we can mark the FLUSH request as such
with a flag (FUSE_FLUSH_FINAL).  Userspace filesystem can act
accordingly and may even return an error value to close(2).  In this
case we could even omit the RELEASE request as an optimization, since
we know the file cannot be resurrected if this was the last reference.

Do we need to be synchronous in any other case?  E.g. munmap() comes to mind.

Thanks,
Miklos
