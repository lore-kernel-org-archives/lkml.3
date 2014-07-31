Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601AbaGaWRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 18:17:20 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbaGaWRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 18:17:19 -0400
Message-ID: <53DAC069.7070606@nod.at>
Date: Fri, 01 Aug 2014 00:17:13 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org
CC: viro@zeniv.linux.org.uk, hch@infradead.org, paulmck@linux.vnet.ibm.com,
        jeffm@suse.com, sahne@0x90.at,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxram@us.ibm.com
Subject: Re: MNT_DETACH and mount namespace issue
References: <1406728756-32443-1-git-send-email-richard@sigma-star.at> <53D959A7.5070702@nod.at>
In-Reply-To: <53D959A7.5070702@nod.at>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 30.07.2014 22:46, schrieb Richard Weinberger:
> Am 30.07.2014 15:59, schrieb Richard Weinberger:
>> If we use the plain list_empty() we might not see the
>> hlist_del_init_rcu() and therefore miss one member of the
>> list.
>>
>> It fixes the following issue:
>> $ unshare -m /usr/bin/sleep 10000 &
>> $ mkdir -p foo/proc
>> $ mount -t proc none foo/proc
>> $ mount -t binfmt_misc none foo/proc/sys/fs/binfmt_misc
>> $ umount -l foo/proc
>> $ rmdir foo/proc
>> rmdir: failed to remove ‘foo/proc’: Device or resource busy
> 
> Although my fix was wrong, the issue is real, it seems to exist for a very long
> time. Just was able to reproduce it on 2.6.32.
> Please note that you need a shared root subtree to trigger the issue.
> i.e. mount --shared /
> Maybe this is why nobody noticed it so far as only systemd distros
> have the root subtree shared by default.
> 
> I hit the issue on openSUSE 13.1 where an application creates a chroot environment
> and then lazy umounts /proc.
> It happened on very few machines. An analysis showed that only boxes with an OpenVPN tunnel
> were affected. This did not make any sense until I discovered that the OpenVPN systemd
> service file has set "PrivateTmp=true". This setting creates
> a mount namespace for the said service...
> 
> In __propagate_umount() the following piece of code is interesting:
> 
>  /*
>  * umount the child only if the child has no
>  * other children
>  */
> if (child && list_empty(&child->mnt_mounts)) {
>         hlist_del_init_rcu(&child->mnt_hash);
>         hlist_add_before_rcu(&child->mnt_hash, &mnt->mnt_hash);
> }
> 
> child->mnt_mounts is non-empty for the "proc" although the "binfmt_misc"
> subtree was removed.
> I'm not sure whether this is only one more symptom or the main culprit.

CC'ing Ram Pai.

Ram, you are the author of the said code. Can you please explain why we need that
list_empty() check?
To my (limited) understanding of VFS, the following change should be fine to fix the issue:

diff --git a/fs/pnode.c b/fs/pnode.c
index 302bf22..627b35f 100644
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -376,11 +376,7 @@ static void __propagate_umount(struct mount *mnt)

 		struct mount *child = __lookup_mnt_last(&m->mnt,
 						mnt->mnt_mountpoint);
-		/*
-		 * umount the child only if the child has no
-		 * other children
-		 */
-		if (child && list_empty(&child->mnt_mounts)) {
+		if (child) {
 			hlist_del_init_rcu(&child->mnt_hash);
 			hlist_add_before_rcu(&child->mnt_hash, &mnt->mnt_hash);
 		}

Thanks,
//richard
