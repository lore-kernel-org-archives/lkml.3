Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab3CRUcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 16:32:25 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34582 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab3CRUcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 16:32:24 -0400
Date: Mon, 18 Mar 2013 16:32:02 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, sri@us.ibm.com,
        "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sctp: hang in sctp_remaddr_seq_show
Message-ID: <20130318203202.GB9478@hmsreliant.think-freely.org>
References: <51434D78.9030308@oracle.com>
 <20130318110415.GA9478@hmsreliant.think-freely.org>
 <1363620340.29475.132.camel@edumazet-glaptop>
 <5147333A.3010907@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5147333A.3010907@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 11:31:06AM -0400, Vlad Yasevich wrote:
> On 03/18/2013 11:25 AM, Eric Dumazet wrote:
> >On Mon, 2013-03-18 at 07:04 -0400, Neil Horman wrote:
> >
> >>I'm not sure why the process would never get back to the schedule, but looking
> >>at the sctp_remaddr_seq_show function, I think that we should convert this
> >>sequence:
> >>	sctp_local_bh_disable();
> >>	read_lock(&head->lock);
> >>	rcu_read_lock();
> >>
> >>to this:
> >>	read_lock(&head->lock);
> >>	rcu_read_lock_bh();
> >>
> >>Neil
> >
> >I dont think so.
> >
> >BH needs to be disabled before read_lock(&head->lock);
> >
> >or else, write_lock() could deadlock (assuming it can be called from BH)
> >
> >
> 
> If anything, this should probably be done like this:
> 
> rcu_read_lock();
> read_lock_bh(&head->lock)
> ...
> 
> read_unlock_bh(&head->lock)
> rcu_read_unlock();
> 
Vlads, right.  We need to grab the rcu lock before the read lock, but we should
probably use the rcu_read_lock_bh variant, since we're going to disable bottom
halves anyway.
Neil

> -vlad
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
