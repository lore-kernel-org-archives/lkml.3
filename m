Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3K0Jfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 04:35:32 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:37683 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3K0Jf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 04:35:26 -0500
MIME-Version: 1.0
Date: Wed, 27 Nov 2013 10:35:25 +0100
X-Google-Sender-Auth: u0AKEYuQ5jy0Yg0vIOjyIpcpKlI
Message-ID: <CAMuHMdUr2Vr9+STwcYf1PcB=PF+u3SJxU3LYnzqQ+vdbDsp71A@mail.gmail.com>
Subject: Evolution of Linux kernel sizes
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preface:
    The results below are for m68k.
    Why would you care about m68k? You don't, but that doesn't
    mean the results are not applicable to other architectures and
    platforms where RAM is a precious resource.

Below are the static kernel sizes (as reported by "size") for m68k
multi-platform kernels (m68k/multi_defconfig), for kernel versions
2.6.28 to 3.12:

   text    data     bss     dec     hex filename
3420940  204772  163888 3789600  39d320 vmlinux-v2.6.28
3464548  219592  164972 3849112  3abb98 vmlinux-v2.6.29
3388760  207964  156588 3753312  394560 vmlinux-v2.6.30
3453128  210649  157580 3821357  3a4f2d vmlinux-v2.6.31
3477222  212032  158156 3847410  3ab4f2 vmlinux-v2.6.32
3513197  210032  154880 3878109  3b2cdd vmlinux-v2.6.33
3530751  211200  154032 3895983  3b72af vmlinux-v2.6.34
3583761  211404  154448 3949613  3c442d vmlinux-v2.6.35
3570768  179888  153344 3904000  3b9200 vmlinux-v2.6.36
3568083  182516  149992 3900591  3b84af vmlinux-v2.6.37
3609796  182736  149228 3941760  3c2580 vmlinux-v2.6.38
3621429  180576  145056 3947061  3c3a35 vmlinux-v2.6.39
3756437  181424  140184 4078045  3e39dd vmlinux-v3.0
3778616  203272  135564 4117452  3ed3cc vmlinux-v3.1
3550337  182512  183004 3915853  3bc04d vmlinux-v3.2
3579169  183044  182360 3944573  3c307d vmlinux-v3.3
3520525  210752  176384 3907661  3ba04d vmlinux-v3.4
3543961  211604  181788 3937353  3c1449 vmlinux-v3.5
3567386  209328  181888 3958602  3c674a vmlinux-v3.6
3623569  210344  181572 4015485  3d457d vmlinux-v3.7
3981063  216584  184284 4381931  42dceb vmlinux-v3.8
3999784  220336  183356 4403476  433114 vmlinux-v3.9
4040393  217440  188108 4445941  43d6f5 vmlinux-v3.10
4076456  222544  190632 4489632  4481a0 vmlinux-v3.11
4010686  220476  190220 4421382  437706 vmlinux-v3.12

It's not a perfect list, as config files evolve over time, but there's
clearly a trend of increasing kernel sizes, ca. 25 KiB/version.

One issue we're facing is that currently the early kernel startup
code on m68k does not support kernel images larger than 4 MiB.
However, I'm not inclined to fix that, as it removes all incentive
to keep kernel sizes small ;-)

The current distro solution is to make as many drivers as possible
modular, and use an initrd. But this adds complexity, and not
everyone wants to use an initrd.

Then you start wondering: What options can I disable? What does
disabling an option gain?

So I wrote a script to automate this process, starting from the current
.config:

https://github.com/geertu/linux-scripts/blob/master/linux-analyze-marginal-sizes

>From the accompanying README:

    Starting from the current .config file, find out how much space is saved
    in the kernel image by individually disabling each of the currently
    enabled config options. Module support and all modules are disabled first.

    You can pass make options to specify e.g. the target architecture and
    cross compiler.

    Caveats:
      * This is only about static kernel size, not about dynamic memory
        consumption.
      * You cannot just add up the numbers, as some config options depend on
        other config options.
      * It's highly recommended to use ccache or distcc.

    Example: Display the top 10 options to decrease kernel image size:

        linux-analyze-marginal-sizes CROSS_COMPILE=m68k-linux-gnu- \
                ARCH=m68k -j 4 | tee log
        grep -w saves log | sort -nr --key=4 | head -10

For v3.13-rc1, the top 10 is:

Disabling CONFIG_NET saves 1038404 bytes
Disabling CONFIG_INET saves 572034 bytes
Disabling CONFIG_EXT4_FS saves 328370 bytes
Disabling CONFIG_NFS_FS saves 258728 bytes
Disabling CONFIG_NETWORK_FILESYSTEMS saves 258728 bytes
Disabling CONFIG_SCSI saves 241850 bytes
Disabling CONFIG_FB saves 207496 bytes
Disabling CONFIG_AMIGA saves 160700 bytes
Disabling CONFIG_MAC saves 151134 bytes
Disabling CONFIG_ATARI saves 138392 bytes

I hope you find this useful!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
