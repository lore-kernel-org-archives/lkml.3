Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281AbaJIPyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:54:18 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:45836 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaJIPyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:54:10 -0400
Date: Thu, 9 Oct 2014 08:54:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-m32r-ja@ml.linux-m32r.org" <linux-m32r-ja@ml.linux-m32r.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-xtensa@linux-xtensa.org" <linux-xtensa@linux-xtensa.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "lguest@lists.ozlabs.org" <lguest@lists.ozlabs.org>,
        "linux-c6x-dev@linux-c6x.org" <linux-c6x-dev@linux-c6x.org>,
        "linux-hexagon@vger.kernel.org" <linux-hexagon@vger.kernel.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "adi-buildroot-devel@lists.sourceforge.net" 
	<adi-buildroot-devel@lists.sourceforge.net>,
        "linux-m68k@vger.kernel.org" <linux-m68k@vger.kernel.org>,
        "linux-am33-list@redhat.com" <linux-am33-list@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
        "linux-metag@vger.kernel.org" <linux-metag@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        "linux-cris-kernel@axis.com" <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-alpha@vger.kernel.org" <linux-alpha@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH 12/44] mfd: ab8500-sysctrl: Register with kernel poweroff
 handler
Message-ID: <20141009155404.GC31987@roeck-us.net>
References: <1412659726-29957-1-git-send-email-linux@roeck-us.net>
 <1412659726-29957-13-git-send-email-linux@roeck-us.net>
 <20141007080048.GB25331@lee--X1>
 <20141009103656.GF17836@e104818-lin.cambridge.arm.com>
 <20141009104927.GN20647@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009104927.GN20647@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 11:49:27AM +0100, Lee Jones wrote:
> On Thu, 09 Oct 2014, Catalin Marinas wrote:
> 
> > On Tue, Oct 07, 2014 at 09:00:48AM +0100, Lee Jones wrote:
> > > On Mon, 06 Oct 2014, Guenter Roeck wrote:
> > > > --- a/drivers/mfd/ab8500-sysctrl.c
> > > > +++ b/drivers/mfd/ab8500-sysctrl.c
> > > > @@ -6,6 +6,7 @@
> > > 
> > > [...]
> > > 
> > > > +static int ab8500_power_off(struct notifier_block *this, unsigned long unused1,
> > > > +			    void *unused2)
> > > >  {
> > > >  	sigset_t old;
> > > >  	sigset_t all;
> > > > @@ -34,11 +36,6 @@ static void ab8500_power_off(void)
> > > >  	struct power_supply *psy;
> > > >  	int ret;
> > > >  
> > > > -	if (sysctrl_dev == NULL) {
> > > > -		pr_err("%s: sysctrl not initialized\n", __func__);
> > > > -		return;
> > > > -	}
> > > 
> > > Can you explain the purpose of this change please?
> > 
> > I guess it's because the sysctrl_dev is already initialised when
> > registering the power_off handler, so there isn't a way to call the
> > above function with a NULL sysctrl_dev. Probably even with the original
> > code you didn't need this check (after some race fix in
> > ab8500_sysctrl_remove but races is one of the things Guenter's patches
> > try to address).
> 
> Sounds reasonable, although I think this change should be part of
> another patch.
> 
Turns out the options are to either drop the check or to use the device
managed function to register the poweroff handler. I decided to keep
the check and use the device managed function.

Guenter
