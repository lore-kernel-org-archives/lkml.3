Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab3EZFT4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 01:19:56 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:55893 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3EZFTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 01:19:52 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1305261503510.7712@tundra.namei.org>
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com>
	<CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com>
	<20130525165710.GC25399@ZenIV.linux.org.uk>
	<51A1040A.80003@schaufler-ca.com>
	<CA+55aFw1RLrMsvkG+yHfHw4ht5BcC7Q39qXDD2dyUp9+_HsSLA@mail.gmail.com>
	<alpine.LRH.2.02.1305261503510.7712@tundra.namei.org>
Date: Sat, 25 May 2013 22:19:51 -0700
X-Google-Sender-Auth: cOvKHPQ30prS1tdqiueJnKsrwvA
Message-ID: <CA+55aFyiOR=2o7BWQXcb-7_YULXbr+SuzoOeGQxV4cmck1y8Ow@mail.gmail.com>
Subject: Re: Stupid VFS name lookup interface..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 25, 2013 at 10:04 PM, James Morris <jmorris@namei.org> wrote:
> On Sat, 25 May 2013, Linus Torvalds wrote:
>
>> But I haven't even looked at what non-selinux setups do to
>> performance. Last time I tried Ubuntu (they still use apparmor, no?),
>> "make modules_install ; make install" didn't work for the kernel, and
>> if the Ubuntu people don't want to support kernel engineers, I
>> certainly am not going to bother with them. Who uses smack?
>
> Tizen, perhaps a few others.

Btw, it really would be good if security people started realizing that
performance matters. It's annoying to see the security lookups cause
50% performance degradations on pathname lookup (and no, I'm not
exaggerating, that's literally what it was before we fixed it - and
no, by "we" I don't mean security people).

There's a really simple benchmark that is actually fairly relevant:
build a reasonable kernel ("make localmodconfig" or similar - not the
normal distro kernel that has everything enabled) without debugging or
other crud enabled, run that kernel, and then re-build the fully built
kernel to make sure it's all in the disk cache. Then, when you don't
need any IO, and don't need to recompile anything, do a "make -j".

Assuming you have a reasonably modern desktop machine, it should take
something like 5-10 seconds, of which almost everything is just "make"
doing lots of stat() calls to see that everything is fully built. If
it takes any longer, you're doing something wrong.

Once you are at that point, just do "perf record -f -e cycles:pp make
-j" and then "perf report" on the thing.

(The "-e cycles:pp" is not necessary for the rough information, but it
helps if you then want to go and annotate the assembler to see where
the costs come from).

If you see security functions at the top, you know that the security
routines take more time than the real work the kernel is doing, and
should realize that that would be a problem.

Right now (zooming into the kernel only - ignoring the fact that make
really spends a fair amount of time in user space) I get

  9.79%      make  [k] __d_lookup_rcu
  5.48%      make  [k] link_path_walk
  2.94%      make  [k] avc_has_perm_noaudit
  2.47%      make  [k] selinux_inode_permission
  2.25%      make  [k] path_lookupat
  1.89%      make  [k] generic_fillattr
  1.50%      make  [k] lookup_fast
  1.27%      make  [k] copy_user_generic_string
  1.17%      make  [k] generic_permission
  1.15%      make  [k] dput
  1.12%      make  [k] inode_has_perm.constprop.58
  1.11%      make  [k] __inode_permission
  1.08%      make  [k] kmem_cache_alloc
  ...

so the permission checking is certainly quite noticeable, but it's by
no means dominant. This is with both of the patches I've posted, but
the numbers weren't all that different before (inode_has_perm and
selinux_inode_permission used to be higher up in the list, now
avc_has_perm_noaudit is the top selinux cost - which actually makes
some amount of sense).

So it's easy to have a fairly real-world performance profile that
shows path lookup costs on a real test.

                  Linus
