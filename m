Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab3CDLWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 06:22:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756573Ab3CDLWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 06:22:49 -0500
Date: Mon, 4 Mar 2013 12:21:31 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Hu Tao <hutao@cn.fujitsu.com>, kvm list <kvm@vger.kernel.org>,
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
Message-ID: <20130304102131.GK23616@redhat.com>
References: <cover.1362051581.git.hutao@cn.fujitsu.com>
 <20130303091738.GB23616@redhat.com>
 <513471F1.5020702@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513471F1.5020702@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 11:05:37AM +0100, Paolo Bonzini wrote:
> > Guest uses acpi_get_devices() to discover a platform device by
> > its name (QEMU0001).  Then you put the driver for the platform device
> > into drivers/platform/x86/ and QEMU/kvm/Xen all will be able to use it.
> 
> Just to clarify it for Hu Tao, the read from a random ioport is how the
> ACPI code will detect presence of the device.
> 
Actually no (at least in the long run, for the first version it may be
OK). Since we want to move DSDT generation into QEMU if device will not
be present QEMU will not generate corresponded Device() in DSDT, or it
will generate it with _STA() { Return (0x00)} hard coded. Seabios can do
the same if we will pass it info about device presence via fw_cfg. Not
sure Kevin will like it now when we plan to move DSDT into QEMU anyway :)

> Something like this should work (in SeaBIOS's src/acpi-dsdt-isa.dsl):
> 
>     Device(PEVT) {
>         Name(_HID, EisaId("QEMU0001"))
>         OperationRegion(PEOR, SystemIO, 0x505, 0x01)
>         Field(PEOR, ByteAcc, NoLock, Preserve) {
>             PEPT,   8,
>         }
> 
>         Method(_STA, 0, NotSerialized) {
>             Store(PEPT, Local0)
>             If (LEqual(Local0, Zero)) {
>                 Return (0x00)
>             } Else {
>                 Return (0x0F)
>             }
>         }
> 
>         Name(_CRS, ResourceTemplate() {
>             IO(Decode16, 0x505, 0x505, 0x01, 0x01)
>         })
>     }
> 
> Please test this with a QEMU option like "-M pc-1.4".  The device should
> _not_ be detected if you're doing it right.
> 

--
			Gleb.
