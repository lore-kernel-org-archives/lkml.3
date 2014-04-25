Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaDYDvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 23:51:07 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58337 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaDYDvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 23:51:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Aditya Kali <adityakali@google.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, james.l.morris@oracle.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Swiecki <swiecki@google.com>
References: <CAGr1F2H+iFi4ZBZXK4nQGomRtpP3f-1sfcMHMMu8GVYjtpXPOQ@mail.gmail.com>
	<87a9bciev9.fsf@x220.int.ebiederm.org>
	<CAGr1F2G=f+nZ8qc9rxXoG_Wc52XxwdKi26B8JJjgntTmS-3ifQ@mail.gmail.com>
Date: Thu, 24 Apr 2014 20:50:24 -0700
In-Reply-To: <CAGr1F2G=f+nZ8qc9rxXoG_Wc52XxwdKi26B8JJjgntTmS-3ifQ@mail.gmail.com>
	(Aditya Kali's message of "Wed, 23 Apr 2014 18:50:40 -0700")
Message-ID: <87eh0m83un.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18ks1KuVYfstIGkKHKHsuOLaUEwry2kbsM=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Aditya Kali <adityakali@google.com>
X-Spam-Relay-Country: 
Subject: Re: dropping capabilities in user namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aditya Kali <adityakali@google.com> writes:

> On Wed, Apr 23, 2014 at 2:17 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Aditya Kali <adityakali@google.com> writes:
>>
>>> Hi all,
>>>
>>> I am trying to understand the behavior of how we can drop capabilities
>>> inside user namespace. i.e., I want to start a process inside user
>>> namespace with its effective and permitted capability sets cleared.
>>
>> Please note to start with that at the point you are in a user namespace
>> all of your capabilities are relative to that user namespace.
>>
>> Now I have not had any problem dropping capabilities in a user namespace
>> so you are doing something weird.  Let me see if I can see what that
>> weird thing is.
>>
>>> A typical way in which a root (uid=0) process can drop its privileges is:
>>>
>>> prctl(PR_SET_KEEPCAPS, 0, 0, 0, 0);
>>
>> You clear this bit in securebits that should already be clear anyay.
>>
>>> setresuid(uid, uid, uid);  // At this point, permitted and effective
>>> capabilities are cleared
>>> exec()
>>>
>>> But this sequence of operation inside a user namespace does not work
>>> as expected:
>>
>>
>> As I look at this it seems to work as designed.  By not starting with
>> uid 0 you are triggered the non-zero uid with caps section of the code
>> that has always behaved differently.
>>
>>> Assume /proc/pid/uid_map has entry: uid uid 1
>>>
>>> attach_user_ns(pid);  // OR create_user_ns() & write_uid_map()
>>> prctl(PR_SET_KEEPCAPS, 0, 0, 0, 0);
>>> setresuid(uid, uid, uid);  // Fails to reset capabilities
>>> exec()
>>>
>>> The exec()ed process starts with correct uid set, but still with all
>>> the capabilities.
>>>
>>> The differentiating factor here seems to be the 'root_uid' value in
>>> security/commoncap.c:cap_emulate_setxuid():
>>>
>>> static inline void cap_emulate_setxuid(struct cred *new, const struct cred *old)
>>> {
>>>   kuid_t root_uid = make_kuid(old->user_ns, 0);
>>>
>>>   if ((uid_eq(old->uid, root_uid) ||
>>>       uid_eq(old->euid, root_uid) ||
>>>       uid_eq(old->suid, root_uid)) &&
>>>      (!uid_eq(new->uid, root_uid) &&
>>>       !uid_eq(new->euid, root_uid) &&
>>>       !uid_eq(new->suid, root_uid)) &&
>>>      !issecure(SECURE_KEEP_CAPS)) {
>>>     cap_clear(new->cap_permitted);
>>>     cap_clear(new->cap_effective);
>>>   }
>>>   ...
>>>
>>> There are couple of problems here:
>>> (1) In above example when there is no mapping for uid 0 inside
>>> old->user_ns, make_kuid() returns INVALID_UID. Since we go on to
>>> compare root_uid without first checking if its even valid, we never
>>> satisfy the 'if' condition and never clear the caps. This looks like a
>>> bug.
>>
>> INVALID_UID will never be in a capability set, so the comparison is
>> guaranteed against root_uid is guaranteed to fail if there is not a root
>> uid.  That is correct.
>>
>
> So this does seem like a regression in userns w.r.t.
> global/init-user-ns. (See below for correct example when the behavior
> is different).

It is outside of the conditions that can exist without user namespaces
so it can not possibly be a regression.

It may be a violation of expectations, but I am not certain it is wrong.

Most of the way capabilities work when you don't trigger their backwards
compatible behavior violates expectations.

>>> (2) Even if there is some mapping for uid 0 inside old->user_ns (say
>>> "0 1111 1"), since old->uid = 0, and root_uid=1111 (or some non-zero
>>> uid), the 'if' condition again remains unsatisfied.
>>
>> Correct.  Because this code is not supposed to do something if you have
>> caps and your uid is not zero.
>>
>>> It looks like currently the only case where global root (uid=0)
>>> process can drop its capabilities inside a user namespace is by having
>>> "0 0 <length>" mapping in the uid_map file. It seems wrong to expose
>>> global root in user namespace just to drop privileges!
>>
>> Where does global root come into this?  Nothing above is global root
>> specific?  Or do you just mean you are starting all of this as the
>> global root user?
>>
>
> I am starting my program as global root user, yes. The program
> attaches to given user namespaces, sets uid to given uid and does some
> work (which it expects to do as user <uid> without any capabilities).
>
> I made a mistake in my example above. If I exec() at the end, the
> capabilities do get cleared as you suggest. The problematic case is:
>
> attach_to_userns(pid)
> prctl(PR_SET_KEEPCAPS, 0, 0, 0, 0);
> setresuid(uid, uid, uid);  // Fails to reset capabilities
> pause() / sleep(...) / do_some_work_as_uid()  [[ no exec, sorry ]]
>
> And I was looking at the Cap* fields in /proc/<process-pid>/status
> from another terminal. I noticed that the capabilities were not reset
> after the setresuid() call. This behavior is different as compared to
> what happens in init_user_ns.

Yes this behavior is different as compared to what happens without user
namespaces involved, and I grant it is a bit surprising.

>>>  So I feel we
>>> need to fix the condition checks everywhere we are using make_kuid()
>>> in security/commoncap.c.
>>> Can the security experts please advice how this is supposed to work?
>>
>> If you don't want to set your uid to 0 inside a user namespace before
>> setting your uid to something else.  You need to call capset, because
>> you are in bizarro land with respect to capabilities.
>>
>> If you don't want things to work like normal, and you want to skip
>> setting your uid to 0 before calling setrexuid(2) you need to call
>> capset(2).
>>
>
> I cannot call setuid(0) before setting the uid to something else there
> is no uid 0 inside userns as per the uid_map. I will try the capset()
> approach, but I hope we could fix the above case too.

>From what I can see of the giant comment above cap_emulate_setxuid the
current behavior was deliberately arranged.

Furthermore the only way I can see to change this behavior is to special
case the root_uid in the parent namespace, and I really don't think we
want that.  In the first case it would not solve the problem if you
called setns from a non-root user, which means that the problem doesn't
actually go away.  In the second case solving this for the case you care
about really involves adding some special case logic only for the case
you care about.  Introducing complex code that will bitrot on a security
path seems like a bad idea.

The way you are running your user namespace actually sounds like you are
in the case SECURE_NO_SETUID_FIXUP was designed for.   Which makes this
request very weird.

Having setreuid clear the user namespace local capabilities seems to be
the wrong thing in this case.  Having the local capabilities is not
dangerous outside of your user namespace, and not clearing capabilities
when changing from one uid to another when the starting uid is not
locally 0 is long standing behavior that was designed to be there.
Furthermore I can't see a way to avoid it without a complex set of
conditionals that will just bitrot.

So short of a persuasive argument to the contrary it looks like you just
need to use setcap.

Eric
