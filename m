Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbaH0K7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 06:59:11 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:44502 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756657AbaH0K7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 06:59:07 -0400
Date: Wed, 27 Aug 2014 11:59:01 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Mantas =?utf-8?Q?Mikul=C4=97nas?= <grawity@gmail.com>,
        Anders Darander <anders@chargestorm.se>, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Harald Hoyer <harald@redhat.com>
Subject: Re: [PATCH] x86: only load initrd above 4g on second try
Message-ID: <20140827105901.GC28116@console-pimps.org>
References: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409089544-24221-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug, at 02:45:44PM, Yinghai Lu wrote:
> Mantas found that after commit 4bf7111f5016 ("x86/efi: Support initrd
> loaded above 4G"), the kernel freezes at the earliest possible moment
> when trying to boot via UEFI on Asus laptop.
> 
> There are buggy EFI implementations: with EFI run time, kernel need
> to load file with 512bytes alignment when buffer is above 4G.
> 
> So revert to old way to load initrd on first try,
> second try will use above 4G buffer when initrd is more than
> 2G and does not fit under 4G.
> 
> Reported-by: Mantas Mikulėnas <grawity@gmail.com>
> Tested-by: Anders Darander <anders@chargestorm.se>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/boot/compressed/eboot.c |   16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)

The reason I suggested introducing some kind of kernel parameter to
allow loading above 4G is because if Mantas loads a 5GB initrd with your
patch, his machine is still going to hang, with no indication of why it
hung.

At least with a kernel paramter, by default we can try to load under 4G,
and if that fails because the file is too big we can print something
along the lines of,

  "initramfs file too large: try booting with efi=file-max"

No, it's not ideal, but I think it's a worthwhile compromise because
you're only going to run into this issue when loading a huge initramfs
with the EFI boot stub.

If instead you're using Grub or Syslinux (and the EFI handover protocol)
it's a non-issue because both of those boot loaders carry FAT drivers
and use EFI_BLOCK_IO_PROTOCOL which doesn't trigger the firmware bug.

It's only because we don't have a FAT driver in the EFI boot stub and
have to resort to using EFI_FILE_PROTOCOL that we've encountered this
problem at all.

-- 
Matt Fleming, Intel Open Source Technology Center
