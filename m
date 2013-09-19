Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab3ISVTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 17:19:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797Ab3ISVTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 17:19:16 -0400
From: Steve Grubb <sgrubb@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Duval <dan.duval@oracle.com>,
        Chuck Anderson <chuck.anderson@oracle.com>,
        Guy Streeter <streeter@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 7/8] audit: clean up AUDIT_GET/SET local variables and future-proof API
Date: Thu, 19 Sep 2013 17:18:55 -0400
Message-ID: <1557446.mvTTyrtVjc@x2>
Organization: Red Hat
User-Agent: KMail/4.11.1 (Linux/3.11.1-200.fc19.x86_64; KDE/4.11.1; x86_64; ; )
In-Reply-To: <3c8ba778c317db8e9d49fa44af736f4b122e4d06.1379530867.git.rgb@redhat.com>
References: <20130917152842.51158606ed46ec67b97b4448@linux-foundation.org> <3c8ba778c317db8e9d49fa44af736f4b122e4d06.1379530867.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 18, 2013 03:06:52 PM Richard Guy Briggs wrote:
> Re-named confusing local variable names (status_set and status_get didn't
> agree with their command type name) and reduced their scope.
> 
> Future-proof API changes by not depending on the exact size of the
> audit_status struct.

I wished things like this were coordinated before being written. We had some 
discussion of this back in July under a topic, "audit: implement generic 
feature setting and retrieving". Maybe that API can be fixed so its not just 
set/unset but can take a number as well.

Also, because there is no way to query the kernel to see what kind of things 
it supports, we've typically defined a new message type and put into it exactly 
what we need. In other words, if you want something expandable, the define a 
new message type like AUDIT_GET_EXT and AUDIT_SET_EXT and build it to be 
expandable.

Then in a future version of auditctl it will try to use the new command and 
fall back to the old one if it gets EINVAL. Then some years later the old GET 
and SET can be deprecated. But the audit code base has to support a wide 
variety of kernels and suddenly making on resizable might break old code on 
new kernel. A new message type is a safer migration path.

-Steve


> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/audit.c |   51 +++++++++++++++++++++++++++------------------------
>  1 files changed, 27 insertions(+), 24 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index acfa7a9..3d17670 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -635,7 +635,6 @@ static int audit_receive_msg(struct sk_buff *skb, struct
> nlmsghdr *nlh) {
>  	u32			seq;
>  	void			*data;
> -	struct audit_status	*status_get, status_set;
>  	int			err;
>  	struct audit_buffer	*ab;
>  	u16			msg_type = nlh->nlmsg_type;
> @@ -661,47 +660,51 @@ static int audit_receive_msg(struct sk_buff *skb,
> struct nlmsghdr *nlh) data = nlmsg_data(nlh);
> 
>  	switch (msg_type) {
> -	case AUDIT_GET:
> -		status_set.enabled	 = audit_enabled;
> -		status_set.failure	 = audit_failure;
> -		status_set.pid		 = audit_pid;
> -		status_set.rate_limit	 = audit_rate_limit;
> -		status_set.backlog_limit = audit_backlog_limit;
> -		status_set.lost		 = atomic_read(&audit_lost);
> -		status_set.backlog	 = skb_queue_len(&audit_skb_queue);
> +	case AUDIT_GET: {
> +		struct audit_status	s;
> +		s.enabled	 = audit_enabled;
> +		s.failure	 = audit_failure;
> +		s.pid		 = audit_pid;
> +		s.rate_limit	 = audit_rate_limit;
> +		s.backlog_limit = audit_backlog_limit;
> +		s.lost		 = atomic_read(&audit_lost);
> +		s.backlog	 = skb_queue_len(&audit_skb_queue);
>  		audit_send_reply(NETLINK_CB(skb).portid, seq, AUDIT_GET, 0, 0,
> -				 &status_set, sizeof(status_set));
> +				 &s, sizeof(s));
>  		break;
> -	case AUDIT_SET:
> -		if (nlh->nlmsg_len < sizeof(struct audit_status))
> -			return -EINVAL;
> -		status_get   = (struct audit_status *)data;
> -		if (status_get->mask & AUDIT_STATUS_ENABLED) {
> -			err = audit_set_enabled(status_get->enabled);
> +	}
> +	case AUDIT_SET: {
> +		struct audit_status	s;
> +		memset(&s, 0, sizeof(s));
> +		/* guard against past and future API changes */
> +		memcpy(&s, data, min(sizeof(s), (size_t)nlh->nlmsg_len));
> +		if (s.mask & AUDIT_STATUS_ENABLED) {
> +			err = audit_set_enabled(s.enabled);
>  			if (err < 0)
>  				return err;
>  		}
> -		if (status_get->mask & AUDIT_STATUS_FAILURE) {
> -			err = audit_set_failure(status_get->failure);
> +		if (s.mask & AUDIT_STATUS_FAILURE) {
> +			err = audit_set_failure(s.failure);
>  			if (err < 0)
>  				return err;
>  		}
> -		if (status_get->mask & AUDIT_STATUS_PID) {
> -			int new_pid = status_get->pid;
> +		if (s.mask & AUDIT_STATUS_PID) {
> +			int new_pid = s.pid;
> 
>  			if (audit_enabled != AUDIT_OFF)
>  				audit_log_config_change("audit_pid", new_pid, audit_pid, 
1);
>  			audit_pid = new_pid;
>  			audit_nlk_portid = NETLINK_CB(skb).portid;
>  		}
> -		if (status_get->mask & AUDIT_STATUS_RATE_LIMIT) {
> -			err = audit_set_rate_limit(status_get->rate_limit);
> +		if (s.mask & AUDIT_STATUS_RATE_LIMIT) {
> +			err = audit_set_rate_limit(s.rate_limit);
>  			if (err < 0)
>  				return err;
>  		}
> -		if (status_get->mask & AUDIT_STATUS_BACKLOG_LIMIT)
> -			err = audit_set_backlog_limit(status_get->backlog_limit);
> +		if (s.mask & AUDIT_STATUS_BACKLOG_LIMIT)
> +			err = audit_set_backlog_limit(s.backlog_limit);
>  		break;
> +	}
>  	case AUDIT_USER:
>  	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
>  	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:

