Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaE2CXf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 22:23:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbaE2CXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 22:23:33 -0400
Message-ID: <1401330205.13555.29.camel@localhost>
Subject: Re: [PATCH v2 1/2] auditsc: audit_krule mask accesses need bounds
 checking
From: Eric Paris <eparis@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Philipp Kern <pkern@google.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. J. Lu" <hjl.tools@gmail.com>,
        security@kernel.org, greg@kroah.com, linux-audit@redhat.com,
        stable@vger.kernel.org
Date: Wed, 28 May 2014 22:23:25 -0400
In-Reply-To: <833bd6cb411ad1d4e293629c6c34c4abca27a840.1401327752.git.luto@amacapital.net>
References: <cover.1401327752.git.luto@amacapital.net>
	 <833bd6cb411ad1d4e293629c6c34c4abca27a840.1401327752.git.luto@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 18:44 -0700, Andy Lutomirski wrote:
> Fixes an easy DoS and possible information disclosure.
> 
> This does nothing about the broken state of x32 auditing.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  kernel/auditsc.c | 27 ++++++++++++++++++---------
>  1 file changed, 18 insertions(+), 9 deletions(-)
> 
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index f251a5e..7ccd9db 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -728,6 +728,22 @@ static enum audit_state audit_filter_task(struct task_struct *tsk, char **key)
>  	return AUDIT_BUILD_CONTEXT;
>  }
>  
> +static bool audit_in_mask(const struct audit_krule *rule, unsigned long val)
> +{
> +	int word, bit;
> +
> +	if (val > 0xffffffff)
> +		return false;

Why is this necessary?  

> +
> +	word = AUDIT_WORD(val);
> +	if (word >= AUDIT_BITMASK_SIZE)
> +		return false;

Since this covers it and it extensible...

> +
> +	bit = AUDIT_BIT(val);
> +
> +	return rule->mask[word] & bit;

Returning an int as a bool creates worse code than just returning the
int.  (although in this case if the compiler chooses to inline it might
be smart enough not to actually convert this int to a bool and make
worse assembly...)   I'd suggest the function here return an int.  bools
usually make the assembly worse...

Otherwise I'd give it an ACK...

> +}
> +
>  /* At syscall entry and exit time, this filter is called if the
>   * audit_state is not low enough that auditing cannot take place, but is
>   * also not high enough that we already know we have to write an audit
> @@ -745,11 +761,8 @@ static enum audit_state audit_filter_syscall(struct task_struct *tsk,
>  
>  	rcu_read_lock();
>  	if (!list_empty(list)) {
> -		int word = AUDIT_WORD(ctx->major);
> -		int bit  = AUDIT_BIT(ctx->major);
> -
>  		list_for_each_entry_rcu(e, list, list) {
> -			if ((e->rule.mask[word] & bit) == bit &&
> +			if (audit_in_mask(&e->rule, ctx->major) &&
>  			    audit_filter_rules(tsk, &e->rule, ctx, NULL,
>  					       &state, false)) {
>  				rcu_read_unlock();
> @@ -769,20 +782,16 @@ static enum audit_state audit_filter_syscall(struct task_struct *tsk,
>  static int audit_filter_inode_name(struct task_struct *tsk,
>  				   struct audit_names *n,
>  				   struct audit_context *ctx) {
> -	int word, bit;
>  	int h = audit_hash_ino((u32)n->ino);
>  	struct list_head *list = &audit_inode_hash[h];
>  	struct audit_entry *e;
>  	enum audit_state state;
>  
> -	word = AUDIT_WORD(ctx->major);
> -	bit  = AUDIT_BIT(ctx->major);
> -
>  	if (list_empty(list))
>  		return 0;
>  
>  	list_for_each_entry_rcu(e, list, list) {
> -		if ((e->rule.mask[word] & bit) == bit &&
> +		if (audit_in_mask(&e->rule, ctx->major) &&
>  		    audit_filter_rules(tsk, &e->rule, ctx, n, &state, false)) {
>  			ctx->current_state = state;
>  			return 1;


