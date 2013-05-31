Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab3EaQ2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:28:40 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:39230 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3EaQ2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:28:32 -0400
Date: Fri, 31 May 2013 17:28:16 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Russ Anderson <rja@sgi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Jiri Kosina <jkosina@suse.cz>, joeyli <jlee@suse.com>,
        Matt Fleming <matt@console-pimps.org>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130531162815.GA8082@srcf.ucam.org>
References: <20130530221737.GA11105@sgi.com>
 <alpine.LNX.2.00.1305310023020.30576@pobox.suse.cz>
 <20130531101250.GD30394@gmail.com>
 <alpine.LNX.2.00.1305311259520.30576@pobox.suse.cz>
 <20130531123015.GC17843@nazgul.tnic>
 <20130531124356.GA8212@gmail.com>
 <20130531143425.GA5850@srcf.ucam.org>
 <1370011357.1913.15.camel@dabdike.int.hansenpartnership.com>
 <20130531144826.GB5850@srcf.ucam.org>
 <20130531154348.GA17145@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130531154348.GA17145@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 10:43:49AM -0500, Russ Anderson wrote:

> When did writing EFI variables to nvram become necessary to boot on 
> UEFI? And if it is necessary, why is it that only linux boot loaders 
> that use EFI stubs (generally grub2) need it?  The current kernel 
> boots using EFI/grub and EFI/elilo.  It is just when EFI stubs are 
> used that the boot fails.

I think you've misunderstood the problem. If nvram becaomes full, some 
systems crash during firmware initialisation. So we can't let nvram 
become full. The obvious thing to do here is to look at the values from 
QueryVariableInfo, but many systems won't perform any garbage collection 
until they're almost out of space and so variables that have been 
deleted still show up as used space. We can work around that by adding 
up the size of the variables ourselves, but that only gives us the value 
for runtime-visible variables. We also need to know how much space is 
used by variables that are only visible during boot, hence calling 
QueryVariableInfo before ExitBootServices.

> Which means the previous patch(es) that caused the bricking should
> get pulled, too.

There are no patches that cause the bricking.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
