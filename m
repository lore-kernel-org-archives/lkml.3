Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab3JOG3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 02:29:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54509 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab3JOG3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 02:29:31 -0400
X-IronPort-AV: E=Sophos;i="4.93,497,1378828800"; 
   d="scan'208";a="8759196"
Message-ID: <525CE10A.90907@cn.fujitsu.com>
Date: Tue, 15 Oct 2013 14:30:34 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
CC: viro@zeniv.linux.org.uk, eparis@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG][PATCH] audit: audit_log_start running on auditd should
 not stop
References: <20131011103645.6643fabff0eceb152e0be6c2@jp.fujitsu.com> <5257C5D7.80308@cn.fujitsu.com> <5257EF15.6080209@jp.fujitsu.com> <20131015134345.98d72df42a39e9e1ad77a73c@jp.fujitsu.com>
In-Reply-To: <20131015134345.98d72df42a39e9e1ad77a73c@jp.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/15 14:27:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/15 14:27:12,
	Serialize complete at 2013/10/15 14:27:12
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshiyuki-san,
On 10/15/2013 12:43 PM, Toshiyuki Okajima wrote:
> The backlog cannot be consumed when audit_log_start is running on auditd
> even if audit_log_start calls wait_for_auditd to consume it.
> The situation is a deadlock because only auditd can consume the backlog.
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
>  kernel/audit.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 7b0e23a..ce1fb38 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1098,6 +1098,9 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
>  	int reserve;
>  	unsigned long timeout_start = jiffies;
>  
> +	if (audit_pid && audit_pid == current->pid)
> +		gfp_mask &= ~__GFP_WAIT;
> +
>  	if (audit_initialized != AUDIT_INITIALIZED)
>  		return NULL;
>  
> 

Hmm, I see, There may be other code paths that auditd can call audit_log_start except
audit_log_config_change. so it's better to handle this problem in audit_log_start.

but current task is only meaningful when gfp_mask & __GFP_WAIT is true.
so maybe the below patch is what you want.

diff --git a/kernel/audit.c b/kernel/audit.c
index 7b0e23a..10b4545 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1095,7 +1095,9 @@ struct audit_buffer *audit_log_start(struct audit_context
        struct audit_buffer     *ab     = NULL;
        struct timespec         t;
        unsigned int            uninitialized_var(serial);
-       int reserve;
+       int reserve = 5; /* Allow atomic callers to go up to five
+                           entries over the normal backlog limit */
+
        unsigned long timeout_start = jiffies;

        if (audit_initialized != AUDIT_INITIALIZED)
@@ -1104,11 +1106,12 @@ struct audit_buffer *audit_log_start(struct audit_contex
        if (unlikely(audit_filter_type(type)))
                return NULL;

-       if (gfp_mask & __GFP_WAIT)
-               reserve = 0;
-       else
-               reserve = 5; /* Allow atomic callers to go up to five
-                               entries over the normal backlog limit */
+       if (gfp_mask & __GFP_WAIT) {
+               if (audit_pid && audit_pid == current->pid)
+                       gfp_mask &= ~__GFP_WAIT;
+               else
+                       reserve = 0;
+       }

        while (audit_backlog_limit
               && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserv


Thanks
