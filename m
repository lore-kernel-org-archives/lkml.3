Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759039Ab3DZAyt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 20:54:49 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51463 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab3DZAyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 20:54:47 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Rob Landley <rob@landley.net>, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vasily Kulikov <segoon@openwall.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, luto@amacapital.net
References: <CAKgNAkjgmTJ1BiHVbqVtz-g-=yfewMiYaroDJELJpa1aRrFAvQ@mail.gmail.com>
	<CAFLxGvy33QyJEMu_z47oyEEMY_awpT5rkoP4DYVjBQjsZysaGA@mail.gmail.com>
Date: Thu, 25 Apr 2013 17:54:29 -0700
In-Reply-To: <CAFLxGvy33QyJEMu_z47oyEEMY_awpT5rkoP4DYVjBQjsZysaGA@mail.gmail.com>
	(richard's message of "Thu, 25 Apr 2013 09:48:00 +0200")
Message-ID: <87mwsmqfga.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+BMO5VZqbdeA0D+T1owSyv8EVpR7drwXI=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;richard -rw- weinberger <richard.weinberger@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: For review (v2): user_namespaces(7) man page
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

richard -rw- weinberger <richard.weinberger@gmail.com> writes:

> On Wed, Mar 27, 2013 at 10:26 PM, Michael Kerrisk (man-pages)
> <mtk.manpages@gmail.com> wrote:
>>        Inside the user namespace, the shell has user and group  ID  0,
>>        and a full set of permitted and effective capabilities:
>>
>>            bash$ cat /proc/$$/status | egrep '^[UG]id'
>>            Uid: 0    0    0    0
>>            Gid: 0    0    0    0
>>            bash$ cat /proc/$$/status | egrep '^Cap(Prm|Inh|Eff)'
>>            CapInh:   0000000000000000
>>            CapPrm:   0000001fffffffff
>>            CapEff:   0000001fffffffff
>
> I've tried your demo program, but inside the new ns I'm automatically nobody.
> As Eric said, setuid(0)/setgid(0) are missing.

Is it the setuid/setgid or not setting up the uid/gid map?

> Eric, maybe you can help me. How can I drop capabilities within a user
> namespace?

> In childFunc() I did add prctl(PR_CAPBSET_DROP, CAP_NET_ADMIN) but it always
> returns ENOPERM.
> What that? I thought I get a completely fresh set of cap which I can modify.
> I don't want that uid 0 inside the container has all caps.

There are weird things that happen with exec and the user namespace.  If
you have exec'd as an unmapped user all of your capabilities have
already been droped.

> And why does /proc/*/loginuid always contain 4294967295 in a new user namespace?
> Writing to it also fails. (Noticed that because pam_loginuid.so does not work).

Almost certainly because the loginuid has already been set.  Yes. It
looks like I am simply using from_kuid instead of from_kuid_munged on
the read.  So an unmapped loginuid will be reported as 4294967295.

For some circumstances 65534 (nobody) is definitely better in some it is
a toss up, and most of the time no one really cares.  So I have tried to
do something but in this case I don't know which was the best policy.

> Final question, is it by design that uid 0 within a namespace in not
> allowed to write to
> /proc/*/oom_score_adj?

Essentially.  It is by design that uid 0 within a namespace be mapped to
some other uid outside the namespace, and that the permissions on writes
should use the permission needed outside of the user namespace.

Which means there are all kinds of things only uid 0 can write to, that
you can't touch in a user namespace.  Some of those things the policy
may need to be reconsidered.  A lot of those things the default policy
is good.  Regardless we are now defaulting to not letting root in a
container do risky things which is a good thing.

Eric
