Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999AbaGAV5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 17:57:07 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:15057 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758882AbaGAVxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 17:53:53 -0400
X-RZG-AUTH: :OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2ejZCzW8NRdwTYefHi0JchBpEUIQvhemkXwbmc=
X-RZG-CLASS-ID: mo00
From: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To: linux-kernel@vger.kernel.org
Subject: Please review: generic brick framework + first application: asynchronous block device replication
Date: Tue,  1 Jul 2014 23:46:40 +0200
Message-Id: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi together,

after almost 20 years, I am happy to be back at the kernel hacker
community with a new project called MARS Light (Multiversion
Asynchronous Replication System).

Its application area is _different_ from DRBD:

MARS replicates generic block devices asynchronously over long distances
and through network bottlenecks, while the synchronous DRBD works best with
crossover cables (running DRBD through long-distance network bottlenecks
may lead to serious problems described in the presentation below and
also observed in practice -- however I must clearly emphasize that
I can confirm from our experiences in 1&1 datacenters that DRBD runs
very fine in appropriate short-distance scenarios -- so both systems
just have different application areas, not more, not less).

In addition, MARS can replicate to k > 2 replicas out of the box.

For a quick overview, differences to DRBD (conceptual / behavioural),
feature comparisons (also to the commercial DRBD/proxy), etc, please look
at the presentation slides from LinuxTag 2014:

https://github.com/schoebel/mars/blob/master/docu/MARS_LinuxTag2014.pdf?raw=true

...which is an extended version of my LCA2014 presentation from January
2014 where some attending kernel hackers already could get some impressions.

If you want a deeper understanding of concepts and operations, please
read the manual at

https://github.com/schoebel/mars/blob/master/docu/mars-manual.pdf?raw=true

MARS is in production at 1&1 Internet AG since March 2014.

In addition, MARS has been extensively tested with a fully automatic
test suite developed by Frank Liepold (also available at
https://github.com/schoebel/mars ). It contains more than 100 testcases.

Although the test suite has some shortcomings (many false positives
when run uncustomized/unmodified on different hardware/networks), it has
proved to me a valuable tool at least for regression testing.
Unfortunately, Frank is no longer at 1&1. When I had more time, I would
fix the test suite to make it more robust. Alternatively, help from
the community would be highly appreciated! Please contact me
by email if you are seriously interested.

The github version of MARS should be compilable out-of-tree with
elder kernels (starting at least from 2.6.32).

In contrast, the attached patches are for kernel 3.16 and should no
longer contain code for backward compatibility (as well as containing
many other code cleanups, in order to pass checkpatch.pl except
some probably false-positives and except LONG_LINE).

The github version can almost fully automatically be converted to the
(proposed) upstream version via ./rework-mars-for-upstream.pl which
not only renames some identifiers to (hopefully) better names / more
systematic naming conventions via some heavy regex magic, but also
moves files to different (configurable) locations. If anyone wants
a different location than drivers/block/mars/ (e.g. for the generic
brick framework part which doesn't really belong to "drivers" because
it /potentially/ can be used almost everywhere) it should be very
easy to adapt this.

If possible and if it makes sense, I will also fix many _systematic_
review complaints in ./rework-mars-for-upstream.pl instead of in the
C sources. ./rework-mars-for-upstream.pl starts in the out-of-tree
MARS repo (see github) from the branch WIP-BASE, and creates two
branches WIP-PORTABLE (which contains the intended future base
for the out-of-tree version) and WIP-PROPOSED-UPSTREAM (where the
code for backwards compatibility is already stripped off).
Finally, the files are transferred to the kernel repo (using
different paths) and the kernel patchset is generated
where the new files appear as starting afresh.

For some limited time (a few years), the out-of-tree repo must be
maintained in parallel to the kernel upstream, because 1&1
(and probably other people in the world) are using very old
kernels, at least for some time. My long-term goal is to freeze
the out-of-tree version some day and only maintain the in-tree
version permanently.

The attached kernel patchset (as generated by rework-mars-for-upstream.pl)
contains 4 parts which could theoretically be submitted independently
from each other, but IMHO that wouldn't make sense in order to get a
_working_ system:

1) the generic brick framework. Many concepts are from my old Athomux
research project from the University of Stuttgart. The current Linux
implementation is only "instance based", while Athomux was the first
prototype implementation of a fully "instance oriented" (IOP) system.
The future "MARS Full" is planned to make full use of IOP.

Details on IOP concepts can be found at www.athomux.net under papers/
(also look for the monography written in German if you are /very/ deeply
interested - and of course I will be happy to explain it personally
to anyone, best at a meeting opportunity).

2) the first framework personality called "XIO" (eXtended IO), conceptually
similar to AIO, conceptually a true superset of BIO.

3) the first application "MARS Light" which uses the XIO personality.

Notice that 1) to 3) make _no_ _modifications_ to any other parts of
the kernel! They just reside in their own subdirectory, each.

IMHO, 1) to 2) potentially form a new subsystem in the kernel. Of course,
there might be different opinions on that, so I prefer starting with a
small version containing only the needed things for MARS, and later
moving / extending it only when needed.

4) only 2 patches (the last two ones in the patchset) which should make only
_trivial_ modifications to the rest of the kernel: mostly some additional
EXPORT_SYMBOL() and of course some 1-liners for Kconfig and Makefile.

The attached version for item 4) is the so-called "generic" pre-patch
which is also needed for out-of-tree builds with elder kernels.
The current version of MARS can only be compiled as a module
(if needed, this restriction could be overcome some day).

Please, if possible, include this pre-patch (or a substitute) more quickly
if the main code review would take a longer time. You would help me
establishing MARS more widely in the world / at Linux distros
via the out-of-tree version.

It would be great if maintainers for elder *.y kernel branches would
also include the corresponding pre-patch for their version, this
would help me _greatly_. Specialized versions for elder kernels can be
found at github in the pre-patches/ subdirectory.

The "generic" pre-patch generically calls EXPORT_SYMBOL() on all
sys_*() functions, instead of marking only the needed ones. IMHO,
this has the advantage that no maintainance is needed whenever some
future extension of MARS (or any other external kernel modules) need
dynamic linking on such a symbol. Of course, it has the disadvantage
of growing the symbol table. IMHO, the sys_* are _anyway_ standardized
by POSIX and other standards, forming one of the most stable APIs in the
world. So there should be no other drawback when mass exporting those
symbols - even better than exporting any other kernel symbol.

If the "generic" version of the pre-patch is objected / rejected
for any reason, I will happily provide you a new version exporting only
the needed symbols.

Although I am very busy working at 1&1 (not always on MARS),
I will try to answer all your questions in the next time.

I would be glad to get invited to the Kernel Summit, and I would
like to meet some old friends again from ancient times when I was
active in the community, but sadly lost connection due to fateful
private reasons.

Thanks and cheers,

Thomas

