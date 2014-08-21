Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbaHUOQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 10:16:24 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:36809 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755433AbaHUOQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 10:16:22 -0400
MIME-Version: 1.0
In-Reply-To: <72232BCB-CCF2-4BA3-9F40-53D385C83D6B@borea.si>
References: <72232BCB-CCF2-4BA3-9F40-53D385C83D6B@borea.si>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 21 Aug 2014 09:16:01 -0500
Message-ID: <CAErSpo5oyxSZsYnkqs2kXWN01biNv-ATVRuuKyU-4GgRksEwUQ@mail.gmail.com>
Subject: Re: PCI: minimal alignment of resources
To: Matevz Langus <matevz.langus@borea.si>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci]

On Wed, Aug 20, 2014 at 4:05 PM, Matevz Langus <matevz.langus@borea.si> wrote:
> Hi,
>
> I would like to ask if somebody is aware of a correct way to change they way kernel aligns PCI resources. By default it uses minimal alignment of 1 MB.

Do you mean alignment of bridge windows?  Normal device BARs are
aligned on their size, but mem bridge windows are aligned to a minimum
of 1MB.  This is a consequence of the fact that the low 20 bits of the
bridge's Memory Base register are assumed to be zero (see PCI Bridge
spec, r1.2, sec 3.2.5.8).

Similarly, the low 20 bits of the Memory Limit register are assumed to
be 0xfffff, which means the memory window is a multiple of 1MB in
size.

> Due to the hardware limitation I would need to change that down to 64 kB. With this change PCI Endpoints with many small BARs would fit into limited memory space available on the RC.
> This could be useful for all smaller embedded systems.

What's your system topology, e.g., can you share the complete "lspci
-vv" output?  If the bridge window alignment is an issue, it sounds
like maybe you have several bridges.  Each memory window will take at
least 1MB of space.  If you have, e.g., four bridges, with devices
behind all of them, each bridge will require at least 1MB of memory
space.  If your RC only has 2MB of MMIO space, the bridges won't all
fit.

I/O port windows are normally a minimum of 64K, but we do support a
quirk (see io_window_1k) that allows smaller windows on bridges that
support it.  If you have bridges with an extension to allow smaller
memory windows, maybe we could do something similar.

> It looks just changing aligns in pbus_size_mem (in file setup-bus.c) works but not with all PCI EP drivers. Some will crash during init.
>
> Regards,
>   Matevz Langus--
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
