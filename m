Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab3LaTqx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 14:46:53 -0500
Received: from nautica.notk.org ([91.121.71.147]:47927 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756426Ab3LaTqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:46:52 -0500
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Dec 2013 14:46:52 EST
Date: Tue, 31 Dec 2013 20:41:11 +0100
From: Dominique Martinet <dominique.martinet@cea.fr>
To: Richard Yao <ryao@gentoo.org>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org,
        "v9fs-developer@lists.sourceforge.net" 
	<v9fs-developer@lists.sourceforge.net>,
        "kernel@gentoo.org" <kernel@gentoo.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: v9fs does not honor open file handles on anonymous files
Message-ID: <20131231194110.GA28209@nautica>
References: <52C31927.40304@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52C31927.40304@gentoo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Richard Yao wrote on Tue, Dec 31, 2013 :
> #!/bin/bash
> cat <<-EOF
> EOF
> 
> Running this causes bash to fork via clone(), set fd=0 to point to an
> empty file in /tmp, unlink it and then execve cat. Specifically,
> something like this;
> 
> [pid  3699] open("/tmp/sh-thd-1388524249",
> O_WRONLY|O_CREAT|O_EXCL|O_TRUNC, 0600) = 3
> [pid  3699] open("/tmp/sh-thd-1388524249", O_RDONLY) = 4
> [pid  3699] close(3)                    = 0
> [pid  3699] unlink("/tmp/sh-thd-1388524249") = 0
> [pid  3699] dup2(4, 0)                  = 0
> [pid  3699] close(4)                    = 0
> [pid  3699] execve("/bin/cat", ["cat"], [/* 22 vars */]) = 0
> 
> It seems that v9fs_vfs_unlink() is killing the file while we still have
> open file handles. I have confirmed that this behavior occurs on Linux
> 3.13.0-rc6. This breaks several things when Gentoo is on a 9p rootfs
> (e.g. gcc-config, any emerge command that involves a C compiler,
> etcetera) inside QEMU. I have placed /tmp and /var/tmp/portage on a
> tmpfs as a hack-fix, but it would be better to get this fixed.
> 
> I doubt that I will write a patch to fix this. I am sending the details
> to the list so the 9p maintainers or any other interested individual can
> fix it.

I'm not sure if it is the client's job to remember the file has been
unlinked and only really unlink it after all the file handles are closed
or if we should expect the server to do it.

It might not matter in the case of qemu acting as a 9p server, but there
are a couple of network 9p2000.L servers out there (diod[1] and
nfs-ganesha[2]), and if the file is open on one client and unlinked on
another client.. How can the second client wait properly?

For what's it's worth, nfs-ganesha already behaves properly and this
will work with /tmp being a 9P mount off it.


It might be worth looking into qemu's code and see if it wouldn't be
easy to hold the unlink ? I've got to admit I honestly have no clue
there.
(or at least send them a copy of your mail :))


[1] diod "Distributed I/O daemon" - http://code.google.com/p/diod/
[2] nfs-ganesha - https://github.com/nfs-ganesha/nfs-ganesha


Cheers,
-- 
Dominique Martinet
