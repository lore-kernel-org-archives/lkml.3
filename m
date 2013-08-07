Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085Ab3HGS7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:59:38 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:31980 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932158Ab3HGS7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:59:37 -0400
Message-ID: <1375901968.2644.91.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v3 07/11] syslog_ns: implement function for creating
 syslog ns
From: Ben Hutchings <bhutchings@solarflare.com>
To: Rui Xiang <rui.xiang@huawei.com>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <gaofeng@cn.fujitsu.com>,
        <guz.fnst@cn.fujitsu.com>, <libo.chen@huawei.com>
Date: Wed, 7 Aug 2013 20:59:28 +0200
In-Reply-To: <1375861035-24320-8-git-send-email-rui.xiang@huawei.com>
References: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
	 <1375861035-24320-8-git-send-email-rui.xiang@huawei.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [80.83.48.229]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20062.005
X-TM-AS-Result: No--15.346000-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 15:37 +0800, Rui Xiang wrote:
[...]
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
[...]
> @@ -1125,6 +1129,51 @@ static int syslog_print_all(char __user *buf, int size, bool clear,
>  	return len;
>  }
>  
> +static int create_syslog_ns(void)
> +{
> +	struct user_namespace *userns = current_user_ns();
> +	struct syslog_namespace *oldns, *newns;
> +	int err;
> +
> +	/*
> +	 * syslog ns belongs to a user ns.  So you can only unshare your
> +	 * user_ns if you share a user_ns with your parent userns

It looks like this should say:
           * syslog_ns if you share a syslog_ns with your parent user_ns

> +	 */
> +	if (userns == &init_user_ns ||
> +		userns->syslog_ns != userns->parent->syslog_ns)
> +		return -EINVAL;
> +
> +	if (!ns_capable(userns, CAP_SYSLOG))
> +		return -EPERM;
> +
> +	err = -ENOMEM;
> +	oldns = userns->syslog_ns;
> +	newns = kzalloc(sizeof(*newns), GFP_ATOMIC);

This doesn't appear to be an atomic context, so use GFP_KERNEL.

> +	if (!newns)
> +		goto out;
> +	newns->log_buf_len = __LOG_BUF_LEN;
> +	newns->log_buf = kzalloc(newns->log_buf_len, GFP_ATOMIC);
[...]

Same here.

Also¸ I'm not sure that __LOG_BUF_LEN is the right length.  OpenVZ
certainly uses a small buffer for container syslogs (4K) rather than
using the same length as the global syslog.  Maybe it should be
separately configutable.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

