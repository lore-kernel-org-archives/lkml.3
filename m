Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992AbaKTVsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:48:00 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59735 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658AbaKTVr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:47:57 -0500
Date: Thu, 20 Nov 2014 21:47:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, target-devel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] situation with csum_and_copy_... API
Message-ID: <20141120214753.GR7996@ZenIV.linux.org.uk>
References: <CA+55aFyQR2gOzEDROcWFcQzLvTjOxyJRjFJXJ03JB5knd-Gsgg@mail.gmail.com>
 <20141119.161744.1661940121298888832.davem@davemloft.net>
 <20141119213006.GE7996@ZenIV.linux.org.uk>
 <20141119.165340.2162829993279387495.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141119.165340.2162829993279387495.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 04:53:40PM -0500, David Miller wrote:

> Pulled, thanks Al.

Umm...  Not in net-next.git#master...  Anyway, the next portion is in
vfs.git#iov_iter-net right now; I'll post it on netdev once I get some
sleep.

It's getting close to really interesting parts.  Right now the main obstacle
is in iscsit_do_rx_data/iscsit_do_tx_data; what happens there is reuse of
iovec if kernel_sendmsg() gives a short write - it tries to send again, with
the same iovec and decremented length.  Ditto on RX side (with kernel_recvmsg(),
obviously).

As far as I can see, these retries on the send side are simply broken -
normally we are talking to TCP sockets there and tcp_sendmsg() does *not*
modify iovec in normal case.  IOW, if you get 8K sent out of 80K, the next
time it'll try to send 72K - already sent piece + 64K following it, etc.

Could target-devel folks tell how realistic those resends are, in the
first place?  Both with TX and RX sides...  Is there any sane limit on
iovec size there, etc.

Note that while conversion to iov_iter will provide a very simple solution
(iovec remains unchanged, iterator advances and we just need to avoid
reinitializing it for subsequent iterations in those loops), it won't solve
the problem in older kernels; that code had been there since 2011 and
iov_iter conversion is far too invasive for -stable.
