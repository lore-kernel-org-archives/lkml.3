Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755594Ab3ARVO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:14:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49816 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab3ARVO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:14:27 -0500
Date: Fri, 18 Jan 2013 21:08:59 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: Compilation problem with drivers/staging/zsmalloc when !SMP on
	ARM
Message-ID: <20130118210859.GH23505@n2100.arm.linux.org.uk>
References: <CAKGA1b=ACTQHo9=B7EAG5nrFCO9u-J+sy7dXtYk3Rk6OUcW3cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1b=ACTQHo9=B7EAG5nrFCO9u-J+sy7dXtYk3Rk6OUcW3cQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 02:24:15PM -0600, Matt Sealey wrote:
> Hello all,
> 
> I wonder if anyone can shed some light on this linking problem I have
> right now. If I configure my kernel without SMP support (it is a very
> lean config for i.MX51 with device tree support only) I hit this error
> on linking:

Yes, I looked at this, and I've decided that I will _not_ fix this export,
neither will I accept a patch to add an export.

As far as I can see, this code is buggy in a SMP environment.  There's
apparantly no guarantee that:

1. the mapping will be created on a particular CPU.
2. the mapping will then be used only on this specific CPU.
3. no guarantee that another CPU won't speculatively prefetch from this
   region.
4. when the mapping is torn down, no guarantee that it's the same CPU that
   used the happing.

So, the use of the local TLB flush leaves all the other CPUs potentially
containing TLB entries for this mapping.

Finally, there is no TODO file for this driver, which I believe is a
requirement for anything to be in stable.  So as far as I can see, it
should be deleted or a TODO file added.  I'm not sure why Greg decided
to add it without a TODO file.

(If there was such a file, I'd have added the above to it.  As it is,
I've just decided to disable the thing in my randconfig builds.)
