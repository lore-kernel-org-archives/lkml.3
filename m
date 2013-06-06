Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3FFQ6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:58:22 -0400
Received: from out04.mta.xmission.com ([166.70.13.234]:52399 "EHLO
	out04.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3FFQ6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:58:20 -0400
X-Greylist: delayed 1298 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jun 2013 12:58:20 EDT
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chris Webb <chris@arachsys.com>
Cc: linux-kernel@vger.kernel.org
References: <20130606161010.GI12062@arachsys.com>
Date: Thu, 06 Jun 2013 09:35:36 -0700
In-Reply-To: <20130606161010.GI12062@arachsys.com> (Chris Webb's message of
	"Thu, 6 Jun 2013 17:10:10 +0100")
Message-ID: <87ehcf8aef.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/8QkYCTlx59Koha8dpxHAbfNUhOZfJhYk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Chris Webb <chris@arachsys.com>
X-Spam-Relay-Country: 
Subject: Re: Building a BSD-jail clone out of namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Webb <chris@arachsys.com> writes:

> Prompted by the new userns support merged in the 3.8/3.9 kernels, I've been
> playing with namespaces and trying to understand how I could use them to
> build containers to replace some of my uses of qemu-kvm virtual machines.
>
> I've successfully created a fakeroot-type container running as an
> unprivileged user by unsharing everything including CLONE_NEWUSER, and can
> map a block of host UIDs for that environment by writing to
> /proc/PID/[ug]id_map from a helper process running as root.
>
> However, what I'm hoping for in practice is to be able to create containers
> whose access to its filesystem subtree is untranslated, i.e. uid/gid N in
> the container maps to uid/gid N in a subdirectory of the filesystem, but
> which is still isolated from the rest of the host filesystem and can't do
> externally privileged things. This is pretty much what a BSD jail provides,
> for example.
>
> Is this possible to achieve securely using the mechanisms now available?
> (I'm assuming that parent directory permissions prevent unprivileged host
> users from getting at these container filesystems, exactly as is necessary
> to make BSD jails safe.)
>
>
> As a first step, I naively tried running as root and unsharing everything
> with 
>
>   unshare(CLONE_NEWIPC | CLONE_NEWNS | CLONE_NEWNET | CLONE_NEWPID
>                        | CLONE_NEWUTS | CLONE_NEWUSER);
>
> before execing a shell[1]. From another root process in the host namespace,
> I then wrote a pass-through mapping 0 0 4294967295 to /proc/PID/[ug]id_map.

That will work, but you really don't want to run with uid == 0 mapped to
uid == 0.  There are too many things in /proc and /sys and similar that
grant access to uid == 0.

> The result initially looks plausible, with the PID namespace preventing
> signals being sent from one container to another, despite those processes
> sharing the same user ID in the top-level user namespace.
>
> However, unfortunately I still have too many privileges with respect to the
> host. Whilst (for example) I can't mknod, I can mount a sysfs or procfs and
> apparently write to them with host root privileges to reconfigure the host
> kernel. I suspect there will be other things I haven't secured by this
> recipe too.

Yes.  I recommend having a dedicated range of uids for your container to
prevent this kind of silliness.  Or at the very least a separate mapping
of uid == 0.

> I also tried tightening things up by dropping capabilities from my root user
> and preventing capability grant on exec by setting and locking SECBIT_NOROOT
> on before starting the container. However, I'm not sure this really makes
> any difference---does CLONE_NEWUSER drop all capabilities with respect to
> the parent namespace?

Yes.  CLONE_NEWUSER drops all capabilities with respect to the parent
namespace.

> [1] In this description, I'm ignoring the part where I lock into a new root
> filesystem, but presumably the way to do this is by pivot_root into a bind
> mount?

Yes pivot_root and bind mount work.

ERic

