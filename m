Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaF0QIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:08:52 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41076 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023AbaF0QIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:08:49 -0400
Date: Fri, 27 Jun 2014 18:08:41 +0200
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, x86-ml <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] 2 RAS fixes for 3.17, refreshed
Message-ID: <20140627160841.GH23153@pd.tnic>
References: <20140622164603.GA3385@pd.tnic>
 <20140624132439.GH4439@pd.tnic>
 <20140624132701.GB28885@laptop.dumpdata.com>
 <20140627150155.GG23153@pd.tnic>
 <53AD89FB.7090609@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53AD89FB.7090609@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 11:12:59AM -0400, Boris Ostrovsky wrote:
> Yes, it fails because xen_late_init_mcelog() registers /dev/mcelog and (I
> think) it happens before mcheck_init_device().

Yes, mcheck_init_device is device_initcall_sync() while
xen_late_init_mcelog() is device_initcall().

> In other words, misc_register() expected to fail in mcheck/mce.c on
> (privileged?) PV guests (provided right CONFIG_XEN_* is set).

So

	cef12ee52b05 ("xen/mce: Add mcelog support for Xen platform")

made it this way so that xen's init routine runs first.

So it is not the case that misc_register() fails often on xen but it is
*supposed* to fail by design, when running in dom0. And *then* you need
the notifier *not* unregistered on the error path so that the timers do
get deleted properly.

Ok, I see it now. Frankly, I'm not really sure I want to rush this in
now because it might break something else, Who TF knows what.

Right now my gut feeling tells me we should still queue it for 3.17 and
have it run for a while in linux-next. We can backport it to stable
later after some testing...

Hmmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
