Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757474Ab3JOHHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:07:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33133 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab3JOHHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:07:44 -0400
Message-ID: <525CE9BD.4020002@jp.fujitsu.com>
Date: Tue, 15 Oct 2013 16:07:41 +0900
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gao feng <gaofeng@cn.fujitsu.com>
CC: toshi.okajima@jp.fujitsu.com, toshi.okajima@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, eparis@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG][PATCH] audit: audit_log_start running on auditd should
 not stop
References: <20131011103645.6643fabff0eceb152e0be6c2@jp.fujitsu.com> <5257C5D7.80308@cn.fujitsu.com> <5257EF15.6080209@jp.fujitsu.com> <20131015134345.98d72df42a39e9e1ad77a73c@jp.fujitsu.com> <525CE10A.90907@cn.fujitsu.com>
In-Reply-To: <525CE10A.90907@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gao-san,

(2013/10/15 15:30), Gao feng wrote:
> Hi Toshiyuki-san,
> On 10/15/2013 12:43 PM, Toshiyuki Okajima wrote:
>> The backlog cannot be consumed when audit_log_start is running on auditd
>> even if audit_log_start calls wait_for_auditd to consume it.
>> The situation is a deadlock because only auditd can consume the backlog.
>> If the other process needs to send the backlog, it can be also stopped 
>> by the deadlock.
>>
>> So, audit_log_start running on auditd should not stop.
>>
>> You can see the deadlock with the following reproducer:
>>  # auditctl -a exit,always -S all
>>  # reboot
>>
>> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
>> Cc: gaofeng@cn.fujitsu.com
>> ---
>>  kernel/audit.c |    3 +++
>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/audit.c b/kernel/audit.c
>> index 7b0e23a..ce1fb38 100644
>> --- a/kernel/audit.c
>> +++ b/kernel/audit.c
>> @@ -1098,6 +1098,9 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
>>  	int reserve;
>>  	unsigned long timeout_start = jiffies;
>>  
>> +	if (audit_pid && audit_pid == current->pid)
>> +		gfp_mask &= ~__GFP_WAIT;
>> +
>>  	if (audit_initialized != AUDIT_INITIALIZED)
>>  		return NULL;
>>  
>>
> 

> Hmm, I see, There may be other code paths that auditd can call audit_log_start except
Yeah. I found it when I reviewed the code paths to audit_log_start after I got your comment.

sys_sendto
-> sock_sendmsg
   -> netlink_unicast
      -> audit_receive
         -> audit_receive_skb  
            -> audit_receive_msg
               -> audit_log_config_change
                  -> audit_log_start
               -> audit_log_common_recv_msg     ***
                  -> audit_log_start            ***

> audit_log_config_change. so it's better to handle this problem in audit_log_start.
> 
> but current task is only meaningful when gfp_mask & __GFP_WAIT is true.
> so maybe the below patch is what you want.
OK. 

I considered the code size, but I didn't consider the execution speed.
audit_log_start doesn't always need to execute "if (audit_pid && audit_pid == current->pid)"! 

I will send your revised patch later.

Thanks,
Toshiyuki Okajima

> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 7b0e23a..10b4545 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1095,7 +1095,9 @@ struct audit_buffer *audit_log_start(struct audit_context
>         struct audit_buffer     *ab     = NULL;
>         struct timespec         t;
>         unsigned int            uninitialized_var(serial);
> -       int reserve;
> +       int reserve = 5; /* Allow atomic callers to go up to five
> +                           entries over the normal backlog limit */
> +
>         unsigned long timeout_start = jiffies;
> 
>         if (audit_initialized != AUDIT_INITIALIZED)
> @@ -1104,11 +1106,12 @@ struct audit_buffer *audit_log_start(struct audit_contex
>         if (unlikely(audit_filter_type(type)))
>                 return NULL;
> 
> -       if (gfp_mask & __GFP_WAIT)
> -               reserve = 0;
> -       else
> -               reserve = 5; /* Allow atomic callers to go up to five
> -                               entries over the normal backlog limit */
> +       if (gfp_mask & __GFP_WAIT) {
> +               if (audit_pid && audit_pid == current->pid)
> +                       gfp_mask &= ~__GFP_WAIT;
> +               else
> +                       reserve = 0;
> +       }
> 
>         while (audit_backlog_limit
>                && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserv
> 
> 
> Thanks
> 
> 




