Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbaGOPKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:10:33 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:35516 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbaGOPK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:10:28 -0400
Date: Tue, 15 Jul 2014 16:10:25 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH] x86, eboot: Support initrd loaded above 4G
Message-ID: <20140715151025.GB32039@console-pimps.org>
References: <1402773821-15995-1-git-send-email-yinghai@kernel.org>
 <20140618142819.GN24049@console-pimps.org>
 <20140709182651.GB15932@console-pimps.org>
 <CAE9FiQVP6d5GhFBBmX5HDo0w0oKJSizdKvepq5t6vhGNj=W9sg@mail.gmail.com>
 <20140711074029.GD5952@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711074029.GD5952@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul, at 08:40:29AM, Matt Fleming wrote:
> 
> I'm not exactly sure what's wrong with the buffer - whether it's a case
> of not being able to access it properly or somehing buggy in the EFI
> code for reading files. No fault occurs when reading into it, it just
> doesn't contain the correct data.
> 
> Either way, I'm going to leave your patch as-is and just ensure I fix
> this before the merge window. I think it's a good idea to have whatever
> workaround we come up with documented via an entirely separate patch.

I spent some time playing around with this bug and it appears to be
triggered by the read-a-chunk-at-a-time logic in handle_cmdline_files(),
(which is itself a bug workaround) introduced here,

  commit 2d2da60fb40a
  Author: Maarten Lankhorst <m.b.lankhorst@gmail.com>
  Date:   Fri Dec 16 13:30:58 2011 +0100

      x86, efi: Break up large initrd reads
    
      The efi boot stub tries to read the entire initrd in 1 go, however
      some efi implementations hang if too much if asked to read too much
      data at the same time. After some experimentation I found out that my
      asrock p67 board will hang if asked to read chunks of 4MiB, so use a
      safe value.
    
      elilo reads in chunks of 16KiB, but since that requires many read
      calls I use a value of 1 MiB.  hpa suggested adding individual
      blacklists for when systems are found where this value causes a crash.
    
      Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
      Link: http://lkml.kernel.org/r/4EEB3A02.3090201@gmail.com
      Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

Setting EFI_READ_CHUNK_SIZE to -1 (disabling the chunk workaround)
allows everything to work just fine. Any chunk value smaller than the
initrd file size causes the bug to trigger on my machine.

Going forward, I suspect any attempts to use the EFI File Protocol are
going to result in this kind of breakage, and that the only thing that
can be relied upon is the Disk I/O Protocol.

But doing Disk I/O would necessitate adding the in-kernel FAT driver to
the EFI boot stub, which is a scary idea (though not without merit).

On the flip-side, we've no infrastructure in the EFI boot stub for doing
blacklisting via DMI, so there's no way currently to automatically
disable the chunk-read workaround for known buggy machines.

The simplest solution is to require that the user pull some kind of
kernel parameter on the command line to explicitly disable the
workaround, but that's a pretty lame prospect.

-- 
Matt Fleming, Intel Open Source Technology Center
