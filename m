Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbaJHOkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:40:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756231AbaJHOks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:40:48 -0400
Date: Wed, 8 Oct 2014 22:40:05 +0800
From: Baoquan He <bhe@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, vgoyal@redhat.com, keescook@chromium.org,
        ak@linux.intel.com, ebiederm@xmission.com, kexec@lists.infradead.org,
        whissi@whissi.de, kumagai-atsushi@mxc.nes.nec.co.jp,
        stable@vger.kernel.org
Subject: Re: [resend Patch v3 1/2] kaslr: check if kernel location is changed
Message-ID: <20141008144005.GA2015@dhcp-17-102.nay.redhat.com>
References: <1412060896-1902-1-git-send-email-bhe@redhat.com>
 <542B1EC1.8090502@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542B1EC1.8090502@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/14 at 02:21pm, H. Peter Anvin wrote:
> On 09/30/2014 12:08 AM, Baoquan He wrote:
> > Function handle_relocations() is used to do the relocations handling
> > for i686 and kaslr of x86_64. For 32 bit the relocation handling is
> > mandotary to perform. For x86_64 only when kaslr is enabled and a
> > random kernel location is chosen successfully the relocation handling
> > shound be done. However previous implementation only compared the
> > kernel loading address and LOAD_PHYSICAL_ADDR where kernel were
> > compiled to run at. This would casue system to be exceptional in
> > few conditions like when delta between load address and compiled
> > address is bigger than what 32bit signed relocations can handle.
> > Also there will be limitations that delta can't be too big otherwise
> > kernel text virtual addresses will overflow in module address space.
> > 
> > So in this patch check if kernel location is changed after
> > choose_kernel_location() when x86_64. If and only if in x86_64
> > and kernel location is changed, we say a kaslr random kernel
> > location is chosen, then the relocation handling is needed.
> > 
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > Acked-by: Vivek Goyal <vgoyal@redhat.com>
> > Acked-by: Kees Cook <keescook@chromium.org>
> > Tested-by: Thomas D. <whissi@whissi.de>
> > Cc: stable@vger.kernel.org
> 
> Could you clarify under what conditions we may end up with 32-bit signed
> overflow, and yet have a functional kernel?

Hi hpa,

As Vivek has replied, and from my test result, in x86_64 when kernel is
loaded above 2G by bootloader, the 32-bit signed overflow will happen.
Meanwhile the error() in arch/x86/boot/compressed/misc.c will be called,
this function will execute 'hlt' instruction, then system halted.

In current kaslr, there are 3 hebaviours. Since the candidate slot for
randomized kernel location is only between kernel loaded address and 1G,
it doesn't choose a new kernel location when kernel is loaded above 1G.

1) Kernel is loaded between 0x1000000 and 1G, kaslr works well.

2)kernel is loaded between 1G and 2G, kernel doesn't choose a new kernel
location, so the ourput_orig==output > 1G. But current code compares the
output with LOAD_PHYSICAL_ADDR, relocation handling is still taken and
this cause kenrel text mapping stomps module mapping space. So in this
case form printing we can see kaslr passed, but kernel reboot to bios
immediately.

3) When kernel is loaded above 2G, this is the 32-bit signed overflow as
we discussed above.

So this patch can fix case 2  and case 3. 

Thanks
Baoquan
> 
> 
