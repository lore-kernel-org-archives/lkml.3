Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab3EWKgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:36:15 -0400
Received: from relay.parallels.com ([195.214.232.42]:42382 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757799Ab3EWKgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:36:13 -0400
Message-ID: <519DF109.9010309@parallels.com>
Date: Thu, 23 May 2013 14:35:53 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>, <jlayton@redhat.com>
CC: <viro@zeniv.linux.org.uk>, <serge.hallyn@canonical.com>,
        <lucas.demarchi@profusion.mobi>, <rusty@rustcorp.com.au>,
        <linux-kernel@vger.kernel.org>, <oleg@redhat.com>,
        <bfields@fieldses.org>, <bharrosh@panasas.com>,
        <linux-fsdevel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <devel@openvz.org>
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
References: <20130522072840.27720.85023.stgit@localhost.localdomain> <878v36ex6n.fsf@xmission.com> <519DCE5D.6070204@parallels.com> <87k3mq9fsu.fsf@xmission.com>
In-Reply-To: <87k3mq9fsu.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.18.163]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

23.05.2013 14:00, Eric W. Biederman пишет:
> Stanislav Kinsbursky <skinsbursky@parallels.com> writes:
>
>> 22.05.2013 21:33, Eric W. Biederman пишет:
>>> Stanislav Kinsbursky <skinsbursky@parallels.com> writes:
>>>
>>>> Usermode helper executes all binaries in global "init" root context. This
>>>> doesn't allow to call a binary from other root context (for example in a
>>>> container).
>>>> Currently, both containerized NFS client and NFS server requires an ability to
>>>> execute a binary in a container's root context. Root swap can be done in
>>>> "init" callback, passed by UMH caller.
>>>> But since we have 2 callers already (and more of them are expected to appear
>>>> in future) and because set_fs_root() in not exported, it looks reasonable to
>>>> add one more generic UMH helper to generic fs code.
>>>> Root path reference must be hold by the caller, since it will be put on UMH
>>>> thread exit.
>>>
>>> Awesome.  With this patch as an uprivilieged user I get to pick which
>>> binary the kernel will execute.  At least if nfs and nfsd ever runs in a
>>> user namespace (something that looks like only matter of time).
>>>
>>
>> Not really. Only by using a kernel module to call the UMH.
>> And an unprivileged can't load a module as far a I know.
>> I.e. NFSd, for example, will use unprivileged user's root to perform this call.
>
> To help me understand the context which instances of call user mode
> helper are you expecting to use this facility?
>

Ok. Here is how the NFSd uses UMH:
UMH is used on NFSd service to start user-space client tracker daemon
("/sbin/nfsdcltarck"), which is used to store some per-client locks data on
persistent storage.

>>> I think this is a seriously bad idea.
>>>
>>> Why can't we do this in userspace with setns as we do with the core dump
>>> helper?
>>>
>>
>> Could you, please, clarify, how setns can help here?
>
> setns can change the mount namespace, and chroot can change to root
> directory in the specified mount namespace.  Essentially you can enter
> into a containers complete context (pid, mnt, root, etc) comming from
> the outside.
>

So, you are actually suggesting to move the binary start from the kernel to user-space.
IOW, you are suggesting to do not using UMH at all.
Am I right?
I don't know the reasons, why it was done by using UMH and not in userspace.
Could you clarify this, Jeff?

> For nfs and nfsd I believe everything is controlled by mounts.  So the
> alternate solution is to have a kernel thread for calling your user mode
> helper processes that is created with plain old kernel_thread aka fork
> when we perform the controlling nfs mount, and have that thread be the
> parent process for any containerized user mode helper calls.
>

Can't we just run into lack of credentials to execute the desired binary with this
kernel_thread() approach?

>>> I am missing a lot of context here and capturing the context of a
>>> process at time time we mount the filesystem and reconstituing it in
>>> call user mode helper seems like something we could do.
>>>
>>> This patch as it stands looks like it would compete for the honor of the
>>> easiest kernel feature to exploit.
>>>
>>
>> Hmmm...
>> As far as I can see (maybe I'm missing something), there main security issue that could be here
>> is allowing of using any passed root to swap to.
>
> Assuming that it is mounts that control this, and root in a user
> namespace will be able to mount nfs.  Then root in a user namespace will
> be able to cause any program to run as the global root by simply
> performing the appropriate set of mounts, and triggering the user mode
> helper.
>

Why you say "any program" in this case?
There is no way to pass a program name into the kernel as far a I know.
In case of NFSd the binary path is hard-coded in the kernel module.

> Instant gaining of all capabilities and privilieges on the system given
> to a binary of your choice.
>
>> What about using the current root instead of passed one? I.e. taking the root to swap to inside the UMH.
>> Does this keeps the isolation on the same level?
>
> Passing the necessary information to the user mode helper so the user
> mode helper can perform the swaps should be fine.  That essentially is
> what I was suggesting when I mentioned setns above.
>

Looks I'm missing something here.
If you are not against of using the UMH itself, then there must be a way to tell the
UMH where it should lookup the binary (UHM thread's root is used to lookup for the path in existent
implementation).
And that's what I'm trying to implement.

> Eric
>


-- 
Best regards,
Stanislav Kinsbursky
