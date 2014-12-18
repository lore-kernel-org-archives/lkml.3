Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbaLRRuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:50:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49268 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbaLRRuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:50:21 -0500
Message-ID: <1418925016.5162.21.camel@localhost>
Subject: Re: linux-next 20141216 BUG: sleeping function called from invalid
 context at mm/slab.c:2849
From: Eric Paris <eparis@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, Paul Moore <paul@paul-moore.com>,
        linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-audit@redhat.com
Date: Thu, 18 Dec 2014 12:50:16 -0500
In-Reply-To: <20141218174629.GB29827@madcap2.tricolour.ca>
References: <2966.1418778594@turing-police.cc.vt.edu>
	 <5444.1418921116@turing-police.cc.vt.edu>
	 <1418921420.5162.19.camel@localhost>
	 <20141218174629.GB29827@madcap2.tricolour.ca>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-18 at 12:46 -0500, Richard Guy Briggs wrote:
> On 14/12/18, Eric Paris wrote:
> > On Thu, 2014-12-18 at 11:45 -0500, Valdis.Kletnieks@vt.edu wrote:
> > > On Tue, 16 Dec 2014 20:09:54 -0500, Valdis Kletnieks said:
> > > > Spotted these two while booting single-user on 20141216.  20141208
> > > > doesn't throw these, so it's something in the last week or so..
> > > 
> > > Gaah!  Turns out that 20141208 *is* susceptible - it had been booting
> > > just fine for several days, but it went around the bend, apparently due
> > > to a userspace or initrd change.
> > 
> > $5 says you updated systemd?
> > 
> > Richard?
> 
> Ok, so if you are correct, then either we justify dropping the lock (I
> assume the one commone to both BUG reports [sig->cred_guard_mutex] ),
> or we make yet another queue were were hoping to avoid...
> 
> It would also be good to narrow it down to a rule that triggers this.

I thought the first message was enough to find the problem, but:

static void kauditd_send_multicast_skb(struct sk_buff *skb)
{
...
        nlmsg_multicast(sock, copy, 0, AUDIT_NLGRP_READLOG, GFP_KERNEL);
...
}

Since kauditd_send_multicast_skb() gets called in audit_log_end(), which
can come from any context (aka even a sleeping context) you can't use
GFP_KERNEL.  The audit_buffer know what context it should use.  So pass
that down and use that.

-Eric

> 
> > > egrep 'BUG|Linux vers' from my syslog:
> > > 
> > > Dec  9 12:19:53 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> ...
> > > Dec 12 19:42:30 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> > > Dec 12 20:00:39 turing-police kernel: [ 1109.635328] BUG: sleeping function called from invalid context at mm/slab.c:2849
> ...
> > > Dec 12 20:42:47 turing-police kernel: [ 3633.863552] BUG: sleeping function called from invalid context at mm/slab.c:2849
> > > Dec 12 20:51:33 turing-police kernel: [    0.000000] Linux version 3.18.0-next-20141208 (source@turing-police.cc.vt.edu) (gcc version 4.9.2 20141101 (Red Hat 4.9.2-1) (GCC) ) #27 SMP PREEMPT Mon Dec 8 22:20:07 EST 2014
> > > Dec 12 21:51:04 turing-police kernel: [ 3587.132867] BUG: sleeping function called from invalid context at mm/slab.c:2849
> ...
> > > I need to figure out what changed around 7:30PM on the 12th.
> 
> - RGB
> 
> --
> Richard Guy Briggs <rbriggs@redhat.com>
> Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
> Remote, Ottawa, Canada
> Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545


