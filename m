Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbaDUJlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 05:41:06 -0400
Received: from smtp-out002.kontent.com ([81.88.40.216]:59367 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaDUJlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 05:41:04 -0400
Message-ID: <1398073259.9256.3.camel@linux-fkkt.site>
Subject: Re: question on read_barrier_depends
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 21 Apr 2014 11:40:59 +0200
In-Reply-To: <Pine.LNX.4.44L0.1404161119490.1334-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1404161119490.1334-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-16 at 11:26 -0400, Alan Stern wrote:
> On Wed, 16 Apr 2014, Oliver Neukum wrote:
> 
> > Hi,
> > 
> > I am looking at memory ordering and a question hit me.
> > I was looking at the kfifo code. kfifo_put() has a barrier:
> > 
> > 			)[__kfifo->in & __tmp->kfifo.mask] = \
> > 				(typeof(*__tmp->type))__val; \
> > 			smp_wmb(); \
> > 			__kfifo->in++; \
> > 
> > Looking at kfifo_get() 
> > 
> > 		__ret = !kfifo_is_empty(__tmp); \
> > 		if (__ret) { \
> > 			*(typeof(__tmp->type))__val = \
> > 				(__is_kfifo_ptr(__tmp) ? \
> > 
> > A thought struck me. There is no corresponding barrier. I cannot
> > help myself, but I think there needs to be a smp_read_barrier_depends()
> > between reading kfifo->in (in kfifo_is empty) and reading val.
> > What do you think?
> 
> I think you are right.
> 
> In addition, the following code in kfifo_get() does this:
> 
> 			*(typeof(__tmp->type))__val = \
> 				(__is_kfifo_ptr(__tmp) ? \
> 				((typeof(__tmp->type))__kfifo->data) : \
> 				(__tmp->buf) \
> 				)[__kfifo->out & __tmp->kfifo.mask]; \
> 			smp_wmb(); \
> 			__kfifo->out++; \
> 
> It looks like the smp_wmb() should really be smp_mb(), because it 
> separates the _read_ for val from the _write_ of kfifo->out.

On the third hand, I now think wmb() is sufficient, because
there's also a write to __val. It does depend on the read
of buf[out & mask], but if no CPU does speculative writes
it must be correct.

	Regards
		Oliver



