Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751358AbaHITXK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 15:23:10 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:61285 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaHITXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 15:23:06 -0400
Date: Sat, 9 Aug 2014 20:23:02 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org
Subject: Re: Loading initrd above 4G causes freeze on boot
Message-ID: <20140809192302.GJ15082@console-pimps.org>
References: <53E62EEF.9040801@gmail.com>
 <CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 09 Aug, at 09:44:55AM, Yinghai Lu wrote:
> On Sat, Aug 9, 2014 at 7:23 AM, Mantas Mikulėnas <grawity@gmail.com> wrote:
> > As of commit 4bf7111f5016 ("x86/efi: Support initrd loaded above 4G"),
> > the kernel freezes at the earliest possible moment when trying to boot
> > via UEFI on my Asus laptop. (It still boots via BIOS.)
> >
> > If I revert that commit on current master (c309bfa9b481), it boots
> > correctly again [although I see "setup_efi_pci() failed" being printed].
> >
> > (Seems like it freezes when handle_cmdline_files() attempts to read
> > the last chunk of the initramfs -- the last call to efi_file_read()
> > never returns. Figuring out why that happens is beyond me, though.)
> >
> 
> Matt found that efi_file_read()/firmware has problem that could not do
> several reading. Please check if reverting that commit have any
> difference.
> 
> ---
> I spent some time playing around with this bug and it appears to be
> triggered by the read-a-chunk-at-a-time logic in handle_cmdline_files(),
> (which is itself a bug workaround) introduced here,
> 
>   commit 2d2da60fb40a
>   Author: Maarten Lankhorst <m.b.lankhorst@gmail.com>
>   Date:   Fri Dec 16 13:30:58 2011 +0100
> 
>       x86, efi: Break up large initrd reads

Right, I committed a patch to workaround this problem here,

  http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=next&id=1c24a2bef39f041eb578189207240d0457ef0ac3

since on my ASUS machine the combination of breaking up initrd reads
into chunks and reading into a buffer above 4G actually triggers a whole
new bug.

Mantas, could you try out the patch referenced above and pass
"efi=nochunk" on the command line to the EFI boot stub. I'm hoping that
fixes your problem.

-- 
Matt Fleming, Intel Open Source Technology Center
