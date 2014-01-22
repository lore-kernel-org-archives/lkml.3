Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaAVTIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:08:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbaAVTIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:08:23 -0500
Date: Wed, 22 Jan 2014 19:08:16 +0000
From: Mel Gorman <mgorman@suse.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>, gnome@rvzt.net,
        drawoc@darkrefraction.com, alan@lxorguk.ukuu.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 67651] Bisected: Lots of fragmented mmaps cause gimp to fail in
 3.12 after exceeding vm_max_map_count
Message-ID: <20140122190816.GB4963@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill,

Gimp is broken due to a kernel bug included in 3.12. It cannot open
large files without failing memory allocations due to exceeding
vm.max_map_count. The relevant bugzilla entries are

https://bugzilla.kernel.org/show_bug.cgi?id=67651
https://bugzilla.gnome.org/show_bug.cgi?id=719619#c0

They include details on how to reproduce the issue. In my case, a
failure shows messages like this

	(gimp:11768): GLib-ERROR **: gmem.c:110: failed to allocate 4096 bytes

	(file-tiff-load:12038): LibGimpBase-WARNING **: file-tiff-load: gimp_wire_read(): error
	xinit: connection to X server lost

	waiting for X server to shut down
	/usr/lib64/gimp/2.0/plug-ins/file-tiff-load terminated: Hangup
	/usr/lib64/gimp/2.0/plug-ins/script-fu terminated: Hangup
	/usr/lib64/gimp/2.0/plug-ins/script-fu terminated: Hangup

X-related junk is there was because I was using a headless server and
xinit directly to launch gimp to reproduce the bug.

Automated bisection using mmtests (https://github.com/gormanm/mmtests)
and the configuration file configs/config-global-dhp__gimp-simple (needs
local web server with a copy of the image file) identified the following
commit. Test case was simple -- try and open the large file described in
the bug. I did not investigate the patch itself as I'm just reporting
the results of the bisection. If I had to guess, I'd say that VMA
merging has been affected.

d9104d1ca9662498339c0de975b4666c30485f4e is the first bad commit
commit d9104d1ca9662498339c0de975b4666c30485f4e
Author: Cyrill Gorcunov <gorcunov@gmail.com>
Date:   Wed Sep 11 14:22:24 2013 -0700

    mm: track vma changes with VM_SOFTDIRTY bit
    
    Pavel reported that in case if vma area get unmapped and then mapped (or
    expanded) in-place, the soft dirty tracker won't be able to recognize this
    situation since it works on pte level and ptes are get zapped on unmap,
    loosing soft dirty bit of course.
    
    So to resolve this situation we need to track actions on vma level, there
    VM_SOFTDIRTY flag comes in.  When new vma area created (or old expanded)
    we set this bit, and keep it here until application calls for clearing
    soft dirty bit.
    
    Thus when user space application track memory changes now it can detect if
    vma area is renewed.
    
    Reported-by: Pavel Emelyanov <xemul@parallels.com>
    Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
    Cc: Andy Lutomirski <luto@amacapital.net>
    Cc: Matt Mackall <mpm@selenic.com>
    Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
    Cc: Marcelo Tosatti <mtosatti@redhat.com>
    Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
    Cc: Stephen Rothwell <sfr@canb.auug.org.au>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
    Cc: Rob Landley <rob@landley.net>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

-- 
Mel Gorman
SUSE Labs
