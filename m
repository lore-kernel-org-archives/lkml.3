Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab3HPQpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 12:45:51 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:41143 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224Ab3HPQpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 12:45:49 -0400
Date: Fri, 16 Aug 2013 12:45:44 -0400
From: Tejun Heo <tj@kernel.org>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, Jeff Dike <jdike@addtoit.com>,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [PATCH] print_worker_info: Handle pointer with more care
Message-ID: <20130816164544.GK2505@htj.dyndns.org>
References: <1376668606-32354-1-git-send-email-richard@nod.at>
 <20130816161229.GI2505@htj.dyndns.org>
 <520E500B.5000408@nod.at>
 <20130816162844.GJ2505@htj.dyndns.org>
 <520E55A2.9080900@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520E55A2.9080900@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 16, 2013 at 06:38:58PM +0200, Richard Weinberger wrote:
> > cc'ing uml people.  Hey, guys, workqueue uses proble_kernel_read() to
> > print out workqueue related information during oops because those
> > events are completely asynchronous and workqueue states may not be
> > consistently accessible.  It seems like uml doesn't implement
> > probe_kernel_read() and tries direct derference of incorrect pointers
> > leading to its own oops.  Maybe uml should check whether the memory is
> > mapped from probe_kernel_read()?
> 
> You are already talking to UML people. ;)

Ooh... :)

> Anyway, I'll investigate into that.
> What I see so far is that pwq is NULL after probe_kernel_read().

Yeah, and that should be fine.  &pwq->wq would be just an offset of wq
from NULL which is an invalid pointer but probe_kernel_read() should
be able to handle that and probably just return 0 or -1 (all bits
set).  I *think* what's necessary is making probe_kernel_read() use
mincore() to fine out whether the requested address is mapped (it
should return -EFAULT if not) and try to dereference the address iff
it's mapped.

Thanks.

-- 
tejun
