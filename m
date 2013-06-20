Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935612Ab3FTDAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 23:00:41 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36971 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S935506Ab3FTDAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 23:00:40 -0400
X-IronPort-AV: E=Sophos;i="4.87,901,1363104000"; 
   d="scan'208";a="7609965"
Message-ID: <51C270AF.1080902@cn.fujitsu.com>
Date: Thu, 20 Jun 2013 11:02:07 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: Aristeu Rozanski <aris@redhat.com>, containers@lists.linux-foundation.org,
        linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        serge.hallyn@ubuntu.com, ebiederm@xmission.com,
        matthltc@linux.vnet.ibm.com, sgrubb@redhat.com
Subject: Re: [Part1 PATCH 00/22] Add namespace support for audit
References: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>  <20130619204927.GJ3212@redhat.com> <1371675095.16587.5.camel@dhcp137-13.rdu.redhat.com>
In-Reply-To: <1371675095.16587.5.camel@dhcp137-13.rdu.redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/20 10:59:27,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/20 10:59:31,
	Serialize complete at 2013/06/20 10:59:31
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2013 04:51 AM, Eric Paris wrote:
> On Wed, 2013-06-19 at 16:49 -0400, Aristeu Rozanski wrote:
>> On Wed, Jun 19, 2013 at 09:53:32AM +0800, Gao feng wrote:
>>> This patchset is first part of namespace support for audit.
>>> in this patchset, the mainly resources of audit system have
>>> been isolated. the audit filter, rules havn't been isolated
>>> now. It will be implemented in Part2. We finished the isolation
>>> of user audit message in this patchset.
>>>
>>> I choose to assign audit to the user namespace.
>>> Right now,there are six kinds of namespaces, such as
>>> net, mount, ipc, pid, uts and user. the first five
>>> namespaces have special usage. the audit isn't suitable to
>>> belong to these five namespaces, And since the flag of system
>>> call clone is in short supply, we can't provide a new flag such
>>> as CLONE_NEWAUDIT to enable audit namespace separately. so the
>>> user namespace may be the best choice.
>>
>> I thought it was said on the last submission that to tie userns and
>> audit namespace would be a bad idea?
> 
> I consider it a non-starter.  unpriv users are allowed to launch their
> own user namespace.  The whole point of audit is to have only a priv
> user be allowed to make changes.  If you tied audit namespace to user
> namespace you grant an unpriv user the ability to modify audit.
> 

I understand your views.

But ven the unpriv user are allowed to make changes, they can do no harm.
they can only make changes on the audit namespace they created.they can
only communicate with the audit namespace they created.

Before we have mount namespace, only priv user can change the mount
information, And with mount namespace & user namespace, the unpriv
user can create their own user namespace,and then create they own
mount namespace. so the unpriv user have the ability to change their
own mount namespace, since they become the priv user in their user
namespace.

The only difference to the mount namespace is that,audit namespace
is created automatically when creating user namespace,So the unpriv
users even have no chance to change the init audit namespace. the
unpriv users can't make changes on the init audit namespace.

In this patchset, I already do some check to make sure only the priv
user in init user namespace can change the rate_limit,audit_failure,
backlog_limit. I think we can absolutely make the unpriv users
can't do some bad influence on the whole system.

If we don't tie audit to user namespace, there is still one problem.
how audit netlink works? In this patchset, I use sock_net(sk)->user_ns
to decide if two audit netlink sockets can communicate with each other.
if we don't tie audit to user namespace, we have to add one field such
as 'auditns' in socket and use sk1->auditns == sk2->auditns to decide
if two audit netlink sockets belong to same audit namespace. I think
this is a little of overhead and ugly.

> NAK.
> 
> If there are not clone flags you will either need to only do this from
> unshare and not from clone, or get more flags to clone
> 

If you still think it's unsafe or unreasonable for unpriv users to create
audit namespace, I think we can only allow priv user to create audit ns
when they creating user namespace. If unpriv users create new user namespace,
we can simply don't create new audit namespace for them.

I can't find out a better solution...

Thanks,
Gao
