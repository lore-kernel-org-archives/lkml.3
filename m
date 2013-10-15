Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343Ab3JOJkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 05:40:00 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:9796 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab3JOJj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 05:39:58 -0400
X-IronPort-AV: E=Sophos;i="4.93,498,1378828800"; 
   d="scan'208";a="8761129"
Message-ID: <525D0DAE.6000909@cn.fujitsu.com>
Date: Tue, 15 Oct 2013 17:41:02 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
CC: viro@zeniv.linux.org.uk, eparis@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG][PATCH V3] audit: audit_log_start running on auditd should
 not stop
References: <20131011103645.6643fabff0eceb152e0be6c2@jp.fujitsu.com> <5257C5D7.80308@cn.fujitsu.com> <5257EF15.6080209@jp.fujitsu.com> <20131015134345.98d72df42a39e9e1ad77a73c@jp.fujitsu.com> <525CE10A.90907@cn.fujitsu.com> <525CE9BD.4020002@jp.fujitsu.com> <20131015165857.aa1c68502180cb4b89d6226a@jp.fujitsu.com>
In-Reply-To: <20131015165857.aa1c68502180cb4b89d6226a@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/15 17:37:37,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/15 17:37:38,
	Serialize complete at 2013/10/15 17:37:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 03:58 PM, Toshiyuki Okajima wrote:
> The backlog cannot be consumed when audit_log_start is running on auditd
> even if audit_log_start calls wait_for_auditd to consume it.
> The situation is the deadlock because only auditd can consume the backlog.
> If the other process needs to send the backlog, it can be also stopped 
> by the deadlock.
> 
> So, audit_log_start running on auditd should not stop.
> 
> You can see the deadlock with the following reproducer:
>  # auditctl -a exit,always -S all
>  # reboot
> 
> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
> Cc: gaofeng@cn.fujitsu.com
> ---
>  kernel/audit.c |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
> 

Looks good to me, thanks!
Reviewed-by: Gao feng <gaofeng@cn.fujitsu.com>


> diff --git a/kernel/audit.c b/kernel/audit.c
> index 7b0e23a..29cfc94 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1095,7 +1095,8 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
>  	struct audit_buffer	*ab	= NULL;
>  	struct timespec		t;
>  	unsigned int		uninitialized_var(serial);
> -	int reserve;
> +	int reserve = 5; /* Allow atomic callers to go up to five
> +			    entries over the normal backlog limit */
>  	unsigned long timeout_start = jiffies;
>  
>  	if (audit_initialized != AUDIT_INITIALIZED)
> @@ -1104,11 +1105,12 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
>  	if (unlikely(audit_filter_type(type)))
>  		return NULL;
>  
> -	if (gfp_mask & __GFP_WAIT)
> -		reserve = 0;
> -	else
> -		reserve = 5; /* Allow atomic callers to go up to five
> -				entries over the normal backlog limit */
> +	if (gfp_mask & __GFP_WAIT) {
> +		if (audit_pid && audit_pid == current->pid)
> +			gfp_mask &= ~__GFP_WAIT;
> +		else
> +			reserve = 0;
> +	}
>  
>  	while (audit_backlog_limit
>  	       && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
> 

