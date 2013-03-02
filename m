Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab3CBAVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 19:21:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559Ab3CBAVy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 19:21:54 -0500
Date: Fri, 1 Mar 2013 21:03:12 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Hu Tao <hutao@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>,
        Blue Swirl <blauwirbel@gmail.com>, Eric Blake <eblake@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Wen Congyang <wency@cn.fujitsu.com>
Subject: Re: [PATCH v12 rebased] kvm: notify host when the guest is panicked
Message-ID: <20130302000312.GA25309@amt.cnet>
References: <cover.1358920534.git.hutao@cn.fujitsu.com>
 <1358925575-4505-1-git-send-email-hutao@cn.fujitsu.com>
 <20130208013947.GA3364@amt.cnet>
 <20130228085425.GA16362@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130228085425.GA16362@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 04:54:25PM +0800, Hu Tao wrote:
> > > diff --git a/arch/x86/include/uapi/asm/kvm_para.h b/arch/x86/include/uapi/asm/kvm_para.h
> > > index 06fdbd9..c15ef33 100644
> > > --- a/arch/x86/include/uapi/asm/kvm_para.h
> > > +++ b/arch/x86/include/uapi/asm/kvm_para.h
> > > @@ -96,5 +96,7 @@ struct kvm_vcpu_pv_apf_data {
> > >  #define KVM_PV_EOI_ENABLED KVM_PV_EOI_MASK
> > >  #define KVM_PV_EOI_DISABLED 0x0
> > >  
> > > +#define KVM_PV_EVENT_PORT	(0x505UL)
> > > +
> > 
> > No need for the ioport to be hard coded. What are the options to
> > communicate an address to the guest? An MSR, via ACPI?
> 
> I'm not quite understanding here. By 'address', you mean an ioport?
> how to communicate an address? (I have little knowledge about ACPI)

Yes, the ioport. The address of the ioport should not be fixed (for
example future emulated board could use that fixed ioport address,
0x505UL).

One option is to pass the address via an MSR. Yes, that is probably the
best option because there is no dependency on ACPI.

> > "pv-event" is a bad name for an interface which is specific to notify
> > panic events. Please use pv-panic everywhere.
> 
> panic event is one of the events supported. Can we keep the name?

> > Call the initialization code from kvm_guest_init, only one function is
> > necessary.
> 
> At the point of kvm_guest_init, rqeust_region (called by
> kvm_pv_event_init) will block, so the guest kernel won't up.

Why does it block?

> > >  #define PANIC_TIMER_STEP 100
> > >  #define PANIC_BLINK_SPD 18
> > > @@ -132,6 +133,9 @@ void panic(const char *fmt, ...)
> > >  	if (!panic_blink)
> > >  		panic_blink = no_blink;
> > >  
> > > +	if (kvm_pv_event_enabled())
> > > +		panic_timeout = 0;
> > > +
> > 
> > What is the rationale behind this?
> 
> This is a hack to disable reset_on_panic if user enables
> pv-event.

Condition it to kvm_pv_event_enabled() directly?

