Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaJJTJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 15:09:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754458AbaJJTJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 15:09:03 -0400
Message-ID: <1412968142.15099.3.camel@redhat.com>
Subject: Re: [PATCH 2/7] audit: cull redundancy in audit_rule_change
From: Eric Paris <eparis@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, sgrubb@redhat.com,
        aviro@redhat.com, pmoore@redhat.com
Date: Fri, 10 Oct 2014 15:09:02 -0400
In-Reply-To: <92746f6d4ad17ce7af82d08f5b18443ca3b0c31b.1412285491.git.rgb@redhat.com>
References: <cover.1412285491.git.rgb@redhat.com>
	 <92746f6d4ad17ce7af82d08f5b18443ca3b0c31b.1412285491.git.rgb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 22:05 -0400, Richard Guy Briggs wrote:
> Re-factor audit_rule_change() to reduce the amount of code redundancy and
> simplify the logic.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/auditfilter.c |   20 +++++++-------------
>  1 files changed, 7 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index 4a11697..e3378a4 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -1064,30 +1064,24 @@ int audit_rule_change(int type, __u32 portid, int seq, void *data,
>  	int err = 0;
>  	struct audit_entry *entry;
>  
> +	entry = audit_data_to_entry(data, datasz);
> +	if (IS_ERR(entry))
> +		return PTR_ERR(entry);
> +
>  	switch (type) {
>  	case AUDIT_ADD_RULE:
> -		entry = audit_data_to_entry(data, datasz);
> -		if (IS_ERR(entry))
> -			return PTR_ERR(entry);
> -
>  		err = audit_add_rule(entry);
>  		audit_log_rule_change("add_rule", &entry->rule, !err);
> -		if (err)
> -			audit_free_rule(entry);
>  		break;
>  	case AUDIT_DEL_RULE:
> -		entry = audit_data_to_entry(data, datasz);
> -		if (IS_ERR(entry))
> -			return PTR_ERR(entry);
> -
>  		err = audit_del_rule(entry);
>  		audit_log_rule_change("remove_rule", &entry->rule, !err);
> -		audit_free_rule(entry);
>  		break;
> -	default:
> -		return -EINVAL;

I left the default case and made it:

                err = -EINVAL;
                WARN_ON(1);

Seemed like better defensive coding....

>  	}
>  
> +	if (err || type == AUDIT_DEL_RULE)
> +		audit_free_rule(entry);
> +
>  	return err;
>  }
>  


