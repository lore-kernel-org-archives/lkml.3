Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3EZSRV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 14:17:21 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:35563 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab3EZSRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 14:17:20 -0400
MIME-Version: 1.0
In-Reply-To: <51A24D9B.50104@schaufler-ca.com>
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com>
	<CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com>
	<20130525165710.GC25399@ZenIV.linux.org.uk>
	<51A1040A.80003@schaufler-ca.com>
	<CA+55aFw1RLrMsvkG+yHfHw4ht5BcC7Q39qXDD2dyUp9+_HsSLA@mail.gmail.com>
	<alpine.LRH.2.02.1305261503510.7712@tundra.namei.org>
	<CA+55aFyiOR=2o7BWQXcb-7_YULXbr+SuzoOeGQxV4cmck1y8Ow@mail.gmail.com>
	<51A24D9B.50104@schaufler-ca.com>
Date: Sun, 26 May 2013 11:17:18 -0700
X-Google-Sender-Auth: SJFkWJAZW2LZ0bynEDMypxKDRAc
Message-ID: <CA+55aFyAW5tGqZA8kx7kMrMp0Zm0H1ohXVM4thZPOcnZeoosSg@mail.gmail.com>
Subject: Re: Stupid VFS name lookup interface..
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 10:59 AM, Casey Schaufler
<casey@schaufler-ca.com> wrote:
>
> The whole secid philosophy comes out of the need to keep security out
> of other people's way. It has performance impact. Sure, SELinux
> hashes lookups, but a blob pointer gets you right where you want to be.
> When we are constrained in unnatural ways there are going to be
> consequences. Performance is one. Code complexity is another.

Quite frankly, I'd like to possibly introduce a cache of security
decisions at least for the common filesystem operations (and the
per-pathcomponent lookup is *the* most common one, but the per-stat
one is pretty bad too), and put that cache at the VFS level, so that
the security people can *not* screw it up, and so that we don't call
down to the security layer at all 99% of the time.

Once that happens, we don't care any more what security people do.

It has been how we have fixed performance problems for filesystems
every single time. It's simply not possible to have a generic
interface to 50+ different filesystems and expect that kind of generic
interface to be high-performance - but when we've been able to
abstract it out as a cache in front of the filesystem operations, it
is suddenly quite reasonable to spend a lot of effort making that
cache go fast like a bat out of hell.

It started with the dentry cache and the page cache, but we now do the
POSIX ACL's that way too, because it just wasn't reasonable to call
down to the filesystem to look up ACL's and have all the complex "we
do this with RCU locks held" semantics.

Is there something similar we could do for the security layer? We
don't have 50+ different security models, but we do have several. If
the different security modules could agree on some kind of generic
"security ID" model so that we could cache things (see fs/namei.c and
get_cached_acl_rcu() for example), it would be a great thing.

Then selinux could get rid of it's hashed lookups entirely, because
that whole "cache the security ID" would be handled by generic code.

But that *would* require that there would be some abstract notion of
security ID/context that we could use in generic code *WITHOUT* the
need to call down the the security subsystem.

The indirect calls are expensive, but they are expensive not because
an indirect call itself is particularly expensive (although that's
true on some architectures too), but because the whole notion of "I'm
calling down to the lower-level non-generic code" means that we can't
do inlining, we can't optimize locking, we can't do anything clever.

My selinux patch kept the indirect call, but at least made it cheap.
Could we do even better? And keep it generic?

Btw, if we can do something like that, then nested security modules
likely get much easier to do too, because the nesting would all be
behind the cache. Once it's behind the cache, it doesn't matter if
we'd need to traverse lists etc. The hot case would be able to ignore
it all.

                  Linus
