Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaLHWtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 17:49:20 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:64172 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405AbaLHWtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 17:49:16 -0500
MIME-Version: 1.0
In-Reply-To: <87ppbtn4mv.fsf@x220.int.ebiederm.org>
References: <52e0643bd47b1e5c65921d6e00aea1f724bb510a.1417281801.git.luto@amacapital.net>
 <87h9xez20g.fsf@x220.int.ebiederm.org> <CALCETrXOz4C7Tu8mggBtR=k47ZmkuAhinVUxWJSFyS1Ep0HvRw@mail.gmail.com>
 <87mw75ygwp.fsf@x220.int.ebiederm.org> <CALCETrVfO4sBdZcQiZXsofPZMj7pqKeVbX+4g3dAj6WjUca+1w@mail.gmail.com>
 <87fvcxyf28.fsf_-_@x220.int.ebiederm.org> <874mtdyexp.fsf_-_@x220.int.ebiederm.org>
 <CALCETrXyC7XPaqj6oe-TmyypOVc_CkZbF6UAAx8YfkyD=gEMOQ@mail.gmail.com>
 <87a935u3nj.fsf@x220.int.ebiederm.org> <CALCETrXkEOiyzpvqtXtk1f4sL+M1Q-Y6rV=K91ez3yv2nb4Y0Q@mail.gmail.com>
 <87388xodlj.fsf@x220.int.ebiederm.org> <CALCETrXWx2-ZejEHmOi7aSoF-qJMRGR5yseeMhuurZwJRrQbUg@mail.gmail.com>
 <87h9x5re41.fsf_-_@x220.int.ebiederm.org> <87mw6xpzb0.fsf_-_@x220.int.ebiederm.org>
 <CALCETrU-o5mPr1jCaLXDuuF6J2N470zAtx=8Fa-SjF=ZpdE8mQ@mail.gmail.com> <87ppbtn4mv.fsf@x220.int.ebiederm.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 8 Dec 2014 14:48:54 -0800
Message-ID: <CALCETrXSScp77BUJR5NSTh5-RnEZ9rqELSGJBeEzgdQ-OtohuQ@mail.gmail.com>
Subject: Re: [CFT][PATCH 6/7] userns: Add a knob to disable setgroups on a per
 user namespace basis
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>,
        linux-man <linux-man@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        LSM <linux-security-module@vger.kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Richard Weinberger <richard@nod.at>,
        Kenton Varda <kenton@sandstorm.io>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 2:44 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>
>> On Mon, Dec 8, 2014 at 2:11 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
>>>
>>> - Expose the knob to user space through a proc file /proc/<pid>/setgroups
>>>
>>>   A value of 0 means the setgroups system call is disabled in the
>>
>> "deny"
>>
>>>   current processes user namespace and can not be enabled in the
>>>   future in this user namespace.
>>>
>>>   A value of 1 means the segtoups system call is enabled.
>>>
>>
>> "allow"
>>
>>> - Descedent user namespaces inherit the value of setgroups from
>>
>> s/Descedent/Descendent/
>
> Bah.  I updated everything but the changelog comment.
>
>>> --- a/kernel/groups.c
>>> +++ b/kernel/groups.c
>>> @@ -222,6 +222,7 @@ bool may_setgroups(void)
>>>          * the user namespace has been established.
>>>          */
>>>         return userns_gid_mappings_established(user_ns) &&
>>> +               userns_setgroups_allowed(user_ns) &&
>>>                 ns_capable(user_ns, CAP_SETGID);
>>>  }
>>
>> Can you add a comment explaining the ordering?  For example:
>
> I need to think on what I can say to make it clear.
> Perhaps: /* Careful the order of these checks is important. */
>
>> We need to check for a gid mapping before checking setgroups_allowed
>> because an unprivileged user can create a userns with setgroups
>> allowed, then disallow setgroups and add a mapping.  If we check in
>> the opposite order, then we have a race: we could see that setgroups
>> is allowed before the user clears the bit and then see that there is a
>> gid mapping after the other thread is done.
>

This text was actually my suggested comment text.

If you put smp_rmb() in this function with a comment like that, then I
think it will all make sense and be obviously correct (even with most
of the other barriers removed).

--Andy

> Since these are independent atomic variables yes that ordering issue
> seems to be the case.
>
> For me it was the natural ordering of the checks so I didn't even bother
> to think about what happens when you reorder them.
>
> Eric



-- 
Andy Lutomirski
AMA Capital Management, LLC
