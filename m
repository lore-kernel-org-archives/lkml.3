Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab3DZFsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 01:48:12 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54248 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285Ab3DZFsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 01:48:10 -0400
MIME-Version: 1.0
In-Reply-To: <87mwsmqfga.fsf@xmission.com>
References: <CAKgNAkjgmTJ1BiHVbqVtz-g-=yfewMiYaroDJELJpa1aRrFAvQ@mail.gmail.com>
	<CAFLxGvy33QyJEMu_z47oyEEMY_awpT5rkoP4DYVjBQjsZysaGA@mail.gmail.com>
	<87mwsmqfga.fsf@xmission.com>
Date: Fri, 26 Apr 2013 07:48:08 +0200
Message-ID: <CAFLxGvw-d4jZniV=KHSDVCQtJEzhZB0bJAW-VyUKdAqDJi+_nA@mail.gmail.com>
Subject: Re: For review (v2): user_namespaces(7) man page
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Rob Landley <rob@landley.net>, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vasily Kulikov <segoon@openwall.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, luto@amacapital.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 2:54 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> richard -rw- weinberger <richard.weinberger@gmail.com> writes:
>
>> On Wed, Mar 27, 2013 at 10:26 PM, Michael Kerrisk (man-pages)
>> <mtk.manpages@gmail.com> wrote:
>>>        Inside the user namespace, the shell has user and group  ID  0,
>>>        and a full set of permitted and effective capabilities:
>>>
>>>            bash$ cat /proc/$$/status | egrep '^[UG]id'
>>>            Uid: 0    0    0    0
>>>            Gid: 0    0    0    0
>>>            bash$ cat /proc/$$/status | egrep '^Cap(Prm|Inh|Eff)'
>>>            CapInh:   0000000000000000
>>>            CapPrm:   0000001fffffffff
>>>            CapEff:   0000001fffffffff
>>
>> I've tried your demo program, but inside the new ns I'm automatically nobody.
>> As Eric said, setuid(0)/setgid(0) are missing.
>
> Is it the setuid/setgid or not setting up the uid/gid map?

uid/git mapping are set up.

>> Eric, maybe you can help me. How can I drop capabilities within a user
>> namespace?
>
>> In childFunc() I did add prctl(PR_CAPBSET_DROP, CAP_NET_ADMIN) but it always
>> returns ENOPERM.
>> What that? I thought I get a completely fresh set of cap which I can modify.
>> I don't want that uid 0 inside the container has all caps.
>
> There are weird things that happen with exec and the user namespace.  If
> you have exec'd as an unmapped user all of your capabilities have
> already been droped.

I've setup the mappings. If I look into /proc/*/status I see that my process has
all caps.
So, in general it is possible to drop cap within a user namespace?
I really want to drop CAP_NET_ADMIN and some others.
root within my container must not change any networking settings.

>> And why does /proc/*/loginuid always contain 4294967295 in a new user namespace?
>> Writing to it also fails. (Noticed that because pam_loginuid.so does not work).
>
> Almost certainly because the loginuid has already been set.  Yes. It
> looks like I am simply using from_kuid instead of from_kuid_munged on
> the read.  So an unmapped loginuid will be reported as 4294967295.
>
> For some circumstances 65534 (nobody) is definitely better in some it is
> a toss up, and most of the time no one really cares.  So I have tried to
> do something but in this case I don't know which was the best policy.

Hmm, I hoped that loginuid will be reset upon entering a user namespace.

>> Final question, is it by design that uid 0 within a namespace in not
>> allowed to write to
>> /proc/*/oom_score_adj?
>
> Essentially.  It is by design that uid 0 within a namespace be mapped to
> some other uid outside the namespace, and that the permissions on writes
> should use the permission needed outside of the user namespace.

Okay, I've asked because systemd is a heavy user of this file and
fails due to this
within a user namespace.
Luckily it is possible to remove all the score changes from the .service files.

--
Thanks,
//richard
