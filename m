Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760606Ab3GaUKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 16:10:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143Ab3GaUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 16:10:32 -0400
Date: Wed, 31 Jul 2013 13:10:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Al Viro <viro@ZenIV.linux.org.uk>, dholsgrove@xilinx.com,
        Rich Felker <dalias@aerifal.cx>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        James Hogan <james.hogan@imgtec.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH v3] microblaze: Fix clone syscall
Message-Id: <20130731131030.3d03c68362382dad78136cfb@linux-foundation.org>
In-Reply-To: <db3f4687983a591b1797f2a54a9a8eb695afb9ac.1375081274.git.michal.simek@xilinx.com>
References: <db3f4687983a591b1797f2a54a9a8eb695afb9ac.1375081274.git.michal.simek@xilinx.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jul 2013 09:01:48 +0200 Michal Simek <michal.simek@xilinx.com> wrote:

> Fix inadvertent breakage in the clone syscall ABI for Microblaze
> that was introduced in this patch:
> "microblaze: switch to generic fork/vfork/clone"
> (sha1: f3268edbe6fe0ce56e62c6d6b14640aeb04864b7)
> 
> The Microblaze syscall ABI for clone takes the parent tid address in
> the 4th argument; the third argument slot is used for the stack size.
> The incorrectly-used CLONE_BACKWARDS type assigned parent tid to the
> 3rd slot.
> 
> This commit restores the original ABI so that existing userspace libc
> code will work correctly.
> 
> All kernel versions from v3.8-rc1 were affected.

x86_64 allnoconfig generates screenfuls of

In file included from fs/signalfd.c:31:
include/linux/syscalls.h:805:5: warning: "CONFIG_CLONE_BACKWARDS3" is not defined

> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -802,9 +802,14 @@ asmlinkage long sys_vfork(void);
>  asmlinkage long sys_clone(unsigned long, unsigned long, int __user *, int,
>  	       int __user *);
>  #else
> +#if CONFIG_CLONE_BACKWARDS3

Presumably ifdef here will fix that.  Please redo, retest and resend?


