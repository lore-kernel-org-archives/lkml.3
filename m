Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147Ab3D2UVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:21:40 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:57763 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757342Ab3D2UVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:21:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvw-d4jZniV=KHSDVCQtJEzhZB0bJAW-VyUKdAqDJi+_nA@mail.gmail.com>
References: <CAKgNAkjgmTJ1BiHVbqVtz-g-=yfewMiYaroDJELJpa1aRrFAvQ@mail.gmail.com>
 <CAFLxGvy33QyJEMu_z47oyEEMY_awpT5rkoP4DYVjBQjsZysaGA@mail.gmail.com>
 <87mwsmqfga.fsf@xmission.com> <CAFLxGvw-d4jZniV=KHSDVCQtJEzhZB0bJAW-VyUKdAqDJi+_nA@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 29 Apr 2013 13:21:18 -0700
Message-ID: <CALCETrV=9Rebc3NNyQD3bLee_EL_222-oww45JXUasK=mq3dgA@mail.gmail.com>
Subject: Re: For review (v2): user_namespaces(7) man page
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Rob Landley <rob@landley.net>, linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vasily Kulikov <segoon@openwall.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 10:48 PM, richard -rw- weinberger
<richard.weinberger@gmail.com> wrote:
> On Fri, Apr 26, 2013 at 2:54 AM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> richard -rw- weinberger <richard.weinberger@gmail.com> writes:
>>
>>> On Wed, Mar 27, 2013 at 10:26 PM, Michael Kerrisk (man-pages)
>>> <mtk.manpages@gmail.com> wrote:
>>>>        Inside the user namespace, the shell has user and group  ID  0,
>>>>        and a full set of permitted and effective capabilities:
>>>>
>>>>            bash$ cat /proc/$$/status | egrep '^[UG]id'
>>>>            Uid: 0    0    0    0
>>>>            Gid: 0    0    0    0
>>>>            bash$ cat /proc/$$/status | egrep '^Cap(Prm|Inh|Eff)'
>>>>            CapInh:   0000000000000000
>>>>            CapPrm:   0000001fffffffff
>>>>            CapEff:   0000001fffffffff
>>>
>>> I've tried your demo program, but inside the new ns I'm automatically nobody.
>>> As Eric said, setuid(0)/setgid(0) are missing.
>>
>> Is it the setuid/setgid or not setting up the uid/gid map?
>
> uid/git mapping are set up.
>
>>> Eric, maybe you can help me. How can I drop capabilities within a user
>>> namespace?
>>
>>> In childFunc() I did add prctl(PR_CAPBSET_DROP, CAP_NET_ADMIN) but it always
>>> returns ENOPERM.
>>> What that? I thought I get a completely fresh set of cap which I can modify.
>>> I don't want that uid 0 inside the container has all caps.
>>
>> There are weird things that happen with exec and the user namespace.  If
>> you have exec'd as an unmapped user all of your capabilities have
>> already been droped.
>
> I've setup the mappings. If I look into /proc/*/status I see that my process has
> all caps.
> So, in general it is possible to drop cap within a user namespace?
> I really want to drop CAP_NET_ADMIN and some others.
> root within my container must not change any networking settings.

You may have the common issue that uid 0 tends to regain capabilities
on exec due to "legacy" capability emulation.  Try playing with
securebits and/or the bounding set.  (The setpriv command in very new
util-linux-ng makes this easy to play with.)

Note that you almost certainly want to set no_new_privs if anything
other than uid 0 is running with non-default securebits.

--Andy
