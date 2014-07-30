Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaG3Uqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 16:46:37 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882AbaG3Uqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 16:46:36 -0400
Message-ID: <53D959A7.5070702@nod.at>
Date: Wed, 30 Jul 2014 22:46:31 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: viro@zeniv.linux.org.uk, hch@infradead.org, paulmck@linux.vnet.ibm.com,
        jeffm@suse.com, sahne@0x90.at,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: MNT_DETACH and mount namespace issue (was: Re: [PATCH] vfs: Fix RCU
 usage in __propagate_umount())
References: <1406728756-32443-1-git-send-email-richard@sigma-star.at>
In-Reply-To: <1406728756-32443-1-git-send-email-richard@sigma-star.at>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.07.2014 15:59, schrieb Richard Weinberger:
> If we use the plain list_empty() we might not see the
> hlist_del_init_rcu() and therefore miss one member of the
> list.
> 
> It fixes the following issue:
> $ unshare -m /usr/bin/sleep 10000 &
> $ mkdir -p foo/proc
> $ mount -t proc none foo/proc
> $ mount -t binfmt_misc none foo/proc/sys/fs/binfmt_misc
> $ umount -l foo/proc
> $ rmdir foo/proc
> rmdir: failed to remove ‘foo/proc’: Device or resource busy

Although my fix was wrong, the issue is real, it seems to exist for a very long
time. Just was able to reproduce it on 2.6.32.
Please note that you need a shared root subtree to trigger the issue.
i.e. mount --shared /
Maybe this is why nobody noticed it so far as only systemd distros
have the root subtree shared by default.

I hit the issue on openSUSE 13.1 where an application creates a chroot environment
and then lazy umounts /proc.
It happened on very few machines. An analysis showed that only boxes with an OpenVPN tunnel
were affected. This did not make any sense until I discovered that the OpenVPN systemd
service file has set "PrivateTmp=true". This setting creates
a mount namespace for the said service...

In __propagate_umount() the following piece of code is interesting:

 /*
 * umount the child only if the child has no
 * other children
 */
if (child && list_empty(&child->mnt_mounts)) {
        hlist_del_init_rcu(&child->mnt_hash);
        hlist_add_before_rcu(&child->mnt_hash, &mnt->mnt_hash);
}

child->mnt_mounts is non-empty for the "proc" although the "binfmt_misc"
subtree was removed.
I'm not sure whether this is only one more symptom or the main culprit.

Any ideas?

Thanks,
//richard
