Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab3CDJqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 04:46:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab3CDJqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 04:46:03 -0500
Message-ID: <51346C94.4080409@redhat.com>
Date: Mon, 04 Mar 2013 10:42:44 +0100
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
Subject: Re: [PATCH v13 6/8] introduce a new qom device to deal with panicked
 event
References: <cover.1362051581.git.hutao@cn.fujitsu.com> <d7b92bed37f3669194b45acd8736b4b7ac71cc95.1362051582.git.hutao@cn.fujitsu.com>
In-Reply-To: <d7b92bed37f3669194b45acd8736b4b7ac71cc95.1362051582.git.hutao@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 28/02/2013 13:13, Hu Tao ha scritto:
> If the target is x86/x86_64, the guest's kernel will write 0x01 to the
> port KVM_PV_EVENT_PORT when it is panciked. This patch introduces a new
> qom device kvm_pv_ioport to listen this I/O port, and deal with panicked
> event according to panicked_action's value. The possible actions are:
> 1. emit QEVENT_GUEST_PANICKED only
> 2. emit QEVENT_GUEST_PANICKED and pause the guest
> 3. emit QEVENT_GUEST_PANICKED and poweroff the guest
> 4. emit QEVENT_GUEST_PANICKED and reset the guest
> 
> I/O ports does not work for some targets(for example: s390). And you
> can implement another qom device, and include it's code into pv_event.c
> for such target.
> 
> Note: if we emit QEVENT_GUEST_PANICKED only, and the management
> application does not receive this event(the management may not
> run when the event is emitted), the management won't know the
> guest is panicked.

There's nothing KVM-specific about this, no?

Let's call the device hw/pvevent.c, and the device isa-pvevent like
isa-debugcon and isa-debugexit.

Paolo

> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
> ---
>  hw/kvm/Makefile.objs |   2 +-
>  hw/kvm/pv_event.c    | 198 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  hw/pc_piix.c         |   5 ++
>  include/sysemu/kvm.h |   2 +
>  kvm-stub.c           |   4 ++
>  5 files changed, 210 insertions(+), 1 deletion(-)
>  create mode 100644 hw/kvm/pv_event.c
> 
> diff --git a/hw/kvm/Makefile.objs b/hw/kvm/Makefile.objs
> index f620d7f..cf93199 100644
> --- a/hw/kvm/Makefile.objs
> +++ b/hw/kvm/Makefile.objs
> @@ -1 +1 @@
> -obj-$(CONFIG_KVM) += clock.o apic.o i8259.o ioapic.o i8254.o pci-assign.o
> +obj-$(CONFIG_KVM) += clock.o apic.o i8259.o ioapic.o i8254.o pci-assign.o pv_event.o
> diff --git a/hw/kvm/pv_event.c b/hw/kvm/pv_event.c
> new file mode 100644
> index 0000000..5e68190
> --- /dev/null
> +++ b/hw/kvm/pv_event.c
> @@ -0,0 +1,198 @@
> +/*
> + * QEMU KVM support, paravirtual event device
> + *
> + * Copyright Fujitsu, Corp. 2012
> + *
> + * Authors:
> + *     Wen Congyang <wency@cn.fujitsu.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory.
> + *
> + */
> +
> +#include <linux/kvm_para.h>
> +#include <asm/kvm_para.h>
> +#include <qapi/qmp/qobject.h>
> +#include <qapi/qmp/qjson.h>
> +#include <monitor/monitor.h>
> +#include <sysemu/sysemu.h>
> +#include <sysemu/kvm.h>
> +
> +/* Possible values for action parameter. */
> +#define PANICKED_REPORT     1   /* emit QEVENT_GUEST_PANICKED only */
> +#define PANICKED_PAUSE      2   /* emit QEVENT_GUEST_PANICKED and pause VM */
> +#define PANICKED_POWEROFF   3   /* emit QEVENT_GUEST_PANICKED and quit VM */
> +#define PANICKED_RESET      4   /* emit QEVENT_GUEST_PANICKED and reset VM */
> +
> +#define PV_EVENT_DRIVER     "kvm_pv_event"
> +#define PV_IOPORT(obj)      OBJECT_CHECK(PVIOPortState, (obj), PV_EVENT_DRIVER)
> +
> +struct PVEventAction {
> +    char *panicked_action;
> +    int panicked_action_value;
> +};
> +
> +#define DEFINE_PV_EVENT_PROPERTIES(_state, _conf)   \
> +    DEFINE_PROP_STRING("panicked_action", _state, _conf.panicked_action)
> +
> +static void panicked_mon_event(const char *action)
> +{
> +    QObject *data;
> +
> +    data = qobject_from_jsonf("{ 'action': %s }", action);
> +    monitor_protocol_event(QEVENT_GUEST_PANICKED, data);
> +    qobject_decref(data);
> +}
> +
> +static void panicked_perform_action(uint32_t panicked_action)
> +{
> +    switch (panicked_action) {
> +    case PANICKED_REPORT:
> +        panicked_mon_event("report");
> +        break;
> +
> +    case PANICKED_PAUSE:
> +        panicked_mon_event("pause");
> +        vm_stop(RUN_STATE_GUEST_PANICKED);
> +        break;
> +
> +    case PANICKED_POWEROFF:
> +        panicked_mon_event("poweroff");
> +        qemu_system_shutdown_request();
> +        break;
> +
> +    case PANICKED_RESET:
> +        panicked_mon_event("reset");
> +        qemu_system_reset_request();
> +        break;
> +    }
> +}
> +
> +static uint64_t supported_event(void)
> +{
> +    return 1 << KVM_PV_FEATURE_PANICKED;
> +}
> +
> +static void handle_event(int event, struct PVEventAction *conf)
> +{
> +    if (event == KVM_PV_EVENT_PANICKED) {
> +        panicked_perform_action(conf->panicked_action_value);
> +    }
> +}
> +
> +static int pv_event_init(struct PVEventAction *conf)
> +{
> +    if (!conf->panicked_action) {
> +        conf->panicked_action_value = PANICKED_REPORT;
> +    } else if (strcasecmp(conf->panicked_action, "none") == 0) {
> +        conf->panicked_action_value = PANICKED_REPORT;
> +    } else if (strcasecmp(conf->panicked_action, "pause") == 0) {
> +        conf->panicked_action_value = PANICKED_PAUSE;
> +    } else if (strcasecmp(conf->panicked_action, "poweroff") == 0) {
> +        conf->panicked_action_value = PANICKED_POWEROFF;
> +    } else if (strcasecmp(conf->panicked_action, "reset") == 0) {
> +        conf->panicked_action_value = PANICKED_RESET;
> +    } else {
> +        return -1;
> +    }
> +
> +    return 0;
> +}
> +
> +#if defined(KVM_PV_EVENT_PORT)
> +
> +#include "hw/isa.h"
> +
> +typedef struct {
> +    ISADevice dev;
> +    struct PVEventAction conf;
> +    MemoryRegion ioport;
> +} PVIOPortState;
> +
> +static uint64_t pv_io_read(void *opaque, hwaddr addr, unsigned size)
> +{
> +    return supported_event();
> +}
> +
> +static void pv_io_write(void *opaque, hwaddr addr, uint64_t val,
> +                        unsigned size)
> +{
> +    PVIOPortState *s = opaque;
> +
> +    handle_event(val, &s->conf);
> +}
> +
> +static const MemoryRegionOps pv_io_ops = {
> +    .read = pv_io_read,
> +    .write = pv_io_write,
> +    .impl = {
> +        .min_access_size = 4,
> +        .max_access_size = 4,
> +    },
> +};
> +
> +static int pv_ioport_initfn(ISADevice *dev)
> +{
> +    PVIOPortState *s = PV_IOPORT(dev);
> +
> +    if (pv_event_init(&s->conf) < 0) {
> +        return -1;
> +    }
> +
> +    memory_region_init_io(&s->ioport, &pv_io_ops, s, "pv_event", 4);
> +    isa_register_ioport(dev, &s->ioport, KVM_PV_EVENT_PORT);
> +
> +    return 0;
> +}
> +
> +static Property pv_ioport_properties[] = {
> +    DEFINE_PV_EVENT_PROPERTIES(PVIOPortState, conf),
> +    DEFINE_PROP_END_OF_LIST(),
> +};
> +
> +static void pv_ioport_class_init(ObjectClass *klass, void *data)
> +{
> +    DeviceClass *dc = DEVICE_CLASS(klass);
> +    ISADeviceClass *ic = ISA_DEVICE_CLASS(klass);
> +
> +    ic->init = pv_ioport_initfn;
> +    dc->no_user = 1;
> +    dc->props = pv_ioport_properties;
> +}
> +
> +static TypeInfo pv_ioport_info = {
> +    .name          = PV_EVENT_DRIVER,
> +    .parent        = TYPE_ISA_DEVICE,
> +    .instance_size = sizeof(PVIOPortState),
> +    .class_init    = pv_ioport_class_init,
> +};
> +
> +static void pv_ioport_register_types(void)
> +{
> +    type_register_static(&pv_ioport_info);
> +}
> +
> +type_init(pv_ioport_register_types)
> +
> +void kvm_pv_event_init(void *opaque)
> +{
> +    ISABus *bus = opaque;
> +    ISADevice *dev;
> +
> +    dev = isa_create(bus, PV_EVENT_DRIVER);
> +    qdev_init_nofail(&dev->qdev);
> +}
> +
> +#else
> +
> +/*
> + * If you need a qom device to handle pv event, this device should
> + * be created and initialized in kvm_pv_event_init().
> + *
> + * The parameter opaque is the device's parent bus.
> + */
> +void kvm_pv_event_init(void *opaque)
> +{
> +}
> +#endif
> diff --git a/hw/pc_piix.c b/hw/pc_piix.c
> index aa9cc81..24a9bf3 100644
> --- a/hw/pc_piix.c
> +++ b/hw/pc_piix.c
> @@ -47,6 +47,7 @@
>  #ifdef CONFIG_XEN
>  #  include <xen/hvm/hvm_info_table.h>
>  #endif
> +#include <linux/kvm_para.h>
>  
>  #define MAX_IDE_BUS 2
>  
> @@ -216,6 +217,10 @@ static void pc_init1(MemoryRegion *system_memory,
>      if (pci_enabled) {
>          pc_pci_device_init(pci_bus);
>      }
> +
> +    if (kvm_enabled()) {
> +        kvm_pv_event_init(isa_bus);
> +    }
>  }
>  
>  static void pc_init_pci(QEMUMachineInitArgs *args)
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index f2d97b5..97d3daf 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -296,4 +296,6 @@ int kvm_irqchip_add_irqfd_notifier(KVMState *s, EventNotifier *n, int virq);
>  int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n, int virq);
>  void kvm_pc_gsi_handler(void *opaque, int n, int level);
>  void kvm_pc_setup_irq_routing(bool pci_enabled);
> +
> +void kvm_pv_event_init(void *opaque);
>  #endif
> diff --git a/kvm-stub.c b/kvm-stub.c
> index 760aadc..f543fa2 100644
> --- a/kvm-stub.c
> +++ b/kvm-stub.c
> @@ -145,3 +145,7 @@ int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n, int virq)
>  {
>      return -ENOSYS;
>  }
> +
> +void kvm_pv_event_init(void *opaque)
> +{
> +}
> 

