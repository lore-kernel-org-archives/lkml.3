Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab3J3NOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 09:14:34 -0400
Received: from mail-qa0-f54.google.com ([209.85.216.54]:60325 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab3J3NOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 09:14:33 -0400
Date: Wed, 30 Oct 2013 09:14:29 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, ebiederm@xmission.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: move assignment to be under lock in
 sysfs_remove_dir()
Message-ID: <20131030131429.GA27632@htj.dyndns.org>
References: <20131029220939.GA23060@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029220939.GA23060@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, guys.

On Tue, Oct 29, 2013 at 03:09:39PM -0700, Greg KH wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Linus noticed that the assignment of sd isn't protected by the lock in
> sysfs_remove_dir(), so move the assignment of the variable under the
> lock to be safe.
> 
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> Tejun, any objection to this patch?  You consolidated the locks back in
> 2007 on this function, and nothing has changed there since then, so odds
> are it's not a problem, but nice to be safe, right?

IIRC, it was a lock added to specifically address race between kobject
removal and someone else symlinking to it.  In all other cases, the
rule is that the kobject owner is responsible for ensuring that
removal doesn't race against other sysfs operations on the kobject.
However, someone else linking to it didn't have any way to ensure that
kobj->sd won't be removed underneath it - it holds the target kobject
but that doesn't do anything to prevent the target's owner from
disassociating the kobject from its sysfs_dirent.

So, sysfs_assoc_lock is protecting against that specific scenario - it
guarantees that either kobj->sd is disassociated and symlinking sees
that or symlinking grabs sysfs_dirent's reference before
disassociation happens.  It addresses the one exception case of the
general "kobject owner handles exclusion among operations" rule.

Moving "sd = kobj->sd" inside the spinlock doesn't make any difference
but what we really need is a comment explaining what that odd piece of
locking is about.

Thanks.

-- 
tejun
