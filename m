Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaDGKnA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 06:43:00 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47600 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbaDGKm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 06:42:57 -0400
Date: Mon, 7 Apr 2014 06:42:16 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hans-Bernhard =?iso-8859-1?Q?Br=F6ker?= 
	<broeker@users.sourceforge.net>,
        Hans-Bernhard Broeker <broeker@physik.rwth-aachen.de>,
        Neil Horman <nhorman@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        cscope-devel@lists.sourceforge.net
Subject: Re: cscope: issue with symlinks in
 tools/testing/selftests/powerpc/copyloops/
Message-ID: <20140407104216.GB5287@hmsreliant.think-freely.org>
References: <1396530975.4361.28.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396530975.4361.28.camel@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 03:16:15PM +0200, Yann Droneaud wrote:
> Hi,
> 
> I'm using cscope to browse kernel sources, but I'm facing warnings from
> the tool since following commit:
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=22d651dcef536c75f75537290bf3da5038e68b6b
> 
>     commit 22d651dcef536c75f75537290bf3da5038e68b6b
>     Author: Michael Ellerman <mpe@ellerman.id.au>
>     Date:   Tue Jan 21 15:22:17 2014 +1100
> 
>     selftests/powerpc: Import Anton's memcpy / copy_tofrom_user tests
>     
>     Turn Anton's memcpy / copy_tofrom_user test into something that can
>     live in tools/testing/selftests.
>     
>     It requires one turd in arch/powerpc/lib/memcpy_64.S, but it's 
>     pretty harmless IMHO.
>     
>     We are sailing very close to the wind with the feature macros. We 
>     define them to nothing, which currently means we get a few extra 
>     nops and include the unaligned calls.
>     
>     Signed-off-by: Anton Blanchard <anton@samba.org>
>     Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>     Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> 
> 
> cscope reports error when generating the cross-reference database:
> 
>     $ make ALLSOURCE_ARCHS=all O=./obj-cscope/ cscope
>       GEN     cscope
>     cscope: cannot find
> file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/copyuser_power7.S
>     cscope: cannot find
> file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/memcpy_64.S
>     cscope: cannot find
> file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/memcpy_power7.S
>     cscope: cannot find
> file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/copyuser_64.S
> 
> And when calling cscope from ./obj-cscope/ directory, it reports errors
> too.
> 
> Hopefully it doesn't stop it from working, so I'm still able to use
> cscope to browse kernel sources.
> 
No, it won't stop it from working, it just won't search those files.  I don't
recall exactly the reason, but IIRC there was a big discussion long ago about
symlinks and our ability to support them (around version 1.94 I think).  We
decided to not handle symlinks, as they would either point outside our search
tree, which we didn't want to include, or would point to another file in the
search tree, which made loading them pointless (as we would cover the search in
the pointed file).

Neil

> It's a rather uncommon side effect of having (for the first time ?)
> sources files as symlinks: looking for symlinks in the kernel sources
> returns only:
> 
>     $ find . -type l
>     ./arch/mips/boot/dts/include/dt-bindings
>     ./arch/microblaze/boot/dts/system.dts
>     ./arch/powerpc/boot/dts/include/dt-bindings
>     ./arch/metag/boot/dts/include/dt-bindings
>     ./arch/arm/boot/dts/include/dt-bindings
>     ./tools/testing/selftests/powerpc/copyloops/copyuser_power7.S
>     ./tools/testing/selftests/powerpc/copyloops/memcpy_64.S
>     ./tools/testing/selftests/powerpc/copyloops/memcpy_power7.S
>     ./tools/testing/selftests/powerpc/copyloops/copyuser_64.S
>     ./obj-cscope/source
>     ./Documentation/DocBook/vidioc-g-sliced-vbi-cap.xml
>     ./Documentation/DocBook/vidioc-decoder-cmd.xml
> ...
>     ./Documentation/DocBook/media-func-ioctl.xml
>     ./Documentation/DocBook/vidioc-enumoutput.xml
> 
> 
> So one can wonder if having symlinked sources files is an expected
> supported feature for kbuild and all the various kernel
> tools/infrastructure ?
> 
> Regarding cscope specifically, it does not support symlink, and it's the
> expected behavior according to the bug reports I was able to find:
> 
> #214 cscope ignores symlinks to files 
> http://sourceforge.net/p/cscope/bugs/214/
> 
> #229 -I options doesn't handle symbolic link
> http://sourceforge.net/p/cscope/bugs/229/
> 
> #247 cscope: cannot find file 
> http://sourceforge.net/p/cscope/bugs/247/
> 
> #252 cscope: cannot find file *** 
> http://sourceforge.net/p/cscope/bugs/252/
> 
> #261 Regression - version 15.7a does not follow symbolic links 
> http://sourceforge.net/p/cscope/bugs/261/
> 
> 
> Regards.
> 
> -- 
> Yann Droneaud
> OPTEYA
> 
> 
> 
