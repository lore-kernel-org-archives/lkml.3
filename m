Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab3ALBRc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 20:17:32 -0500
Received: from ozlabs.org ([203.10.76.45]:35447 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755890Ab3ALBRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 20:17:30 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Tim Abbott <tabbott@ksplice.com>, "Tejun Heo" <tj@kernel.org>
Subject: Re: [PATCH] module, fix percpu reserved memory exhaustion
In-Reply-To: <50F01EC2.1000908@redhat.com>
References: <1357785669-31848-1-git-send-email-prarit@redhat.com> <87d2xc1itd.fsf@rustcorp.com.au> <50F01EC2.1000908@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sat, 12 Jan 2013 11:36:09 +1030
Message-ID: <87pq1byzum.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prarit Bhargava <prarit@redhat.com> writes:
> On 01/10/2013 10:48 PM, Rusty Russell wrote:
> The timing were similar.  I didn't see any huge delays, etc.  Can the
> relocations really cause a long delay?  I thought we were pretty much writing
> values to memory...

For x86 that's true, but look at what ppc64 has to do for example.  I'm
guessing you don't have a giant Nvidia proprietary driver module
loading, either.

It just makes me nervous; this kind of boot slowdown typically won't get
diagnosed for several releases, if ever.  Now I've done the work, I'm
going to apply my patch (with an additional fix: I forgot to change
kgdb, which traverses the module list too).

> [I should point out that I'm booting a 32 physical/64 logical, with 64GB of memory]

I figured it had to be something big ;)

>> We currently have PERCPU_MODULE_RESERVE set at 8k: in my 32-bit
>> allmodconfig build, there are only three modules with per-cpu data,
>> totalling 328 bytes.  So it's not reasonable to increase that number to
>> paper over this.
>
> I've been thinking about that.  The problem is that at the same time the kvm
> problem occurs I'm attempting to load a debug module that I've written to debug
> some cpu timer issues that allocates a large amount of percpu data (~.5K/cpu).
> While extending PERCPU_MODULE_RESERVE to 10k might work now, it might not work
> tomorrow if I have the need to increase the size of my log buffer.

Well, it looks like PERCPU_MODULE_RESERVE is actually very generous; it
could easily be halved.  I guess this is because dynamic per-cpu data is
now such a nice alternative (thanks to Tejun).

> <snip patch>
>
> Tested-by: Prarit Bhargava <prarit@redhat.com>
>
> Rusty, you can change that to an Acked-by if you prefer that.  I know some
> engineers prefer one over the other.  I'll also continue doing some reboot
> testing and will email back in a few days to let you know what the timing looks
> like.

There seem to be two kinds of Acked-by:

1) Acked-by: <maintainer>.  ie. "this should go through my tree, but
   it's going via someone else".  I like this: shows the normal
   maintainer is aware of the change.

2) Acked-by: <random>. ie. "I like the concept of the patch though I
   haven't actually read it or tested it".  Completely useless.

OTOH, Tested-by: means it actually fixed someone's problem.

Thanks!
Rusty.
