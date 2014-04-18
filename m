Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaDRSQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 14:16:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42760 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751139AbaDRSQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 14:16:41 -0400
Date: Fri, 18 Apr 2014 14:16:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: question on read_barrier_depends
In-Reply-To: <1397829723.4798.5.camel@linux-fkkt.site>
Message-ID: <Pine.LNX.4.44L0.1404181409300.1115-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2014, Oliver Neukum wrote:

> On Thu, 2014-04-17 at 11:50 -0400, Alan Stern wrote:
> > On Thu, 17 Apr 2014, Oliver Neukum wrote:
> > 
> > > On Wed, 2014-04-16 at 11:26 -0400, Alan Stern wrote:
> > > 
> > > > In addition, the following code in kfifo_get() does this:
> > > > 
> > > > 			*(typeof(__tmp->type))__val = \
> > > > 				(__is_kfifo_ptr(__tmp) ? \
> > > > 				((typeof(__tmp->type))__kfifo->data) : \
> > > > 				(__tmp->buf) \
> > > > 				)[__kfifo->out & __tmp->kfifo.mask]; \
> > > > 			smp_wmb(); \
> > > > 			__kfifo->out++; \
> > > > 
> > > > It looks like the smp_wmb() should really be smp_mb(), because it 
> > > > separates the _read_ for val from the _write_ of kfifo->out.
> > > 
> > > But where is kfifo->out read at all?
> > 
> > It is read in kfifo_put(), inside the call to kfifo_is_full() -> 
> > kfifo_len().
> 
> I had overlooked that. In that case kfifo_put() also needs
> smp_read_barrier_depends()

I don't think so.

kfifo_put() uses the read of kfifo->out to determine whether to perform
the store; i.e., it won't store the data if the kfifo is already full.  
No architectures do speculative writes, so the data can never get
stored before kfifo->out is read, even without any memory barriers.  

smp_read_barrier_depends() is meant to prevent speculative _reads_, or
any similar mechanism.

Alan Stern

