Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422731Ab3CVTnw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 15:43:52 -0400
Received: from mail-vb0-f52.google.com ([209.85.212.52]:41139 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab3CVTnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 15:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzbV81KQh_f0=wti9=_6=PXu37z0+NJymhDvzv13GgpuA@mail.gmail.com>
References: <20130321233630.GE21522@ZenIV.linux.org.uk>
	<CA+55aFyLJ9vVm1T994EaE4tnEbV8rHj43m+cWsFFBi_qndao1A@mail.gmail.com>
	<CA+55aFyWNkOnrQ41xCAU8q5sVXdq1-u2P8n+quLY50OdiFo3Zw@mail.gmail.com>
	<20130322001257.GH21522@ZenIV.linux.org.uk>
	<CA+55aFz5Ce7h2ja0m++tENXuG-1d346VNu9N=ZKy2UfojaSf0g@mail.gmail.com>
	<20130322012208.GJ21522@ZenIV.linux.org.uk>
	<CA+55aFzPD08kJi=x8wLBi5FAjr1TqSGXWbv5KXy5Ymm0PJL0wA@mail.gmail.com>
	<20130322014037.GK21522@ZenIV.linux.org.uk>
	<20130322043715.GL21522@ZenIV.linux.org.uk>
	<CA+55aFzUobqDR0RSh8t18m32BdTvm4k7j2PCseXpFVCH_gR=Fw@mail.gmail.com>
	<20130322051817.GM21522@ZenIV.linux.org.uk>
	<CA+55aFzbV81KQh_f0=wti9=_6=PXu37z0+NJymhDvzv13GgpuA@mail.gmail.com>
Date: Fri, 22 Mar 2013 12:43:50 -0700
X-Google-Sender-Auth: -LdiSNepmMgxGL1m2xRBo-HEzUk
Message-ID: <CA+55aFwACJ+JQHMTGf7waFOygOV8NA0nRhnJVZJg6+bV_7O=4g@mail.gmail.com>
Subject: Re: [CFT] Re: VFS deadlock ?
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 10:33 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And I wonder how big of a deal the aggressive dentry deletion is.
> Maybe it's even ok to allocate/free the inodes all the time. The whole
> "get the inode hash lock and look it up there" can't be all that
> wonderful either. It takes the inode->i_lock for each entry it finds
> on the hash list, which looks horrible. I suspect our slab allocator
> isn't much worse than that, although the RCU freeing of the inodes
> could end up being problematic.

I tested this out by just having a process that keeps stat'ing the
same /proc inode over and over and over again, which should be pretty
much the worst-case situation (because we will delete the dentry after
each stat, and so we'll repopulate it for each stat)

The allocation overhead seems to be in the noise. The real costs are
all in proc_lookup_de() just finding the entry, with strlen/strcmp
being much hotter. So if we actually care about performance for these
cases, what we would actually want to do is to just cache the dentries
and have some kind of timeout instead of getting rid of them
immediately. That would get rid of the lookup costs, and in the
process also get rid of the constant inode allocation/deallocation
costs.

There was also some locking overhead, but that's also mainly
dentry-related, with the inode side being visible but not dominant.
Again, not immediately expiring the dentries would make all that just
go away.

Regardless, the patch seems to be the right thing to do. It actually
simplifies /proc, seems to fix the problem for Dave, and is small and
should be trivial to backport. I've committed it and marked it for
stable. Let's hope there won't be any nasty surprises, but it does
seem to be the simplest non-hacky patch.

                   Linus
