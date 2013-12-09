Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256Ab3LIBqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 20:46:50 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:17876 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760148Ab3LIBqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 20:46:46 -0500
X-IronPort-AV: E=Sophos;i="4.93,854,1378828800"; 
   d="scan'208";a="9218304"
Message-ID: <52A52146.1060804@cn.fujitsu.com>
Date: Mon, 09 Dec 2013 09:47:50 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        toshi.okajima@jp.fujitsu.com, containers@lists.linux-foundation.org,
        serge.hallyn@ubuntu.com, eparis@redhat.com, ebiederm@xmission.com,
        sgrubb@redhat.com
Subject: Re: [PATCH 16/20] audit: allow GET, SET, USER MSG operations in audit
 namespace
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com> <1382599925-25143-17-git-send-email-gaofeng@cn.fujitsu.com> <20131206220033.GB22445@mail.hallyn.com>
In-Reply-To: <20131206220033.GB22445@mail.hallyn.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 09:46:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 09:46:29,
	Serialize complete at 2013/12/09 09:46:29
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2013 06:00 AM, Serge E. Hallyn wrote:
> Quoting Gao feng (gaofeng@cn.fujitsu.com):
>> 1, remove the permission check of pid namespace. it's no reason
>>    to deny un-init pid namespace to operate audit subsystem.
>>
>> 2, only allow init user namespace and init audit namespace to
>>    operate list/add/del rule, tty set, trim, make equiv operations.
>>
>> 3, allow audit namespace to get/set audit configuration, send
>>    userspace audit message.
>>
>> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
>> ---
>>  kernel/audit.c | 13 ++++++-------
>>  1 file changed, 6 insertions(+), 7 deletions(-)
>>
>> diff --git a/kernel/audit.c b/kernel/audit.c
>> index 095f54d..c4d4291 100644
>> --- a/kernel/audit.c
>> +++ b/kernel/audit.c
>> @@ -573,11 +573,7 @@ out:
>>  static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
>>  {
>>  	int err = 0;
>> -
>> -	/* Only support the initial namespaces for now. */
>> -	if ((current_user_ns() != &init_user_ns) ||
>> -	    (task_active_pid_ns(current) != &init_pid_ns))
>> -		return -EPERM;
>> +	struct audit_namespace *ns = current->nsproxy->audit_ns;
>>  
>>  	switch (msg_type) {
>>  	case AUDIT_LIST:
>> @@ -586,6 +582,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
>>  		return -EOPNOTSUPP;
>>  	case AUDIT_GET:
>>  	case AUDIT_SET:
>> +		break;
> 
> So, these AUDIT_SET and AUDIT_GET go from requiring CAP_AUDIT_CONTROL
> to not needing any privs at all?
> 

My mistake, there should be a check such as
ns_capable(ns, CAP_AUDIT_CONTROL).

will fix in next version.

Thanks!

