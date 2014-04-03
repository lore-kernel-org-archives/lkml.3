Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbaDCNQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:16:40 -0400
Received: from smtp6-g21.free.fr ([212.27.42.6]:34089 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079AbaDCNQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:16:39 -0400
Message-ID: <1396530975.4361.28.camel@localhost.localdomain>
Subject: cscope: issue with symlinks in
 tools/testing/selftests/powerpc/copyloops/
From: Yann Droneaud <ydroneaud@opteya.com>
To: Michael Ellerman <mpe@ellerman.id.au>, Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hans-Bernhard =?ISO-8859-1?Q?Br=F6ker?= 
	<broeker@users.sourceforge.net>,
        Hans-Bernhard Broeker <broeker@physik.rwth-aachen.de>,
        Neil Horman <nhorman@users.sourceforge.net>,
        Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        cscope-devel@lists.sourceforge.net
Date: Thu, 03 Apr 2014 15:16:15 +0200
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using cscope to browse kernel sources, but I'm facing warnings from
the tool since following commit:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=22d651dcef536c75f75537290bf3da5038e68b6b

    commit 22d651dcef536c75f75537290bf3da5038e68b6b
    Author: Michael Ellerman <mpe@ellerman.id.au>
    Date:   Tue Jan 21 15:22:17 2014 +1100

    selftests/powerpc: Import Anton's memcpy / copy_tofrom_user tests
    
    Turn Anton's memcpy / copy_tofrom_user test into something that can
    live in tools/testing/selftests.
    
    It requires one turd in arch/powerpc/lib/memcpy_64.S, but it's 
    pretty harmless IMHO.
    
    We are sailing very close to the wind with the feature macros. We 
    define them to nothing, which currently means we get a few extra 
    nops and include the unaligned calls.
    
    Signed-off-by: Anton Blanchard <anton@samba.org>
    Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>


cscope reports error when generating the cross-reference database:

    $ make ALLSOURCE_ARCHS=all O=./obj-cscope/ cscope
      GEN     cscope
    cscope: cannot find
file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/copyuser_power7.S
    cscope: cannot find
file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/memcpy_64.S
    cscope: cannot find
file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/memcpy_power7.S
    cscope: cannot find
file /home/ydroneaud/src/linux/tools/testing/selftests/powerpc/copyloops/copyuser_64.S

And when calling cscope from ./obj-cscope/ directory, it reports errors
too.

Hopefully it doesn't stop it from working, so I'm still able to use
cscope to browse kernel sources.

It's a rather uncommon side effect of having (for the first time ?)
sources files as symlinks: looking for symlinks in the kernel sources
returns only:

    $ find . -type l
    ./arch/mips/boot/dts/include/dt-bindings
    ./arch/microblaze/boot/dts/system.dts
    ./arch/powerpc/boot/dts/include/dt-bindings
    ./arch/metag/boot/dts/include/dt-bindings
    ./arch/arm/boot/dts/include/dt-bindings
    ./tools/testing/selftests/powerpc/copyloops/copyuser_power7.S
    ./tools/testing/selftests/powerpc/copyloops/memcpy_64.S
    ./tools/testing/selftests/powerpc/copyloops/memcpy_power7.S
    ./tools/testing/selftests/powerpc/copyloops/copyuser_64.S
    ./obj-cscope/source
    ./Documentation/DocBook/vidioc-g-sliced-vbi-cap.xml
    ./Documentation/DocBook/vidioc-decoder-cmd.xml
...
    ./Documentation/DocBook/media-func-ioctl.xml
    ./Documentation/DocBook/vidioc-enumoutput.xml


So one can wonder if having symlinked sources files is an expected
supported feature for kbuild and all the various kernel
tools/infrastructure ?

Regarding cscope specifically, it does not support symlink, and it's the
expected behavior according to the bug reports I was able to find:

#214 cscope ignores symlinks to files 
http://sourceforge.net/p/cscope/bugs/214/

#229 -I options doesn't handle symbolic link
http://sourceforge.net/p/cscope/bugs/229/

#247 cscope: cannot find file 
http://sourceforge.net/p/cscope/bugs/247/

#252 cscope: cannot find file *** 
http://sourceforge.net/p/cscope/bugs/252/

#261 Regression - version 15.7a does not follow symbolic links 
http://sourceforge.net/p/cscope/bugs/261/


Regards.

-- 
Yann Droneaud
OPTEYA


