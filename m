Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab3JWT4H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 15:56:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab3JWT4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 15:56:05 -0400
Date: Wed, 23 Oct 2013 15:55:50 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
        Gao feng <gaofeng@cn.fujitsu.com>, eparis@redhat.com
Subject: Re: [BUG][PATCH] audit: audit_log_start running on auditd should not
 stop
Message-ID: <20131023195550.GA9109@madcap2.tricolour.ca>
References: <20131011103645.6643fabff0eceb152e0be6c2@jp.fujitsu.com>
 <5257C5D7.80308@cn.fujitsu.com>
 <5257EF15.6080209@jp.fujitsu.com>
 <20131015134345.98d72df42a39e9e1ad77a73c@jp.fujitsu.com>
 <525CE10A.90907@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <525CE10A.90907@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 02:30:34PM +0800, Gao feng wrote:
> Hi Toshiyuki-san,

Toshiuki and Gao,

> On 10/15/2013 12:43 PM, Toshiyuki Okajima wrote:
> > The backlog cannot be consumed when audit_log_start is running on auditd
> > even if audit_log_start calls wait_for_auditd to consume it.
> > The situation is a deadlock because only auditd can consume the backlog.
> > If the other process needs to send the backlog, it can be also stopped 
> > by the deadlock.
> > 
> > So, audit_log_start running on auditd should not stop.
> > 
> > You can see the deadlock with the following reproducer:
> >  # auditctl -a exit,always -S all
> >  # reboot

> Hmm, I see, There may be other code paths that auditd can call audit_log_start except
> audit_log_config_change. so it's better to handle this problem in audit_log_start.
> 
> but current task is only meaningful when gfp_mask & __GFP_WAIT is true.
> so maybe the below patch is what you want.

I have been following this thread with interest.  I like the general
evolution of this patch.  The first patch was a bit too abrupt, dropping
too much, but this one makes much more sense.  I would be tempted to
make the reserve even bigger.

I see that you should be using a kernel that has included commit
8ac1c8d5 (which made it into v3.12-rc3)
	audit: fix endless wait in audit_log_start()
That was an obvious bug, but I was still concerned about the cause of
the initial wait.  There are other fixes and ideas in the works that
should alleviate some of the pressure to make the service more usable.
	https://lkml.org/lkml/2013/9/18/453

I have tested with and without this v3 patch and I don't see any
significant difference with the reproducer provided above.  I'm also
testing with a reproducer of the endless wait bug (readahead-collector).

What are your expected results?  What are your actual results in each
case?  How are they different?

> diff --git a/kernel/audit.c b/kernel/audit.c
> index 7b0e23a..10b4545 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1095,7 +1095,9 @@ struct audit_buffer *audit_log_start(struct audit_context
>         struct audit_buffer     *ab     = NULL;
>         struct timespec         t;
>         unsigned int            uninitialized_var(serial);
> -       int reserve;
> +       int reserve = 5; /* Allow atomic callers to go up to five
> +                           entries over the normal backlog limit */
> +
>         unsigned long timeout_start = jiffies;
> 
>         if (audit_initialized != AUDIT_INITIALIZED)
> @@ -1104,11 +1106,12 @@ struct audit_buffer *audit_log_start(struct audit_contex
>         if (unlikely(audit_filter_type(type)))
>                 return NULL;
> 
> -       if (gfp_mask & __GFP_WAIT)
> -               reserve = 0;
> -       else
> -               reserve = 5; /* Allow atomic callers to go up to five
> -                               entries over the normal backlog limit */
> +       if (gfp_mask & __GFP_WAIT) {
> +               if (audit_pid && audit_pid == current->pid)
> +                       gfp_mask &= ~__GFP_WAIT;
> +               else
> +                       reserve = 0;
> +       }
> 
>         while (audit_backlog_limit
>                && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserv

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer
Kernel Security
AMER ENG Base Operating Systems
Remote, Ottawa, Canada
Voice: +1.647.777.2635
Internal: (81) 32635
Alt: +1.613.693.0684x3545
