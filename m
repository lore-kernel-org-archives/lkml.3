Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951AbaKUTjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:39:21 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33424 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbaKUTjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:39:19 -0500
Date: Fri, 21 Nov 2014 19:39:11 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, David Miller <davem@davemloft.net>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] situation with csum_and_copy_... API
Message-ID: <20141121193911.GU7996@ZenIV.linux.org.uk>
References: <CA+55aFyQR2gOzEDROcWFcQzLvTjOxyJRjFJXJ03JB5knd-Gsgg@mail.gmail.com>
 <20141119.161744.1661940121298888832.davem@davemloft.net>
 <20141119213006.GE7996@ZenIV.linux.org.uk>
 <20141119.165340.2162829993279387495.davem@davemloft.net>
 <20141120214753.GR7996@ZenIV.linux.org.uk>
 <1416520542.8629.46.camel@edumazet-glaptop2.roam.corp.google.com>
 <20141120222506.GS7996@ZenIV.linux.org.uk>
 <1416524035.8629.54.camel@edumazet-glaptop2.roam.corp.google.com>
 <20141121084956.GT7996@ZenIV.linux.org.uk>
 <063D6719AE5E284EB5DD2968C1650D6D1C9F6930@AcuExch.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1C9F6930@AcuExch.aculab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 21, 2014 at 05:42:55PM +0000, David Laight wrote:

> Callers of kernel_send/recvmsg() could easily be using a wrapper
> function that creates the 'msghdr'.
> When the want to send the remaining part of a buffer the old iterator
> will no longer be available - just the original iov and the required offset.

Er...  So why not copy a struct iov_iter to/from msg->msg_iter, then?
It's not as it had been particulary large - 5 words isn't much...

I'm not at all sure that _anything_ has valid reasons for draining iovecs.
Maintaining a struct iov_iter and modifying it is easy and actually faster...

Right now the main examples outside of net/* are due to unfortunate
limitations of ->sendmsg() - until now it had no way to be told that
desired data starts at offset.  With ->msg_iter it obviously becomes
possible...
