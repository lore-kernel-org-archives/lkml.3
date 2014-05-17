Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbaEQAvH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 20:51:07 -0400
Received: from mail.phunq.net ([184.71.0.62]:57399 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775AbaEQAvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 20:51:05 -0400
Message-ID: <5376B273.7000800@partner.samsung.com>
Date: Fri, 16 May 2014 17:50:59 -0700
From: Daniel Phillips <d.phillips@partner.samsung.com>
Reply-To: daniel@phunq.net
Organization: Samsung
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, tux3@tux3.org
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC] Tux3 for review
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We would like to offer Tux3 for review for mainline merge. We have 
prepared a new repository suitable for pulling:

https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/

Tux3 kernel module files are here:

https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/tree/fs/tux3

Tux3 userspace tools and tests are here:

https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/tree/fs/tux3/user?h=user

Repository

We are moving our development to the kernel.org tree from our standalone 
Github repository. Our history was imported from the standalone 
repository using git am. Our kernel.org tree is the usual fork of Linus 
mainline, with Tux3 kernel files on the master branch and userspace 
files in fs/tux3/user on the user branch. We maintain the user files in 
our kernel tree because Tux3 has a tighter coupling than usual between 
userspace and kernel.

Most of our kernel code also runs in userspace, for testing or as a fuse 
filesystem or as part of our userspace support. We also need to keep our 
master branch clean of userspace files. These conflicting requirements 
creates challenges for our workflow. We can't just merge from user to 
master because that would pull in userspace files to kernel, and we 
can't merge from master to user because that would pull the entire 
kernel history into our branch. The best idea we have come up with is to 
cherry-pick changes from user to master and master to user. This creates 
merge noise in our user history and requires care to avoid combining 
kernel and userspace changes in the same commit. At least, this is 
better than having two completely separate repositories. Probably. We 
would appreciate any comment on how this workflow could be improved.

For the time being, the subtree at fs/tux3 can also be used standalone. 
Run make in fs/tux3 to build a kernel module for the running kernel 
version. Run make in fs/tux3/user to build userspace commands including 
"tux3 mkfs". Run "make tests" in fs/tux3/user to run our unit tests. 
This capability might be useful for people interested in experimenting 
with Tux3 in user space, and is handy for a quick build of the user 
support without needing to pull the whole repository.

The tux3 command built in fs/tux3/user provides our support tools 
including "tux3 mkfs" and "tux3 fsck". For now, we do not build a 
standalone mkfs.tux3 and consider that a feature, not a bug, because it 
sends the message that Tux3 is for developers right now.

API changes

Tux3 does not implement any custom or extended interfaces.

Core changes

Tux3 builds without any core changes, however we do some unnatural 
things to enable that. We would like to have some core changes to clean 
this up. One is a correctness issue for mmap and three others are to 
clean up ugly workarounds. Without any core changes, mmap will be 
disabled because there is a potential for stale cache pages with 
combined file and mmap IO. I will describe them here and provide patches 
if asked:

1. mmap

Our "page fork" technique does copy-on-write on cache pages in order to 
enforce strict delta ordering, which prevents changing pages already 
under IO as a side effect. For mmap, we do the page fork in 
->page_mkwrite, which needs to be able to change the target page. 
Without this ability, we fault twice for each page_mkwrite, and we 
cannot close all races. We also have an ugly hack to export a 
page_cow_file symbol to our module without patching core.

2. Free a forked page

A forked page that goes out of scope after IO must be freed. We 
currently do that in an ugly way by polling for refcount to go to zero.

3. Cgroup interaction

We need some unexported functions to support cgroup.

4. Inode flushing

To enforce strong ordering, we flush inodes in a certain order that core 
knows nothing about. Allowing core to flush our inodes using its current 
algorithm would cause corruption. We would like a new fs-specific hook 
to call our own flushing algorithm. Without that, we replicate part of 
the core flushing code to call the tux3 flusher. Code for this is in 
commit_flusher.c and commit_flusher_hack.c. Alternatively we can try to 
improve the core flusher to meet our needs, or do both: develop a 
generic, improved flusher within Tux3 using the hook, test it a lot, 
then propose it for core. We would be more than happy to join in the 
active effort to improve the core flusher.

Style

