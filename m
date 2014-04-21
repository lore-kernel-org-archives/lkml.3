Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaDUKwt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:52:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824AbaDUKwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:52:47 -0400
Date: Mon, 21 Apr 2014 18:52:32 +0800
From: WANG Chao <chaowang@redhat.com>
To: Kees Cook <keescook@chromium.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: kaslr relocation incompitable with kernel loaded high
Message-ID: <20140421105232.GB4564@dhcp-17-89.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Kees

When I'm testing kaslr with kdump, I find that when 2nd kernel is loaded
high, it doesn't boot.

I reserved 128M memory at high with kernel cmdline
"crashkernel=128M,high crashkernel=0,low", and for which I got:

[    0.000000] Reserving 128MB of memory at 6896MB for crashkernel (System RAM: 6013MB)

Then I load kdump kernel into the reserved memory region, using a local
modified kexec-tools which is passing e820 in boot_params.

The e820 map of system RAM passed to 2nd kernel:

E820 memmap (of RAM):
0000000000001000-000000000009e3ff (1)
00000001af000000-00000001b6f5dfff (1)
00000001b6fff400-00000001b6ffffff (1)

In which, 2nd kernel is loaded at 0x1b5000000.

After triggerred a system crash, 2nd kernel doesn't boot even with
"nokaslr" cmdline:

# echo c > /proc/sysrq-trigger
[..]

I'm in purgatory
early console in decompress_kernel
KASLR disabled...

Decompressing Linux... Parsing ELF... Performing relocations... 

32-bit relocation outside of kernel!


 -- System halted


I know 32bit relocation code has recently moved to misc.c and it's a
ground work for kaslr on x86_64. However it doesn't work out on a kernel
high loaded case.

I'm not quite familiar with this. But I'm wondering if it makes sense to
skip handle_relocation() if kaslr doesn't take effects (nokaslr or
kaslr failed to find suitable area).

Thanks
WANG Chao
