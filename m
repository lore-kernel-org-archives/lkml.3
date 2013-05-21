Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996Ab3EUJOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 05:14:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2322 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752525Ab3EUJOJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 05:14:09 -0400
X-IronPort-AV: E=Sophos;i="4.87,713,1363104000"; 
   d="scan'208";a="7322590"
Message-ID: <519B3B4E.1070405@cn.fujitsu.com>
Date: Tue, 21 May 2013 17:15:58 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Gao feng <gaofeng@cn.fujitsu.com>
CC: eparis@redhat.com, ebiederm@xmission.com, serge.hallyn@ubuntu.com,
        davem@davemloft.net, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: Re: [PATCH RFC 00/48] Add namespace support for audit
References: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
In-Reply-To: <1367893269-9308-1-git-send-email-gaofeng@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/21 17:12:50,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/21 17:12:51,
	Serialize complete at 2013/05/21 17:12:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 10:20 AM, Gao feng wrote:
> This patchset try to add namespace support for audit.
> 
> I choose to assign audit to the user namespace.
> Right now,there are six kinds of namespaces, such as
> net, mount, ipc, pid, uts and user. the first five
> namespaces have special usage. the audit isn't suitable to
> belong to these five namespaces, so the user namespace
> may be the best choice.
> 
> Through I decide to make audit related resources per user
> namespace, but audit uses netlink to communicate between kernel
> space and user space, and the netlink is a private resource
> of per net namespace. So we need the capability to allow the
> netlink sockets to communicate with each other in the same user
> namespace even they are in different net namespace. [PATCH 2/48]
> does this job, it adds a new function "compare" for per netlink
> table to compare two sockets. it means the netlink protocols can
> has its own compare fuction, For other protocols, two netlink
> sockets are different if they belong to the different net namespace.
> For audit protocol, two sockets can be the same even they in different
> net namespace,we use user namespace not net namespace to make the
> decision.
> 
> There is one point that some people may dislike,in [PATCH 1/48],
> the kernel side audit netlink socket is created only when we create
> the first netns for the userns, and this userns will hold the netns
> until we destroy this userns.
> 
> The other patches just make the audit related resources per
> user namespace.
> 
> This patchset is sent as an RFC,any comments are welcome.
> 

Half of month passed, Can anybody give me some comments or advice or even
an ACK?

I think the key point is the first 3 patch. these patches add a compare
function per netlink_table, netlink sockets use this compare function to
decide if they can communicate with each other. For other netlink protocols
we use net namespace to make this decision. But for audit netlink protocol,
we use user namespace to make the decision. It means, for audit netlink sockets,
they can communicate when they in same user namespace and there is no need
for them to stay in same net namespace.

I don't know if anyone object to this and if there is a better solution.

Eric, Serge & David, can you give me some comments?

Thanks!

> Gao feng (48):
>   Audit: make audit kernel side netlink sock per userns
>   netlink: Add compare function for netlink_table
>   Audit: implement audit self-defined compare function
>   Audit: make audit_skb_queue per user namespace
>   Audit: make audit_skb_hold_queue per user namespace
>   Audit: make kauditd_task per user namespace
>   Audit: make audit_pid per user namespace
>   Audit: make audit_nlk_portid per user namesapce
>   Audit: make audit_enabled per user namespace
>   Audit: change type of audit_ever_enabled to bool
>   Audit: make audit_ever_enabled per user namespace
>   Audit: make audit_initialized per user namespace
>   Audit: only allow init user namespace to change audit_rate_limit
>   Audit: only allow init user namespace to change audit_failure
>   Audit: allow to send netlink message to auditd in uninit user
>     namespace
>   Audit: user proper user namespace in audit_log_config_change
>   Audit: make kauditd_wait per user namespace
>   Audit: make audit_backlog_wait per user namespace
>   Audit: remove duplicate comments
>   Audit: introduce new audit logging interface for user namespace
>   Audit: pass proper user namespace to audit_log_common_recv_msg
>   Audit: Log audit config change in uninit user namespace
>   Audit: netfilter: Log xt table replace behavior in proper user
>     namespace
>   Audit: xt_AUDIT: Log audit message in proper user namespace
>   Audit: send reply message to the auditd in proper user namespace
>   Audit: make audit_inode_hash per user namespace
>   Audit: make tree_list per user namespace
>   Audit: make audit filter list per user namespace
>   Audit: make audit_krule belongs to user namespace
>   Audit: reply audit filter list request to proper user namespace
>   Audit: pass proper user namespace to audit_filter_syscall
>   Audit: pass proper user namespace to audit_filter_inode_name
>   Audit: Log filter related audit message to proper user namespace
>   Log audit tree related message in proper user namespace
>   Audit: Log task related audit message to proper user namespace
>   Audit: Log watch related audit message to proper user namespace
>   Audit: translate audit_log_start to audit_log_start_ns
>   Audit: tty: translate audit_log_start to audit_log_start_ns
>   Audit: netlabel: translate audit_log_start to audit_log_start_ns
>   Audit: ima: translate audit_log_start to audit_log_start_ns
>   Audit: lsm: translate audit_log_start to audit_log_start_ns
>   Audit: selinux: translate audit_log_start to audit_log_start_ns
>   Audit: xfrm: translate audit_log_start to audit_log_start_ns
>   Audit: rename audit_log_start_ns to audit_log_start
>   Audit: user audit_enabled_ns to replace audit_enabled
>   Audit: rename audit_enabled_ns to audit_enabled
>   Audit: make audit_log user namespace awared
>   Audit: allow root user of un-init user namespace to set audit
> 
>  drivers/tty/tty_audit.c             |   9 +-
>  include/linux/audit.h               |  44 ++--
>  include/linux/netlink.h             |   1 +
>  include/linux/user_namespace.h      |  25 +++
>  include/net/xfrm.h                  |   7 +-
>  kernel/audit.c                      | 393 +++++++++++++++++++++---------------
>  kernel/audit.h                      |  24 +--
>  kernel/audit_tree.c                 |  49 ++---
>  kernel/audit_watch.c                |  23 ++-
>  kernel/auditfilter.c                |  76 +++----
>  kernel/auditsc.c                    | 156 ++++++++------
>  kernel/user.c                       |  19 ++
>  kernel/user_namespace.c             |   3 +
>  net/core/dev.c                      |  12 +-
>  net/ipv4/cipso_ipv4.c               |   4 +-
>  net/netfilter/x_tables.c            |   9 +-
>  net/netfilter/xt_AUDIT.c            |   8 +-
>  net/netlabel/netlabel_domainhash.c  |   4 +-
>  net/netlabel/netlabel_unlabeled.c   |   8 +-
>  net/netlabel/netlabel_user.c        |   8 +-
>  net/netlink/af_netlink.c            |  26 ++-
>  net/netlink/af_netlink.h            |   1 +
>  net/xfrm/xfrm_policy.c              |   4 +-
>  net/xfrm/xfrm_state.c               |  14 +-
>  security/apparmor/lib.c             |   2 +-
>  security/integrity/ima/ima_api.c    |   5 +-
>  security/integrity/ima/ima_audit.c  |  11 +-
>  security/integrity/ima/ima_policy.c |   5 +-
>  security/lsm_audit.c                |   8 +-
>  security/selinux/avc.c              |   3 +-
>  security/selinux/hooks.c            |  17 +-
>  security/selinux/selinuxfs.c        |   9 +-
>  security/selinux/ss/services.c      |  30 ++-
>  security/smack/smack_lsm.c          |   3 +-
>  34 files changed, 630 insertions(+), 390 deletions(-)
> 

