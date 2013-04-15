Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816Ab3DOSRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 14:17:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58965 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab3DOSRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 14:17:49 -0400
Date: Mon, 15 Apr 2013 19:17:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Maxim Patlasov <mpatlasov@parallels.com>, dev@parallels.com,
        xemul@parallels.com, fuse-devel@lists.sourceforge.net,
        bfoster@redhat.com, linux-kernel@vger.kernel.org, devel@openvz.org,
        anand.avati@gmail.com
Subject: Re: [PATCH 0/5] fuse: close file synchronously
Message-ID: <20130415181739.GJ4068@ZenIV.linux.org.uk>
References: <20121220122702.4101.80042.stgit@maximpc.sw.ru>
 <CAJfpegsD2iyP2=Z3zL-yb_TjjQxipOBKV7yqpdPPTH9oobQ=bA@mail.gmail.com>
 <CAJfpegtvfunCV4cjezQuWji3PoJRpXXKWgH+y55tYMi0O+TdkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtvfunCV4cjezQuWji3PoJRpXXKWgH+y55tYMi0O+TdkQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 05:30:41PM +0200, Miklos Szeredi wrote:
> On Mon, Apr 15, 2013 at 5:08 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> > For example doing a readlink() on a magic symlink under /proc
> > shouldn't result in a synchronous call to a fuse filesystem.  Making
> > fput() synchronous may actually end up doing that (even if it's not
> > very likely).
> 
> Thinking about this a bit more.  As it is it sounds wrong to rely on a
> synchronous release, when in fact release is just not synchronous, as
> indicated by the above example.  Maybe it's the proc code that's buggy
> and shouldn't do get_file/fput because everyone is assuming release
> being synchronous with close().  Don't know.

What the hell?  ->release() is not and has never been synchronous with close().
There is any number of places where the final fput() might be called and no,
this readlink example is irrelevant - things like munmap()/dup2()/close
of a socket discarding a datagram with the last reference to struct file in
it, et sodding cetera.

Hell, another thread might be in the middle of read(2) at the moment when you
call close().  Result: the final fput() will be done when we are about to
return from that read(2).

People, ->release() is *NOT* guaranteed to be anywhere near close(2).  Never
had been.
