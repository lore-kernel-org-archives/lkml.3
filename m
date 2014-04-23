Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbaDWJSV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 05:18:21 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39920 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaDWJSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 05:18:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Aditya Kali <adityakali@google.com>
Cc: serge.hallyn@canonical.com, james.l.morris@oracle.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Swiecki <swiecki@google.com>
References: <CAGr1F2H+iFi4ZBZXK4nQGomRtpP3f-1sfcMHMMu8GVYjtpXPOQ@mail.gmail.com>
Date: Wed, 23 Apr 2014 02:17:46 -0700
In-Reply-To: <CAGr1F2H+iFi4ZBZXK4nQGomRtpP3f-1sfcMHMMu8GVYjtpXPOQ@mail.gmail.com>
	(Aditya Kali's message of "Tue, 22 Apr 2014 15:52:10 -0700")
Message-ID: <87a9bciev9.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/FhZS8yqrH8CjwPSNlAbK+x0EIeSg+Bf8=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2944]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
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

> Hi all,
>
> I am trying to understand the behavior of how we can drop capabilities
> inside user namespace. i.e., I want to start a process inside user
> namespace with its effective and permitted capability sets cleared.

Please note to start with that at the point you are in a user namespace
all of your capabilities are relative to that user namespace.

Now I have not had any problem dropping capabilities in a user namespace
so you are doing something weird.  Let me see if I can see what that
weird thing is.

> A typical way in which a root (uid=0) process can drop its privileges is:
>
> prctl(PR_SET_KEEPCAPS, 0, 0, 0, 0);

You clear this bit in securebits that should already be clear anyay.

> setresuid(uid, uid, uid);  // At this point, permitted and effective
> capabilities are cleared
> exec()
>
> But this sequence of operation inside a user namespace does not work
> as expected:


As I look at this it seems to work as designed.  By not starting with
uid 0 you are triggered the non-zero uid with caps section of the code
that has always behaved differently.

> Assume /proc/pid/uid_map has entry: uid uid 1
>
> attach_user_ns(pid);  // OR create_user_ns() & write_uid_map()
> prctl(PR_SET_KEEPCAPS, 0, 0, 0, 0);
> setresuid(uid, uid, uid);  // Fails to reset capabilities
> exec()
>
> The exec()ed process starts with correct uid set, but still with all
> the capabilities.
>
> The differentiating factor here seems to be the 'root_uid' value in
> security/commoncap.c:cap_emulate_setxuid():
>
> static inline void cap_emulate_setxuid(struct cred *new, const struct cred *old)
> {
>   kuid_t root_uid = make_kuid(old->user_ns, 0);
>
>   if ((uid_eq(old->uid, root_uid) ||
>       uid_eq(old->euid, root_uid) ||
>       uid_eq(old->suid, root_uid)) &&
>      (!uid_eq(new->uid, root_uid) &&
>       !uid_eq(new->euid, root_uid) &&
>       !uid_eq(new->suid, root_uid)) &&
>      !issecure(SECURE_KEEP_CAPS)) {
>     cap_clear(new->cap_permitted);
>     cap_clear(new->cap_effective);
>   }
>   ...
>
> There are couple of problems here:
> (1) In above example when there is no mapping for uid 0 inside
> old->user_ns, make_kuid() returns INVALID_UID. Since we go on to
> compare root_uid without first checking if its even valid, we never
> satisfy the 'if' condition and never clear the caps. This looks like a
> bug.

INVALID_UID will never be in a capability set, so the comparison is
guaranteed against root_uid is guaranteed to fail if there is not a root
uid.  That is correct.

> (2) Even if there is some mapping for uid 0 inside old->user_ns (say
> "0 1111 1"), since old->uid = 0, and root_uid=1111 (or some non-zero
> uid), the 'if' condition again remains unsatisfied.

Correct.  Because this code is not supposed to do something if you have
caps and your uid is not zero.

> It looks like currently the only case where global root (uid=0)
> process can drop its capabilities inside a user namespace is by having
> "0 0 <length>" mapping in the uid_map file. It seems wrong to expose
> global root in user namespace just to drop privileges!

Where does global root come into this?  Nothing above is global root
specific?  Or do you just mean you are starting all of this as the
global root user?

>  So I feel we
> need to fix the condition checks everywhere we are using make_kuid()
> in security/commoncap.c.
> Can the security experts please advice how this is supposed to work?

If you don't want to set your uid to 0 inside a user namespace before
setting your uid to something else.  You need to call capset, because
you are in bizarro land with respect to capabilities.

If you don't want things to work like normal, and you want to skip
setting your uid to 0 before calling setrexuid(2) you need to call
capset(2).

But your scenario continues to be very weird because after exec you
should not have capabilities.

Looking at cap_bprm_set_creds()
{
	if (!issecure(SECURE_NOROOT)) {

        	...

		if (uid_eq(new->euid, root_uid))
			effective = true;
	}

        ...

	if (effective)
		new->cap_effective = new->cap_permitted;
	else
		cap_clear(new->cap_effective);

        ...
}

That very clearly clears your effective set if your uid is not 0 in the
user namespace.

I fail to see how even in the example you gave above that you would have
any effective capabilities after exec.

Eric
