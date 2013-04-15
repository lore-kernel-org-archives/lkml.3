Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab3DOPas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 11:30:48 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38625 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976Ab3DOPan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 11:30:43 -0400
MIME-Version: 1.0
X-Originating-IP: [188.6.195.195]
In-Reply-To: <CAJfpegsD2iyP2=Z3zL-yb_TjjQxipOBKV7yqpdPPTH9oobQ=bA@mail.gmail.com>
References: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
	<CAJfpegsD2iyP2=Z3zL-yb_TjjQxipOBKV7yqpdPPTH9oobQ=bA@mail.gmail.com>
Date: Mon, 15 Apr 2013 17:30:41 +0200
Message-ID: <CAJfpegtvfunCV4cjezQuWji3PoJRpXXKWgH+y55tYMi0O+TdkQ@mail.gmail.com>
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

On Mon, Apr 15, 2013 at 5:08 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> For example doing a readlink() on a magic symlink under /proc
> shouldn't result in a synchronous call to a fuse filesystem.  Making
> fput() synchronous may actually end up doing that (even if it's not
> very likely).

Thinking about this a bit more.  As it is it sounds wrong to rely on a
synchronous release, when in fact release is just not synchronous, as
indicated by the above example.  Maybe it's the proc code that's buggy
and shouldn't do get_file/fput because everyone is assuming release
being synchronous with close().  Don't know.

Let's approach it from the other direction:  what if you give back the
write lease on the first flush?  It will probably work fine for 99% of
cases, since no other writes are going to happen after the first
flush.  For the remaining cases you'll just have to reacquire the
lease when a write happens after the flush.  I guess performance-wise
that will not be an issue, but I may be wrong.

Thanks,
Miklos
