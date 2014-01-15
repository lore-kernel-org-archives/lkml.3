Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959AbaAOMh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:37:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:40310 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbaAOMhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:37:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,662,1384329600"; 
   d="scan'208";a="459176320"
Date: Wed, 15 Jan 2014 20:37:19 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [x86, kaslr] BUG: kernel boot hang
Message-ID: <20140115123719.GB16708@localhost>
References: <20140114133125.GB26942@localhost>
 <CAGXu5j+uBnEJ2qddoec0Y2z3=yzAYwKE_GjMRhXzc4XRw_Se_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+uBnEJ2qddoec0Y2z3=yzAYwKE_GjMRhXzc4XRw_Se_g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 02:33:15PM -0800, Kees Cook wrote:
> On Tue, Jan 14, 2014 at 5:31 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Greetings,
> >
> > I got the below dmesg and the first bad commit is
> >
> > commit 82fa9637a2ba285bcc7c5050c73010b2c1b3d803
> > Author:     Kees Cook <keescook@chromium.org>
> > AuthorDate: Thu Oct 10 17:18:16 2013 -0700
> > Commit:     H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Sun Oct 13 03:12:19 2013 -0700
> >
> >     x86, kaslr: Select random position from e820 maps
> >
> >     Counts available alignment positions across all e820 maps, and chooses
> >     one randomly for the new kernel base address, making sure not to collide
> >     with unsafe memory areas.
> >
> >     Signed-off-by: Kees Cook <keescook@chromium.org>
> >     Link: http://lkml.kernel.org/r/1381450698-28710-5-git-send-email-keescook@chromium.org
> >     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> >
> > Note that there are many other warning/errors and it's not very
> > reproducible, so this report might be wrong.
> >
> > ===================================================
> > PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
> > ===================================================
> >
> > +-----------------------------------------------------------+--------------+--------------+
> > |                                                           | 5bfce5ef55cb | 1955a14a5ba6 |
> > +-----------------------------------------------------------+--------------+--------------+
> > | boot_successes                                            | 3948         | 0            |
> > | boot_failures                                             | 52           | 89           |
> > | page_allocation_failure:order:,mode                       | 48           | 2            |
> > | Out_of_memory:Kill_process                                | 7            |              |
> > | BUG:kernel_early_hang_without_any_printk_output           | 1            |              |
> > | BUG:soft_lockup-CPU_stuck_for_s                           | 1            |              |
> > | WARNING:CPU:PID:at_kernel/locking/lockdep.c:check_flags() | 0            | 85           |
> > | general_protection_fault:SMP_SMP                          | 0            | 1            |
> > | RIP:__lock_acquire                                        | 0            | 1            |
> > | Kernel_panic-not_syncing:Fatal_exception                  | 0            | 1            |
> > | BUG:kernel_boot_hang                                      | 0            | 2            |
> > | BUG:kernel_boot_crashed                                   | 0            | 1            |
> > +-----------------------------------------------------------+--------------+--------------+
> >
> > The last dmesg is
> >
> > [    0.803796] Initramfs unpacking failed: junk in compressed archive
> 
> Can you tell me how the initrd for quantal-core-x86_64.cgz was built
> in the qemu instances you're using? It seems like all the failures
> point to a problem with how kASLR is interacting with the initrd.

That Initramfs unpacking error is much harder to reproduce, but
anyway here's how I create the image file:

quantal-core-x86_64.cgz is based on the ubuntu-core images files:

http://cdimage.ubuntu.com/ubuntu-core/releases/quantal/release/

Download one image and extract files to quantal-core-x86_64/ and run
the below script in parent dir

        ./create-cpio.sh quantal-core-x86_64

#!/bin/bash

core=$1

[[ $1 ]] || exit
cd $core || exit

[[ -d ../addon ]] && cp -a ../addon/* .

mkdir initrd
ln -s sbin/init init

find . |
grep -v -e usr/doc				\
        -e usr/man				\
	-e usr/info				\
	-e sbin/modprobe			\
	-e usr/share/doc			\
	-e usr/share/man			\
	-e usr/share/info			\
	-e usr/share/i18n			\
	-e usr/share/locales			\
	-e usr/lib/x86_64-linux-gnu/gconv	\
	-e var/lib/apt/lists			\
	-e var/lib/dpkg/info			\
	-e var/cache/apt/archives		|
cpio -o -H newc | gzip -n -9 > ../$core.cgz
