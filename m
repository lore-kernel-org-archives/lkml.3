Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab3G2S6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:58:48 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:52581 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3G2S6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:58:46 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rui Xiang <rui.xiang@huawei.com>
Cc: <containers@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <serge.hallyn@ubuntu.com>, <akpm@linux-foundation.org>,
        <gaofeng@cn.fujitsu.com>, <libo.chen@huawei.com>
References: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com>
Date: Mon, 29 Jul 2013 11:58:23 -0700
In-Reply-To: <1375065080-26740-1-git-send-email-rui.xiang@huawei.com> (Rui
	Xiang's message of "Mon, 29 Jul 2013 10:31:11 +0800")
Message-ID: <87wqo9urao.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18tp+nlU8b+h1l++RGOTezouEYePiJ4ZnQ=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3706]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rui Xiang <rui.xiang@huawei.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 0/9] Add namespace support for syslog v2
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rui Xiang <rui.xiang@huawei.com> writes:

> This patchset introduces a system log namespace.

The largest outstanding question is not answered.  Can't we just fix
iptables to log somehwere better than dmesg, and would that not entirely
remove the need for this work?

That question needs to be answered before we proceed down this path.

Eric

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
