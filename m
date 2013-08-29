Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab3H2AtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 20:49:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918Ab3H2AtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 20:49:03 -0400
Date: Wed, 28 Aug 2013 20:49:00 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com, eparis@redhat.com,
        rgb@redhat.com
Subject: Re: [RFC] audit: avoid soft lockup in audit_log_start()
Message-ID: <20130828204900.4dc02876@redhat.com>
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
> else, which makes more sense.  A sysrq-T (or echo t >
> /proc/sysrq-trigger) should provide clues.

Yes, "*** sleeping" is the last one.

> I'd remove the "_ratelimited" - you don't want your debug messages to be
> ratelimited (ie: omitted).

I'll try that.

Another interesting info is that the process that triggers the hang
is killall5 and by the time the hang happens auditd is not running
anymore.
