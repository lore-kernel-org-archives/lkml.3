Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739AbaCJV6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:58:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55978 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbaCJV5u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:57:50 -0400
Message-ID: <1394488666.17193.16.camel@localhost>
Subject: Re: [RFC][PATCH] audit: Simplify by assuming the callers socket
 buffer is large enough
From: Eric Paris <eparis@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: ebiederm@xmission.com, sgrubb@redhat.com, rgb@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, akpm@linux-foundation.org
Date: Mon, 10 Mar 2014 17:57:46 -0400
In-Reply-To: <20140310.153001.1202621819107314058.davem@davemloft.net>
References: <7457128.6VP2v68V93@x2> <87wqg8zfj4.fsf@xmission.com>
	 <1394232722.17779.57.camel@flatline.rdu.redhat.com>
	 <20140310.153001.1202621819107314058.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-10 at 15:30 -0400, David Miller wrote:
> From: Eric Paris <eparis@redhat.com>
> Date: Fri, 07 Mar 2014 17:52:02 -0500
> 
> > The second user Eric patched, audit_send_list(), can grow without bound.
> > The number of skb's is going to be the size of the number of audit rules
> > that root loaded.  We run the list of rules, generate an skb per rule,
> > and add all of them to an skb_buff_head.  We then pass the skb_buff_head
> > to a kthread so that current will be able to read/drain the socket.
> > There really is no limit to how big the skb_buff_head could possibly
> > grow.  This doesn't necessarily absolutely have to be lossless but it
> > can actually quite reasonably be a whole lot of data that needs to get
> > sent.  I know of no way to deliver unbounded lengths of data to the
> > current task via netlink without blocking on more space in the socket.
> > Even if the socket rmem was MAX_INT, how can we deliver more?  The rule
> > size is unbounded.  How do I get an unbounded amount of data onto this
> > side of the socket when I have to generate it all during the request...
> 
> This is what netlink dumps  are for.  It is how we are able to dump
> routing tables with millions of routes to userspace.
> 
> By using normal netlink requests and netlink_unicast() for this, you
> are ignoring an entire mechanism in netlink designed specifically to
> handle this kind of situation.
> 
> Netlink dumps track state and build one or more SKBs (as necessary),
> one by one, to form the reply.  It implements flow control, state
> tracking for iteration, optimized SKB sizing and allocation, etc.

Awesome.  I'll see what I can find!


