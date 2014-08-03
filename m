Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaHCLsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 07:48:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12689 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016AbaHCLsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 07:48:40 -0400
Date: Sun, 3 Aug 2014 13:48:33 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: Nick Krause <xerofoify@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] scatterlist.h: Change CONFIG_DEBUG_SG for ifdef
 statement in sg_set_bf
Message-ID: <20140803114832.GA31653@mguzik>
References: <1407034573-14358-1-git-send-email-xerofoify@gmail.com>
 <20140803035931.GA24059@mguzik.redhat.com>
 <CAPDOMVh16no_Lh=4cPEpXJheCU67DJJS6EBtg9AH_0yUXxXSPg@mail.gmail.com>
 <20140803050221.GA31553@mguzik>
 <CAPDOMVhmcSqAR413hA8Ro0j2x54snt9Pj5Q_VVQLtea7Xr1jBQ@mail.gmail.com>
 <CAPDOMVjvJsvFkJW7FdM+77-oh5h7WGs7=X80Vk_oScMcSA+fpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPDOMVjvJsvFkJW7FdM+77-oh5h7WGs7=X80Vk_oScMcSA+fpA@mail.gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 03, 2014 at 01:27:26AM -0400, Nick Krause wrote:
> On Sun, Aug 3, 2014 at 1:18 AM, Nick Krause <xerofoify@gmail.com> wrote:
> > I am really losing my temper with people , when all you do is tell me to work on
> > something else and don't even point me to how to build test in the kernel tree.
> > Are you stating that your every fucking change I have to build the kernel over
> > again, that is  a waste of time and you known it. Please stop telling me I can
> > do this due to a few mistakes that you and the other developers are fucking
> > over doing.
> 
> My apologizes, I misread the message boards and this was my fault. Please stop
> telling me to move away it's really get on my nerves.

Let's examine some stuff and try to reach some conclusions.

======================= last btrfs patch =======================

It is unclear what were you trying to achieve.
a) did you want to return -EOPNOTSUPP if FALLOC_FL_ZERO_RANGE or
FALLOC_FL_COLLAPSE_RANGE is encountered?
b) did you want to add support for these?

Given your commit message in the patch I presume a).

So let's examine the code:
=============
	/* Make sure we aren't being give some crap mode */
	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
		return -EOPNOTSUPP;

	if (mode & FALLOC_FL_PUNCH_HOLE)
		return btrfs_punch_hole(inode, offset, len);
=============

If you know C language you can tell this code will error out if any flag
other than FALLOC_FL_KEEP_SIZE or FALLOC_FL_PUNCH_HOLE is specified the
code will error out. So the flags you were concerned about are handled
and there is nothing to fix in that regard.

But let's say you brainfart and misread the statement. That happens to
everyone.

The next step is to test your theory. 

So what you do is you write a test program using fallocate and both good
and bad flags and verify the results. You see it errors out for the
flags you were concerned about and works fine for flags used in the
statement. Then you revisit the code and see your brainfart, case
closed.

So now let's take a look at the patch:
=============
-	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
+	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE|
+	FALLOC_FL_COLLAPSE_RANGE | FALLOC_FL_ZERO_RANGE))
 		return -EOPNOTSUPP;
=============

Well, FALLOC_FL_PUNCH_HOLE is definitely a supported flag as indicated by:
=============
        if (mode & FALLOC_FL_PUNCH_HOLE)
                return btrfs_punch_hole(inode, offset, len);
=============

But in the patch all flags (including FALLOC_FL_PUNCH_HOLE) are |'ed into
one and then used to test supportability. This alone shows the patch
cannot be correct.

======================= sg_set_buf patch =======================

Misunderstanding of the original mail and brokeness of the idea of the
patch were already stated, so let's get to testing stage. Again,
brainfarts happen and there is nothing to be concerned about.

So you do:
=============
-#ifdef CONFIG_DEBUG_SG
+#ifdef !CONFIG_DEBUG_SG
 	BUG_ON(!virt_addr_valid(buf));
 #endif
=============

$ make M=include

And do some for some other arguments as well. No failure is seen, you send
the patch.

Well, as asked previously, what makes you think you actually
compile-tested the patch? You came up with some command variations and
assumed they work as you expect them to without any evidence. This is
very dangerous.

Here is what should have happened instead:

You intentionally break sg_set_buf by putting a syntax error into the
function, for instance:

=============
 static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
                              unsigned int buflen)
 {
+       blah blah this will not compile as it is
 #ifdef CONFIG_DEBUG_SG
        BUG_ON(!virt_addr_valid(buf));
 #endif
=============

Did it break my build?
=============
$ make M=include
  Building modules, stage 2.
  MODPOST 0 modules
=============

Not only this didn't break, this does not appear to compile anything.

Now you may conclude maybe you have to try to compile actual users and
try out M=drivers/usb. If it still does not break, you know you could
not possibly hit any users. Once it breaks, you put your actual patch
and see what happens:

=============
include/linux/scatterlist.h: In function ‘sg_set_buf’:
include/linux/scatterlist.h:114:8: error: macro names must be identifiers
 #ifdef !CONFIG_DEBUG_SG
=============

Clearly, the patch is syntactically incorrect.

==============================================

All these steps are obvious to everyone who did real-world programming,
are easy to do and you definitely could perform them yourself no
problem.

You sent a lot of patches, almost all of them were broken in obvious
ways which would be detected by employing actual testing. Some of them
were harder to test in runtime, but then why were you trying to address
some obscure issue?

Most of your patches also show you didn't perform due dilligence in
understanding the code you are modifying. This happens with beginners
quite often, I definitely make such mistakes myself. Even experienced
people make mistakes, that's again nothing to be worried about.

The problem is there if you repeatedly make the same mistakes.

Let me repeat:

There is nothing wrong with creating bad code, everyone has to start
somewhere. It is wrong though to send out such code to the world over
and over again, even though recipients repeatedly tell you that:
- the patch is incorrect
AND/OR
- it does not compile
AND
- you should take a step back and focus on something less demanding for
  now

It's great you are interested in kernel development. But in order to do
it, you have to have solid programming skills. Various patches and
questions you sent over last 2 months suggest you don't have them yet.

So people advised you how to get them: userspace development.

Userspace development is well equipped with tools for beginners. It is
way easier to experiment there, there are better debugging tools,
simpler problems to solve (in fact, you can come up with approachable
toy problems at any time).

Some people were rude to you (and some of them apologized). This is
quite unfortunate, but the point still stands: kernel development is not 
a playground for people who are new to programming.

There are trivial problems here and there, but you have to find them
yourself. And it is unlikely if you are not proficient to some extent
already.

So, I strongly recommend you take the advice. The sooner the better.
You are not going to become a proficient programmer in finite time with
your current approach.

This is not a 'go away', this is an actual advice to give you a chance
to improve.

Example programs you can write for fun:
- a tcp proxy using poll, epoll and select. backend can be chosen at
  startup. implement everything yourself, do not use wrappers
- a simple shell supporting output redirection and pipes
- pick your favourite utility from and implement your own version. can
  be echo, cat, rev, kill, strings; then you can move to maybe stat, du,
  ls, chmod

I hope this helps,
-- 
Mateusz Guzik
