Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3CDKGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 05:06:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50589 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755016Ab3CDKGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:06:43 -0500
Message-ID: <513471F1.5020702@redhat.com>
Date: Mon, 04 Mar 2013 11:05:37 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Hu Tao <hutao@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Blue Swirl <blauwirbel@gmail.com>,
        Eric Blake <eblake@redhat.com>, Andrew Jones <drjones@redhat.com>,
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
Subject: Re: [PATCH v13 0/8] pv event interface between host and guest
References: <cover.1362051581.git.hutao@cn.fujitsu.com> <20130303091738.GB23616@redhat.com>
In-Reply-To: <20130303091738.GB23616@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 03/03/2013 10:17, Gleb Natapov ha scritto:
> On Thu, Feb 28, 2013 at 08:13:10PM +0800, Hu Tao wrote:
>> This series implements a new interface, kvm pv event, to notify host when
>> some events happen in guest. Right now there is one supported event: guest
>> panic.
>>
> What other event do you have in mind? Is interface generic enough to
> accommodate future, yet unknown, events. It allows to pass only one
> integer specifying even type, what if additional info is needed? My be
> stop pretending that device is generic and make it do once thing but do
> it well? For generic even passing interface (whatever it may be needed
> for) much more powerful virtio should be used.
> 
> On implementation itself I do not understand why is this kvm specific.
> The only thing that makes it so is that you hook device initialization
> into guest kvm initialization code, but this is obviously incorrect.
> What stops QEMU tcg or Xen from reusing the same device for the same
> purpose except the artificial limitation in a guest.

Agreed.

> Reading data from a random ioports is not how you discover platform
> devices in 21 century (and the data you read from unassigned port is not
> guarantied to be zero, it may depend on QEMU version), you use ACPI for
> that and Marcelo already pointed that to you. Having little knowledge of
> ACPI (we all do) is not a good reason to not doing it. We probably need
> to reserve QEMU specific ACPI Plug and Play hardware ID to define our own
> devices. After that you will be able to create device with _HID(QEMU0001)
> in DSDT that supplies address information (ioport to use) and capability
> supported.

Please also document this HID in a new file in the QEMU docs/ directory.

> Guest uses acpi_get_devices() to discover a platform device by
> its name (QEMU0001).  Then you put the driver for the platform device
> into drivers/platform/x86/ and QEMU/kvm/Xen all will be able to use it.

Just to clarify it for Hu Tao, the read from a random ioport is how the
ACPI code will detect presence of the device.

Something like this should work (in SeaBIOS's src/acpi-dsdt-isa.dsl):

    Device(PEVT) {
        Name(_HID, EisaId("QEMU0001"))
        OperationRegion(PEOR, SystemIO, 0x505, 0x01)
        Field(PEOR, ByteAcc, NoLock, Preserve) {
            PEPT,   8,
        }

        Method(_STA, 0, NotSerialized) {
            Store(PEPT, Local0)
            If (LEqual(Local0, Zero)) {
                Return (0x00)
            } Else {
                Return (0x0F)
            }
        }

        Name(_CRS, ResourceTemplate() {
            IO(Decode16, 0x505, 0x505, 0x01, 0x01)
        })
    }

Please test this with a QEMU option like "-M pc-1.4".  The device should
_not_ be detected if you're doing it right.

> On QEMU side of things I cannot comment much on how QOMified the device
> is (it should be),

Please make the device target-independent.  It can be used on non-x86
architectures that have I/O ports.  You should make the port
configurable using a property (DEFINE_PROPERTY_INT16 or something like
that), with a default of 0x505.

All the panicked_action is not necessary in my opinion.  We have it for
watchdogs, but that's really a legacy thing.  Let libvirt do it, and
always make the guest panic perform the PANICKED_PAUSE action.

If you do it properly, a lot (really a lot) of code will go away.

> I hope other reviews will verify it, but I noticed
> that device is only initialized for PIIX, what about Q35?

Yup.

Paolo

