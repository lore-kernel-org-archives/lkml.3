Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab3JWA5x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 20:57:53 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48350 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753511Ab3JWA5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 20:57:51 -0400
X-IronPort-AV: E=Sophos;i="4.93,551,1378828800"; 
   d="scan'208";a="8832974"
Message-ID: <52671F55.5030108@cn.fujitsu.com>
Date: Wed, 23 Oct 2013 08:59:01 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>
CC: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: allow unlimited audit_backlog_limit [was: Re: [PATCH] audit:
 don't create audit log when audit_backlog_limit is zero]
References: <1382342500-12693-1-git-send-email-gaofeng@cn.fujitsu.com> <20131022175901.GA5059@madcap2.tricolour.ca>
In-Reply-To: <20131022175901.GA5059@madcap2.tricolour.ca>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/23 08:55:19,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/23 08:55:20,
	Serialize complete at 2013/10/23 08:55:20
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2013 01:59 AM, Richard Guy Briggs wrote:
> On Mon, Oct 21, 2013 at 04:01:40PM +0800, Gao feng wrote:
>> As the man page of auditctl said:
>> "
>> -b backlog
>>               Set max number of outstanding audit buffers allowed (Kernel Default=64)
>> 	      If all buffers are full, the failure flag is consulted by the kernel
>>               for action.
>> "
>>
>> So if audit_backlog_limit is zero, it means no audit buffer
>> should be allocated.
> 
> Which sounds the same as audit=0 on the kernel boot line or "auditctl -e 0"
> to disable it.  This is redundant.  I would suggest instead that it
> would be more useful to have backlog set to zero mean unlimited (well,
> limited by system RAM).  This can be dangerous, but that can be
> warned in the manpage.  So, to accomplish that, a minor change is
> needed in the audit_hold_skb() funciton:
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> @@ -355,7 +355,8 @@ static int audit_set_failure(int state)
>  static void audit_hold_skb(struct sk_buff *skb)
>  {
>  	if (audit_default &&
> -	    skb_queue_len(&audit_skb_hold_queue) < audit_backlog_limit)
> +	    (!audit_backlog_limit ||
> +	     skb_queue_len(&audit_skb_hold_queue) < audit_backlog_limit))
>  		skb_queue_tail(&audit_skb_hold_queue, skb);
>  	else
>  		kfree_skb(skb);
> 
> And here is what I would propose for the corresponding userspace mod:
> 
> diff --git a/trunk/docs/auditctl.8 b/trunk/docs/auditctl.8
> @@ -8,7 +8,7 @@ The \fBauditctl\fP program is used to control the behavior, get status, and add
>  .SH OPTIONS
>  .TP
>  .BI \-b\  backlog
> -Set max number of outstanding audit buffers allowed (Kernel Default=64) If all buffers are full, the failure flag is consulted by the kernel for action.
> +Set max number of outstanding audit buffers allowed (Kernel Default=64) If all buffers are full, the failure flag is consulted by the kernel for action.  Setting this to "0" (which is dangerous) implies an unlimited queue, limited only by system resources.
>  .TP
>  \fB\-e\fP [\fB0\fP..\fB2\fP]
>  Set enabled flag. When \fB0\fP is passed, this can be used to temporarily disable auditing. When \fB1\fP is passed as an argument, it will enable auditing. To lock the audit configuration so that it can't be changed, pass a \fB2\fP as the argument. Locking the configuration is intended to be the last command in audit.rules for anyone wishing this feature to be active. Any attempt to change the configuration in this mode will be audited and denied. The configuration can only be changed by rebooting the machine.
> diff --git a/trunk/src/auditctl.c b/trunk/src/auditctl.c
> @@ -107,7 +107,7 @@ static void usage(void)
>       "    -a <l,a>            Append rule to end of <l>ist with <a>ction\n"
>       "    -A <l,a>            Add rule at beginning of <l>ist with <a>ction\n"
>       "    -b <backlog>        Set max number of outstanding audit buffers\n"
> -     "                        allowed Default=64\n"
> +     "                        allowed. Default=64 Unlimited=0(dangerous)\n"
>       "    -c                  Continue through errors in rules\n"
>       "    -C f=f              Compare collected fields if available:\n"
>       "                        Field name, operator(=,!=), field name\n"
> 
> 
> Does this sound like a reasonable change?
> 

Yes, it's reasonable, I'm ok with this change, just like audit_rate_limit,
zero means unlimited. And it's better to change the comments of audit_backlog_limit
in kernel.

Thanks.
