Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbbAWShf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 13:37:35 -0500
Received: from mga14.intel.com ([192.55.52.115]:15182 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbbAWShd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 13:37:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,455,1418112000"; 
   d="scan'208";a="666611107"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 00/10] tinification: Make memory-access char devices optional
Date: Fri, 23 Jan 2015 12:37:06 -0600
Message-Id: <cover.1422035184.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds a top-level config option, CONFIG_DEVMEM_BASE, and
a series of dependent options below it which allow various devices
such as /dev/mem, /dev/null, /dev/zero, /dev/random, etc. to be
disabled.  This allows embedded systems systems that don't need any or
all of those devices to save the kernel memory associated with those
devices.

It also adds a related option to disable the getrandom(2) syscall,
CONFIG_GETRANDOM_SYSCALL, which allows code shared between it and
/dev/*random to be compiled out as well.

Disabling of CONFIG_DEVMEM_BASE and its dependent options is only
available if CONFIG_EMBEDDED is enabled; normal systems will still
have everything enabled as usual.

bloat-o-meter shows a total 6k savings for a tinyconfig kernel with
all options disabled, and about 10k savings for the same thing but
using defconfig.

bloat-o-meter (based on tinyconfig):

add/remove: 0/55 grow/shrink: 1/3 up/down: 332/-6563 (-6231)
function                                     old     new   delta
extract_entropy                              114     446    +332
__print_once                                  13      12      -1
write_null                                     3       -      -3
read_null                                      3       -      -3
mix_pool_bytes                                17      14      -3
aio_read_null                                  3       -      -3
pipe_to_null                                   4       -      -4
mem_class                                      4       -      -4
write_full                                     6       -      -6
devkmsg_release                               15       -     -15
random_fasync                                 16       -     -16
mmap_zero                                     16       -     -16
aio_write_null                                18       -     -18
open_port                                     19       -     -19
random_read                                   20       -     -20
splice_write_null                             24       -     -24
null_lseek                                    25       -     -25
mmap_mem_ops                                  32       -     -32
mem_devnode                                   35       -     -35
mmap_kmem                                     37       -     -37
random_write                                  42       -     -42
xfer_secondary_pool                           60       -     -60
write_pool                                    82       -     -82
random_poll                                   83       -     -83
read_iter_zero                                95       -     -95
urandom_read                                  96       -     -96
memory_open                                   96       -     -96
devkmsg_poll                                  97       -     -97
read_port                                     98       -     -98
mmap_mem                                     103       -    -103
devkmsg_open                                 112       -    -112
write_port                                   116       -    -116
zero_fops                                    120       -    -120
urandom_fops                                 120       -    -120
random_fops                                  120       -    -120
port_fops                                    120       -    -120
null_fops                                    120       -    -120
memory_fops                                  120       -    -120
mem_fops                                     120       -    -120
kmsg_fops                                    120       -    -120
kmem_fops                                    120       -    -120
full_fops                                    120       -    -120
memory_lseek                                 122       -    -122
devkmsg_llseek                               144       -    -144
chr_dev_init                                 162       3    -159
read_mem                                     162       -    -162
extract_buf                                  164       -    -164
_random_read.part                            173       -    -173
account                                      181       -    -181
write_mem                                    184       -    -184
devlist                                      192       -    -192
extract_entropy_user                         197       -    -197
devkmsg_write                                209       -    -209
sys_getrandom                                211       -    -211
zero_bdi                                     244       -    -244
read_kmem                                    290       -    -290
random_ioctl                                 319       -    -319
write_kmem                                   349       -    -349
devkmsg_read                                 699       -    -699


The following changes since commit 5eb11d6b3f55eb4d28c51ea7f641c0e5e255a70f:

  Merge tag 'sound-3.19-rc6' of git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound (2015-01-21 20:37:25 +1200)

are available in the git repository at:

  git://git.yoctoproject.org/linux-yocto-contrib.git tzanussi/devmem-tinification-v1
  http://git.yoctoproject.org/cgit/cgit.cgi/linux-yocto-contrib/log/?h=tzanussi/devmem-tinification-v1

Tom Zanussi (10):
  drivers/char: Support compiling out memory-access char devices
  drivers/char: Support compiling out /dev/mem
  drivers/char: Support compiling out /dev/port
  drivers/char: Support compiling out /dev/null
  drivers/char: Support compiling out /dev/zero
  drivers/char: Support compiling out /dev/full
  drivers/char: Support compiling out /dev/random
  drivers/char: Support compiling out /dev/urandom
  drivers/char: Support compiling out /dev/kmsg
  drivers/char: Support compiling out the getrandom(2) syscall

 arch/x86/Kconfig.debug |   1 +
 drivers/char/Kconfig   | 109 ++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/char/mem.c     |  83 +++++++++++++++++++++++++++----------
 drivers/char/random.c  |  24 ++++++++---
 kernel/printk/printk.c |   2 +
 kernel/sys_ni.c        |   1 +
 6 files changed, 192 insertions(+), 28 deletions(-)

-- 
1.9.3

