Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3IRUt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 16:49:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751655Ab3IRUt4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 16:49:56 -0400
Date: Wed, 18 Sep 2013 16:49:49 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, Steve Grubb <sgrubb@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Duval <dan.duval@oracle.com>,
        Chuck Anderson <chuck.anderson@oracle.com>,
        Guy Streeter <streeter@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 8/8] audit: add audit_backlog_wait_time configuration
 option
Message-ID: <20130918204949.GI13968@madcap2.tricolour.ca>
References: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org>
 <863f1daf3a84b52ae5054f5d232b205ae5caab83.1379530867.git.rgb@redhat.com>
 <1379536405.3032.61.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379536405.3032.61.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 04:33:25PM -0400, Eric Paris wrote:
> On Wed, 2013-09-18 at 15:06 -0400, Richard Guy Briggs wrote:
> > reaahead-collector abuses the audit logging facility to discover which files
> > are accessed at boot time to make a pre-load list
> > 
> > Add a tuning option to audit_backlog_wait_time so that if auditd can't keep up,
> > or gets blocked, the callers won't be blocked.

> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 3d17670..fc535b6 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -701,8 +708,21 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >  			if (err < 0)
> >  				return err;
> >  		}
> > -		if (s.mask & AUDIT_STATUS_BACKLOG_LIMIT)
> > +		if (s.mask & AUDIT_STATUS_BACKLOG_LIMIT) {
> >  			err = audit_set_backlog_limit(s.backlog_limit);
> > +			if (err < 0)
> > +				return err;
> > +		}
> > +		if (s.mask & AUDIT_STATUS_BACKLOG_WAIT_TIME) {
> > +			if (sizeof(s) > (size_t)nlh->nlmsg_len)
> > +				break;
> 
> What gets returned here?  I think err has a value of 0, but it doesn't
> seem to have been clearly intentional.  If they know about the
> AUDIT_STATUS_BACKLOG_WAIT_TIME flag, but they didn't send a long enough
> skb?  That seems like an error condition....

The intent was that it is a NOP, since err would have a value of zero,
but I see your point, that if that flag is present, the struct member
should be too.  My original intent was that if the structure member
wasn't present, it would default to zero, unintentionally setting the
wait time to zero.  It was part of my paranoia in the absence of an API
version indicator.  No harm done, but I agree it should return an error.

Thanks for the catch.

> > +			if (s.backlog_wait_time < 0 ||
> > +			    s.backlog_wait_time > 10*AUDIT_BACKLOG_WAIT_TIME)
> > +				return -EINVAL;

I assume values less than zero or larger than 10 times the current
default of one minute are errors or unreasonable.

Any argument for more than 10 minutes?


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
