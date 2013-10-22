Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab3JVR7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:59:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861Ab3JVR7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:59:11 -0400
Date: Tue, 22 Oct 2013 13:59:01 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: allow unlimited audit_backlog_limit [was: Re: [PATCH] audit: don't
 create audit log when audit_backlog_limit is zero]
Message-ID: <20131022175901.GA5059@madcap2.tricolour.ca>
References: <1382342500-12693-1-git-send-email-gaofeng@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382342500-12693-1-git-send-email-gaofeng@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 04:01:40PM +0800, Gao feng wrote:
> As the man page of auditctl said:
> "
> -b backlog
>               Set max number of outstanding audit buffers allowed (Kernel Default=64)
> 	      If all buffers are full, the failure flag is consulted by the kernel
>               for action.
> "
> 
> So if audit_backlog_limit is zero, it means no audit buffer
> should be allocated.

Which sounds the same as audit=0 on the kernel boot line or "auditctl -e 0"
to disable it.  This is redundant.  I would suggest instead that it
would be more useful to have backlog set to zero mean unlimited (well,
limited by system RAM).  This can be dangerous, but that can be
warned in the manpage.  So, to accomplish that, a minor change is
needed in the audit_hold_skb() funciton:

diff --git a/kernel/audit.c b/kernel/audit.c
@@ -355,7 +355,8 @@ static int audit_set_failure(int state)
 static void audit_hold_skb(struct sk_buff *skb)
 {
 	if (audit_default &&
-	    skb_queue_len(&audit_skb_hold_queue) < audit_backlog_limit)
+	    (!audit_backlog_limit ||
+	     skb_queue_len(&audit_skb_hold_queue) < audit_backlog_limit))
 		skb_queue_tail(&audit_skb_hold_queue, skb);
 	else
 		kfree_skb(skb);

And here is what I would propose for the corresponding userspace mod:

diff --git a/trunk/docs/auditctl.8 b/trunk/docs/auditctl.8
@@ -8,7 +8,7 @@ The \fBauditctl\fP program is used to control the behavior, get status, and add
 .SH OPTIONS
 .TP
 .BI \-b\  backlog
-Set max number of outstanding audit buffers allowed (Kernel Default=64) If all buffers are full, the failure flag is consulted by the kernel for action.
+Set max number of outstanding audit buffers allowed (Kernel Default=64) If all buffers are full, the failure flag is consulted by the kernel for action.  Setting this to "0" (which is dangerous) implies an unlimited queue, limited only by system resources.
 .TP
 \fB\-e\fP [\fB0\fP..\fB2\fP]
 Set enabled flag. When \fB0\fP is passed, this can be used to temporarily disable auditing. When \fB1\fP is passed as an argument, it will enable auditing. To lock the audit configuration so that it can't be changed, pass a \fB2\fP as the argument. Locking the configuration is intended to be the last command in audit.rules for anyone wishing this feature to be active. Any attempt to change the configuration in this mode will be audited and denied. The configuration can only be changed by rebooting the machine.
diff --git a/trunk/src/auditctl.c b/trunk/src/auditctl.c
@@ -107,7 +107,7 @@ static void usage(void)
      "    -a <l,a>            Append rule to end of <l>ist with <a>ction\n"
      "    -A <l,a>            Add rule at beginning of <l>ist with <a>ction\n"
      "    -b <backlog>        Set max number of outstanding audit buffers\n"
-     "                        allowed Default=64\n"
+     "                        allowed. Default=64 Unlimited=0(dangerous)\n"
      "    -c                  Continue through errors in rules\n"
      "    -C f=f              Compare collected fields if available:\n"
      "                        Field name, operator(=,!=), field name\n"


Does this sound like a reasonable change?

> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> ---
>  kernel/audit.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 7b0e23a..bbb4000 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1104,14 +1104,16 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
>  	if (unlikely(audit_filter_type(type)))
>  		return NULL;
>  
> +	if (!audit_backlog_limit)
> +		return NULL;
> +
>  	if (gfp_mask & __GFP_WAIT)
>  		reserve = 0;
>  	else
>  		reserve = 5; /* Allow atomic callers to go up to five
>  				entries over the normal backlog limit */
>  
> -	while (audit_backlog_limit
> -	       && skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
> +	while (skb_queue_len(&audit_skb_queue) > audit_backlog_limit + reserve) {
>  		if (gfp_mask & __GFP_WAIT && audit_backlog_wait_time) {
>  			unsigned long sleep_time;
>  

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
