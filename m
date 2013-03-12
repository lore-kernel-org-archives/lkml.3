Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab3CLOVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 10:21:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52749 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3CLOVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 10:21:14 -0400
Date: Tue, 12 Mar 2013 10:21:21 -0400 (EDT)
Message-Id: <20130312.102121.1471200685376534204.davem@davemloft.net>
To: g.nault@alphalink.fr
Cc: jchapman@katalix.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] l2tp: Restore socket refcount when sendmsg succeeds
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130312103650.GA4512@alphalink.fr>
References: <20130301150202.GA3649@alphalink.fr>
	<20130301.141252.1152926224695074046.davem@davemloft.net>
	<20130312103650.GA4512@alphalink.fr>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 12 Mar 2013 07:21:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Nault <g.nault@alphalink.fr>
Date: Tue, 12 Mar 2013 11:36:50 +0100

> On Fri, Mar 01, 2013 at 02:12:52PM -0500, David Miller wrote:
>> Looking at how this code works, it is such a terrible design.  This
>> whole reference counting issue exists purely because
>> pppol2tp_sock_to_session() grabs the 'sk' reference.
>> 
>> In all but one case, it need not do this.
>> 
>> The socket system calls have an implicit reference to 'sk' via
>> socket->sk.  If you can get into the system call and socket->sk
>> is non-NULL then 'sk' is NOT going anywhere.
>> 
>> And all of these system call handlers have this pattern:
>> 
>> 	session = pppol2tp_sock_to_session(sk);
>> 	...
>> 	sock_put(sk);
>> 
>> The only case where the reference count is really needed is that
>> sequence in pppol2tp_release().
>> 
>> Long term the right thing to do here is stop having this session
>> grabber function take the 'sk' reference.  Then in pppol2tp_release
>> we'll grab a reference explicitly.  At all the other call sites we
>> then blast aweay all of the sock_put(sk) paths.
>> 
> Could this also apply to l2tp_sock_to_tunnel() (in l2tp_core.h)? As per
> my understanding, none of its callers needs to take a socket reference.
> So sock_hold() could be removed in both pppol2tp_sock_to_session() and
> l2tp_sock_to_tunnel() functions. The corresponding sock_put() calls
> would then be removed from all calling functions but pppol2tp_release().
> If this is correct, I'll send a patch for net-next.

Yes, it could be simplified in this way too.  Just make sure that this
interface is only used in system call / user context, where we know
the underlying socket cannot go away on us.
