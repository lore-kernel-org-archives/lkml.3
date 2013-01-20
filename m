Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab3ATDM5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 22:12:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50143 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242Ab3ATDM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 22:12:56 -0500
Date: Sun, 20 Jan 2013 03:12:53 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Issues with "x86, um: switch to generic fork/vfork/clone" commit
Message-ID: <20130120031253.GO4939@ZenIV.linux.org.uk>
References: <50F3D2F2.3080200@6wind.com>
 <20130119063808.GN4939@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130119063808.GN4939@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 06:38:08AM +0000, Al Viro wrote:
> > [   64.313636] kbd[2563]: segfault at 9fe ip 000009fe sp b758293c
> > error 4 in dash[8048000+18000]
> > 
> > After bisecting, the following commit seems responsible:
> > 1d4b4b2994b5fc208963c0b795291f8c1f18becf (x86, um: switch to generic
> > fork/vfork/clone)
> 
> Er...  Bisect of the guest kernel, I take it?  Could you check if building
> the guest !SMP affects anything?

OK...  I think I understand what's going on.  We need asmlinkage_protect
in sys_clone() ;-/  For what it's worth, I really wonder if we ought to
treat that as syscall wrappers - i.e. have SYSCALL_DEFINEx on i386 add
a wrapper that would do asmlinkage_protect itself.  IMO it's the same kind
of thing as argument normalization handled by syscall wrappers - we make
sure that C function plays well with what asm glue is doing and expecting.

Anyway, the following seems to fix the problem here (and yes, I could reproduce
it with your config); could you verify that it fixes things on your setup?
If it does, this sucker should go into mainline and -stable...

diff --git a/kernel/fork.c b/kernel/fork.c
index a31b823..e05cff2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1660,8 +1660,10 @@ SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 		 int, tls_val)
 #endif
 {
-	return do_fork(clone_flags, newsp, 0,
-		parent_tidptr, child_tidptr);
+	long ret = do_fork(clone_flags, newsp, 0, parent_tidptr, child_tidptr);
+	asmlinkage_protect(5, ret, clone_flags, newsp,
+			parent_tidptr, child_tidptr, tls_val);
+	return ret;
 }
 #endif
 
