Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaAMMQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:16:43 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:40424 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751357AbaAMMQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:16:40 -0500
Date: Mon, 13 Jan 2014 12:16:36 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Madper Xie <cxie@redhat.com>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [BUG] Kernel OOPS when reboot if I set reboot=efi,{warm, cold}
 (and some questions :-)
Message-ID: <20140113121636.GA3256@console-pimps.org>
References: <8738l5zcfp.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738l5zcfp.fsf@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 Jan, at 04:39:38PM, Madper Xie wrote:
> Howdy Folks,
>   Happy new yeah, happy new bug!
>   With a uefi system, I meet following panic when reboot after I adding
>   `reboot=efi,warm`
> [call trace]:
> <0>[  698.736637] reboot: Restarting system
> <5>[  698.737407] reboot: machine restart
> <1>[  698.738399] BUG: unable to handle kernel paging request at 00000000ded53e60
> <1>[  698.738924] IP: [<ffff8800dedb946d>] 0xffff8800dedb946d
> <4>[  698.739408] PGD 0 
> <4>[  698.739868] Oops: 0000 [#1] SMP 

[...]

> According to Call Trace, the panic happen when call ResetSystem() which
> is a uefi run time service. It's seems a asm code in efi_stub_64.S
> I disassembly it with crash got following outputs:
> crash> dis efi_call4
> 0xffffffff810518f0 <efi_call4>: mov    %rsp,%rax
> [ ... ]
> 0xffffffff81051918 <efi_call4+40>:      movaps %xmm3,0x30(%rsp)
> 0xffffffff8105191d <efi_call4+45>:      movaps %xmm4,0x20(%rsp)
> 0xffffffff81051922 <efi_call4+50>:      movaps %xmm5,0x10(%rsp)
> 0xffffffff81051927 <efi_call4+55>:      sub    $0x20,%rsp
> [ ... ]
> 
> So it seems the panic happen when SAVE_XMM? Does SAVE_XMM will trigger
> paging? (`unable to handle kernel paging request at 00000000ded53e60`)
 
No, the crash is happening within the ResetSystem() runtime service.
Checkout the RIP, it's in the direct mapping region (0xffff8800.....).

> in case it's a hardware special issue: My testbed is a DELL xps x8500
> And I'll try to test it on another uefi system.

It looks like your firmware is trying to access physical addresses. Can
you build a kernel from the 'next' branch at,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

That branch includes Borislav's 1:1 mapping work and may fix your issue.

-- 
Matt Fleming, Intel Open Source Technology Center
