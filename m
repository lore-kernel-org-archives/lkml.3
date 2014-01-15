Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876AbaAOMYM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 07:24:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:27679 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaAOMYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 07:24:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,662,1384329600"; 
   d="scan'208";a="459170920"
Date: Wed, 15 Jan 2014 20:24:01 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [x86, kaslr] PANIC: early exception 0e rip 10:ffffffff8ae04c6e
 error 0 cr2 ffffffff81972b28
Message-ID: <20140115122401.GB18065@localhost>
References: <20140115121201.GA16953@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115121201.GA16953@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees,

This script can reproduce the problem. Please modify the -initrd line
before use.

Usage:
        ./kvm-0day.sh vmlinuz-3.12.0-rc4-00008-g6e6a493

#!/bin/bash

kernel=$1

kvm=(
	qemu-system-x86_64 -cpu kvm64 -enable-kvm
	-kernel $kernel
	-initrd /kernel-tests/initrd/yocto-minimal-x86_64.cgz
	# -initrd /kernel-tests/initrd/yocto-minimal-i386.cgz
	# -initrd /kernel-tests/initrd/quantal-core-i386.cgz
	# -initrd /kernel-tests/initrd/quantal-core-x86_64.cgz
	-smp 2
	-m 256M
	-net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio
	-net user,vlan=0
	-net nic,vlan=1,model=e1000
	-net user,vlan=1
	-boot order=nc
	-no-reboot
	-watchdog i6300esb
	-serial stdio
	-display none
	-monitor null
)

append=(
	debug
	sched_debug
	apic=debug
	ignore_loglevel
	# dyndbg=\"func kobject_release +p\"
	sysrq_always_enabled
	panic=10
	prompt_ramdisk=0
	earlyprintk=ttyS0,115200
	console=ttyS0,115200
	console=tty0
	vga=normal
	root=/dev/ram0
	rw
)

"${kvm[@]}" --append "${append[*]}"
