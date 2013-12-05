Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3LEUwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:52:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab3LEUwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:52:23 -0500
Message-ID: <1386276741.24441.2.camel@localhost>
Subject: Re: [PATCH] audit: process errors from filter user rules
From: Eric Paris <eparis@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Steve Grubb <sgrubb@redhat.com>
Date: Thu, 05 Dec 2013 15:52:21 -0500
In-Reply-To: <647f568c0aa7a20435d2471c8052710bf811095c.1386214928.git.rgb@redhat.com>
References: <647f568c0aa7a20435d2471c8052710bf811095c.1386214928.git.rgb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know we talked about this patch, and it seemed like a good idea at the
time, but honestly, these races are so rare, it isn't worth the code
complexity.  I tried to simplify the readability of your code and got
something better, but still the loop is needless...

Just log the messages on any error, even with a dontaudit rule...   How
about a function like:

int audit_filter_user(int type)
{
        enum audit_state state = AUDIT_DISABLED;
        struct audit_entry *e;
        int rc, ret;

        ret = 1; /* Audit by default */

        rcu_read_lock();
        list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_USER], list) {
                rc = audit_filter_user_rules(&e->rule, type, &state);
                if (rc > 0 && state == AUDIT_DISABLED)
                        ret = 0;
                break;
        }
        rcu_read_unlock();
        return ret;
}

and use some sense with the 80 character line length rule.  It's 81
long.  Just let it be long even if checkpatch whines....

-Eric

On Wed, 2013-12-04 at 22:45 -0500, Richard Guy Briggs wrote:
> Errors from filter user rules were previously ignored, and worse, an error on
> a AUDIT_NEVER rule disabled logging on that rule.  On -ESTALE, retry up to 5
> times.  On error on AUDIT_NEVER rules, log.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/audit.c       |    2 +-
>  kernel/auditfilter.c |   44 +++++++++++++++++++++++++++++++-------------
>  2 files changed, 32 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 4cbc945..c93cf06 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -706,7 +706,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  			return 0;
>  
>  		err = audit_filter_user(msg_type);
> -		if (err == 1) {
> +		if (err) { /* match or error */
>  			err = 0;
>  			if (msg_type == AUDIT_USER_TTY) {
>  				err = tty_audit_push_current();
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index b4c6e03..1a7dfa5 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -1272,8 +1272,8 @@ static int audit_filter_user_rules(struct audit_krule *rule, int type,
>  			break;
>  		}
>  
> -		if (!result)
> -			return 0;
> +		if (result <= 0)
> +			return result;
>  	}
>  	switch (rule->action) {
>  	case AUDIT_NEVER:    *state = AUDIT_DISABLED;	    break;
> @@ -1286,19 +1286,37 @@ int audit_filter_user(int type)
>  {
>  	enum audit_state state = AUDIT_DISABLED;
>  	struct audit_entry *e;
> -	int ret = 1;
> -
> -	rcu_read_lock();
> -	list_for_each_entry_rcu(e, &audit_filter_list[AUDIT_FILTER_USER], list) {
> -		if (audit_filter_user_rules(&e->rule, type, &state)) {
> -			if (state == AUDIT_DISABLED)
> -				ret = 0;
> -			break;
> +	int rc, count = 0, retry = 0, ret = 1; /* Audit by default */
> +#define FILTER_RETRY_LIMIT 5
> +
> +	do {
> +		rcu_read_lock();
> +		list_for_each_entry_rcu(e,
> +					&audit_filter_list[AUDIT_FILTER_USER],
> +					list) {
> +			retry = 0;
> +			rc = audit_filter_user_rules(&e->rule, type, &state);
> +			if (rc > 0) {
> +				if (state == AUDIT_DISABLED)
> +					ret = 0;
> +				break;
> +			} else if (rc < 0) {
> +				if (rc == -ESTALE && count < FILTER_RETRY_LIMIT) {
> +					rcu_read_unlock();
> +					count++;
> +					retry = 1;
> +					cond_resched();
> +				} else {
> +					ret = rc;
> +				}
> +				break;
> +			}
>  		}
> -	}
> -	rcu_read_unlock();
> +		if (!retry)
> +			rcu_read_unlock();
> +	} while (retry);
>  
> -	return ret; /* Audit by default */
> +	return ret;
>  }
>  
>  int audit_filter_type(int type)


