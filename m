Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab3LBNX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:23:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039Ab3LBNX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:23:28 -0500
Date: Tue, 3 Dec 2013 21:23:03 +0800
From: Baoquan He <bhe@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        mjg59@srcf.ucam.org, greg@kroah.com, ebiederm@xmission.com,
        hpa@zytor.com
Subject: Re: [PATCH 0/6] kexec: A new system call to allow in kernel loading
Message-ID: <20131203132303.GA3826@localhost.localdomain>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tested kdump and kexec using --use-kexec2-syscall on kenrel 3.13.0-rc2+,
they work very well.


On 11/20/13 at 12:50pm, Vivek Goyal wrote:
> Current proposed secureboot implementation disables kexec/kdump because
> it can allow unsigned kernel to run on a secureboot platform. Intial
> idea was to sign /sbin/kexec binary and let that binary do the kernel
> signature verification. I had posted RFC patches for this apparoach
> here.
> 
> https://lkml.org/lkml/2013/9/10/560
> 
> Later we had discussion at Plumbers and most of the people thought
> that signing and trusting /sbin/kexec is becoming complex. So a 
> better idea might be let kernel do the signature verification of
> new kernel being loaded. This calls for implementing a new system call
> and moving lot of user space code in kernel.
> 
> kexec_load() system call allows loading a kexec/kdump kernel and jump
> to that kernel at right time. Though a lot of processing is done in
> user space which prepares a list of segments/buffers to be loaded and
> kexec_load() works on that list of segments. It does not know what's
> contained in those segments.
> 
> Now a new system call kexec_file_load() is implemented which takes
> kernel fd and initrd fd as parameters. Now kernel should be able
> to verify signature of newly loaded kernel. 
> 
> This is an early RFC patchset. I have not done signature handling
> part yet. This is more of a minimal patch to show how new system
> call and functionality will look like. Right now it can only handle
> bzImage with 64bit entry point on x86_64. No EFI, no x86_32  or any
> other architecture. Rest of the things can be added slowly as need
> arises. In first iteration, I have tried to address most common use case
> for us.
> 
> Any feedback is welcome.
> 
> Vivek Goyal (6):
>   kexec: Export vmcoreinfo note size properly
>   kexec: Move segment verification code in a separate function
>   resource: Provide new functions to walk through resources
>   kexec: A new system call, kexec_file_load, for in kernel kexec
>   kexec-bzImage: Support for loading bzImage using 64bit entry
>   kexec: Support for Kexec on panic using new system call
> 
>  arch/x86/include/asm/crash.h         |    9 +
>  arch/x86/include/asm/kexec-bzimage.h |   12 +
>  arch/x86/include/asm/kexec.h         |   43 ++
>  arch/x86/kernel/Makefile             |    2 +
>  arch/x86/kernel/crash.c              |  585 +++++++++++++++++++++++++++
>  arch/x86/kernel/kexec-bzimage.c      |  420 +++++++++++++++++++
>  arch/x86/kernel/machine_kexec_64.c   |   60 +++-
>  arch/x86/kernel/purgatory_entry_64.S |  119 ++++++
>  arch/x86/syscalls/syscall_64.tbl     |    1 +
>  include/linux/ioport.h               |    6 +
>  include/linux/kexec.h                |   57 +++
>  include/linux/syscalls.h             |    3 +
>  include/uapi/linux/kexec.h           |    4 +
>  kernel/kexec.c                       |  731 ++++++++++++++++++++++++++++++----
>  kernel/ksysfs.c                      |    2 +-
>  kernel/resource.c                    |  108 +++++-
>  kernel/sys_ni.c                      |    1 +
>  17 files changed, 2074 insertions(+), 89 deletions(-)
>  create mode 100644 arch/x86/include/asm/crash.h
>  create mode 100644 arch/x86/include/asm/kexec-bzimage.h
>  create mode 100644 arch/x86/kernel/kexec-bzimage.c
>  create mode 100644 arch/x86/kernel/purgatory_entry_64.S
> 
> -- 
> 1.7.7.6
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
