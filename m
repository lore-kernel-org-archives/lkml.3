Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab3FFQf7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:35:59 -0400
Received: from cdw.me.uk ([91.203.57.136]:42924 "EHLO cdw.me.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab3FFQf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:35:57 -0400
X-Greylist: delayed 1543 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Jun 2013 12:35:57 EDT
Date: Thu, 6 Jun 2013 17:10:10 +0100
From: Chris Webb <chris@arachsys.com>
To: linux-kernel@vger.kernel.org
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Building a BSD-jail clone out of namespaces
Message-ID: <20130606161010.GI12062@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prompted by the new userns support merged in the 3.8/3.9 kernels, I've been
playing with namespaces and trying to understand how I could use them to
build containers to replace some of my uses of qemu-kvm virtual machines.

I've successfully created a fakeroot-type container running as an
unprivileged user by unsharing everything including CLONE_NEWUSER, and can
map a block of host UIDs for that environment by writing to
/proc/PID/[ug]id_map from a helper process running as root.

However, what I'm hoping for in practice is to be able to create containers
whose access to its filesystem subtree is untranslated, i.e. uid/gid N in
the container maps to uid/gid N in a subdirectory of the filesystem, but
which is still isolated from the rest of the host filesystem and can't do
externally privileged things. This is pretty much what a BSD jail provides,
for example.

Is this possible to achieve securely using the mechanisms now available?
(I'm assuming that parent directory permissions prevent unprivileged host
users from getting at these container filesystems, exactly as is necessary
to make BSD jails safe.)


As a first step, I naively tried running as root and unsharing everything
with 

  unshare(CLONE_NEWIPC | CLONE_NEWNS | CLONE_NEWNET | CLONE_NEWPID
                       | CLONE_NEWUTS | CLONE_NEWUSER);

before execing a shell[1]. From another root process in the host namespace,
I then wrote a pass-through mapping 0 0 4294967295 to /proc/PID/[ug]id_map.

The result initially looks plausible, with the PID namespace preventing
signals being sent from one container to another, despite those processes
sharing the same user ID in the top-level user namespace.

However, unfortunately I still have too many privileges with respect to the
host. Whilst (for example) I can't mknod, I can mount a sysfs or procfs and
apparently write to them with host root privileges to reconfigure the host
kernel. I suspect there will be other things I haven't secured by this
recipe too.

I also tried tightening things up by dropping capabilities from my root user
and preventing capability grant on exec by setting and locking SECBIT_NOROOT
on before starting the container. However, I'm not sure this really makes
any difference---does CLONE_NEWUSER drop all capabilities with respect to
the parent namespace?

[1] In this description, I'm ignoring the part where I lock into a new root
filesystem, but presumably the way to do this is by pivot_root into a bind
mount?

Best wishes,

Chris.
