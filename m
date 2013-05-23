Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759555Ab3EWVdP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 17:33:15 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39371 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759190Ab3EWVdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 17:33:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Jeff Layton <jlayton@redhat.com>, Boaz Harrosh <bharrosh@panasas.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        viro@zeniv.linux.org.uk, serge.hallyn@canonical.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, oleg@redhat.com,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
        devel@openvz.org
References: <519DCE5D.6070204@parallels.com> <87k3mq9fsu.fsf@xmission.com>
	<519DF109.9010309@parallels.com>
	<20130523073108.13afafa6@tlielax.poochiereds.net>
	<519DFFA9.3010606@parallels.com>
	<20130523075620.21abf79a@tlielax.poochiereds.net>
	<519E0474.5000606@parallels.com> <519E0AB0.7040704@panasas.com>
	<20130523090526.63fc153e@corrin.poochiereds.net>
	<20130523195547.GA13640@fieldses.org>
	<20130523201431.GB13640@fieldses.org>
Date: Thu, 23 May 2013 14:32:51 -0700
In-Reply-To: <20130523201431.GB13640@fieldses.org> (J. Bruce Fields's message
	of "Thu, 23 May 2013 16:14:31 -0400")
Message-ID: <87obc12xh8.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/BSD+vTokLEXeUVaGuTsyPAsnzQVgJ+EU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
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

> On Thu, May 23, 2013 at 03:55:47PM -0400, J. Bruce Fields wrote:
>> On Thu, May 23, 2013 at 09:05:26AM -0400, Jeff Layton wrote:
>> > What might help most here is to lay out a particular scenario for how
>> > you envision setting up knfsd in a container so we can ensure that it's
>> > addressed properly by whatever solution you settle on.
>
> BTW the problem I have here is that the only case I've personally had
> any interest in is using network and file namespaces to isolate nfsd's
> to make them safe to migrate across nodes of a cluster.
>
> So while the idea of making user namespaces and unprivileged knfsd and
> the rest work is really interesting and I'm happy to think about it, I'm
> not sure how feasible or useful it is.
>
> I'd therefore actually prefer just to take something like Stanislav's
> patch now and put off the problem of how to make it work correctly with
> user namespaces until we actually turn that on.  His patch fixes a real
> bug that we have now, while user-namespaced-nfsd still sounds a bit
> pie-in-the-sky to me.
>
>
> But maybe I don't understand why Eric thinks nfsd in usernamespaces is
> imminent.  Or maybe I'm missing some security problem that Stanislav's
> patch would introduce now without allowing nfsd to run in a user
> namespace.

The problem I saw is less pronounced but I think actually exists without
user namespaces as well.  In particular if we let root in the container
start knfsd in a network and mount namespace.  Then if that container
does not have certain capabilities like say CAP_MKNOD all of a sudden
we have a process running in the container with CAP_MKNOD.

I haven't had time to look at everything just yet but I don't think
solving this is particularly hard.

There are really two very simple solutions.
1) When we start knfsd in the container we create a kernel thread that
   is a child of the userspace process that started knfsd.  That kernel
   thread can then be used to launch user mode helpers.

   This uses the same code as is needed today to launch user mode
   helpers with just a different parent thread.

2) We pass enough information for the user mode helper to figure out
   what container this is all for.  File descriptors or whatever.
   Then the user mode helper outside the container using chdir and setns
   sets up the environment that the user mode helper typically expects
   and runs the process inside of the container.

Or we look at what the user mode helper is doing and realize we don't
need to run the user mode binary inside of the container.  If all it
does is query /etc/passwd for username to uid mapping for example (for
user namespaces we will probably care but not without them).

I don't think any of this is hard to implement.

I think user namespaces are imminent because after my last pass through
the code the remaining work looked pretty trivial, and as soon as the
dust settles I expect user namespaces become the common way to run code
in containers, which should greatly increase the demand for this feature
in user namespaces.

Eric





