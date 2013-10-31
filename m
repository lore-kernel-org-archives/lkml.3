Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab3JaPC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 11:02:57 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:33067 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220Ab3JaPC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 11:02:56 -0400
Date: Thu, 31 Oct 2013 11:02:52 -0400
From: Tejun Heo <tj@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: WTF: driver-core-next contains recursive directory removal!
Message-ID: <20131031150252.GA11698@mtj.dyndns.org>
References: <8761sexu2l.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8761sexu2l.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Eric.

On Wed, Oct 30, 2013 at 03:38:58PM -0700, Eric W. Biederman wrote:
> Please pull out that crap it has no business ever going into a stable
> kernel.

Can you please calm down a bit?  It's becoming pretty difficult to
take your opinions as technical especially as all the points you're
raising had already been discussed before without you providing much
meat to it.  I'll just go over all the points in the thread and
reiterate what was discussed before just in case.

> The short version is unless someone has drastically changed pci hotplug
> since last time I looked the code is dramatically wrong as pci hotplug
> removes directories in the wrong order remove the parent first.

We already discussed this.  kobject sysfs interface code holds onto
its sysfs_dirent until the kobject itself is removed.  Given that the
existing sysfs interface doesn't even provide sd based interface for
files or subdirectories (all removals are by dir + name), this
shouldn't break anything.  Even if removal order is reversed, the only
behavior change would be that a kobj would be disconnected from the
hierarchy if one of parent is removed before it.  I can't think of a
scenario where that'd lead to an explosion.  Even in the very unlikely
case this causes an actual problem, I can't see how this would be
something too difficult to rectify.

> So now we have sysfs code that is remove directories multiple times, and
> we just finished the conversation about sysfs_assoc_lock where Tejun was
> just explaining how multiple removal of kobjects is not safe.

No, you're completely misunderstanding what I said in the thread.
Multiple *concurrent* removal invocations on the same kobject is
unsafe (no intrinsic reason for it to be that way tho) becaues of the
way kobj <-> sysfs association is handled - it's about synchronizing
conflicting operations to the same sysfs_diernt.  The sysfs hierarchy
proper has always been fully protected by sysfs_mutex.  There's
nothing racy about recursive removal.  In fact, we've been doing
partial recursive removal for a very long time now.

> This sysfs semantic change is an unmaintainable disaster.

That's a very strong statement without matching backing arguments.
AFAICS, most, if not all, of your arguments stem either from
misunderstanding or heavily handwavy.  I'll continue on the thread.

> Linus if you would be so kind as to not merge this disaster when the
> merge window opens I would very much appreciate it.

Nice going.

-- 
tejun
