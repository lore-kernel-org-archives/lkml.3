Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbaE2ClT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 22:41:19 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:49436 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaE2ClS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 22:41:18 -0400
MIME-Version: 1.0
In-Reply-To: <1401329367.13555.25.camel@localhost>
References: <cover.1401327752.git.luto@amacapital.net> <ff8ecb985119c06510e2c45c078b41cd5df3aaea.1401327752.git.luto@amacapital.net>
 <1401329367.13555.25.camel@localhost>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 28 May 2014 19:40:57 -0700
Message-ID: <CALCETrWr+_fo=q+LBT-WLJGXLWK6vEeFa=KC=LSMYehi=c-r4A@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] audit: Mark CONFIG_AUDITSYSCALL BROKEN and update
 help text
To: Eric Paris <eparis@redhat.com>
Cc: Philipp Kern <pkern@google.com>, "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. J. Lu" <hjl.tools@gmail.com>,
        "security@kernel.org" <security@kernel.org>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-audit@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 7:09 PM, Eric Paris <eparis@redhat.com> wrote:
> NAK
>
> On Wed, 2014-05-28 at 18:44 -0700, Andy Lutomirski wrote:
>> Here are some issues with the code:
>>  - It thinks that syscalls have four arguments.
>
> Not true at all.  It records the registers that would hold the first 4
> entries on syscall entry, for use later if needed, as getting those
> later on some arches is not feasible (see ia64).  It makes no assumption
> about how many syscalls a function has.

What about a5 and a6?

>
>>  - It's a performance disaster.
>
> Only if you enable it.  If you don't use audit it is a single branch.
> Hardly a disaster.

It forces all syscalls into the slow path and it can do crazy things
like building audit contexts just in case actual handling of the
syscall triggers an audit condition so that the exit path can log the
syscall.  That's way worse than a single branch.

Try it: benchmark getpid on Fedora and then repeat the experiment with
syscall auditing fully disabled.  The difference is striking.

>
>>  - It assumes that syscall numbers are between 0 and 2048.
>
> There could well be a bug here.  Not questioning that.  Although that
> would be patch 1/2

Even with patch 1, it still doesn't handle large syscall numbers -- it
just assumes they're not audited.

>
>>  - It's unclear whether it's supposed to be reliable.
>
> Unclear to whom?

To me.

If some inode access or selinux rule triggers an audit, is the auditsc
code guaranteed to write an exit record?  And see below...

>
>>  - It's broken on things like x32.
>>  - It can't support ARM OABI.
>
> Some arches aren't supported?  And that makes it BROKEN?

It acts like x32 is supported.  OABI is fixable.  Admittedly, OABI not
being supported is fine, now that it's correctly disabled.

>
>>  - Its approach to freeing memory is terrifying.
>
> What?
>
> None of your reasons hold water.  Bugs need to be fixed.  Try reporting
> them...  This is just stupid.

...for reference, I've *tried* to fix the performance issues.  I've
run into all kinds of problems.

The actual context code is incredibly tangled.  It's unclear whether
it would be permissible for various rule combinations to suppress exit
records triggered by selinux.  Any effort to actually deal with this
stuff will have to deal with the fact that the audit code builds up
lots of state and frees it on syscall exit.  That means that the exit
hook needs to be actually invoked, otherwise we leak.  I was never
able to convince myself that the current code is correct wrt kernel
threads.

In summary, the code is a giant mess.  The way it works is nearly
incomprehensible.  It contains at least one severe bug.  I'd love to
see it fixed, but for now, distributions seem to think that enabling
CONFIG_AUDITSYSCALL is a reasonable thing to do, and I'd argue that
it's actually a terrible choice for anyone who doesn't actually need
syscall audit rules.  And I don't know who needs these things.

I've heard an argument that selinux benefits from this, since the
syscall exit log helps with diagnosing denials.  I think that's
absurd.  I've never found anything wrong with the denial record itself
that would be helped by seeing the syscall log.  (And there's always
syscall_get_xyz, which would cover this case splendidly with about an
order of magnitude less code.)

As I said, I'm not going to push hard for this code to be marked
BROKEN.  But I think it's rather broken, and I'm definitely not
volunteering to fix it.

--Andy
