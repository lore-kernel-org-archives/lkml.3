Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab3EZSs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 14:48:27 -0400
Received: from smtp105.biz.mail.gq1.yahoo.com ([98.137.12.180]:31976 "HELO
	smtp105.biz.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754786Ab3EZSs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 14:48:26 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 May 2013 14:48:26 EDT
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: a4ekpUoVM1kggUJL.wvzpi_Ta_wx5uNFqOkMDar2yxGNwqZ
 iYa79FIbrTMF2YNpOC.OcXcnMUTZk.uRJa8ZlbQjIEw5kGNqo4DCyULIrT0C
 jRo8gbzcEFdRvDNHkR_SYAseDrWRH.r_pc46EgPtYLfRuyIllrbcMfpWzvo0
 OY0cTWDkXXnLnrDiwZD9z3ejdPWpPrJykJ2oOyN3rjCmYYu16GIbTOcFF69e
 V1MOSD6NT4ctW3462D6u3qYV8M.Ll7i6NTXAJaHdo_7gV_08t0bewIkNKiKR
 esCquhkurJQPM2lnNoMwxH38Xwgm4agxI8_4H.or.PRPhOoJGcM3F1Zv2VGz
 okpSdP_WiSuku_h22zyEiPhs.yqOg_sVb8lHoyGKkZk9NEZgHS3oGtuKBRcs
 dXfPSrxLxaQX1uqDLc8PwwxO3iA0Dc1qfyz_GtGZGzr6amVnmR.28.lVgiyX
 6LxCryXWmPdaT8BJCIFXka6t_VYzcmhN3Dz3_qY1xQf4bfbcjzXym9pmClq_
 ZYKcUdLz3O4SLQr2C9So-
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@24.6.250.25 with plain)
        by smtp105.biz.mail.gq1.yahoo.com with SMTP; 26 May 2013 11:41:44 -0700 PDT
Message-ID: <51A25767.4050407@schaufler-ca.com>
Date: Sun, 26 May 2013 11:41:43 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: James Morris <jmorris@namei.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        LSM <linux-security-module@vger.kernel.org>
Subject: Re: Stupid VFS name lookup interface..
References: <CA+55aFyKg=m=USnRmFQNaRB_9MWNpzdLwxr-v7X0ONaG72+nsg@mail.gmail.com> <CA+55aFw_ic=4OvH0Ys2CUjgotdbfdbuxUsx77RYEYPGrbqzbAA@mail.gmail.com> <20130525165710.GC25399@ZenIV.linux.org.uk> <51A1040A.80003@schaufler-ca.com> <CA+55aFw1RLrMsvkG+yHfHw4ht5BcC7Q39qXDD2dyUp9+_HsSLA@mail.gmail.com> <alpine.LRH.2.02.1305261503510.7712@tundra.namei.org> <CA+55aFyiOR=2o7BWQXcb-7_YULXbr+SuzoOeGQxV4cmck1y8Ow@mail.gmail.com> <51A24D9B.50104@schaufler-ca.com> <CA+55aFyAW5tGqZA8kx7kMrMp0Zm0H1ohXVM4thZPOcnZeoosSg@mail.gmail.com>
In-Reply-To: <CA+55aFyAW5tGqZA8kx7kMrMp0Zm0H1ohXVM4thZPOcnZeoosSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/26/2013 11:17 AM, Linus Torvalds wrote:
> On Sun, May 26, 2013 at 10:59 AM, Casey Schaufler
> <casey@schaufler-ca.com> wrote:
>> The whole secid philosophy comes out of the need to keep security out
>> of other people's way. It has performance impact. Sure, SELinux
>> hashes lookups, but a blob pointer gets you right where you want to be.
>> When we are constrained in unnatural ways there are going to be
>> consequences. Performance is one. Code complexity is another.
> Quite frankly, I'd like to possibly introduce a cache of security
> decisions at least for the common filesystem operations (and the
> per-pathcomponent lookup is *the* most common one, but the per-stat
> one is pretty bad too), and put that cache at the VFS level, so that
> the security people can *not* screw it up, and so that we don't call
> down to the security layer at all 99% of the time.
>
> Once that happens, we don't care any more what security people do.
>
> It has been how we have fixed performance problems for filesystems
> every single time. It's simply not possible to have a generic
> interface to 50+ different filesystems and expect that kind of generic
> interface to be high-performance - but when we've been able to
> abstract it out as a cache in front of the filesystem operations, it
> is suddenly quite reasonable to spend a lot of effort making that
> cache go fast like a bat out of hell.
>
> It started with the dentry cache and the page cache, but we now do the
> POSIX ACL's that way too, because it just wasn't reasonable to call
> down to the filesystem to look up ACL's and have all the complex "we
> do this with RCU locks held" semantics.
>
> Is there something similar we could do for the security layer? We
> don't have 50+ different security models, but we do have several. If
> the different security modules could agree on some kind of generic
> "security ID" model so that we could cache things (see fs/namei.c and
> get_cached_acl_rcu() for example), it would be a great thing.
>
> Then selinux could get rid of it's hashed lookups entirely, because
> that whole "cache the security ID" would be handled by generic code.
>
> But that *would* require that there would be some abstract notion of
> security ID/context that we could use in generic code *WITHOUT* the
> need to call down the the security subsystem.
>
> The indirect calls are expensive, but they are expensive not because
> an indirect call itself is particularly expensive (although that's
> true on some architectures too), but because the whole notion of "I'm
> calling down to the lower-level non-generic code" means that we can't
> do inlining, we can't optimize locking, we can't do anything clever.
>
> My selinux patch kept the indirect call, but at least made it cheap.
> Could we do even better? And keep it generic?

Probably, but we'll need help from people who really understand VFS,
caching and RCU.

> Btw, if we can do something like that, then nested security modules
> likely get much easier to do too, because the nesting would all be
> behind the cache. Once it's behind the cache, it doesn't matter if
> we'd need to traverse lists etc. The hot case would be able to ignore
> it all.

Indeed. It may require significant revision to the existing LSMs.

>
>                   Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

