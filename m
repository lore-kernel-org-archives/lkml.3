Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486Ab3LIUWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 15:22:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755964Ab3LIUWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 15:22:01 -0500
Date: Mon, 9 Dec 2013 15:21:57 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH] audit: process errors from filter user rules
Message-ID: <20131209202157.GC1687@madcap2.tricolour.ca>
References: <647f568c0aa7a20435d2471c8052710bf811095c.1386214928.git.rgb@redhat.com>
 <1386276741.24441.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386276741.24441.2.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/05, Eric Paris wrote:
> I know we talked about this patch, and it seemed like a good idea at the
> time, but honestly, these races are so rare, it isn't worth the code
> complexity.  I tried to simplify the readability of your code and got
> something better, but still the loop is needless...

Your original code suggestion was cleaner and simpler than mine, but I
tried to code it in a structured manner without gotos, perhaps naively
believing structured code to be superior.  I think that effort backfired
and made it more complex.  I'm ok going back to your original ideas.

I do still think that retry and passing back of error codes is the
better approach.

> Just log the messages on any error, even with a dontaudit rule...   How
> about a function like:

I suspect this isn't what you intended.  The way this is written, it
always breaks after the first rule, not checking any of the others.

> int audit_filter_user(int type)
> {
>         enum audit_state state = AUDIT_DISABLED;
>         struct audit_entry *e;
>         int rc, ret;
> 
>         ret = 1; /* Audit by default */
> 
>         rcu_read_lock();
>         list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_USER], list) {
>                 rc = audit_filter_user_rules(&e->rule, type, &state);
>                 if (rc > 0 && state == AUDIT_DISABLED)
>                         ret = 0;
>                 break;
>         }
>         rcu_read_unlock();
>         return ret;
> }

Did you mean?

        list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_USER], list) {
                rc = audit_filter_user_rules(&e->rule, type, &state);
                if (rc) {
                	if (rc > 0 && state == AUDIT_DISABLED)
                        	ret = 0;
                	break;
		}
        }

> and use some sense with the 80 character line length rule.  It's 81
> long.  Just let it be long even if checkpatch whines....

Yeah, I haven't been too pedantic about line length warnings barely over
80 characters when it affects readability...

> -Eric
> 
> On Wed, 2013-12-04 at 22:45 -0500, Richard Guy Briggs wrote:
> > Errors from filter user rules were previously ignored, and worse, an error on
> > a AUDIT_NEVER rule disabled logging on that rule.  On -ESTALE, retry up to 5
> > times.  On error on AUDIT_NEVER rules, log.
> > 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  kernel/audit.c       |    2 +-
> >  kernel/auditfilter.c |   44 +++++++++++++++++++++++++++++++-------------
> >  2 files changed, 32 insertions(+), 14 deletions(-)
> > 
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 4cbc945..c93cf06 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -706,7 +706,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >  			return 0;
> >  
> >  		err = audit_filter_user(msg_type);
> > -		if (err == 1) {
> > +		if (err) { /* match or error */
> >  			err = 0;
> >  			if (msg_type == AUDIT_USER_TTY) {
> >  				err = tty_audit_push_current();
> > diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> > index b4c6e03..1a7dfa5 100644
> > --- a/kernel/auditfilter.c
> > +++ b/kernel/auditfilter.c
> > @@ -1272,8 +1272,8 @@ static int audit_filter_user_rules(struct audit_krule *rule, int type,
> >  			break;
> >  		}
> >  
> > -		if (!result)
> > -			return 0;
> > +		if (result <= 0)
> > +			return result;
> >  	}
> >  	switch (rule->action) {
> >  	case AUDIT_NEVER:    *state = AUDIT_DISABLED;	    break;
> > @@ -1286,19 +1286,37 @@ int audit_filter_user(int type)
> >  {
> >  	enum audit_state state = AUDIT_DISABLED;
> >  	struct audit_entry *e;
> > -	int ret = 1;
> > -
> > -	rcu_read_lock();
> > -	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_USER], list) {
> > -		if (audit_filter_user_rules(&e->rule, type, &state)) {
> > -			if (state == AUDIT_DISABLED)
> > -				ret = 0;
> > -			break;
> > +	int rc, count = 0, retry = 0, ret = 1; /* Audit by default */
> > +#define FILTER_RETRY_LIMIT 5
> > +
> > +	do {
> > +		rcu_read_lock();
> > +		list_for_each_entry_rcu(e,
> > +					&audit_filter_list[AUDIT_FILTER_USER],
> > +					list) {
> > +			retry = 0;
> > +			rc = audit_filter_user_rules(&e->rule, type, &state);
> > +			if (rc > 0) {
> > +				if (state == AUDIT_DISABLED)
> > +					ret = 0;
> > +				break;
> > +			} else if (rc < 0) {
> > +				if (rc == -ESTALE && count < FILTER_RETRY_LIMIT) {
> > +					rcu_read_unlock();
> > +					count++;
> > +					retry = 1;
> > +					cond_resched();
> > +				} else {
> > +					ret = rc;
> > +				}
> > +				break;
> > +			}
> >  		}
> > -	}
> > -	rcu_read_unlock();
> > +		if (!retry)
> > +			rcu_read_unlock();
> > +	} while (retry);
> >  
> > -	return ret; /* Audit by default */
> > +	return ret;
> >  }
> >  
> >  int audit_filter_type(int type)
> 
> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
