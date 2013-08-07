Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843Ab3HGSxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 14:53:10 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:31836 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab3HGSwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 14:52:55 -0400
Message-ID: <1375901563.2644.84.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH v3 04/11] syslog_ns: make syslog handling per namespace
From: Ben Hutchings <bhutchings@solarflare.com>
To: Rui Xiang <rui.xiang@huawei.com>
CC: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <ebiederm@xmission.com>,
        <akpm@linux-foundation.org>, <gaofeng@cn.fujitsu.com>,
        <guz.fnst@cn.fujitsu.com>, <libo.chen@huawei.com>
Date: Wed, 7 Aug 2013 20:52:43 +0200
In-Reply-To: <1375861035-24320-5-git-send-email-rui.xiang@huawei.com>
References: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com>
	 <1375861035-24320-5-git-send-email-rui.xiang@huawei.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [80.83.48.229]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20062.005
X-TM-AS-Result: No--18.361500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-07 at 15:37 +0800, Rui Xiang wrote:
> This patch makes syslog buf and other fields per
> namespace.
> 
> Here use ns->log_buf(log_buf_len, logbuf_lock,
> log_first_seq, logbuf_lock, and so on) fields
> instead of global ones to handle syslog.
[...]
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
[...]
>  }
>  
> -#ifdef CONFIG_SECURITY_DMESG_RESTRICT
> -int dmesg_restrict = 1;
> -#else
> -int dmesg_restrict;
> -#endif
> -
> -static int syslog_action_restricted(int type)
> +static int syslog_action_restricted(int type,
> +			struct syslog_namespace *ns)
>  {
> -	if (dmesg_restrict)
> +	if (ns->dmesg_restrict)
>  		return 1;
>  	/*
>  	 * Unless restricted, we allow "read all" and "get buffer size"
[...]

I don't think this should be a per-namespace setting.  And it certainly
should not be possible for child namespaces to disable dmesg_restrict if
it is enabled by a parent namespace.

In later patches, it appears to be copied into child namespaces but not
made visible or controllable there.  So if an administrator enables
dmesg_restrict in the initial syslog namespace after another syslog
namespace has been created, she won't be able to tell that it is still
disabled in that other namespace.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

