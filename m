Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934383AbaGXST7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:19:59 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:42625 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391AbaGXST6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:19:58 -0400
Message-ID: <53D14E48.3040202@twiddle.net>
Date: Thu, 24 Jul 2014 08:19:52 -1000
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michael Cree <mcree@orcon.net.nz>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Bug: retry of clone() on Alpha can result in zeroed process thread
 pointer
References: <20140723085244.GB4799@omega>
In-Reply-To: <20140723085244.GB4799@omega>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2014 10:52 PM, Michael Cree wrote:
> Running strace on nptl/tst-eintr3 reveals that the clone() syscall
> is retried by the kernel if an ERESTARTNOINTR error occurs.  At
> $syscall_error in arch/alpha/kernel/entry.S the kernel handles the
> error and in doing that it writes to 72(sp) which is where the value
> of the a3 CPU register on entry to the kernel is stored.  Then the
> kernel retries the clone() function.  But the alpha specific code
> for copy_thread() in arch/alpha/kernel/process.c does not use the
> passed a3 cpu register (the argument tls), instead it goes to the
> saved stack to get the value of the a3 register, which on the
> second call to clone() has been modified to no longer be the value
> of the a3 cpu register on entry to the kernel.  And a latent bomb
> is laid for userspace in the form of an incorrect process unique
> value (which is the thread pointer) in the PCB.
> 
> Am I correct in my analysis and, if so, can we get a fix for this
> please.

Well...  let me start with the assumption that we can't possibly restart unless
the syscall fails with -ERESTART*.

Before we clobber 72($sp), $syscall_error saves the old value in $19.  This is
the r19 parameter to do_work_pending, and is passed all the way down to
syscall_restart where we do restore the original value of a3 for ERESTARTNOINTR.

So if there's a path that leads to restart, but doesn't save a3 before
clobbering, I don't see it.  Do you have an strace dump that shows this?


r~
