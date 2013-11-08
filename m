Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501Ab3KHXPc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:15:32 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:46069 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757800Ab3KHXP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:15:29 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20131108180759.12dab53816900b1b58c1ea1b@canb.auug.org.au>
Date: Fri, 08 Nov 2013 15:15:17 -0800
In-Reply-To: <20131108180759.12dab53816900b1b58c1ea1b@canb.auug.org.au>
	(Stephen Rothwell's message of "Fri, 8 Nov 2013 18:07:59 +1100")
Message-ID: <87r4aqscxm.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18oM2caBJ1fObDi4DcOxImU5ldn+0Axrzc=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.2029]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
Subject: Re: linux-next: build failure after merge of the userns tree
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> After merging the userns tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> fs/namespace.c: In function 'detach_mounts':
> fs/namespace.c:1340:2: error: implicit declaration of function 'br_write_lock' [-Werror=implicit-function-declaration]
>   br_write_lock(&vfsmount_lock);
>   ^
> fs/namespace.c:1340:17: error: 'vfsmount_lock' undeclared (first use in this function)
>   br_write_lock(&vfsmount_lock);
>                  ^
> fs/namespace.c:1340:17: note: each undeclared identifier is reported only once for each function it appears in
> fs/namespace.c:1345:2: error: implicit declaration of function 'br_write_unlock' [-Werror=implicit-function-declaration]
>   br_write_unlock(&vfsmount_lock);
>   ^
>
> Caused by the interaction between commit d7e58b8abc4f ("vfs: Add a
> function to lazily unmount all mounts from any dentry. v3") from the
> userns tree and commit 84550b9356af ("RCU'd vfsmounts") from the vfs tree.
>
> I don't know how to fix this up, so I have just dropped the userns tree
> for today.  I only dropped that tree because it was the latter of the two
> conflicting trees.

Yeah.  Al has somethng cooking where he renamed the lock.

It looks like this just needs the trivial change:
s/br_write_lock(&vfsmount_lock)/lock_mount_hash()/
s/br_write_unlock(&vfsmount_lock)/unlock_mount_hash()/

Certainly that is all it needed when I closely inspected an earlier
version of Al's changes.  He changed the name of the lock and I just
happen to be using it.  In this case I don't think any of the semantics
have changed.

Eric
