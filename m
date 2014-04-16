Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161828AbaDPP0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:26:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42583 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161602AbaDPP0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:26:54 -0400
Date: Wed, 16 Apr 2014 11:26:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: question on read_barrier_depends
In-Reply-To: <1397634429.21891.13.camel@linux-fkkt.site>
Message-ID: <Pine.LNX.4.44L0.1404161119490.1334-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2014, Oliver Neukum wrote:

> Hi,
> 
> I am looking at memory ordering and a question hit me.
> I was looking at the kfifo code. kfifo_put() has a barrier:
> 
> 			)[__kfifo->in & __tmp->kfifo.mask] = \
> 				(typeof(*__tmp->type))__val; \
> 			smp_wmb(); \
> 			__kfifo->in++; \
> 
> Looking at kfifo_get() 
> 
> 		__ret = !kfifo_is_empty(__tmp); \
> 		if (__ret) { \
> 			*(typeof(__tmp->type))__val = \
> 				(__is_kfifo_ptr(__tmp) ? \
> 
> A thought struck me. There is no corresponding barrier. I cannot
> help myself, but I think there needs to be a smp_read_barrier_depends()
> between reading kfifo->in (in kfifo_is empty) and reading val.
> What do you think?

I think you are right.

In addition, the following code in kfifo_get() does this:

			*(typeof(__tmp->type))__val = \
				(__is_kfifo_ptr(__tmp) ? \
				((typeof(__tmp->type))__kfifo->data) : \
				(__tmp->buf) \
				)[__kfifo->out & __tmp->kfifo.mask]; \
			smp_wmb(); \
			__kfifo->out++; \

It looks like the smp_wmb() should really be smp_mb(), because it 
separates the _read_ for val from the _write_ of kfifo->out.

Alan Stern

