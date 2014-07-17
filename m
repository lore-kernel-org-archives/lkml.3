Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaGQIMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:12:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154AbaGQIMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:12:21 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: stefano.stabellini@eu.citrix.com, xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] xen/pvhvm: Make MSI IRQs work after kexec
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com>
	<1405431640-649-5-git-send-email-vkuznets@redhat.com>
	<20140715152105.GP3403@laptop.dumpdata.com>
	<87fvi1u16k.fsf@vitty.brq.redhat.com>
	<20140716134050.GH19585@laptop.dumpdata.com>
	<87egxljk48.fsf@vitty.brq.redhat.com>
	<20140716173038.GD30483@laptop.dumpdata.com>
Date: Thu, 17 Jul 2014 10:12:07 +0200
In-Reply-To: <20140716173038.GD30483@laptop.dumpdata.com> (Konrad Rzeszutek
	Wilk's message of "Wed, 16 Jul 2014 13:30:38 -0400")
Message-ID: <87a988jtew.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:

> On Wed, Jul 16, 2014 at 07:20:39PM +0200, Vitaly Kuznetsov wrote:
>> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:
>> 
>> > On Wed, Jul 16, 2014 at 11:01:55AM +0200, Vitaly Kuznetsov wrote:
>> >> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> writes:
>> >> 
>> >> > On Tue, Jul 15, 2014 at 03:40:40PM +0200, Vitaly Kuznetsov wrote:
>> >> >> When kexec was peformed MSI IRQs for passthrough-ed devices were already
>> >> >> mapped and we see non-zero pirq extracted from MSI msg. xen_irq_from_pirq()
>> >> >> fails as we have no IRQ mapping information for that. Requesting for new
>> >> >> mapping with __write_msi_msg() does not result in MSI IRQ being remapped so
>> >> >> we don't recieve these IRQs.
>> >> >
>> >> > receive
>> >> >
>> >> 
>> >> Thanks for your comments!
>> >
>> > Thank you for quick turnaround with the answers!
>> >> 
>> >> > How come '__write_msi_msg' does not result in new MSI IRQs?
>> >> >
>> >> 
>> >> Actually that was the hidden question in my RFC :-)
>> >> 
>> >> Let me describe what I see. When normal boot is performed we have the
>> >> following in xen_hvm_setup_msi_irqs():
>> >> 
>> >> __read_msi_msg()
>> >>  pirq -> 0
>> >> 
>> >> then we allocate new pirq with
>> >>  pirq = xen_allocate_pirq_msi()
>> >>  pirq -> 54
>> >> 
>> >> and we have the following mapping:
>> >> xen: msi --> pirq=54 --> irq=72
>> >> 
>> >> in 'xl debug-keys i':
>> >> (XEN)    IRQ:  29 affinity:04 vec:b9 type=PCI-MSI status=00000030 in-flight=0 domain-list=7: 54(----),
>> >> 
>> >> After kexec we see the following:
>> >> __read_msi_msg()
>> >>  pirq -> 54
>> >> 
>> >> but as xen_irq_from_pirq() fails we follow the same path allocating new pirq:
>> >>  pirq = xen_allocate_pirq_msi()
>> >>  pirq -> 55
>> >> 
>> >> and we have the following mapping:
>> >> xen: msi --> pirq=55 --> irq=75
>> >> 
>> >> However (afaict) mapping in xen wasn't updated:
>> >> 
>> >> in 'xl debug-keys i':
>> >> (XEN)    IRQ:  29 affinity:02 vec:b9 type=PCI-MSI status=00000030 in-flight=0 domain-list=7: 54(--M-),
>> >
>> > I am wondering if that is related to in QEMU traditional:
>> >
>> >     qemu-xen-trad: free all the pirqs for msi/msix when driver unloads
>> >
>> > (which in the upstream QEMU is 1d4fd4f0e2fc5dcae0c60e00cc9af95f52988050)
>> >
>> > If you have that patch in, is the PIRQ value correctly updated?
>> >
>> 
>> Thanks, that really works! I tested both kexec -e / kdump cases. I'm
>> wondering if we although need my commit to workaround non-fixed qemus?
>
> Without your patch on older QEMU's with PCI passthrough we won't get
> any more interrupts after we kexec in the guest right?
>

