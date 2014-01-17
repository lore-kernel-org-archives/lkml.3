Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaAQBgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:36:35 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6791 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751194AbaAQBgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:36:32 -0500
X-IronPort-AV: E=Sophos;i="4.95,670,1384272000"; 
   d="scan'208";a="9425954"
Message-ID: <52D8894D.2000007@cn.fujitsu.com>
Date: Fri, 17 Jan 2014 09:37:17 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: eparis@redhat.com, rgb@redhat.com, containers@lists.linux-foundation.org,
        serge.hallyn@ubuntu.com, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, ebiederm@xmission.com, sgrubb@redhat.com
Subject: Re: [PATCH audit-next 2/2] Audit: make audit netlink socket net namespace
 unaware
References: <1389258691-2680-1-git-send-email-gaofeng@cn.fujitsu.com> <1389258691-2680-2-git-send-email-gaofeng@cn.fujitsu.com> <20140116222933.GA22731@mail.hallyn.com>
In-Reply-To: <20140116222933.GA22731@mail.hallyn.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/17 09:35:05,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/01/17 09:35:15,
	Serialize complete at 2014/01/17 09:35:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 06:29 AM, Serge E. Hallyn wrote:
> Quoting Gao feng (gaofeng@cn.fujitsu.com):
>> Add a compare function which always return true for
>> audit netlink socket, this will cause audit netlink
>> sockets netns unaware, and no matter which netns the
>> user space audit netlink sockets belong to, they all
>> can find out and communicate with audit_sock.
>>
>> This gets rid of the necessary to create per-netns
>> audit kernel side socket(audit_sock), it's pain to
>> depend on and get reference of netns for auditns.
>>
>> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> 
> So whereas before you could prevent a task from spamming
> audit by putting it into a private netns, now you have to
> do it using a user namespace (to prevent capable(CAP_AUDIT_WRITE))
> right?
> 

Yes, the commit 1a938bec0090dc49abdb471e978e0d8155186845
"listen in all network namespaces" in audit-next already
did this change. this patch is another way to allow task
to generate audit msg in un-init netns. This is one of
the purpose of auditns. And this capable check has already
done in audit_netlink_ok.

> I don't know that anyone is depending on that, in any case, but
> it's a change.
> 

I think this change should be transparent to the userspace tools.
Since I don't know why a task should depend on audit is unavailable.

Or I misunderstand your question?

> Is this building up to something?
> 

Just allow task in un-init netns to communicate with kernel.

Thanks!
Gao

>> ---
>>  kernel/audit.c | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/kernel/audit.c b/kernel/audit.c
>> index b62153a..2ac6212 100644
>> --- a/kernel/audit.c
>> +++ b/kernel/audit.c
>> @@ -1064,12 +1064,18 @@ static void audit_receive(struct sk_buff  *skb)
>>  	mutex_unlock(&audit_cmd_mutex);
>>  }
>>  
>> +static bool audit_compare(struct net *net, struct sock *sk)
>> +{
>> +	return true;
>> +}
>> +
>>  /* Initialize audit support at boot time. */
>>  static int __init audit_init(void)
>>  {
>>  	int i;
>>  	struct netlink_kernel_cfg cfg = {
>>  		.input	= audit_receive,
>> +		.compare = audit_compare,
>>  	};
>>  
>>  	if (audit_initialized == AUDIT_DISABLED)
>> -- 
>> 1.8.4.2
>>
>> _______________________________________________
>> Containers mailing list
>> Containers@lists.linux-foundation.org
>> https://lists.linuxfoundation.org/mailman/listinfo/containers
> 

