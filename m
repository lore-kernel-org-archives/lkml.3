Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3HEPez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 11:34:55 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:57807 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753516Ab3HEPew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 11:34:52 -0400
Message-ID: <1375716889.2163.12.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [edk2] Corrupted EFI region
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Laszlo Ersek <lersek@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, edk2-devel@lists.sourceforge.net,
        David Woodhouse <dwmw2@infradead.org>, linux-efi@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, Gleb Natapov <gleb@redhat.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Date: Mon, 05 Aug 2013 08:34:49 -0700
In-Reply-To: <51FFC19A.1020204@redhat.com>
References: <20130731205431.GG4724@pd.tnic>
	 <1375307727.22084.103.camel@shinybook.infradead.org>
	 <20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com>
	 <20130805130258.GB31845@pd.tnic> <51FFAB13.4090603@redhat.com>
	 <20130805140306.GD31845@pd.tnic> <51FFB660.4060400@redhat.com>
	 <20130805144010.GE31845@pd.tnic> <51FFC19A.1020204@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 17:15 +0200, Laszlo Ersek wrote:
> On 08/05/13 16:40, Borislav Petkov wrote:
> > On Mon, Aug 05, 2013 at 04:27:44PM +0200, Laszlo Ersek wrote:
> >> I wouldn't call the design of SetVirtualAddressMap() braindead.
> > 
> > Ok, I've always wondered and you could probably shed some light on the
> > matter: why is SetVirtualAddressMap() a call-once only? Why can't I
> > simply call it again and update the mappings?
> 
> The current implementation (how pointers are converted) probably doesn't
> accommodate a second call.

Having actually looked at the code (trying to find why we were getting
an unconverted pointer), I second that.  However, the ugliness of the
massive pointer chase should have been an indication that something was
not quite right architecturally (or implementation wise) with
SetVirtualAddressMap().

> Of course you want to know why SetVirtualAddressMap() was designed like
> that... I didn't participate in the design so I don't know :)
> 
> But, as I said, a kernel directly executing another kernel is an
> unexpected idea. IMHO the second kernel in question doesn't fit the UEFI
> phases at all. The OS booted like that (ie. the OS whose kernel is the
> 2nd (=kexec) kernel) never goes through SEC, PEI, DXE, BDS.

That thinking is a bit last century (not that I'm blaming you for it, it
seems to be ingrained in the way UEFI sometimes goes about things) ...
in the old days, DOS was bootstrapped by the 512 byte jump code in a
well known sector.  In the current century, almost every OS is
bootstrapped by a sophisticated loader, which is effectively another OS
(if you don't believe this, try looking at the grub source code one
day); it's a short step from this to one OS booting another, and that's
really what kexec is.  The utility of kexec has proven itself over the
past couple of decades or so by allowing us to dump (kexec to a dump
kernel), short circuit the boot process (simply re-kexec the kernel on
crash) and now do rebootless upgrades (checkpoint the userspace and
kexec to the new kernel).  It's not even unique to Linux: Solaris used a
hidden kexec system call to do live upgrades as well and I believe
several other UNIXs have this feature.

James