Correct.

> As in, this issue happens _only_ with PCI passthrough devices that use
> MSI or MSI-X?

I haven't tested MSI-X but in theory yes, only MSI and MSI-X
passthrough-ed devices are affected.

>
> Still need to get Stefano's view on this.
>

Sure, thanks!

>> 
>> >> 
>> >> > Is it fair to state that your code ends up reading the MSI IRQ (PIRQ)
>> >> > from the device and updating the internal PIRQ<->IRQ code to match
>> >> > with the reality?
>> >> >
>> >> 
>> >> Yea, 'always trust the device'.
>> >> 
>> >> >> 
>> >> >> RFC: I wasn't able to understand why commit af42b8d1 which introduced
>> >> >> xen_irq_from_pirq() check in xen_hvm_setup_msi_irqs() is checking that instead
>> >> >> of checking pirq > 0 as if the mapping was already done (and we have pirq>0 here)
>> >> >> we don't need to request for a new pirq. We're loosing existing PIRQ and I'm also
>> >> >> not sure when __write_msi_msg() with new PIRQ will result in new mapping.
>> >> >
>> >> > We don't request a new pirq. We end up returning before we call xen_allocate_pirq_msi.
>> >> > At least that is how the commit you mentioned worked.
>> >> >
>> >> 
>> >> I meant to say that in case we have pirq > 0 from __read_msi_msg() but
>> >> xen_irq_from_pirq(pirq) fails (kexec-only case?) we always do
>> >> xen_allocate_pirq_msi() which brings us new pirq.
>> >> 
>> >> > In regards to why using 'xen_irq_from_pirq' instead of just checking the PIRQ - is
>> >> > that we might be called twice by a buggy driver. As such we want to check
>> >> > our PIRQ<->IRQ to figure this out.
>> >> 
>> >> But if we're called twice we'll see the same pirq, right? Or there are
>> >
>> > Good point.
>> >> some cases when we see 'crap' instead of pirq here?
>> >
>> > For PCI passthrough devices they will be zero until they are enabled.
>> > But I am not sure about the emulated devices, such as e1000 or such, which
>> > would also go through this path (I think - do we have MSI devices that
>> > we emulate in QEMU?)
>> 
>> AFAICT emulated e1000 doesn't use MSI (at least with qemu-tradidtional)
>> and with my patch series it works after kexec.
>> 
>> >
>> >> 
>> >> I think it would be nice to use the same pirq after kexec instead of
>> >> allocating a new one even in case we can make remapping work.
>> >
>> > I concur.
>> >
>> > Stefano, do you recall why you used xen_irq_from_pirq instead of just
>> > trusting the 'pirq' value? Was it to workaround broken QEMU?
>> >
>> >> 
>> >> Thanks for your comments again!
>> >> 
>> >> >> 
>> >> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> >> >> ---
>> >> >>  arch/x86/pci/xen.c | 3 +--
>> >> >>  1 file changed, 1 insertion(+), 2 deletions(-)
>> >> >> 
>> >> >> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
>> >> >> index 905956f..685e8f1 100644
>> >> >> --- a/arch/x86/pci/xen.c
>> >> >> +++ b/arch/x86/pci/xen.c
>> >> >> @@ -231,8 +231,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>> >> >>  		__read_msi_msg(msidesc, &msg);
>> >> >>  		pirq = MSI_ADDR_EXT_DEST_ID(msg.address_hi) |
>> >> >>  			((msg.address_lo >> MSI_ADDR_DEST_ID_SHIFT) & 0xff);
>> >> >> -		if (msg.data != XEN_PIRQ_MSI_DATA ||
>> >> >> -		    xen_irq_from_pirq(pirq) < 0) {
>> >> >> +		if (msg.data != XEN_PIRQ_MSI_DATA || pirq <= 0) {
>> >> >>  			pirq = xen_allocate_pirq_msi(dev, msidesc);
>> >> >>  			if (pirq < 0) {
>> >> >>  				irq = -ENODEV;
>> >> >> -- 
>> >> >> 1.9.3
>> >> >> 
>> >> 
>> >> -- 
>> >>   Vitaly
>> 
>> -- 
>>   Vitaly

-- 
  Vitaly
