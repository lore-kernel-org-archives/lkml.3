Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbaHIQo7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 12:44:59 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:62789 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaHIQo4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 12:44:56 -0400
MIME-Version: 1.0
In-Reply-To: <53E62EEF.9040801@gmail.com>
References: <53E62EEF.9040801@gmail.com>
Date: Sat, 9 Aug 2014 09:44:55 -0700
X-Google-Sender-Auth: Dq35zXpd6a4VrjpHzi3-ExXIu6A
Message-ID: <CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
Subject: Re: Loading initrd above 4G causes freeze on boot
From: Yinghai Lu <yinghai@kernel.org>
To: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 9, 2014 at 7:23 AM, Mantas Mikulėnas <grawity@gmail.com> wrote:
> As of commit 4bf7111f5016 ("x86/efi: Support initrd loaded above 4G"),
> the kernel freezes at the earliest possible moment when trying to boot
> via UEFI on my Asus laptop. (It still boots via BIOS.)
>
> If I revert that commit on current master (c309bfa9b481), it boots
> correctly again [although I see "setup_efi_pci() failed" being printed].
>
> (Seems like it freezes when handle_cmdline_files() attempts to read
> the last chunk of the initramfs -- the last call to efi_file_read()
> never returns. Figuring out why that happens is beyond me, though.)
>

Matt found that efi_file_read()/firmware has problem that could not do
several reading. Please check if reverting that commit have any
difference.

---
I spent some time playing around with this bug and it appears to be
triggered by the read-a-chunk-at-a-time logic in handle_cmdline_files(),
(which is itself a bug workaround) introduced here,

  commit 2d2da60fb40a
  Author: Maarten Lankhorst <m.b.lankhorst@gmail.com>
  Date:   Fri Dec 16 13:30:58 2011 +0100

      x86, efi: Break up large initrd reads
---
