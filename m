Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaJFJQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:16:43 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:43029 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751157AbaJFJQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:16:41 -0400
X-IronPort-AV: E=Sophos;i="5.04,662,1406563200"; 
   d="scan'208";a="36858564"
From: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>
To: Richard Guy Briggs <rgb@redhat.com>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>
CC: "eparis@redhat.com" <eparis@redhat.com>,
        "pmoore@redhat.com" <pmoore@redhat.com>,
        "aviro@redhat.com" <aviro@redhat.com>,
        "sgrubb@redhat.com" <sgrubb@redhat.com>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>
Subject: RE: [PATCH V5 01/13] namespaces: assign each namespace instance a
 serial	number
Thread-Topic: [PATCH V5 01/13] namespaces: assign each namespace instance a
 serial	number
Thread-Index: AQHP4SO3i4QYR0K9KkudggenOXuwnpwiwAQA
Date: Mon, 6 Oct 2014 09:16:40 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E5DAB74@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <cover.1412543112.git.rgb@redhat.com>
 <8bc6e9595dea17bba389f4d2ce4077c30b3eb137.1412543112.git.rgb@redhat.com>
In-Reply-To: <8bc6e9595dea17bba389f4d2ce4077c30b3eb137.1412543112.git.rgb@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s969GlMX005296



> -----Original Message-----
> From: containers-bounces@lists.linux-foundation.org
> [mailto:containers-bounces@lists.linux-foundation.org] On Behalf Of Richard Guy
> Briggs
> Sent: Monday, October 06, 2014 1:08 PM
> To: linux-audit@redhat.com; linux-kernel@vger.kernel.org;
> containers@lists.linux-foundation.org
> Cc: eparis@redhat.com; pmoore@redhat.com; aviro@redhat.com; sgrubb@redhat.com;
> ebiederm@xmission.com
> Subject: [PATCH V5 01/13] namespaces: assign each namespace instance a serial
> number
> 
> Generate and assign a serial number per namespace instance since boot.
> 
> Use a serial number per namespace (unique across one boot of one kernel)
> instead of the inode number (which is claimed to have had the right to change
> reserved and is not necessarily unique if there is more than one proc fs) to
> uniquely identify it per kernel boot.
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  fs/mount.h                     |    1 +
>  fs/namespace.c                 |    1 +
>  include/linux/ipc_namespace.h  |    1 +
>  include/linux/nsproxy.h        |   10 ++++++++++
>  include/linux/pid_namespace.h  |    1 +
>  include/linux/user_namespace.h |    1 +
>  include/linux/utsname.h        |    1 +
>  include/net/net_namespace.h    |    1 +
>  init/version.c                 |    1 +
>  ipc/msgutil.c                  |    1 +
>  ipc/namespace.c                |    2 ++
>  kernel/nsproxy.c               |   18 ++++++++++++++++++
>  kernel/pid.c                   |    1 +
>  kernel/pid_namespace.c         |    2 ++
>  kernel/user.c                  |    1 +
>  kernel/user_namespace.c        |    2 ++
>  kernel/utsname.c               |    2 ++
>  net/core/net_namespace.c       |    8 +++++++-
>  18 files changed, 54 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/mount.h b/fs/mount.h
> index d55297f..c076f99 100644
> --- a/fs/mount.h
> +++ b/fs/mount.h
> @@ -5,6 +5,7 @@
>  struct mnt_namespace {
>  	atomic_t		count;
>  	unsigned int		proc_inum;
> +	long long	serial_num;
>  	struct mount *	root;
>  	struct list_head	list;
>  	struct user_namespace	*user_ns;
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 182bc41..9af49ff 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -2486,6 +2486,7 @@ static struct mnt_namespace *alloc_mnt_ns(struct
> user_namespace *user_ns)
>  		kfree(new_ns);
>  		return ERR_PTR(ret);
>  	}
> +	new_ns->serial_num = ns_serial();
>  	new_ns->seq = atomic64_add_return(1, &mnt_ns_seq);
>  	atomic_set(&new_ns->count, 1);
>  	new_ns->root = NULL;
> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
> index 35e7eca..8ccfb2d 100644
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -69,6 +69,7 @@ struct ipc_namespace {
>  	struct user_namespace *user_ns;
> 
>  	unsigned int	proc_inum;
> +	long long	serial_num;
>  };
> 
>  extern struct ipc_namespace init_ipc_ns;
> diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
> index b4ec59d..9d627b5 100644
> --- a/include/linux/nsproxy.h
> +++ b/include/linux/nsproxy.h
> @@ -66,6 +66,16 @@ static inline struct nsproxy *task_nsproxy(struct task_struct
> *tsk)
>  	return rcu_dereference(tsk->nsproxy);
>  }
> 
> +long long ns_serial(void);
> +enum {
> +	NS_IPC_INIT_SN	= 1,
> +	NS_UTS_INIT_SN	= 2,
> +	NS_USER_INIT_SN	= 3,
> +	NS_PID_INIT_SN	= 4,
> +	__NS_MAX_INIT_SN= 5,

You may need a space before '='.

The rest looks good to me.

Thanks,

- Chen
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
