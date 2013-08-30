Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab3H3SXb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 14:23:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab3H3SX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 14:23:29 -0400
Date: Fri, 30 Aug 2013 14:23:26 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com, eparis@redhat.com,
        rgb@redhat.com
Subject: Re: [RFC] audit: avoid soft lockup in audit_log_start()
Message-ID: <20130830142326.79864486@redhat.com>
In-Reply-To: <20130828160813.e448eee90886310d6640b87d@linux-foundation.org>
References: <20130828182114.6b67ea90@redhat.com>
	<20130828153345.55631b3b3f6f8940ef1b7614@linux-foundation.org>
	<20130828185436.279bc6dd@redhat.com>
	<20130828160813.e448eee90886310d6640b87d@linux-foundation.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 16:08:13 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 28 Aug 2013 18:54:36 -0400 Luiz Capitulino <lcapitulino@redhat.com> wrote:
> 
> > > Are you really sure that kauditd is stuck in schedule() and doesn't
> > > come out?
> > 
> > No, that's a guess. Inferred from:
> > 
> > 1. I tried calling wake_up_interruptible(&kauditd_wait); right
> >    before wait_for_auditd(). Nothing changes
> > 
> > 2. I added this debug printks:
> > 
> >   diff --git a/kernel/audit.c b/kernel/audit.c
> >   index 91e53d0..27448ad 100644
> >   --- a/kernel/audit.c
> >   +++ b/kernel/audit.c
> >   @@ -458,11 +458,14 @@ static int kauditd_thread(void *dummy)
> >    		set_current_state(TASK_INTERRUPTIBLE);
> >    		add_wait_queue(&kauditd_wait, &wait);
> >    
> >   +		pr_emerg_ratelimited("*** sleeping\n");
> >   +
> >    		if (!skb_queue_len(&audit_skb_queue)) {
> >    			try_to_freeze();
> >    			schedule();
> >    		}
> >    
> >   +		pr_emerg_ratelimited("*** waking up\n");
> >    		__set_current_state(TASK_RUNNING);
> >    		remove_wait_queue(&kauditd_wait, &wait);
> >    	}
> > 
> >  I get several pairs of sleeping/waking up strings right before the
> >  system begins to shut down. Then it stops (even though we do
> >  have SKBs queued)
> 
> Well.  I assume "*** sleeping" the last thing kauditd prints?  If the
> last print is "waking up" then obviously kauditd is stuck somewhere
> else, which makes more sense.

That's correct. According to crash, here's where it's stuck:

 #0 [ffff880115511c58] __schedule at ffffffff815361de
 #1 [ffff880115511cd0] schedule at ffffffff81537039
 #2 [ffff880115511ce0] schedule_timeout at ffffffff81534524
 #3 [ffff880115511d90] netlink_attachskb at ffffffff81498c69
 #4 [ffff880115511df0] netlink_unicast at ffffffff81498d7f
 #5 [ffff880115511e40] kauditd_send_skb at ffffffff810c254f
 #6 [ffff880115511e60] kauditd_thread at ffffffff810c26e9
 #7 [ffff880115511ec0] kthread at ffffffff810693b0
 #8 [ffff880115511f50] ret_from_fork at ffffffff8154071c

I see two possible reasons for this:

 1. User-space triggered a NETLINK_CONGESTED condition. If this is
    the problem, then the fix is to make audit's netlink socket
    non-blocking and queue SKBs if netlink_unicast() returns -EINVAL

 2. It's a race condition in the audit code. This bug is only triggered
    on SMP machines _and_ adding printk()s to kauditd_thread() makes
    it go away. Also, if I'm not mistaken, there's a number of global
    variables that are shared between kaudit_thread() and threads
    calling audit_log(). For example: kaudit_sock, audit_skb_hold_queue,
	kauditd_wait and others

I can try protecting the global data structures with a mutex but, will
such a patch be accepted if the bug goes away? :)
