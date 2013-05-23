Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab3EWKA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 06:00:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48173 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968Ab3EWKA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 06:00:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: <viro@zeniv.linux.org.uk>, <serge.hallyn@canonical.com>,
        <jlayton@redhat.com>, <lucas.demarchi@profusion.mobi>,
        <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>,
        <oleg@redhat.com>, <bfields@fieldses.org>, <bharrosh@panasas.com>,
        <linux-fsdevel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <devel@openvz.org>
References: <20130522072840.27720.85023.stgit@localhost.localdomain>
	<878v36ex6n.fsf@xmission.com> <519DCE5D.6070204@parallels.com>
Date: Thu, 23 May 2013 03:00:33 -0700
In-Reply-To: <519DCE5D.6070204@parallels.com> (Stanislav Kinsbursky's message
	of "Thu, 23 May 2013 12:07:57 +0400")
Message-ID: <87k3mq9fsu.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX1+5SiG+adEUryunxfUzvf6A1OBdUvUUwe4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  1.0 XM_Evil_Numbers_Gen maybe a phone number spam
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stanislav Kinsbursky <skinsbursky@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislav Kinsbursky <skinsbursky@parallels.com> writes:

> 22.05.2013 21:33, Eric W. Biederman пишет:
>> Stanislav Kinsbursky <skinsbursky@parallels.com> writes:
>>
>>> Usermode helper executes all binaries in global "init" root context. This
>>> doesn't allow to call a binary from other root context (for example in a
>>> container).
>>> Currently, both containerized NFS client and NFS server requires an ability to
>>> execute a binary in a container's root context. Root swap can be done in
>>> "init" callback, passed by UMH caller.
>>> But since we have 2 callers already (and more of them are expected to appear
>>> in future) and because set_fs_root() in not exported, it looks reasonable to
>>> add one more generic UMH helper to generic fs code.
>>> Root path reference must be hold by the caller, since it will be put on UMH
>>> thread exit.
>>
>> Awesome.  With this patch as an uprivilieged user I get to pick which
>> binary the kernel will execute.  At least if nfs and nfsd ever runs in a
>> user namespace (something that looks like only matter of time).
>>
>
> Not really. Only by using a kernel module to call the UMH.
> And an unprivileged can't load a module as far a I know.
> I.e. NFSd, for example, will use unprivileged user's root to perform this call.

To help me understand the context which instances of call user mode
helper are you expecting to use this facility?

>> I think this is a seriously bad idea.
>>
>> Why can't we do this in userspace with setns as we do with the core dump
>> helper?
>>
>
> Could you, please, clarify, how setns can help here?

setns can change the mount namespace, and chroot can change to root
directory in the specified mount namespace.  Essentially you can enter
into a containers complete context (pid, mnt, root, etc) comming from
the outside.

For nfs and nfsd I believe everything is controlled by mounts.  So the
alternate solution is to have a kernel thread for calling your user mode
helper processes that is created with plain old kernel_thread aka fork
when we perform the controlling nfs mount, and have that thread be the
parent process for any containerized user mode helper calls.

>> I am missing a lot of context here and capturing the context of a
>> process at time time we mount the filesystem and reconstituing it in
>> call user mode helper seems like something we could do.
>>
>> This patch as it stands looks like it would compete for the honor of the
>> easiest kernel feature to exploit.
>>
>
> Hmmm...
> As far as I can see (maybe I'm missing something), there main security issue that could be here
> is allowing of using any passed root to swap to.

Assuming that it is mounts that control this, and root in a user
namespace will be able to mount nfs.  Then root in a user namespace will
be able to cause any program to run as the global root by simply
performing the appropriate set of mounts, and triggering the user mode
helper.

Instant gaining of all capabilities and privilieges on the system given
to a binary of your choice.

> What about using the current root instead of passed one? I.e. taking the root to swap to inside the UMH.
> Does this keeps the isolation on the same level?

Passing the necessary information to the user mode helper so the user
mode helper can perform the swaps should be fine.  That essentially is
what I was suggesting when I mentioned setns above.

Eric
