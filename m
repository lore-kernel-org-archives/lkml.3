Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab3GCCNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 22:13:47 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:36480 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab3GCCNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 22:13:46 -0400
X-AuditID: 85900ec0-d1ac5b900000151e-77-51d388d6704f
X-Mailbox-Line: From nobody Wed Jul  3 10:46:16 2013
From: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Subject: [RFC PATCH 0/5] Add a hash value for each line in /dev/kmsg
To: linux-kernel@vger.kernel.org
Cc: yrl.pp-manager.tt@hitachi.com, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, kay@vrfy.org, davem@davemloft.net
Date: Wed, 03 Jul 2013 10:46:16 +0900
Message-ID: <20130703014616.18745.34699.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch series adds hash values of printk format strings into
each line of /dev/kmsg outputs as follows:

        6,154,325061,-,b7db707c@kernel/smp.c:554;Brought up 4 CPUs

Background
==========
We sometimes want to identify each kernel message automatically
because of the following purposes:

(1) Show more detailed information about the message by cooperating
    with external system
(2) Take actions automatically depending on the message, for example
    trigger a fail over or collect related information to analyze the
    problem

However, most of printk messages have dynamically generated parts,
so it is difficult to identify the messages.  Even if you can, it will
be expensive.

To solve this issue, this patch series add a hash value of each
printk format string.  A catalog file which consists of hash, location,
and format string lines is also generated at the kernel build time.
Userland tools can easily identify kernel messages by utilizing the
catalog file.


Design
======
Hash values are displayed only when reading /dev/kmsg.  Console and
/proc/kmsg outputs are not affected by this feature.

The format in /dev/kmsg output is like this:

        6,154,325061,-,b7db707c@kernel/smp.c:554;Brought up 4 CPUs

The 5th field is added, and it means "<32-bit hash>@<filename>:<lineno>".
If you disable this feature (CONFIG_KMSG_HASH=n) or any cases the
hash value is not calculated, the 5th field shows '-'.

The function printk() is replaced with macro version to create
a metadata table which is used to calculate and keep hash values.
Hash value calculation is done at the kernel build time, but not
execution time.  scripts/msghash tools scan the metadata table in
vmlinux, calculate hash values, and put them back into the table.
At the same time, msghash creates a catalog file named
"<objfile>.msglist".  Here is an example of its contents:

    ...
    b6be0058@init/main.c:180,"Parameter %s is obsolete, ignored"
    72dfe336@init/main.c:403,"Malformed early option '%s'"
    85788d36@init/do_mounts.c:573,"Waiting for root device %s..."
    ...

The format is <32-bit hash>@<filename>:<lineno>,"<message format>".
Similar to /dev/kmsg, unprintable characters in message formats
are escaped and a trailing newline is dropped.


Restrictions
============
Currently, only printk, pr_xxx, dev_printk, and dev_xxx are supported
except for pr_debug with dynamic printk.  Other printk variants won't
show meaningful hash values.  I'm going to support some of them in
the future patches.

KERN_CONT cases are not dealt with well.  Only the first printk's
hash is output and continued printks are ignored.

Kernel module support has not been implemented yet.  I'm going to do
this in the future patches.


Note
====
When CONFIG_KMSG_HASH=y, a metadata table and additional file name
strings are allocated in object files, and it increases the kernel
size.  Below is the difference of CONFIG_KMSG_HASH=n/y in some
configuration.  The total size increases about 2%.

   text    data     bss     dec     hex filename
8135284 2395144 2211840 12742268         c26e7c vmlinux_hash_disabled
8255079 2519368 2211840 12986287         c627af vmlinux_hash_enabled


Thanks,
---

Hidehiro Kawai (5):
      printk: Add msghash support for dev_printk
      msghash: Add userland msghash tool
      tools/include: Add jhash.h
      printk: add message hash values in /dev/kmsg output
      printk: make printk a macro


 .gitignore                        |    1 
 Makefile                          |    7 +
 drivers/base/core.c               |   57 ++-------
 drivers/usb/storage/debug.c       |    2 
 include/asm-generic/vmlinux.lds.h |    5 +
 include/linux/device.h            |   73 +++++++----
 include/linux/kmsghash.h          |   19 +++
 include/linux/printk.h            |   31 ++++-
 kernel/printk.c                   |   81 +++++++++---
 lib/Kconfig.debug                 |   22 +++
 lib/dynamic_debug.c               |    4 -
 net/core/dev.c                    |    2 
 scripts/Makefile                  |    1 
 scripts/link-vmlinux.sh           |    5 +
 scripts/msghash/.gitignore        |    1 
 scripts/msghash/Makefile          |    7 +
 scripts/msghash/msghash.c         |  241 +++++++++++++++++++++++++++++++++++++
 scripts/msghash/msghash.sh        |   45 +++++++
 tools/include/tools/jhash.h       |  192 +++++++++++++++++++++++++++++
 19 files changed, 698 insertions(+), 98 deletions(-)
 create mode 100644 include/linux/kmsghash.h
 create mode 100644 scripts/msghash/.gitignore
 create mode 100644 scripts/msghash/Makefile
 create mode 100644 scripts/msghash/msghash.c
 create mode 100755 scripts/msghash/msghash.sh
 create mode 100644 tools/include/tools/jhash.h

-- 
Hidehiro Kawai
Hitach, Yokohama Research Laboratory
Linux Technology Center

