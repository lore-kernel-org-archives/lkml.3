Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821Ab3E3B2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 21:28:32 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42494 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab3E3B2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 21:28:24 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyiOR=2o7BWQXcb-7_YULXbr+SuzoOeGQxV4cmck1y8Ow@mail.gmail.com>
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com>
	<CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com>
	<20130525165710.GC25399@ZenIV.linux.org.uk>
	<51A1040A.80003@schaufler-ca.com>
	<CA+55aFw1RLrMsvkG+yHfHw4ht5BcC7Q39qXDD2dyUp9+_HsSLA@mail.gmail.com>
	<alpine.LRH.2.02.1305261503510.7712@tundra.namei.org>
	<CA+55aFyiOR=2o7BWQXcb-7_YULXbr+SuzoOeGQxV4cmck1y8Ow@mail.gmail.com>
Date: Wed, 29 May 2013 18:28:23 -0700
Message-ID: <CACLa4ptBVHwrruB-WeVKfPYoyAVH6ys4bEHhHTp6RyhqAw0vHg@mail.gmail.com>
Subject: Re: Stupid VFS name lookup interface..
From: Eric Paris <eparis@parisplace.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>, Casey Schaufler <casey@schaufler-ca.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 10:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, May 25, 2013 at 10:04 PM, James Morris <jmorris@namei.org> wrote:
>> On Sat, 25 May 2013, Linus Torvalds wrote:
>>
>>> But I haven't even looked at what non-selinux setups do to
>>> performance. Last time I tried Ubuntu (they still use apparmor, no?),
>>> "make modules_install ; make install" didn't work for the kernel, and
>>> if the Ubuntu people don't want to support kernel engineers, I
>>> certainly am not going to bother with them. Who uses smack?
>>
>> Tizen, perhaps a few others.
>
> Btw, it really would be good if security people started realizing that
> performance matters. It's annoying to see the security lookups cause
> 50% performance degradations on pathname lookup (and no, I'm not
> exaggerating, that's literally what it was before we fixed it - and
> no, by "we" I don't mean security people).

I take a bit of exception to this.  I do care.  Stephen Smalley, the
only other person who does SELinux kernel work, cares.  I don't speak
for other LSMs, but at least both of us who have done anything with
SELinux in the last years care.  I did the RCU work for selinux and
you, sds, and I did a bunch of work to stop wasting so much stack
space which was crapping on performance.  And I'm here again   :)

> Right now (zooming into the kernel only - ignoring the fact that make
> really spends a fair amount of time in user space) I get
>
>   9.79%      make  [k] __d_lookup_rcu
>   5.48%      make  [k] link_path_walk
>   2.94%      make  [k] avc_has_perm_noaudit
>   2.47%      make  [k] selinux_inode_permission
>   2.25%      make  [k] path_lookupat
>   1.89%      make  [k] generic_fillattr
>   1.50%      make  [k] lookup_fast
>   1.27%      make  [k] copy_user_generic_string
>   1.17%      make  [k] generic_permission
>   1.15%      make  [k] dput
>   1.12%      make  [k] inode_has_perm.constprop.58
>   1.11%      make  [k] __inode_permission
>   1.08%      make  [k] kmem_cache_alloc
>   ...

I tried something else, doing caching of the last successful security
check inside the isec.  It isn't race free, so it's not ready for
prime time.  But right now my >1% looks like:

  7.97%          make  [k] __d_lookup_rcu
  5.79%          make  [k] link_path_walk
  3.67%          make  [k] selinux_inode_permission
  2.02%          make  [k] lookup_fast
  1.90%          make  [k] system_call
  1.76%          make  [k] path_lookupat
  1.68%          make  [k] inode_has_perm.isra.45.constprop.61
  1.53%          make  [k] copy_user_enhanced_fast_string
  1.39%          make  [k] generic_permission
  1.35%          make  [k] kmem_cache_free
  1.30%          make  [k] __audit_syscall_exit
  1.13%          make  [k] kmem_cache_alloc
  1.00%          make  [k] strncpy_from_user

How do I tell what is taking time inside selinux_inode_permission?
