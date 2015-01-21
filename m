Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750840AbbAUFJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 00:09:11 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:48896 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbbAUFJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 00:09:09 -0500
X-Originating-IP: 50.43.58.154
Date: Tue, 20 Jan 2015 21:08:58 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Iulia Manda <iulia.manda21@gmail.com>, serge.hallyn@canonical.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, mhocko@suse.cz
Subject: Re: [PATCH] kernel: Conditionally support non-root users, groups and
 capabilities
Message-ID: <20150121050857.GA1752@thin>
References: <20150120233308.GA6256@winterfell>
 <54BEED2C.2000000@schaufler-ca.com>
 <20150121005006.GA1217@thin>
 <54BEFF7A.1000709@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BEFF7A.1000709@schaufler-ca.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 05:23:06PM -0800, Casey Schaufler wrote:
> On 1/20/2015 4:50 PM, Josh Triplett wrote:
> > On Tue, Jan 20, 2015 at 04:05:00PM -0800, Casey Schaufler wrote:
> >> On 1/20/2015 3:33 PM, Iulia Manda wrote:
> >>> There are a lot of embedded systems that run most or all of their functionality
> >>> in init, running as root:root. For these systems, supporting multiple users is
> >>> not necessary.
> >>>
> >>> This patch adds a new symbol, CONFIG_NON_ROOT, that makes support for non-root
> >>> users, non-root groups, and capabilities optional.
> >>>
> >>> When this symbol is not defined, UID and GID are zero in any possible case
> >>> and processes always have all capabilities.
> >>>
> >>> Also, the following syscalls are compiled out: setuid, setregid, setgid,
> >>> setreuid, setresuid, getresuid, setresgid, getresgid, setgroups, getgroups,
> >>> setfsuid, setfsgid, capget, capset.
> >>>
> >>> This change saves about 25 KB on a defconfig build.
> >>>
> >>> Bloat-o-meter output:
> >>> add/remove: 7/66 grow/shrink: 21/421 up/down: 1701/-27172 (-25471)
> >>>
> >>> Signed-off-by: Iulia Manda <iulia.manda21@gmail.com>
> >>> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> >> Authoritative LSM hooks were loudly rejected in or about 1999.
> >> One of the primary reasons they were rejected was because you could
> >> use them do exactly what this patch does, which is to remove the basic
> >> Linux security policy. If attitudes have changed sufficiently that
> >> removing the "classic" security behavior is now deemed acceptable,
> >> I propose that we reintroduce the option of authoritative LSM hooks
> >> instead. That would give you all this saving, and probably more.
> > Wouldn't authoritative LSM hooks require *adding* the necessary hook
> > logic, along with a hook module implementing such a policy?  Unless
> > you're suggesting that compiling in LSM hooks without any providers
> > would result in this behavior by default, which seems rather
> > questionable.
> 
> The proposed default configuration would have included hooks implementing the
> traditional UNIX/Linux discretionary access controls and Super User. Proposed
> alternative configurations allowed the addition of POSIX capabilities, B&L MAC
> and that new kid on the block, FLASK.
> 
> Your configuration would have required trivial "return success" policy functions,
> much like what you find in security/capability.c today.

It's entirely possible that kernel developers are willing to
accept a CONFIG_NON_ROOT=n policy but are still opposed to authoritative
LSM hooks.  Not every mechanism needs to be expanded and abstracted to
cover the most general possible form.  On the contrary, simple solutions
tend to go over better unless there's a strong push for a whole family
of use cases that require a more complex solution.  And I haven't seen
any kind of push for authoritative LSM hooks for years.

I appreciate that you'd be interested in an opportunity to revive
authoritative LSM hooks, and you're welcome to write the much larger
patch doing so.  That's not by itself an argument against a much simpler
solution with existing code that solves the use case at hand.

On top of that, unless that mechanism supported selecting a single such
(lack of) policy at compile time and turning it into static inlines,
even trivial policy functions would not actually get compiled away into
nothing along with all the hundreds of conditionals calling them.

> > Also note that this is compiling out the entire family of UID/GID system
> > calls, which LSM hooks could not do.
> 
> Which breaks backward compatibility.

