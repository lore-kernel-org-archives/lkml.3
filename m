Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab3BHAkr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:40:47 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:54990 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3BHAkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:40:46 -0500
Date: Thu, 7 Feb 2013 16:40:23 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Dumazet <edumazet@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, john.stultz@linaro.org
Subject: Re: [RFC PATCH 1/6] kernel: implement queue spinlock API
Message-ID: <20130208004023.GM2545@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1358896415-28569-1-git-send-email-walken@google.com>
 <1358896415-28569-2-git-send-email-walken@google.com>
 <20130207223434.GG2545@linux.vnet.ibm.com>
 <1360277809.28557.60.camel@edumazet-glaptop>
 <CANN689G0N0ynSMVcH9CbOFgL_mLSswOBx5yBzPBag0AO9fk8+A@mail.gmail.com>
 <1360281834.28557.73.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360281834.28557.73.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13020800-5518-0000-0000-00000B62B848
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 04:03:54PM -0800, Eric Dumazet wrote:
> On Thu, 2013-02-07 at 15:58 -0800, Michel Lespinasse wrote:
> 
> > No, I think that's doable. The trick would be that once a thread
> > acquires the lock, the only remaining use of the node is to receive
> > the 'next' pointer if/when another thread starts contending for the
> > lock. So if the lock state would need to distinguish between a lock
> > that is currently locked but not contended (the next value would then
> > be NULL), and a lock that is currently locked and contended (the
> > lock->next value is the node that goes after the current lock owner)
> > 
> 
> It adds yet another memory write to store the node pointer in the
> lock...
> 
> I suspect it's going to increase false sharing.

On the other hand, compared to straight MCS, it reduces the need to
pass the node address around.  Furthermore, the node pointer is likely
to be in the same cache line as the lock word itself, and finally
some architectures can do a double-pointer store.

Of course, it might well be slower, but it seems like it is worth
giving it a try.

							Thanx, Paul

