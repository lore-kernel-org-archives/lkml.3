Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbbAUAuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 19:50:17 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:40897 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbbAUAuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 19:50:14 -0500
X-Originating-IP: 50.43.58.154
Date: Tue, 20 Jan 2015 16:50:06 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Iulia Manda <iulia.manda21@gmail.com>, serge.hallyn@canonical.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        peterz@infradead.org, mhocko@suse.cz
Subject: Re: [PATCH] kernel: Conditionally support non-root users, groups and
 capabilities
Message-ID: <20150121005006.GA1217@thin>
References: <20150120233308.GA6256@winterfell>
 <54BEED2C.2000000@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BEED2C.2000000@schaufler-ca.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 04:05:00PM -0800, Casey Schaufler wrote:
> On 1/20/2015 3:33 PM, Iulia Manda wrote:
> > There are a lot of embedded systems that run most or all of their functionality
> > in init, running as root:root. For these systems, supporting multiple users is
> > not necessary.
> >
> > This patch adds a new symbol, CONFIG_NON_ROOT, that makes support for non-root
> > users, non-root groups, and capabilities optional.
> >
> > When this symbol is not defined, UID and GID are zero in any possible case
> > and processes always have all capabilities.
> >
> > Also, the following syscalls are compiled out: setuid, setregid, setgid,
> > setreuid, setresuid, getresuid, setresgid, getresgid, setgroups, getgroups,
> > setfsuid, setfsgid, capget, capset.
> >
> > This change saves about 25 KB on a defconfig build.
> >
> > Bloat-o-meter output:
> > add/remove: 7/66 grow/shrink: 21/421 up/down: 1701/-27172 (-25471)
> >
> > Signed-off-by: Iulia Manda <iulia.manda21@gmail.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> Authoritative LSM hooks were loudly rejected in or about 1999.
> One of the primary reasons they were rejected was because you could
> use them do exactly what this patch does, which is to remove the basic
> Linux security policy. If attitudes have changed sufficiently that
> removing the "classic" security behavior is now deemed acceptable,
> I propose that we reintroduce the option of authoritative LSM hooks
> instead. That would give you all this saving, and probably more.

Wouldn't authoritative LSM hooks require *adding* the necessary hook
logic, along with a hook module implementing such a policy?  Unless
you're suggesting that compiling in LSM hooks without any providers
would result in this behavior by default, which seems rather
questionable.

Also note that this is compiling out the entire family of UID/GID system
calls, which LSM hooks could not do.

In any case, I see two major problems with authoritative LSM hooks that
this patch avoids:

First, simplicity: I doubt authoritative LSM hooks could match this
diffstat:

> >  include/linux/capability.h |   12 ++++++++++++
> >  include/linux/uidgid.h     |   12 ++++++++++++
> >  init/Kconfig               |   19 ++++++++++++++++++-
> >  kernel/capability.c        |    6 ++++++
> >  kernel/groups.c            |    4 ++++
> >  kernel/sys.c               |    2 ++
> >  kernel/sys_ni.c            |   14 ++++++++++++++
> >  7 files changed, 68 insertions(+), 1 deletion(-)

Second, code size reduction: In addition to the concern above about
adding hooks rather than removing code, this patch allows
constant-folding away huge amounts of code, which any kind of "hook"
mechanism would have a hard time doing.  This patch lets the compiler do
almost all of the work.  Notice the "66 shrink" and "421 down" in the
bloat-o-meter summary.

The intent here is not to open the door to arbitrary replacement
security policies.  The intent is to simply add a compile-time option to
compile *out* security policies entirely, for systems that will not only
never call setuid but in many cases never even call fork.

- Josh Triplett
