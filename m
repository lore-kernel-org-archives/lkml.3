Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab3EXGEj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 02:04:39 -0400
Received: from relay.parallels.com ([195.214.232.42]:47400 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab3EXGEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 02:04:38 -0400
Message-ID: <519F02E7.9010609@parallels.com>
Date: Fri, 24 May 2013 10:04:23 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@redhat.com>,
        Boaz Harrosh <bharrosh@panasas.com>, <viro@zeniv.linux.org.uk>,
        <serge.hallyn@canonical.com>, <lucas.demarchi@profusion.mobi>,
        <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>,
        <oleg@redhat.com>, <linux-fsdevel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <devel@openvz.org>
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
References: <519DCE5D.6070204@parallels.com> <87k3mq9fsu.fsf@xmission.com> <519DF109.9010309@parallels.com> <20130523073108.13afafa6@tlielax.poochiereds.net> <519DFFA9.3010606@parallels.com> <20130523075620.21abf79a@tlielax.poochiereds.net> <519E0474.5000606@parallels.com> <519E0AB0.7040704@panasas.com> <20130523090526.63fc153e@corrin.poochiereds.net> <20130523195547.GA13640@fieldses.org> <20130523201431.GB13640@fieldses.org> <87obc12xh8.fsf@xmission.com>
In-Reply-To: <87obc12xh8.fsf@xmission.com>
Content-Type: text/plain; charset="windows-1251"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.18.163]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

24.05.2013 01:32, Eric W. Biederman пишет:
> "J. Bruce Fields" <bfields@fieldses.org> writes:
>
>> On Thu, May 23, 2013 at 03:55:47PM -0400, J. Bruce Fields wrote:
>>> On Thu, May 23, 2013 at 09:05:26AM -0400, Jeff Layton wrote:
>>>> What might help most here is to lay out a particular scenario for how
>>>> you envision setting up knfsd in a container so we can ensure that it's
>>>> addressed properly by whatever solution you settle on.
>>
>> BTW the problem I have here is that the only case I've personally had
>> any interest in is using network and file namespaces to isolate nfsd's
>> to make them safe to migrate across nodes of a cluster.
>>
>> So while the idea of making user namespaces and unprivileged knfsd and
>> the rest work is really interesting and I'm happy to think about it, I'm
>> not sure how feasible or useful it is.
>>
>> I'd therefore actually prefer just to take something like Stanislav's
>> patch now and put off the problem of how to make it work correctly with
>> user namespaces until we actually turn that on.  His patch fixes a real
>> bug that we have now, while user-namespaced-nfsd still sounds a bit
>> pie-in-the-sky to me.
>>
>>
>> But maybe I don't understand why Eric thinks nfsd in usernamespaces is
>> imminent.  Or maybe I'm missing some security problem that Stanislav's
>> patch would introduce now without allowing nfsd to run in a user
>> namespace.
>
> The problem I saw is less pronounced but I think actually exists without
> user namespaces as well.  In particular if we let root in the container
> start knfsd in a network and mount namespace.  Then if that container
> does not have certain capabilities like say CAP_MKNOD all of a sudden
> we have a process running in the container with CAP_MKNOD.
>
> I haven't had time to look at everything just yet but I don't think
> solving this is particularly hard.
>
> There are really two very simple solutions.
> 1) When we start knfsd in the container we create a kernel thread that
>     is a child of the userspace process that started knfsd.  That kernel
>     thread can then be used to launch user mode helpers.
>
>     This uses the same code as is needed today to launch user mode
>     helpers with just a different parent thread.
>

This might work for us.
but one of the reasons I'm worrying about is that the spawned kernel thread will
have the same capabilities as the process, calling for NFSd start.
And this capabilities can be insufficient for running "/sbin/nfsdcltrack" binary.

> 2) We pass enough information for the user mode helper to figure out
>     what container this is all for.  File descriptors or whatever.
>     Then the user mode helper outside the container using chdir and setns
>     sets up the environment that the user mode helper typically expects
>     and runs the process inside of the container.
>

How does chdir and setns differs from doing set_fs_root() in UMH  in terms of
security and isolation?

> Or we look at what the user mode helper is doing and realize we don't
> need to run the user mode binary inside of the container.  If all it
> does is query /etc/passwd for username to uid mapping for example (for
> user namespaces we will probably care but not without them).
>
> I don't think any of this is hard to implement.
>
> I think user namespaces are imminent because after my last pass through
> the code the remaining work looked pretty trivial, and as soon as the
> dust settles I expect user namespaces become the common way to run code
> in containers, which should greatly increase the demand for this feature
> in user namespaces.
>
> Eric
>
>
>
>
>


-- 
Best regards,
Stanislav Kinsbursky
