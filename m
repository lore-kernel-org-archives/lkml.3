Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbaCPOOF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 10:14:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35493 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbaCPOOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 10:14:02 -0400
Message-ID: <5325B1A3.9070102@redhat.com>
Date: Sun, 16 Mar 2014 15:13:55 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>, Tejun Heo <tj@kernel.org>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        dann frazier <dann.frazier@canonical.com>
Subject: Re: linux-next: ahci_platform broken build
References: <5325AFB2.4050505@canonical.com>
In-Reply-To: <5325AFB2.4050505@canonical.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/16/2014 03:05 PM, Tim Gardner wrote:
> Gents  - while reviewing some patches for arm64 in Ubuntu I noticed that there is at least one patch sequence in linux-next that breaks the build.
> 
> 156c5887948cd191417f18026aab9ce26e5a95da ahci-platform: Add support for devices with more then 1 clock
> 039ece38da45f5e6a94be3aa7611cf3634bc2461 libahci: Allow drivers to override start_engine
> 
> For example:
> 
> git reset --hard 156c5887948cd191417f18026aab9ce26e5a95da
> echo "CONFIG_SATA_AHCI_PLATFORM=y" >> .config
> make oldconfig scripts prepare
> make M=drivers/ata
> 
>   WARNING: Symbol version dump /home/rtg/linux/linux-next/Module.symvers
>            is missing; modules will have no dependencies and modversions.
> 
>   CC      drivers/ata/libata-core.o
>   CC      drivers/ata/libata-scsi.o
>   CC      drivers/ata/libata-eh.o
>   CC      drivers/ata/libata-transport.o
>   CC      drivers/ata/libata-sff.o
>   CC      drivers/ata/libata-pmp.o
>   CC      drivers/ata/libata-acpi.o
>   LD      drivers/ata/libata.o
>   CC      drivers/ata/ahci.o
>   CC      drivers/ata/libahci.o
>   CC      drivers/ata/ahci_platform.o
> drivers/ata/ahci_platform.c: In function ‘ahci_probe’:
> drivers/ata/ahci_platform.c:209:2: error: implicit declaration of function ‘ahci_enable_clks’ [-Werror=implicit-function-declaration]
> drivers/ata/ahci_platform.c:293:2: error: implicit declaration of function ‘ahci_disable_clks’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors
> make[1]: *** [drivers/ata/ahci_platform.o] Error 1
> make: *** [_module_drivers/ata] Error 2
> 
> The compile problem is then fixed in 96a01ba52c60fdd74dd6e8cf06645d06515b1396 (ahci-platform: Add enable_ / disable_resources helper functions) which is not really kosher.

Ah good catch, at some point I decided to prefix all the ahci_* functions defined in ahci_platform.c
with ahci_platform_ instead of just ahci_. Somehow the functions got added with their new names
directly in the "ahci-platform: Add support for devices with more then 1 clock" patch (this is
intentional), but the calls added in that patch kept using the old names. Then in the
"ahci-platform: Add enable_ / disable_resources helper functions" patch
the calls get moved to another place and now show up with the proper ahci_platform_*
names. My bad.

Tejun it is probably easiest if you fix this up directly in your tree, let me know if you
want a fixed up resend of the 2 patches in question instead.

Regards,

Hans
