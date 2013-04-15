Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab3DOPIy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:08:54 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:63115 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab3DOPIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:08:52 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
References: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
Date: Mon, 15 Apr 2013 17:08:50 +0200
Message-ID: <CAJfpegsD2iyP2=Z3zL-yb_TjjQxipOBKV7yqpdPPTH9oobQ=bA@mail.gmail.com>
Subject: Re: [PATCH 0/5] fuse: close file synchronously
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: dev@parallels.com, xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org,
        anand.avati@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 1:30 PM, Maxim Patlasov <mpatlasov@parallels.com> wrote:
> Hi,
>
> There is a long-standing demand for syncronous behaviour of fuse_release:
>
> http://sourceforge.net/mailarchive/message.php?msg_id=19343889
> http://sourceforge.net/mailarchive/message.php?msg_id=29814693
>
> A few months ago Avati and me explained why such a feature would be useful:
>
> http://sourceforge.net/mailarchive/message.php?msg_id=29889055
> http://sourceforge.net/mailarchive/message.php?msg_id=29867423
>
> In short, the problem is that fuse_release (that's called on last user
> close(2)) sends FUSE_RELEASE to userspace and returns without waiting for
> ACK from userspace. Consequently, there is a gap when user regards the
> file released while userspace fuse is still working on it. An attempt to
> access the file from another node leads to complicated synchronization
> problems because the first node still "holds" the file.
>
> The patch-set resolves the problem by making fuse_release synchronous:
> wait for ACK from userspace for FUSE_RELEASE if the feature is ON.
>
> To keep single-threaded userspace implementations happy the patch-set
> ensures that by the time fuse_release_common calls fuse_file_put, no
> more in-flight I/O exists. Asynchronous fuse callbacks (like
> fuse_readpages_end) cannot trigger FUSE_RELEASE anymore. Hence, we'll
> never block in contexts other than close().

There are a few fput() calls outside sys_close(), all of these can
trigger FUSE_RELEASE.  Most of those are OK, but for some I'm
reluctant to enable synchronous release.

For example doing a readlink() on a magic symlink under /proc
shouldn't result in a synchronous call to a fuse filesystem.  Making
fput() synchronous may actually end up doing that (even if it's not
very likely).

At least for the unprivileged fuse daemon case it shouldn't be done.
If the fuse daemon can be "trusted" then enabling synchronous release
should be okay, that's why it's enabled for fuseblk.

But maybe I'm just too paranoid...

Thanks,
Miklos
