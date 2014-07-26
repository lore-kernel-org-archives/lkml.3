Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401AbaGZUTV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 16:19:21 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:55383 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbaGZUTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 16:19:17 -0400
Date: Sat, 26 Jul 2014 22:19:14 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Debian GCC Maintainers <debian-gcc@lists.debian.org>,
        Debian Kernel Team <debian-kernel@lists.debian.org>
Subject: Re: Random panic in load_balance() with 3.16-rc
Message-ID: <20140726201914.GB21842@x4>
References: <53D064C7.5050807@daenzer.net>
 <CA+55aFyJhqiPv0kQ+51=Ei-zaAO+0JszxtnEyx-Gbto3SE00xw@mail.gmail.com>
 <53D1B1EF.7030603@daenzer.net>
 <20140725035527.GA30108@pg-vmw-gw1>
 <20140725140237.GB32669@home.goodmis.org>
 <CA+55aFzOoJzqJ=4RVPEBfscA8oRdr5Nv7fKx9aXYw2+frkuhwA@mail.gmail.com>
 <CA+55aFyHU4Gwk6ASTuOgh3eFPshkgy1s5zc4p7f01DwrYddFOw@mail.gmail.com>
 <CA+55aFxaXPqyDJv-SNu6Giy3eKCu_SY1wof1NaNnPTbtF9RbXQ@mail.gmail.com>
 <20140726193557.GA21842@x4>
 <CA+55aFyo=HVZGEYNmz9GHqLatFHiJYTviKz_dXjqCv8b_gGxBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyo=HVZGEYNmz9GHqLatFHiJYTviKz_dXjqCv8b_gGxBA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014.07.26 at 12:56 -0700, Linus Torvalds wrote:
> On Sat, Jul 26, 2014 at 12:35 PM, Markus Trippelsdorf
> <markus@trippelsdorf.de> wrote:
> >
> > But fortunately the workaround for the new inode.c bug is the same as
> > for the original bug: -fno-var-tracking-assignments.
> >
> > It would make sense to enabled it unconditionally for all debug
> > configurations for now.
> 
> So how is code generation affected - if at all? Does the whole
> "var-tracking-assignments" thing *only* matter for debug information?

Yes. It should only affect the quality of the debugging information.
If code generation is affected it is a compiler bug.

> Also, when was it introduced as an option? Can we just unconditionally
> enable it, or do we need to be careful about gcc versions?

Git blame says it was introduced:  Wed Sep 2 02:42:21 2009.

> I'd *like* a debug kernel to not differ significantly from a non-debug
> kernel. Most sane kernel developers (where "sane" is "me" by
> definition) do not tend to use debug kernels, because the debug
> overhead is absolutely disgustingly enormous at build time. But if we
> then have most users using distro kernels that had debug info enabled,
> it would be sad if code generation differences are huge.
> 
> So I'd prefer to just unconditionally add that
> "-fno-var-tracking-assignments" to the build.
> 
> I just tested it on one file (fs/dcache.c) and it made no difference
> at all for my non-debug build. Is this expected?

Yes. The option only affects -g builds.

> Because if the only effect of "-fno-var-tracking-assignments" is
> potentially slightly worse debug information for variables, I'll
> enable it in a jiffy if it fixes this code generation bug. But I'd
> like to get that confirmed.
> 
> Finally, for CONFIG_DEBUG_INFO_REDUCED, we already use
> "-fno-var-tracking". Is that a stronger version that also disables
> "var-tracking-assignments"?

Yes.

So, the option should only be enabled for debugging builds. Something
like the following should be sufficient:

diff --git a/Makefile b/Makefile
index 6b2774145d66..037b78d0f407 100644
--- a/Makefile
+++ b/Makefile
@@ -689,7 +689,7 @@ endif
 endif
 
 ifdef CONFIG_DEBUG_INFO
-KBUILD_CFLAGS	+= -g
+KBUILD_CFLAGS	+= -g -fno-var-tracking-assignments
 KBUILD_AFLAGS	+= -Wa,-gdwarf-2
 endif
 
-- 
Markus
