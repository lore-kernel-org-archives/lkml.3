Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755050AbaGHSDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:03:05 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:47359 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753977AbaGHSDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:03:03 -0400
MIME-Version: 1.0
In-Reply-To: <1404823639-6496-1-git-send-email-mmarek@suse.cz>
References: <CAPVoSvSmzRWSJeR9dyBO0qS6-9SWA_d-CjGuQeULGS_MRUY77w@mail.gmail.com>
	<1404823639-6496-1-git-send-email-mmarek@suse.cz>
Date: Tue, 8 Jul 2014 20:03:01 +0200
Message-ID: <CAPVoSvTSbSrEza+25oW4V2iqVMfKsgTbCxHgwA81kD4D1FYRQQ@mail.gmail.com>
Subject: Re: [PATCH] firmware: Create directories for external firmware
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Ronald <ronald645@gmail.com>, linux-kbuild@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 2:47 PM, Michal Marek <mmarek@suse.cz> wrote:
> Commit 5180d5f4 ("firmware: Simplify directory creation") broke
> including firmware specified in CONFIG_EXTRA_FIRMWARE:
>
>   MK_FW   firmware/amd-ucode/microcode_amd.bin.gen.S
> /bin/sh: firmware/amd-ucode/microcode_amd.bin.gen.S: No such file or directory
> ...
> firmware/Makefile:185: recipe for target
> 'firmware/amd-ucode/microcode_amd.bin.gen.S' failed
>
> It works with O= builds, because the directory is created by
> Makefile.build. Create the directory in firmware/Makefile in non-O
> builds.
>
> Reported-by: Ronald <ronald645@gmail.com>
> Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> ---
>
> Can you try this patch?

Works fine for me.

Thanks for the quick patch!

Torsten

> Ronald, can you tell me your full name for the Reported-by: line?
>
> Thanks.
> ---
>
>  firmware/Makefile | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/firmware/Makefile b/firmware/Makefile
> index 5747417..0862d34 100644
> --- a/firmware/Makefile
> +++ b/firmware/Makefile
> @@ -219,6 +219,12 @@ $(obj)/%.fw: $(obj)/%.H16 $(ihex2fw_dep)
>  obj-y                           += $(patsubst %,%.gen.o, $(fw-external-y))
>  obj-$(CONFIG_FIRMWARE_IN_KERNEL) += $(patsubst %,%.gen.o, $(fw-shipped-y))
>
> +ifeq ($(KBUILD_SRC),)
> +# Makefile.build only creates subdirectories for O= builds, but external
> +# firmware might live outside the kernel source tree
> +_dummy := $(foreach d,$(addprefix $(obj)/,$(dir $(fw-external-y))), $(shell [ -d $(d) ] || mkdir -p $(d)))
> +endif
> +
>  # Remove .S files and binaries created from ihex
>  # (during 'make clean' .config isn't included so they're all in $(fw-shipped-))
>  targets := $(fw-shipped-) $(patsubst $(obj)/%,%, \
> --
> 1.8.4.5
>
