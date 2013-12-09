Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299Ab3LICdT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 21:33:19 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60724 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566Ab3LICdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 21:33:18 -0500
Date: Mon, 9 Dec 2013 11:31:34 +0900
From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
To: Richard Guy Briggs <rgb@redhat.com>
CC: <linux-audit@redhat.com>, <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        Richard Guy Briggs <rgb@tricolour.ca>, <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH 3/3] audit: drop audit_cmd_lock in AUDIT_USER family of
 cases
Message-ID: <20131209113134.23d1176bedbf6831dbf86e8c@jp.fujitsu.com>
In-Reply-To: <53733434b27dc65bd16b2e73211b823da1fa64cf.1386206544.git.rgb@redhat.com>
References: <1382713941.2954.19.camel@flatline.rdu.redhat.com>
	<53733434b27dc65bd16b2e73211b823da1fa64cf.1386206544.git.rgb@redhat.com>
Organization: Fujitsu
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.11; i686-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  4 Dec 2013 21:45:56 -0500
Richard Guy Briggs <rgb@redhat.com> wrote:

> We do not need to hold the audit_cmd_mutex for this family of cases.  The
> possible exception to this is the call to audit_filter_user(), so drop the lock
> immediately after.  To help in fixing the race we are trying to avoid, make
> sure that nothing called by audit_filter_user() calls audit_log_start().  In
> particular, watch out for *_audit_rule_match().
> 
> This fix will take care of systemd and anything USING audit.  It still means
> that we could race with something configuring audit and auditd shutting down.
> 
> Signed-off-by: Richard Guy Briggs <rgb@tricolour.ca>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>

When I have tested a patch with my reproducer, 
a hangup by this problem doesn't occur. 
//// reproducer ////
 # auditctl -a exit,always -S all
 # reboot
/////////////////////////

So, this fix looks good to me.

Please add:

Reported-by: toshi.okajima@jp.fujitsu.com
Tested-by: toshi.okajima@jp.fujitsu.com

Thanks.

> ---
>  kernel/audit.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 4689012..4cbc945 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -713,6 +713,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  				if (err)
>  					break;
>  			}
> +			mutex_unlock(&audit_cmd_mutex);
>  			audit_log_common_recv_msg(&ab, msg_type);
>  			if (msg_type != AUDIT_USER_TTY)
>  				audit_log_format(ab, " msg='%.1024s'",
> @@ -729,6 +730,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  			}
>  			audit_set_pid(ab, NETLINK_CB(skb).portid);
>  			audit_log_end(ab);
> +			mutex_lock(&audit_cmd_mutex);
>  		}
>  		break;
>  	case AUDIT_ADD_RULE:
> -- 
> 1.7.1
> 


-- 
Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
