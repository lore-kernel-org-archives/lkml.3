Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409Ab3GDD2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:28:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:30734 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755247Ab3GDD2u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:28:50 -0400
X-IronPort-AV: E=Sophos;i="4.87,992,1363104000"; 
   d="scan'208";a="7778565"
Message-ID: <51D4EC4B.80708@cn.fujitsu.com>
Date: Thu, 04 Jul 2013 11:30:19 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Eric Paris <eparis@redhat.com>
CC: containers@lists.linux-foundation.org, serge.hallyn@ubuntu.com,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        ebiederm@xmission.com, matthltc@linux.vnet.ibm.com,
        Aristeu Rozanski <aris@redhat.com>
Subject: Re: [Part1 PATCH 00/22] Add namespace support for audit
References: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com> <20130619204927.GJ3212@redhat.com> <1371675095.16587.5.camel@dhcp137-13.rdu.redhat.com> <51C270AF.1080902@cn.fujitsu.com> <1371733353.16587.19.camel@dhcp137-13.rdu.redhat.com> <51C3CCFB.4030901@cn.fujitsu.com>
In-Reply-To: <51C3CCFB.4030901@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/04 11:27:18,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/04 11:27:19,
	Serialize complete at 2013/07/04 11:27:19
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 11:48 AM, Gao feng wrote:
> On 06/20/2013 09:02 PM, Eric Paris wrote:
>> On Thu, 2013-06-20 at 11:02 +0800, Gao feng wrote:
>>> On 06/20/2013 04:51 AM, Eric Paris wrote:
>>>> On Wed, 2013-06-19 at 16:49 -0400, Aristeu Rozanski wrote:
>>>>> On Wed, Jun 19, 2013 at 09:53:32AM +0800, Gao feng wrote:
>>>>>> This patchset is first part of namespace support for audit.
>>>>>> in this patchset, the mainly resources of audit system have
>>>>>> been isolated. the audit filter, rules havn't been isolated
>>>>>> now. It will be implemented in Part2. We finished the isolation
>>>>>> of user audit message in this patchset.
>>>>>>
>>>>>> I choose to assign audit to the user namespace.
>>>>>> Right now,there are six kinds of namespaces, such as
>>>>>> net, mount, ipc, pid, uts and user. the first five
>>>>>> namespaces have special usage. the audit isn't suitable to
>>>>>> belong to these five namespaces, And since the flag of system
>>>>>> call clone is in short supply, we can't provide a new flag such
>>>>>> as CLONE_NEWAUDIT to enable audit namespace separately. so the
>>>>>> user namespace may be the best choice.
>>>>>
>>>>> I thought it was said on the last submission that to tie userns and
>>>>> audit namespace would be a bad idea?
>>>>
>>>> I consider it a non-starter.  unpriv users are allowed to launch their
>>>> own user namespace.  The whole point of audit is to have only a priv
>>>> user be allowed to make changes.  If you tied audit namespace to user
>>>> namespace you grant an unpriv user the ability to modify audit.
>>>>
>>>
>>> I understand your views.
>>>
>>> But ven the unpriv user are allowed to make changes, they can do no harm.
>>> they can only make changes on the audit namespace they created.they can
>>> only communicate with the audit namespace they created.
>>
>> Imagine I set up my machine to audit all user access to super secret
>> information.  With your patch set all an malicious user has to do is
>> create a new user namespace.  Now when he accesses the super secret
>> information it will be logged inside the user namespace he created.  So
>> he can just dump those logs in the trash.
>>
> 
> No, my v1 patchset only log the user audit message(which generated through
> auditctl -m "xxx") inside user namespace.
> 
> I agree with that we should not simply log audit message in the child
> audit namespace. for some global resource related audit messages, they
> should be logged in init audit namespace too.
> 
>> I believe that each audit namespace should require priv
>> (CAP_AUDIT_CONTROL) in the user namespace that created the current audit
>> namespace.  So lets say the machine boots and we are in the init_user
>> and init_audit namespace.  Creating a new audit namespace should require
>> CAP_AUDIT_CONTROL in the init_user namespace.  If instead we spawned a
>> new user namespace userns1 and try to create a new audit namespace, we
>> should STILL check for CAP_AUDIT_CONTROL in the init_user namespace.
>>
> 
> Ok, I can add this permission check in next version, though this seems a
> litter strictness when we make sure child audit namespace won't fool the
> init audit namespace,
> 
>> Assuming we've spawned auditns1 in userns1 and want to spawn auditns2 it
>> should require CAP_AUDIT_CONTROL in userns1.  So now you only have
>> permission to change your audit config (create a new audit namespace) if
>> you already had permission to change your current audit config.
>>
>> Now how to handle coding this...
>>
>> When the kernel receives an audit message on the netlink socket it can
>> always check the current->[whatever] to figure out which audit namespace
>> it came from.  Then it can be processed accordingly...
> 
> Yes, this situation is easy to handle, since we are in process context...
> but in some situations, we are not running in process context... as I
> mentioned, audit messages generated by netfilter rules. current process
> is untrustable. we can only get meaningful net namespace in this situation.
> Actually, it's meaningful to send net related audit messages to the user
> namespace which creates this net namespace.
> 
> 
>>
>> Sending messages to the userspace auditd is a little more tricky.  We
>> need to somehow map the audit namespace to a socket connected to auditd
>> in userspace.  I'd imagine we'd have to either have per auditns backlog
>> queues and run one kauditd per audit namespace, or we'd have to tag the
>> skb's with the intended namespace somehow and then find the right socket
>> in kauditd.  Either way it doesn't seem too onerous (although I admit, I
>> don't know how to code the per namespace kauditd right offhand)
>>
> 
> As I said in "[PATCH 04/22] netlink: Add compare function for netlink_table",
> netlink and socket are private resources of net namespace. socket has no
> idea which audit namespace it belongs to,unless we add a field to mark this.
> Through I think we can archive audit namespace in your way,but maybe we should
> hack into the net namespace. I don't think the network guys will like it.
> 
> There is one more thing we have to do if we don't tie audit namespace to user
> namespace. we have to implement the audit proc file(/proc/<pid>/ns/audit) and
> the clone/unshare/setns parts.
> 
> I still this my way is the simplest and can satisfy your requirement.
> 

Ping...
Eric, I need to know what's your comment..

Thanks
