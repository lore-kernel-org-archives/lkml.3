Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3G2JhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:37:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3943 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab3G2JhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:37:14 -0400
X-IronPort-AV: E=Sophos;i="4.89,768,1367942400"; 
   d="scan'208";a="8056955"
Message-ID: <51F636E6.3080607@cn.fujitsu.com>
Date: Mon, 29 Jul 2013 17:33:26 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Rui Xiang <rui.xiang@huawei.com>
CC: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        akpm@linux-foundation.org, gaofeng@cn.fujitsu.com,
        libo.chen@huawei.com
Subject: Re: [PATCH 0/9] Add namespace support for syslog v2
References: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com>
In-Reply-To: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/29 17:35:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/29 17:35:03,
	Serialize complete at 2013/07/29 17:35:03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui,

On 07/29/2013 10:31 AM, Rui Xiang wrote:

> This patchset introduces a system log namespace.
> 
> It is the 2nd version. The link of the 1st version is 
> http://lwn.net/Articles/525728/. In that version, syslog_
> namespace was added into nsproxy and created through a new
> clone flag CLONE_SYSLOG when cloning a process. 
> 
> There were some discussion in last November about the 1st 
> version. This version used these important advice, and 
> referred to Serge's patch(http://lwn.net/Articles/525629/).
> 
> Unlike the 1st version, in this patchset, syslog namespace 
> is tied to a user namespace. Add we must create a new user 
> ns before create a new syslog ns, because that will make 
> users have full capabilities in this new userns after 
> cloning a new user ns. The syslog namespace can be created 
> through a new command(11) to __NR_syslog syscall. That owe 
> to a new syslog flag SYSLOG_ACTION_NEW_NS.
> 
> In syslog_namespace, some necessary identifiers for handling 
> syslog buf are containerized. When one container creates a
> new syslog ns, individual buf will be allocated to store log
> ownned this container. 
> 
> A new interface ns_printk is added to print the logs which 
> we want to see in the container. Through ns_printk, we can 
> get more logs related to a specific net ns, for instance, 
> iptables. Here we use it to report iptable logs per 
> contianer.
> 
> Then default printk targeted at the init_syslog_ns will 
> continue to print out most kernel log to host.
> 
> One task in a new syslog ns could affect only current 
> container through "dmesg", "dmesg -c" and /dev/kmsg 
> actions. The read/write interface such as /dev/kmsg, 
> /pro/kmsg and syslog syscall continue to be useful for 
> container users.
> 
> This patchset is based on linus' linux tree.

Changelog details between V2 and V1 is seriously needed, the inline description
is not easy reading for other guys.

> 
> Rui Xiang (9):
>   syslog_ns: add syslog_namespace and put/get_syslog_ns
>   syslog_ns: add syslog_ns into user_namespace
>   syslog_ns: add init syslog_ns for global syslog
>   syslog_ns: make syslog handling per namespace
>   syslog_ns: make permisiion check per user namespace
>   syslog_ns: use init syslog_ns for console action
>   syslog_ns: implement function for creating syslog ns
>   syslog_ns: implement ns_printk for specific syslog_ns
>   netfilter: use ns_printk in iptable context
> 
>  fs/proc/kmsg.c                 |  17 +-
>  include/linux/printk.h         |   5 +-
>  include/linux/syslog.h         |  79 ++++-
>  include/linux/user_namespace.h |   2 +
>  include/net/netfilter/xt_log.h |   6 +-
>  kernel/printk.c                | 642 ++++++++++++++++++++++++-----------------
>  kernel/sysctl.c                |   3 +-
>  kernel/user.c                  |   3 +
>  kernel/user_namespace.c        |   4 +
>  net/netfilter/xt_LOG.c         |   4 +-
>  10 files changed, 493 insertions(+), 272 deletions(-)
> 


