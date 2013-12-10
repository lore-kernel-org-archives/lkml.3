Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab3LJFde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 00:33:34 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:13542 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750808Ab3LJFd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 00:33:28 -0500
X-IronPort-AV: E=Sophos;i="4.93,863,1378828800"; 
   d="scan'208";a="9227654"
Message-ID: <52A6A7E7.1080205@cn.fujitsu.com>
Date: Tue, 10 Dec 2013 13:34:31 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Serge Hallyn <serge.hallyn@ubuntu.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>, toshi.okajima@jp.fujitsu.com,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        eparis@redhat.com, linux-audit@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com
Subject: Re: [PATCH 18/20] audit: add new message type AUDIT_CREATE_NS
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com> <1382599925-25143-19-git-send-email-gaofeng@cn.fujitsu.com> <20131206221014.GC22445@mail.hallyn.com> <52A52400.7060008@cn.fujitsu.com> <20131209175343.GA6849@sergelap>
In-Reply-To: <20131209175343.GA6849@sergelap>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/10 13:33:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/10 13:33:09,
	Serialize complete at 2013/12/10 13:33:09
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 01:53 AM, Serge Hallyn wrote:
> Quoting Gao feng (gaofeng@cn.fujitsu.com):
>> On 12/07/2013 06:10 AM, Serge E. Hallyn wrote:
>>> Quoting Gao feng (gaofeng@cn.fujitsu.com):
>>>> Since there is no more place for flags of clone system call.
>>>> we need to find a way to create audit namespace.
>>>>
>>>> this patch add a new type of message AUDIT_CREATE_NS.
>>>> user space can create new audit namespace through
>>>> netlink.
>>>>
>>>> Right now, The privileged user in user namespace is allowed
>>>> to create audit namespace. it means the unprivileged user can
>>>> create an user namespace and then create audit namespace.
>>>>
>>>> Looks like it is not safe, but even the unprivileged user can
>>>> create audit namespace, it can do no harm to the host. un-init
>>>> audit namespace cann't effect the host.
>>>>
>>>> In the follow patches, the audit_backlog_limit will be per
>>>> audit namesapace, but only the privileged user has rights to
>>>> modify it. and the default value of audit_backlog_limit for
>>>> uninit audit namespace will be set to 0.
>>>>
>>>> And the audit_rate_limit will be limited too.
>>>>
>>>> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
>>>> ---
>>>>  include/linux/audit_namespace.h |  7 +++++++
>>>>  include/uapi/linux/audit.h      |  1 +
>>>>  kernel/audit.c                  | 22 ++++++++++++++++++++++
>>>>  kernel/audit_namespace.c        | 29 +++++++++++++++++++++++++++++
>>>>  4 files changed, 59 insertions(+)
>>>>
>>>> diff --git a/include/linux/audit_namespace.h b/include/linux/audit_namespace.h
>>>> index 79a9b78..b17f052 100644
>>>> --- a/include/linux/audit_namespace.h
>>>> +++ b/include/linux/audit_namespace.h
>>>> @@ -54,6 +54,8 @@ void put_audit_ns(struct audit_namespace *ns)
>>>>  		rcu_read_unlock();
>>>>  	}
>>>>  }
>>>> +
>>>> +extern int unshare_audit_namespace(void);
>>>>  #else
>>>>  static inline
>>>>  struct audit_namespace *get_audit_ns(struct audit_namespace *ns)
>>>> @@ -66,6 +68,11 @@ void put_audit_ns(struct audit_namespace *ns)
>>>>  {
>>>>  
>>>>  }
>>>> +
>>>> +static inline int unshare_audit_namespace()
>>>> +{
>>>> +	return -EINVAL;
>>>> +}
>>>>  #endif
>>>>  
>>>>  static inline struct
>>>> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
>>>> index 75cef3f..877d509 100644
>>>> --- a/include/uapi/linux/audit.h
>>>> +++ b/include/uapi/linux/audit.h
>>>> @@ -68,6 +68,7 @@
>>>>  #define AUDIT_MAKE_EQUIV	1015	/* Append to watched tree */
>>>>  #define AUDIT_TTY_GET		1016	/* Get TTY auditing status */
>>>>  #define AUDIT_TTY_SET		1017	/* Set TTY auditing status */
>>>> +#define AUDIT_CREATE_NS		1018	/* Create new audit namespace */
>>>>  
>>>>  #define AUDIT_FIRST_USER_MSG	1100	/* Userspace messages mostly uninteresting to kernel */
>>>>  #define AUDIT_USER_AVC		1107	/* We filter this differently */
>>>> diff --git a/kernel/audit.c b/kernel/audit.c
>>>> index c4d4291..86212d3 100644
>>>> --- a/kernel/audit.c
>>>> +++ b/kernel/audit.c
>>>> @@ -596,6 +596,12 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
>>>>  		    !capable(CAP_AUDIT_CONTROL))
>>>>  			err = -EPERM;
>>>>  		break;
>>>> +	case AUDIT_CREATE_NS:
>>>> +		/* Allow privileged user in user namespace to
>>>> +		 * create audit namespace */
>>>> +		if (!ns_capable(current_user_ns(), CAP_AUDIT_CONTROL))
>>>> +			err = -EPERM;
>>>> +		break;
>>>>  	case AUDIT_USER:
>>>>  	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
>>>>  	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
>>>> @@ -735,6 +741,22 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>>>>  		if (status_get->mask & AUDIT_STATUS_BACKLOG_LIMIT)
>>>>  			err = audit_set_backlog_limit(status_get->backlog_limit);
>>>>  		break;
>>>> +	case AUDIT_CREATE_NS:
>>>> +		err = unshare_audit_namespace();
>>>> +
>>>> +		if (audit_enabled == AUDIT_OFF)
>>>> +			break;
>>>> +
>>>> +		ab = audit_log_start_ns(ns, NULL, GFP_KERNEL, AUDIT_CREATE_NS);
>>>> +		if (ab) {
>>>> +			audit_log_format(ab, "Create audit namespace");
>>>> +			audit_log_session_info(ab);
>>>> +			audit_log_task_context(ab);
>>>> +			audit_log_format(ab, "res=%d", err ? 0 : 1);
>>>> +			audit_log_end_ns(ns, ab);
>>>> +		}
>>>> +
>>>> +		break;
>>>>  	case AUDIT_USER:
>>>>  	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
>>>>  	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
>>>> diff --git a/kernel/audit_namespace.c b/kernel/audit_namespace.c
>>>> index 6d9cb8f..28c608e 100644
>>>> --- a/kernel/audit_namespace.c
>>>> +++ b/kernel/audit_namespace.c
>>>> @@ -6,3 +6,32 @@ struct audit_namespace init_audit_ns = {
>>>>  	.user_ns = &init_user_ns,
>>>>  };
>>>>  EXPORT_SYMBOL_GPL(init_audit_ns);
>>>> +
>>>> +int unshare_audit_namespace(void)
>>>> +{
>>>> +	struct task_struct *tsk = current;
>>>> +	struct audit_namespace *new_audit = NULL;
>>>> +	struct nsproxy *new_nsp;
>>>> +
>>>> +	new_audit = kzalloc(sizeof(struct audit_namespace), GFP_KERNEL);
>>>> +	if (!new_audit)
>>>> +		return -ENOMEM;
>>>> +
>>>> +	skb_queue_head_init(&new_audit->queue);
>>>> +	skb_queue_head_init(&new_audit->hold_queue);
>>>> +	init_waitqueue_head(&new_audit->kauditd_wait);
>>>> +	init_waitqueue_head(&new_audit->backlog_wait);
>>>> +
>>>> +	new_nsp = create_new_namespaces(0, tsk, NULL, NULL);
>>>> +	if (IS_ERR(new_nsp)) {
>>>> +		kfree(new_audit);
>>>> +		return PTR_ERR(new_nsp);
>>>> +	}
>>>> +
>>>> +	new_audit->user_ns = get_user_ns(current_user_ns());
>>>> +	new_nsp->audit_ns = get_audit_ns(new_audit);
>>>> +
>>>> +	switch_task_namespaces(current, new_nsp);
>>>
>>> Do you need to drop the old audit->ns refcount?
>>>
>>
>> task doesn't hold namespace's refcount directly. it hold ns's refcount
> 
> No but when you create the new_nsp with create_new_namespaces(),
> that new_nsp bumps the refcount on the init_audit_ns.  Then you
> point new_nsp to a new audit_ns, but you never drop the refcount
> on init_audit_ns.
> 

Yes, I got it.
Thanks for your explantion, will fix this problem in next version.

Thanks!
