Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaDQQ1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 12:27:35 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:40616 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaDQQ1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 12:27:24 -0400
Date: Thu, 17 Apr 2014 12:27:20 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] workqueue: rescuer_thread() processes all pwqs
 before exit
Message-ID: <20140417162720.GQ15326@htj.dyndns.org>
References: <20140416165052.GK1257@htj.dyndns.org>
 <1397691258-11639-1-git-send-email-laijs@cn.fujitsu.com>
 <20140417152744.GM15326@htj.dyndns.org>
 <CACvQF527RneJwUXf0=C6L0_9ncdS6--iqhdpWAFKqHtd25LOYg@mail.gmail.com>
 <20140417160828.GP15326@htj.dyndns.org>
 <CACvQF53DOj0+sn5EQKLA+mCBdtuceO29gBmH2HCqCOXBmRMWAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF53DOj0+sn5EQKLA+mCBdtuceO29gBmH2HCqCOXBmRMWAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 12:21:51AM +0800, Lai Jiangshan wrote:
> > Hmmm?  Isn't this the same race condition that you tried to remove by
> > relocating the test?  It doesn't matter what destroy_workqueue() does,
> > the rescuer may get preempted inbetween and anything can happen
> > inbetween including someone maydaying and initiation of
> > destroy_workqueue().  Your patch doesn't change the situation at all.
> > It can still return with non-empty mayday list.
> 
> You are right. We need a additional atomic check.

I don't think increasing the number of checks will do anything.  We
just need to keep the test where it is now and exit after doing the
loop.  ie.

	set TASK_INTRRUPTIBLE
	test should_stop and cache the result

	spin_lock_irq();

	while () {
		process the list
	}

	spin_unlock_irq();

	if (was should_stop asserted?)
		exit;

	schedule();

Should do, no?

-- 
tejun