Like half of the other options under CONFIG_EXPERT, as well as some that
aren't.  If you turn off Kconfig options designed to disable syscalls,
you'll get a kernel that returns -ENOSYS for those syscalls, as
requested.  That doesn't break backward compatibility; leave the option
enabled if you need those syscalls.

> > In any case, I see two major problems with authoritative LSM hooks that
> > this patch avoids:
> >
> > First, simplicity: I doubt authoritative LSM hooks could match this
> > diffstat:
> >
> >>>  include/linux/capability.h |   12 ++++++++++++
> >>>  include/linux/uidgid.h     |   12 ++++++++++++
> >>>  init/Kconfig               |   19 ++++++++++++++++++-
> >>>  kernel/capability.c        |    6 ++++++
> >>>  kernel/groups.c            |    4 ++++
> >>>  kernel/sys.c               |    2 ++
> >>>  kernel/sys_ni.c            |   14 ++++++++++++++
> >>>  7 files changed, 68 insertions(+), 1 deletion(-)
> 
> The size of the diffstat is no indication of the value of a change.
> You're using a trivial amount of ifdefing to implement a very significant change.

(Please note that I'm not the author of the change, just a proponent and
reviewer.  I don't wish to take credit for someone else's work here,
though I'm happy to shoulder blame/flame for the idea.)

And yes, indeed, this is a significant change with a mercifully small
diffstat.  The ones with much larger diffstats tend to get rather poor
responses, and suggestions that the compiler should be made to do more
of the work by providing appropriate inline stubs.  This is the first
time I've seen a complaint that a change is too *small*.

> > Second, code size reduction: In addition to the concern above about
> > adding hooks rather than removing code, this patch allows
> > constant-folding away huge amounts of code, which any kind of "hook"
> > mechanism would have a hard time doing.  This patch lets the compiler do
> > almost all of the work.  Notice the "66 shrink" and "421 down" in the
> > bloat-o-meter summary.
> 
> Yes, we all know (or should) that you can reduce the size of a change using

I'm not talking about reducing the size of the *change* here.  I'm
talking about reducing the size of the compiled code.  The full
bloat-o-meter output shows hundreds of functions each becoming smaller,
generally because blocks like "if (!capable(...)) { ... }" went away
entirely.

> > The intent here is not to open the door to arbitrary replacement
> > security policies.  The intent is to simply add a compile-time option to
> > compile *out* security policies entirely, for systems that will not only
> > never call setuid but in many cases never even call fork.
> 
> You are opening the door to creating a "Linux" kernel that does not
> behave like Linux. This has been seriously considered and flat out rejected
> in the past.

Reiterating my explanation from the last time this came up:

"""it's been our standard practice for ages.  We started down that road
long, long ago, when we first introduced Kconfig and optional/modular
features.  /dev/* are user-facing interfaces, yet you can compile them
out or make them modular.  /sys/* and/proc/* are user-facing interfaces,
yet you can compile part or all of them out.  Filesystem names passed to
mount are user-facing interfaces, yet you can compile them out.  (Not
just things like ext4; think FUSE or overlayfs, which some applications
will build upon and require.)  Some prctls are optional, new syscalls
like BPF or inotify or process_vm_{read,write}v are optional, hardware
interfaces are optional, control groups are optional, containers and
namespaces are optional, checkpoint/restart is optional, KVM is
optional, kprobes are optional, kmsg is optional, /dev/port is optional,
ACL support is optional, USB support (as used by libusb) is optional,
sound interfaces are optional, GPU interfaces are optional, even futexes
are optional."""

A fair bit of POSIX and other standard interfaces can already be
compiled out.

So what's this about "not behaving like Linux"?  Linux is whatever lives
in linux.git; it's a lot more capable these days, and that doesn't just
mean *adding* features.  The alternative to a tinier Linux isn't a
larger Linux, it's non-Linux embedded OSes that behave *nothing* like
Linux because they're *not Linux*.

> Again, attitudes may have changed since the turn of the century.  If
> they have, we should do a real job of allowing the existing policy to
> be changed

To the extent there was ever a policy about not compiling out code, that
policy was changed long ago.  If you're looking to change policies about
authoritative LSM hooks and what security frameworks can do:

return -ETOOMANYWINDMILLS;

- Josh Triplett
