Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab3CDJxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:53:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124Ab3CDJxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:53:23 -0500
Message-ID: <51346D9E.1090806@redhat.com>
Date: Mon, 04 Mar 2013 10:47:10 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Hu Tao <hutao@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Anthony Liguori <aliguori@us.ibm.com>,
        Markus Armbruster <armbru@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Orit Wasserman <owasserm@redhat.com>, Kevin Wolf <kwolf@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH v13 7/8] allower the user to disable pv event support
References: <cover.1362051581.git.hutao@cn.fujitsu.com> <1af3c134891e119a21268ac6c48434447a8f6ab2.1362051582.git.hutao@cn.fujitsu.com>
In-Reply-To: <1af3c134891e119a21268ac6c48434447a8f6ab2.1362051582.git.hutao@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/02/2013 13:13, Hu Tao ha scritto:
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
> ---
>  hw/pc_piix.c    | 9 ++++++++-
>  qemu-options.hx | 3 ++-
>  vl.c            | 4 ++++
>  3 files changed, 14 insertions(+), 2 deletions(-)

We cannot add -machine suboptions for everything we add to a random
machine type.  I think it's better to do one of the following:

1) not add it to the machine by default.  Let libvirt add it with -device.

2) add a property to the piix3 ISA bridges (in hw/piix_pci.c) to
enable/disable it.  It can be set with -global PIIX3.pv_event=on/off.

In the second case, if you set it to on by default, you will also need
to add the property in hw/pc.h, to disable the device in older machine
types for backwards-compatibility.

Paolo

> diff --git a/hw/pc_piix.c b/hw/pc_piix.c
> index 24a9bf3..82a421a 100644
> --- a/hw/pc_piix.c
> +++ b/hw/pc_piix.c
> @@ -44,6 +44,7 @@
>  #include "exec/memory.h"
>  #include "exec/address-spaces.h"
>  #include "cpu.h"
> +#include "qemu/config-file.h"
>  #ifdef CONFIG_XEN
>  #  include <xen/hvm/hvm_info_table.h>
>  #endif
> @@ -86,6 +87,8 @@ static void pc_init1(MemoryRegion *system_memory,
>      MemoryRegion *pci_memory;
>      MemoryRegion *rom_memory;
>      void *fw_cfg = NULL;
> +    QemuOptsList *list = qemu_find_opts("machine");
> +    bool enable_pv_event = false;
>  
>      pc_cpus_init(cpu_model);
>      pc_acpi_init("acpi-dsdt.aml");
> @@ -218,7 +221,11 @@ static void pc_init1(MemoryRegion *system_memory,
>          pc_pci_device_init(pci_bus);
>      }
>  
> -    if (kvm_enabled()) {
> +    if (list && !QTAILQ_EMPTY(&list->head)) {
> +        enable_pv_event = qemu_opt_get_bool(QTAILQ_FIRST(&list->head),
> +                                            "enable_pv_event", false);
> +    }
> +    if (kvm_enabled() && enable_pv_event) {
>          kvm_pv_event_init(isa_bus);
>      }
>  }
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 797d992..1ad4041 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -35,7 +35,8 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
>      "                kernel_irqchip=on|off controls accelerated irqchip support\n"
>      "                kvm_shadow_mem=size of KVM shadow MMU\n"
>      "                dump-guest-core=on|off include guest memory in a core dump (default=on)\n"
> -    "                mem-merge=on|off controls memory merge support (default: on)\n",
> +    "                mem-merge=on|off controls memory merge support (default: on)\n"
> +    "                enable_pv_event=on|off controls pv event support (default: off)\n",
>      QEMU_ARCH_ALL)
>  STEXI
>  @item -machine [type=]@var{name}[,prop=@var{value}[,...]]
> diff --git a/vl.c b/vl.c
> index 51d4922..5b3a279 100644
> --- a/vl.c
> +++ b/vl.c
> @@ -427,6 +427,10 @@ static QemuOptsList qemu_machine_opts = {
>              .name = "usb",
>              .type = QEMU_OPT_BOOL,
>              .help = "Set on/off to enable/disable usb",
> +        }, {
> +            .name = "enable_pv_event",
> +            .type = QEMU_OPT_BOOL,
> +            .help = "handle pv event"
>          },
>          { /* End of list */ }
>      },
> 

