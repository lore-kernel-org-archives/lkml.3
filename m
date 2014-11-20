Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbaKTWZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 17:25:12 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59815 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbaKTWZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 17:25:10 -0500
Date: Thu, 20 Nov 2014 22:25:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        target-devel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] situation with csum_and_copy_... API
Message-ID: <20141120222506.GS7996@ZenIV.linux.org.uk>
References: <CA+55aFyQR2gOzEDROcWFcQzLvTjOxyJRjFJXJ03JB5knd-Gsgg@mail.gmail.com>
 <20141119.161744.1661940121298888832.davem@davemloft.net>
 <20141119213006.GE7996@ZenIV.linux.org.uk>
 <20141119.165340.2162829993279387495.davem@davemloft.net>
 <20141120214753.GR7996@ZenIV.linux.org.uk>
 <1416520542.8629.46.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416520542.8629.46.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 01:55:42PM -0800, Eric Dumazet wrote:
> On Thu, 2014-11-20 at 21:47 +0000, Al Viro wrote:
> 
> > As far as I can see, these retries on the send side are simply broken -
> > normally we are talking to TCP sockets there and tcp_sendmsg() does *not*
> > modify iovec in normal case. 
> 
> Arg... I sent this morning something doing this (against net-next tree)
> 
> Is it a problem ?

Yes, it is.  You are breaking several _other_ kernel_sendmsg() users.
They are already slightly broken, but that'll make breakage much more
common.

Please, don't - the right thing to do is to have iov_iter in msghdr
(we already have the kernel and userland ones with different types and
we do not assume their layouts to be identical - currently they are,
but it's easy to change), keep iovec constant in all cases and advance
->msg_iter.  Also in all cases.

Note that direct manipulations of what's currently in ->msg_iov are
wrong - all those loops over vector elements, etc., belong in low-level
primitives.  The main missing ones right now are csum_and_copy_{from,to}_iter()
- I have those in local queue, but I'm still trying to get a reasonably
clean mm/iov_iter.c without ridiculous amounts of boilerplating.  A bit more
massage is needed there...

Seriously, take a look at vfs.git#iov_iter-net; it's preparations for the
one that'll introduce ->msg_iter.  Right now that branch has local iov_iter
declared and initialized in several ->sendmsg() and ->recvmsg() instances and
fed to primitives that work with it; after the conversion it'll be in
msg->msg_iter and it will be initialized by sock_sendmsg()/sock_recvmsg().

The tricky part is how to get through that without temporary breaking the
existing sendmsg/recvmsg users in the kernel *and* without a patch size from
hell.  I more or less see how to carve the remaining steps into
reasonably-sized chunks; iscsi is one of the tricky ones and it, AFAICS,
is genuinely broken in mainline and will need fixes that can go into -stable.

And no, your solution doesn't work.  Sorry.  You'll break e.g. smb_send_kvec()
that way.  ceph_tcp_sendmsg() as well, IIRC.

