Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbaGHWNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 18:13:40 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:51140 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaGHWNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 18:13:39 -0400
Date: Wed, 9 Jul 2014 02:13:36 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RFC 2/2] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP operation
Message-ID: <20140708221336.GL17860@moon.sw.swsoft.com>
References: <20140703143318.568554771@openvz.org>
 <20140703151102.842945837@openvz.org>
 <20140708190849.GC17860@moon.sw.swsoft.com>
 <20140708143830.ea078ef01e1d7d31276edbcd@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708143830.ea078ef01e1d7d31276edbcd@linux-foundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 02:38:30PM -0700, Andrew Morton wrote:
> On Tue, 8 Jul 2014 23:08:49 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > Ping. Guys, any commens please?
> 
> Well, allowing a process to modify pretty deep internals like this is
> always scary from a security point of view, and now we're removing
> CAP_SYS_RESOURCE protections.  Yikes.  Convince me we aren't handing
> out root here.
> 
> The changelog doesn't make it clear (to me) why this is actually being
> done.  criu runs unprivileged?  What's the requirement here?

It comes from user-ns, we are almost ready to support c/r for user
namespaces and faced a problem -- when we create new user-namespace
we loose CAP_SYS_RESOURCE bit and criu fails to proceed. Andrew
Vagin was implementing user-ns in criu and as far as I remember
there were a talk with Eric which (again if my memory doesn't
betray me) end up in -- guys, simply do proper check for values
you read from user space instead of relying on CAP_SYS_RESOURCE.
Erik, am I right?

Probably I should walk over _every_ member we're modifying
explaning where exactly is used in kernel.

Still the good news about all this members we modify -- they are used
for statistics mostly except brk/stack related members but they
are checked very carefully to not exceed the limits (if the
limits are set).

> struct prctl_mm_map could do with a nice comment explaining its role in
> the world.

ok, i'll update

> I'm not seeing a coherent description of the proposed userspace
> interface.  We'll eventually want to update the prctl manpage for this,
> so how about laying out all the needed details now, at patch review
> time so we can see what is proposed.

Sure, I'll write more descriptive comment since original "It takes
a pointer of prctl_mm_map structure which carries all members to be
updated" is too short.

> 
> Why isn't the newly-added code under #ifdef CONFIG_CHECKPOINT_RESTORE?

Initially all prctl set-mm opcodes were CONFIG_CHECKPOINT_RESTORE
guarded but then assumed that such modification might be
needed not only for criu but other tools as well and this #ifdef
were dropped off. Now new PR_SET_MM_MAP is a part of old
interface so I'm not sure if it should be CONFIGed. That
said it is not a problem to wrap it but looks unreasonable
in this particular case.