We are not perfectly checkpatch clean. We run checkpatch like this:

    scripts/checkpatch.pl -f fs/tux3/*.[ch] --ignore 
PRINTF_L,C99_COMMENTS,SPLIT_STRING,SUSPECT_CODE_INDENT,LONG_LINE -q

With that, checkpatch still has a few complaints, but not too
many. Our rationale for suppressing some checkpatch complaints:

    PRINTF_L: printk supports it. It is shorter and nicer to our eyes.
    Checkpatch complains that it is not standard C, but it is not clear
    why that matters for kernel code. If anybody cares strongly, we will
    change %L to %ll.

    C99_COMMENTS: We use them sparingly as a shorthand for "FIXME: <line
    where fix is obviously needed>". Will go away as fixes arrive.

    SPLIT_STRING: We split some strings to fit in 80 columns. If anybody
    hates that, we will change them back to long lines.

    SUSPECT_CODE_INDENT: False positives

    LONG_LINE: There are a few long lines, where readability would be
    worse with splitting. We take our guidance from Linus:

        http://yarchive.net/comp/linux/coding_style.html

    If we made some line unreadable that way, please let us know and we
    will fix it.

Other issues

Declarations after Statements. We have some declarations after 
statements, mostly in the userspace code but also some in the kernel 
code. We have -Wno-declaration-after-statement in tux3/Makefile to build 
without warnings. We think that tasteful use of this C99 extension 
improves our code readability and maintainability. We would prefer to 
keep these if nobody objects.

Source includes. We include C files in a few places instead of linking 
them, typically because it is easier to maintain that way. This 
technique is already used in various places in kernel. Can be changed if 
necessary.

Fitness for use

Tux3 is not fit for use as of today and will eat your data. The most 
glaring deficiency is that Tux3 goes BUG on ENOSPC. Some expected 
interfaces are missing. like direct io, xattrs and atime. Some 
performance patches are out of tree, to be merged later. This includes 
directory indexing, so directories over a few thousand files will slow 
to a crawl. Tux3 survives our stress testing, but that does not mean it 
will survive your stress testing.

Purpose

We think that Tux3 fills a niche in the Linux ecology where a light, 
tight, modern filesystem belongs. We offer a fresh approach to some 
ancient problems. Tux3's best trick is strong consistency without the 
overhead that you might expect. Our obsession with minimal resource 
consumption, including disk space, CPU overhead and cache memory makes 
Tux3 promising for personal and embedded use. Tux3's feature set is not 
enterprise grade by any stretch of the imagination, but we hope to 
accrete some big system features over time. Any of several existing 
Linux filesystems already do a nice job of servicing that space, so we 
do not need to rush that. Tux3's special mission is to focus on basic 
functionality that is really robust, fast and simple.

Quick tour

Tux3 has thirty three c source files and thirteen header files, 
comprising about 18 thousand lines. Some files are the familiar ones 
from Ext2: balloc.c, dir.c, inode.c, namei.c, super.c and xattr.c.

Our btree code is a generic OOP-like btree class implemented in btree.c. 
Subclasses for different btree types are provided by specialized leaf 
methods in dleaf.c and ileaf.c, for file data btrees and our inode table 
tree, respective. We reuse the ileaf.c methods in orphan.c to store 
orphaned inodes.

The main workhorse of Tux3 is filemap.c, which maps between logical and 
physical file extents for read and write. This is analogous to 
ext2_get_block but more complex because of extents and btrees. This 
spreads out over several subfiles for modularity: filemap_blocklib.c, 
filemap_hole.c, filemap_mmap.c.

Our delta commit model is implemented in commit.c and its subfiles 
commit_flusher.c and commit_flusher_hack.c. This is supported by log.c 
and replay.c, to emit log records and replay them on mount. Flushing out 
dirty cache is a major Tux3 obsession, implemented in writeback.c and 
its subfiles writeback_iattrfork.c, writeback_inodedelete.c and 
writeback_xattrfork.c

We use buffers as handles for cache blocks, and have some unique 
requirements there, so we have buffer.c with subfiles buffer_fork.c, 
buffer_writeback.c, and buffer_writebacklib.c. These implement our block 
fork concept. A "bufvec" batching technique translates buffers to bios 
for fast IO.

Digression: there might be something generically useful in our buffer 
code, however in the long run we would rather replace buffer_head 
entirely than try to fix it. Probably, we can save significant CPU and 
memory using a framework that specifically provides cache block handles 
and not other traditional buffer_head IO functionality. So buffer_head 
eradication is in our future work queue and our factoring here reflects 
that.

Our scheme for variable sized inodes with optional attributes is 
implemented in iattr.c. Block allocation is lightly factored into policy 
and mechanism, with the policy bits hived off into policy.c. 
Inode_defer.c is a subfile of inode.c and decouples frontend file 
creation code from backend inode table updating. In inode_vfslib.c we 
duplicate some core kernel code, which will go away if we can export the 
proper core functionality as described earlier. Our ugly hack to export 
page_cow_file is in mmap_builtin_hack.c. In utility.c we have a few 
functions that could possibly become generic.

We encapsulate some of our internal APIs in header files, so we have 
quite a few of those. We also have kcompat.h to support building our 
module over a range of kernel versions. This will go away but is not 
gone yet. In link.h we have a single linked list implementation somewhat 
resembling the list.h API. We could possibly replace that by llist.h or 
something like it. It is less than a hundred lines so it might be wiser 
to just leave it.

Regards,

Daniel

