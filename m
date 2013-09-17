Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab3IQW2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 18:28:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab3IQW2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 18:28:43 -0400
Date: Tue, 17 Sep 2013 15:28:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Paris <eparis@redhat.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Luiz Capitulino <lcapitulino@redhat.com>, linux-kernel@vger.kernel.org,
        oleg@redhat.com, rgb@redhat.com
Subject: Re: [RFC] audit: avoid soft lockup in audit_log_start()
Message-Id: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
In-Reply-To: <1378829005.12992.30.camel@flatline.rdu.redhat.com>
References: <20130828182114.6b67ea90@redhat.com>
	<522DDBED.2020505@openvz.org>
	<1378829005.12992.30.camel@flatline.rdu.redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013 12:03:25 -0400 Eric Paris <eparis@redhat.com> wrote:

> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -1215,9 +1215,10 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
> > 
> >                          sleep_time = timeout_start + audit_backlog_wait_time -
> >                                          jiffies;
> > -                       if ((long)sleep_time > 0)
> > +                       if ((long)sleep_time > 0) {
> >                                  wait_for_auditd(sleep_time);
> > -                       continue;
> > +                               continue;
> > +                       }
> >                  }
> >                  if (audit_rate_check() && printk_ratelimit())
> >                          printk(KERN_WARNING
> 
> I think this is the right(ish) fix, at least it gets at the real bug.
> 829199197a430dade2519d54f5545c4a094393b8 definitely is the problem.

um, which idiot wrote that?


Thngs are somewhat foggy at present.  I have two patches from
Dan/Chuck:

Subject: audit: fix soft lockups due to loop in audit_log_start() wh,en audit_backlog_limit exceeded
Subject: audit: two efficiency fixes for audit mechanism

and two from Luiz:

Subject: audit: flush_hold_queue(): don't drop queued SKBs
Subject: audit: kaudit_send_skb(): make non-blocking call to netlink_unicast()

and now a protopatch from Konstantin which eparis likes.

So, umm, guys, can you please devote a bit of time to working out what
we should do here?

