Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3KGXh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 18:37:28 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:11869 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751010Ab3KGXhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 18:37:19 -0500
Date: Thu, 7 Nov 2013 18:37:17 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 3/4] printk: Defer printing to irq work when we printed
 too much
Message-ID: <20131107183717.0fc9eb6e@gandalf.local.home>
In-Reply-To: <20131107232148.GE28130@localhost.localdomain>
References: <1383860919-1883-1-git-send-email-jack@suse.cz>
	<1383860919-1883-4-git-send-email-jack@suse.cz>
	<CAFTL4hw6wO+3Y8EpW3_swodfyV9UAaLF-KE6KC+u-5sKjKY7eA@mail.gmail.com>
	<20131107225733.GE2054@quack.suse.cz>
	<20131107232148.GE28130@localhost.localdomain>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Nov 2013 00:21:51 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:
 
> Ok I see now.
> 
> But then this irq_work based solution won't work if, say, you run in full dynticks
> mode. Also the hook on the timer interrupt is something that I wish we get rid
> of on archs that can trigger self-IPIs.

Do we really want that? What about users that use LAZY? That is, the
work isn't that important to trigger right now (added interrupt
expense).

> 
> Notwithstanding it's going to have scalibility issues as irq work then converges
> to a single list for unbound works.

Well, it doesn't seem to be something that would be called often. All
CPUs checking a variable that is seldom changed should not have any
scalability issues. Unless of course it happens to share a cache line
with a variable that does change often.

> 
> Offloading to a workqueue would be perhaps better, and writing to the serial
> console could then be done with interrupts enabled, preemptible context, etc...

Oh God no ;-)  Adding workqueue logic into printk just spells a
nightmare of much more complexity for a critical kernel infrastructure.

-- Steve
