Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaLRTEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 14:04:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45467 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbaLRTEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 14:04:50 -0500
Message-ID: <1418929486.5162.22.camel@localhost>
Subject: Re: linux-next 20141216 BUG: sleeping function called from invalid
 context at mm/slab.c:2849
From: Eric Paris <eparis@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, selinux@tycho.nsa.gov,
        linux-kernel@vger.kernel.org
Date: Thu, 18 Dec 2014 14:04:46 -0500
In-Reply-To: <20141218184420.GF29998@madcap2.tricolour.ca>
References: <2966.1418778594@turing-police.cc.vt.edu>
	 <5444.1418921116@turing-police.cc.vt.edu>
	 <1418921420.5162.19.camel@localhost>
	 <20141218174629.GB29827@madcap2.tricolour.ca>
	 <1418925016.5162.21.camel@localhost>
	 <20141218184420.GF29998@madcap2.tricolour.ca>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-18 at 13:44 -0500, Richard Guy Briggs wrote:
> On 14/12/18, Eric Paris wrote:
> > On Thu, 2014-12-18 at 12:46 -0500, Richard Guy Briggs wrote:
> > > On 14/12/18, Eric Paris wrote:
> > > > On Thu, 2014-12-18 at 11:45 -0500, Valdis.Kletnieks@vt.edu wrote:
> > > > > On Tue, 16 Dec 2014 20:09:54 -0500, Valdis Kletnieks said:
> > > > > > Spotted these two while booting single-user on 20141216.  20141208
> > > > > > doesn't throw these, so it's something in the last week or so..
> > > > > 
> > > > > Gaah!  Turns out that 20141208 *is* susceptible - it had been booting
> > > > > just fine for several days, but it went around the bend, apparently due
> > > > > to a userspace or initrd change.
> > > > 
> > > > $5 says you updated systemd?
> > > > 
> > > > Richard?
> > > 
> > > Ok, so if you are correct, then either we justify dropping the lock (I
> > > assume the one commone to both BUG reports [sig->cred_guard_mutex] ),
> > > or we make yet another queue were were hoping to avoid...
> > > 
> > > It would also be good to narrow it down to a rule that triggers this.
> > 
> > I thought the first message was enough to find the problem, but:
> > 
> > static void kauditd_send_multicast_skb(struct sk_buff *skb)
> > {
> > ...
> >         nlmsg_multicast(sock, copy, 0, AUDIT_NLGRP_READLOG, GFP_KERNEL);
> > ...
> > }
> > 
> > Since kauditd_send_multicast_skb() gets called in audit_log_end(), which
> > can come from any context (aka even a sleeping context) you can't use
> > GFP_KERNEL.  The audit_buffer know what context it should use.  So pass
> > that down and use that.
> 
> Ok, that looks more obvious now...  We just need to change the internal
> interface to kauditd_send_multicast_skb() to accept an audit_buffer
> instead of just the skb and use the gfp_mask value from there instead of
> using our own...
> 
> Thanks, Eric.

I'd suggest just sending the GFP type, not the who audit_buffer, but
that's up to you.

-Eric

