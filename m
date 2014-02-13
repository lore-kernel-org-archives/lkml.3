Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaBMHsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 02:48:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbaBMHsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 02:48:40 -0500
Date: Thu, 13 Feb 2014 08:48:17 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Noonan <steven@uplinklabs.net>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Oleg Nesterov <oleg@redhat.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Richard Henderson <rth@twiddle.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] compiler/gcc4: Add quirk for 'asm goto'
 miscompilation bug
Message-ID: <20140213074817.GT20378@tucnak.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20131012171007.GA17167@gmail.com>
 <CAKbGBLgs9t4HPD4duBt=vPaw0WfxLv5qr6pNupHsPTFaV5m+dQ@mail.gmail.com>
 <CA+55aFys_VK+q3LMRzEM-AKU-=fM_tgiDdLm2AO=jVfH7OvrHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFys_VK+q3LMRzEM-AKU-=fM_tgiDdLm2AO=jVfH7OvrHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 08:11:49PM -0800, Linus Torvalds wrote:
> Jakub, any suggestions to how Steven might be able to pinpoint where
> the code generation problem lies?

For a suspected wrong-code where you have no idea where the problem is from
debugging or oops etc., usually the best way is to bisect first at the *.o
level between (ABI compatible) objects built in a way that it works (in this
case supposedly the asm goto workaround you have in the kernel, but
generally it can be -O0 compilation, a different version of the compiler,
some other compiler flags that make the issue go away) and objects built in
a way that fails, once you narrow it down to (hopefully a single) object
where everything built the "bad" way but that single object works in the end
and everything built the "good" way but that single object fails, the next
step is to narrow it down to a single routine (unless there is e.g. just a
single asm goto left in the TU).  For that one can try e.g. optimize
attribute on selected functions, or in this case supposedly preprocessing
the file and bisecting between portions of the preprocessed file from "good"
preprocessed file (with the asm goto workarounds applied) and "bad"
preprocessed file (without them) - count the number of asm gotos there and
bisect to find which asm goto matters.  Or it is also possible to bisect
at the *.s level (easiest is to build with -fno-asynchronous-unwind-tables
-fno-exceptions -g0 if possible to decrease number of labels, build twice
("good" and "bad"), then rename the .LNNN labels in one or both files
such that they don't clash (say to .LXNNN in one file, .LYNNN in another
one) and then bisect at the function level - start with taking approximately
first half of functions from one file and second half from another file,
etc.).  When you narrow it down to function level, eyeball the assembly and
try to find out where it is wrong, or try to create a self-contained
executable testcase out of the preprocessed source (cut out everything
unneeded from the preprocessed file, keep there just the problematic routine
and everything that is inlined into it and all symbols they need, supply
from another file? a new main that calls the routine with the parameters
that cause the problem and stub all the functions it calls with something
that still reproduces it), or even just file a http://gcc.gnu.org/bugzilla/
bug with the preprocessed source, compiler options and hopefully detailed
description what to look at.

	Jakub
