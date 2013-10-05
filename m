Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab3JEXHr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 19:07:47 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:48759 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab3JEXHp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 19:07:45 -0400
Date: Sat, 05 Oct 2013 18:07:42 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC][PATCH 0/3] vfs: Detach mounts on unlink.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <87li281wx6.fsf_-_@xmission.com> (from ebiederm@xmission.com on
	Fri Oct  4 17:41:25 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1381014462.1974.162@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2013 05:41:25 PM, Eric W. Biederman wrote:
> 
> This patchset is an attempt to address two problems:
> 1) Not all modifications to the filesystems happen through the vfs and
>    since the vfs can not cope with a mount point being unlinked or
>    renamed filesystems whose modifications that do not come through  
> the
>    vfs are required to lie.
> 
> 2) Through an oversight it is now possible for one unprivileged user  
> to
>    mount something on another unprivileged users dentry and make it
>    impossible for the other user to unlink or rename that dentry.
> 
> It is now technically possible to easily lift the restriction on
> unlinking and renaming files with mount points on them, with a
> corresponding reduction in complexity of the vfs semantics and a small
> code side reduction.

A todo item I've had _forever_ is fixing chroot() to not be broken so  
that you can trivially break out of a chroot via:

   chdir("/");
   mkdir("sub");
   chroot("sub");
   chdir("./../../../../../../../..");

(Because chroot() affects where "/" points but NOT where "." points to,  
and chdir does an == check with the dentry "/" points at to know when  
to stop, so if you move "/" under "." you can back up to the actual  
root of the tree.)

The above is why lxc uses pivot_root() instead of chroot().

These days, we have multiple mount trees so there's no reason chroot()  
can't trim the process local mount tree (creating a new bind mount if  
necessary). Except my todo list runneth over and I haven't had a chance  
to dig in and see what would be involved. (Last time I brought this up  
people were wondering why chroot() didn't just move "." to the new "/"  
if it wasn't under it. I had no idea, still don't.)

Rob