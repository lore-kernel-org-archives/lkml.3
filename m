Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab3A1Vs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 16:48:29 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:39128 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab3A1Vs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 16:48:26 -0500
Date: Mon, 28 Jan 2013 13:48:23 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, srivatsa.bhat@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] generic dynamic per cpu refcounting
Message-ID: <20130128214823.GH26407@google.com>
References: <20130128182737.GC22465@mtj.dyndns.org>
 <20130128184933.GC26407@google.com>
 <20130128185552.GD22465@mtj.dyndns.org>
 <20130128202214.GD26407@google.com>
 <CAOS58YOQNs9RcNAXHKfkwaxMeDeSzOczNC=-WS5uvsas168T+A@mail.gmail.com>
 <20130128205540.GE26407@google.com>
 <20130128211832.GK22465@mtj.dyndns.org>
 <20130128212407.GF26407@google.com>
 <20130128212814.GL22465@mtj.dyndns.org>
 <20130128213622.GM22465@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130128213622.GM22465@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 01:36:22PM -0800, Tejun Heo wrote:
> On Mon, Jan 28, 2013 at 01:28:14PM -0800, Tejun Heo wrote:
> > But at that point, the operation is already global, so there gotta be
> > a lighter way to synchronize stuff than going through full grace
> > period.  ie. You can add a bias value before marking dead so that the
> > counter never reaches zero before all percpu counters are collected
> > and then unbias it right before putting the base ref, that way the
> > only way you can hit zero ref is all refs are actually zero.
> 
> Note that I'm saying that there's no need to distinguish between dying
> and dead.

Yeah I got that, I _think_ that makes me like the idea.

> The only thing percpu part should care about it whether
> percpu is on or off.  We need a full grace period to turn off percpu
> operations of any type but that should be the only case where full
> grace period is necessary.  The rest should be synchronizable via the
> usual global synchronization.  We probably can just test percpu
> variable against NULL and forget about the encoded state numbers.

Can't quite do that because initially, we use that variable for a
timestamp and when we're shutting down we don't want percpu_ref_get()
allocating percpu counters again.

You'll probably use that as an argument against dynamic allocation :P
