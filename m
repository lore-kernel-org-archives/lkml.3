Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaJPNnz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 09:43:55 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:36118 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaJPNnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 09:43:53 -0400
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <543F9E75.2090509@parallels.com>
References: <20140925120244.540.31506.stgit@dhcp-10-30-22-200.sw.ru>
	<CA+55aFwfTeoCJDs6RJg++0SY=SsPrn7Y_Y0Ag_TsNvd6Vsj1Eg@mail.gmail.com>
	<CAFboF2yhGyjk4e_CHQV5b2WvB-QhsWNyHvFiFG_OM_=3-KArLQ@mail.gmail.com>
	<CA+55aFwqAOGbQ-LYmD-aSALTyA0p9=0vNdsJWd+uweUQyzsW8w@mail.gmail.com>
	<20140930191933.GC5011@tucsk.piliscsaba.szeredi.hu>
	<CA+55aFyD2Q6tJzRUbNyNFRdbSN09SAN9CqC5BTmCtOu4W9PKGw@mail.gmail.com>
	<542BE551.1010705@parallels.com>
	<CAJfpegs4Up_feUbqEGxfhq+rZneTmy0qcZy-k3so7VjufQY7-w@mail.gmail.com>
	<543F9E75.2090509@parallels.com>
Date: Thu, 16 Oct 2014 15:43:52 +0200
Message-ID: <CAJfpegvS+rmFqGgvHq183Z-MxLAwcgEB57LQxAwy3QAe5CaVwg@mail.gmail.com>
Subject: Re: [PATCH 0/5] fuse: handle release synchronously (v4)
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Anand Avati <avati@gluster.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel <fuse-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 12:31 PM, Maxim Patlasov
<mpatlasov@parallels.com> wrote:

> Something as simple as:
>
> int main(int argc, char *argv[])
> {
>     int fd = open(argv[1], O_RDWR);
>     fork();
> }
>
> may easily dive into fuse_try_sync_release() concurrently and both observe
> file->f_count == 2. Then both return falling back to sending the release
> asynchronously. This makes sync/async behaviour unpredictable even for
> well-behaved applications which don't do any esoteric things like racing i/o
> with close or exiting while a descriptor is in-flight in a unix domain
> socket.
>
> I cannot see any way to recognise last flush without help of VFS layer, can
> you?

No.

One idea is to change ->flush() so it's responsible for fput()-ing the
file.  That way we could take control of the actual refcount
decrement.  There are only 20 flush instances in the tree, so it
wouldn't be a huge change.

Thanks,
Miklos
