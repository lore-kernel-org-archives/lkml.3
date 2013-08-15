Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464Ab3HOQL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:11:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45268 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829Ab3HOQL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:11:56 -0400
Date: Thu, 15 Aug 2013 18:11:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>, tony.luck@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error
 trace event
Message-ID: <20130815161153.GI27616@pd.tnic>
References: <520A16BD.30201@linux.vnet.ibm.com>
 <20130813124258.GC4077@pd.tnic>
 <520A6D98.9060204@linux.vnet.ibm.com>
 <20130813175809.GE4077@pd.tnic>
 <520B6282.6030906@linux.vnet.ibm.com>
 <20130814212211.544ee6a4@concha.lan>
 <20130815093831.GA27616@pd.tnic>
 <20130815102607.7168a930@samsung.com>
 <20130815134454.GF27616@pd.tnic>
 <20130815111407.4080a744@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130815111407.4080a744@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 15, 2013 at 11:14:07AM -0300, Mauro Carvalho Chehab wrote:
> I don't see why should we have those two alternatives, as, at worse
> case (e. g. if ghes_edac can't enrich the APEI data with labels),
> they'll basically provide the very same data to userspace, and the
> EDAC extra overhead is small, on its error report logic.

Well, a couple of reasons.

The first and foremost one is having another layer which needs
registration, etc. because ghes_edac pulls the whole edac core stuff
with it. The thinner we are, the less overhead we cause. And this is
a must for RAS.

Actually, this is a must for all kernel code - the faster we can get
done and the thinner we are, the better. We absolutely definitely don't
want to have a useless layer in the error reporting path just because it
is easier.

This short path will pay out later in error storms and other
resources-constrained situations.

Furthermore, dealing with another edac driver is not trivial for
distros, like going around and telling people that all of a sudden
they need to enable ghes_edac. This is tangential to the issue which
Naveen raised that on some machines, you want not only ghes_edac but the
platform-specific one. Which doesn't work currently and we don't have a
clear solution on how to get it working yet.

Finally, userspace doesn't care where it gets its TP data from as long
as it is there.

> The risk of doing the very same thing on two different places is that
> the logic to encapsulate APEI data into trace_mc_event() would be on
> two separate places. It risks that someone would change one of the
> drivers and forget to apply the very same change on the other, causing
> parse errors on userspace, depending on the source.

We'll make sure that doesn't happen.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
