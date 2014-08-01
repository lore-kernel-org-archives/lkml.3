Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbaHAPo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 11:44:59 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42476 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaHAPo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:44:57 -0400
Date: Fri, 1 Aug 2014 08:44:48 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
        paulmck@linux.vnet.ibm.com, jeffm@suse.com, sahne@0x90.at,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: MNT_DETACH and mount namespace issue
Message-ID: <20140801154448.GE24719@ram.oc3035372033.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <1406728756-32443-1-git-send-email-richard@sigma-star.at>
 <53D959A7.5070702@nod.at>
 <53DAC069.7070606@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53DAC069.7070606@nod.at>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14080115-0928-0000-0000-000003D111FE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 12:17:13AM +0200, Richard Weinberger wrote:
> Am 30.07.2014 22:46, schrieb Richard Weinberger:
> > Am 30.07.2014 15:59, schrieb Richard Weinberger:
> >> If we use the plain list_empty() we might not see the
> >> hlist_del_init_rcu() and therefore miss one member of the
> >> list.
> >>
> >> It fixes the following issue:
> >> $ unshare -m /usr/bin/sleep 10000 &
> >> $ mkdir -p foo/proc
> >> $ mount -t proc none foo/proc
> >> $ mount -t binfmt_misc none foo/proc/sys/fs/binfmt_misc
> >> $ umount -l foo/proc
> >> $ rmdir foo/proc
> >> rmdir: failed to remove ‘foo/proc’: Device or resource busy
> > 
> > Although my fix was wrong, the issue is real, it seems to exist for a very long
> > time. Just was able to reproduce it on 2.6.32.
> > Please note that you need a shared root subtree to trigger the issue.
> > i.e. mount --shared /
> > Maybe this is why nobody noticed it so far as only systemd distros
> > have the root subtree shared by default.
> > 
> > I hit the issue on openSUSE 13.1 where an application creates a chroot environment
> > and then lazy umounts /proc.
> > It happened on very few machines. An analysis showed that only boxes with an OpenVPN tunnel
> > were affected. This did not make any sense until I discovered that the OpenVPN systemd
> > service file has set "PrivateTmp=true". This setting creates
> > a mount namespace for the said service...
> > 
> > In __propagate_umount() the following piece of code is interesting:
> > 
> >  /*
> >  * umount the child only if the child has no
> >  * other children
> >  */
> > if (child && list_empty(&child->mnt_mounts)) {
> >         hlist_del_init_rcu(&child->mnt_hash);
> >         hlist_add_before_rcu(&child->mnt_hash, &mnt->mnt_hash);
> > }
> > 
> > child->mnt_mounts is non-empty for the "proc" although the "binfmt_misc"
> > subtree was removed.
> > I'm not sure whether this is only one more symptom or the main culprit.
> 
> CC'ing Ram Pai.
> 
> Ram, you are the author of the said code. Can you please explain why we need that
> list_empty() check?
> To my (limited) understanding of VFS, the following change should be fine to fix the issue:

We had made a rule then, that busy vfsmounts cannot be lazily unmounted
**implicitly**. Propagated unmounts are implicit unmounts, and if such
implicit vfsmounts have child-mounts than obviously they are busy, and
hence they cannot be lazy-unmounted implicitly.

the list_empty() is checking for no child-mounts on the vfsmount before
letting it unmount.

We did not want a bunch of mounts disappear without the users knowledge.
Hence we made the above rule.

Al Viro, will have more insights into this.

RP

