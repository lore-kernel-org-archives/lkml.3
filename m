Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3LXJwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 04:52:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:29049 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751659Ab3LXJwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 04:52:23 -0500
X-IronPort-AV: E=Sophos;i="4.95,542,1384272000"; 
   d="scan'208";a="9317925"
Message-ID: <52B9598F.2070203@cn.fujitsu.com>
Date: Tue, 24 Dec 2013 17:53:19 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Richard Guy Briggs <rgb@redhat.com>
CC: "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org, serge.hallyn@ubuntu.com,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        ebiederm@xmission.com
Subject: Re: [RFC Part1 PATCH 00/20 v2] Add namespace support for audit
References: <1382599925-25143-1-git-send-email-gaofeng@cn.fujitsu.com> <20131206213135.GA22445@mail.hallyn.com> <52A52AFB.2020703@cn.fujitsu.com> <20131223234723.GA23101@madcap2.tricolour.ca>
In-Reply-To: <20131223234723.GA23101@madcap2.tricolour.ca>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/24 17:51:42,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/24 17:51:43,
	Serialize complete at 2013/12/24 17:51:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/24/2013 07:47 AM, Richard Guy Briggs wrote:
> On 13/12/09, Gao feng wrote:
>> On 12/07/2013 05:31 AM, Serge E. Hallyn wrote:
>>> Quoting Gao feng (gaofeng@cn.fujitsu.com):
> 
>>>> The main target of this patchset is allowing user in audit
>>>> namespace to generate the USER_MSG type of audit message,
>>>> some userspace tools need to generate audit message, or
>>>> these tools will broken.
>>>>
>>>> And the login process in container may want to setup
>>>> /proc/<pid>/loginuid, right now this value is unalterable
>>>> once it being set. this will also broke the login problem
>>>> in container. After this patchset, we can reset this loginuid
>>>> to zero if task is running in a new audit namespace.
>>>>
>>>> Same with v1 patchset, in this patchset, only the privileged
>>>> user in init_audit_ns and init_user_ns has rights to
>>>> add/del audit rules. and these rules are gloabl. all
>>>> audit namespace will comply with the rules.
>>>>
>>>> Compared with v1, v2 patch has some big changes.
>>>> 1, the audit namespace is not assigned to user namespace.
>>>>    since there is no available bit of flags for clone, we
>>>>    create audit namespace through netlink, patch[18/20]
>>>>    introduces a new audit netlink type AUDIT_CREATE_NS.
>>>>    the privileged user in userns has rights to create a
>>>>    audit namespace, it means the unprivileged user can
>>>>    create auditns through create userns first. In order
>>>>    to prevent them from doing harm to host, the default
>>>>    audit_backlog_limit of un-init-audit-ns is zero(means
>>>>    audit is unavailable in audit namespace). and it can't
>>>>    be changed in auditns through netlink.
>>>
>>> So the unprivileged user can create an audit-ns, but can't
>>> then actually send any messages there?  I guess setting it
>>> to something small would just be hacky?
>>
>> Yes, if unprivileged user wants to send audit message, he should
>> ask privileged user to setup the audit_backlog_limit for him.
>>
>> I know it's a little of hack, but I don't have good idea :(
> 
> There's a recent patch that actually clarifies the way
> audit_backlog_limit works, since different parts of the code seemed to
> think different things.  It now means unlimited, since there are other
> places to shut off logging.
> 	audit: allow unlimited backlog queue

Yep, thanks for your information, we can set a negative number to backlog_limit
to mark there is no available buff for this audit ns.

> 
> At first, I'd say each audit_ns should be able to set its own
> audit_backlog_limit.  The most obvious argument against this would be
> the vulnerability of a DoS. 

There are two problem we should conside, auditns costs lot's of memory by
setting large backlog_limit and costs lot's of cpu resources by generating
audit log all the time. So I think the privileged user should have the ability
to limit the backlog len.

And I think it's not very necessary to keep on allowing auditns to set its own
audit_backlog_limit. if you think this is necessary, we can add a field max_backlog_limit
for per audit namespace. and set this value when we create auditns.

And seem like the audit_rate_limit should not be change by unprivileged user.

I don't know if I really follow your request...

> Could there be some automatic metrics to
> set sub audit_ns backlog limits, such as default to the same as
> init_audit_ns and have the init_audit_ns override those defaults?
> Could this be done per user like ulimiit?
> 

I think something like ulimit cannot help us.
we should set sub-auditns's backlog_limit in parent auditns..
so maybe the proc file is the best way.
