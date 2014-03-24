Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaCXNtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 09:49:52 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40902 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752882AbaCXNtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 09:49:50 -0400
Date: Mon, 24 Mar 2014 09:49:28 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Monam Agarwal <monamagarwal123@gmail.com>, davem@davemloft.net,
        ebiederm@xmission.com, cwang@twopensource.com, kaber@trash.net,
        antonio@meshcoding.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/core: Use RCU_INIT_POINTER(x, NULL) in netpoll.c
Message-ID: <20140324134928.GD19368@hmsreliant.think-freely.org>
References: <1395601966-12490-1-git-send-email-monamagarwal123@gmail.com>
 <20140324111144.GA19368@hmsreliant.think-freely.org>
 <1395666875.12610.21.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395666875.12610.21.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 06:14:35AM -0700, Eric Dumazet wrote:
> On Mon, 2014-03-24 at 07:11 -0400, Neil Horman wrote:
> > On Mon, Mar 24, 2014 at 12:42:46AM +0530, Monam Agarwal wrote:
> > > This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)
> > > 
> > > The rcu_assign_pointer() ensures that the initialization of a structure       
> > > is carried out before storing a pointer to that structure. 
> > > And in the case of the NULL pointer, there is no structure to initialize. 
> > > So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)
> > > 
> > > Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
> > No, I don't think this is right. __netpoll_cleanup can be called in parallel
> > with bottom half access to dev->npinfo.  rcu_assign pointer is safe against
> > those accesses, but RCU_INIT_POINTER is not.
> 
> Wow, it is always safe for NULL value.
> 

Ok, After reading Paul's explination of what this is doing:
http://mid.gmane.org/20140320150601.GK4405@linux.vnet.ibm.com

This makes a bit more sense to me, and I see that its safe, but I'm still not
sure that I like it, just from a readability standpoint.  Making the conversion
removes a memory barrier and the use of a volatile variable, but this isn't a
hot path, and the use of rcu_assign_pointer seems more readable to me as its
balanced with the rcu_assign_pointer in __netpoll_setup.  Doesn't seem worth the
tradeoff to me.
Neil

