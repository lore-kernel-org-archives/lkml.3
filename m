Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920AbaKYCkY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 21:40:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42882 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbaKYCkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 21:40:22 -0500
Date: Tue, 25 Nov 2014 02:40:18 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        nab@linux-iscsi.org, hch@infradead.org
Subject: Re: [RFC] situation with csum_and_copy_... API
Message-ID: <20141125024018.GH7996@ZenIV.linux.org.uk>
References: <20141120.182339.972861702759954603.davem@davemloft.net>
 <20141121.122615.1091044030302005883.davem@davemloft.net>
 <20141122042856.GZ7996@ZenIV.linux.org.uk>
 <20141122.022444.425003630662787798.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141122.022444.425003630662787798.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 22, 2014 at 02:24:44AM -0500, David Miller wrote:
> From: Al Viro <viro@ZenIV.linux.org.uk>
> Date: Sat, 22 Nov 2014 04:28:57 +0000
> 
> > 	OK, here's the next bunch.  Sorry about the delay, iov_iter.c stuff
> > took most of the day (and it's not included in this pile).  Please, review.
> 
> I read over this stuff twice and this series looks fine to me.
> 
> Since this is the weekend... maybe wait until Monday for other feedback
> then give me a pull request?

I'll probably repost the patches with updates folded in first...

FWIW, the current situation is
	* all but one ->recvmsg() instances switched to iov_iter primitives
(the exception is one of the AF_ALG instances and I know what to do with it).
Consequently, they do not drain iovecs anymore and simply advance ->msg_iter.
	* kvec-based iov_iter work just fine without set_fs(KERNEL_DS).  And
so do ->recvmsg() instances that had received such iov_iter.
	* memcpy_to_iovec() and skb_copy_datagram_iovec() are gone - no users
left.

I'm about to start on ->sendmsg() side of the things.  The interesting
question is whether tcp_send_syn_data() is doing the right thing if it
runs into EFAULT when copying iovec from userland.

As it is, it gives up on the skb it has allocated and falls back to normal
handshake.  I can duplicate that behaviour, all right, but why not simply
do skb_trim(syn_data, <actually copied>) and do fallback only if nothing
got copied at all?  Is there any problem with that?

The reason why I'm asking is that it's easier to just use copy_from_iter()
and let the damn thing advance.  Not a lot of pain to preserve the original
iov_iter (all 5 words of it) and copy it back in case of failure, but I'd
rather understood what's wrong with simpler approach...

Anyway, the current branch is in vfs.git#iov_iter-net.  Current balance is
about -0.5KLoC and that's not counting the simplifications that will become
possible in callers of kernel_sendmg/kernel_recvmsg...  I'll post the beginning
of that queue (the same 17 commits in the beginning) later tonight and wait
for review...
