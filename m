Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410Ab3EWDhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 23:37:47 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34512 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757029Ab3EWDhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 23:37:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>, viro@zeniv.linux.org.uk,
        serge.hallyn@canonical.com, jlayton@redhat.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, oleg@redhat.com, bharrosh@panasas.com,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        devel@openvz.org
References: <20130522072840.27720.85023.stgit@localhost.localdomain>
	<878v36ex6n.fsf@xmission.com> <87wqqqdfqr.fsf@xmission.com>
	<20130522192339.GB31069@fieldses.org>
Date: Wed, 22 May 2013 20:37:23 -0700
In-Reply-To: <20130522192339.GB31069@fieldses.org> (J. Bruce Fields's message
	of "Wed, 22 May 2013 15:23:39 -0400")
Message-ID: <87vc6abc3w.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19627iAWMgBW6MdVvdZErghbNPi9AeHKa0=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0063]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"J. Bruce Fields" <bfields@fieldses.org>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"J. Bruce Fields" <bfields@fieldses.org> writes:

> On Wed, May 22, 2013 at 11:35:56AM -0700, Eric W. Biederman wrote:
>> ebiederm@xmission.com (Eric W. Biederman) writes:
>> 
>> > I am missing a lot of context here and capturing the context of a
>> > process at time time we mount the filesystem and reconstituing it in
>> > call user mode helper seems like something we could do.
>
> So it's not enough just to ensure that the user namespace is set
> correctly?  (To the namespace of the mount process in the nfs case, or
> of the process that starts nfsd in the nfsd case.)

No.  By just setting the user namespace, you gain the ability to create
processes outside of your curremt rlimits, and cgroups, and pid
namespace, etc.

With the wrong set of namespaces you will talk to the wrong processes,
or utilize the wrong resources.

Outside of your current cgroup you gain the ability to use more
resources than you were limited to.

Having thought about it what I would propose is to fork a process from
the context of the mounting process (or possibly from the context of the
process that writes to the sysctl that sets the program to spawn) and
have that process be a daemon that becomes responsible for spawning user
mode helpers with context.  Either that or whe need the user mode helper
userspace infrastructure to become namespace aware and call setns.

>> If we want to do something like this the only sane thing I can see is to
>> have a per container version of kthread call it uthread.  That the user
>> mode helper code would use to launch a new process.
>> 
>> Anything else and I expect we will be tearing our hair out for the rest
>> of our lives with weird corner cases or unexpected semantics.
>
> Could you give examples of weird corner cases or unexpected semantics?

I gave a couple and it is the classic problem with suid executables
where a lot of unexpected things are inherited from the environment, and
so things become a never ending race.  We replaced daemonize in the
kernel with just forking processes from kthreadd for this very reason.
There was always something else that needed to be reset to make a
process a proper kernel thread.

Eric
