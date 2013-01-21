Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab3AUUe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:34:58 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:11819 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631Ab3AUUe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:34:57 -0500
Message-ID: <1358800493.3758.10.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH 01/21] NTB: correct missing readq/writeq errors
From: Ben Hutchings <bhutchings@solarflare.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Jon Mason <jon.mason@intel.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Date: Mon, 21 Jan 2013 20:34:53 +0000
In-Reply-To: <20130121182345.GC5499@kroah.com>
References: <1358586155-23322-1-git-send-email-jon.mason@intel.com>
	 <1358586155-23322-2-git-send-email-jon.mason@intel.com>
	 <20130120234005.GA14196@kroah.com> <20130121173818.GD22208@jonmason-lab>
	 <20130121182345.GC5499@kroah.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19570.005
X-TM-AS-Result: No--29.387200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 10:23 -0800, Greg KH wrote:
> On Mon, Jan 21, 2013 at 10:38:18AM -0700, Jon Mason wrote:
> > On Sun, Jan 20, 2013 at 03:40:05PM -0800, Greg KH wrote:
> > > On Sat, Jan 19, 2013 at 02:02:15AM -0700, Jon Mason wrote:
> > > > Atomic readq and writeq do not exist by default on some 32bit
> > > > architectures, thus causing compile errors due to non-existent symbols.
> > > > In those cases, use the definitions of those symbols from
> > > > include/asm-generic/io-64-nonatomic-hi-lo.h
> > > > 
> > > > Signed-off-by: Jon Mason <jon.mason@intel.com>
> > > > ---
> > > >  drivers/ntb/ntb_hw.c |    1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
> > > > index 4c71b17..0b46fef 100644
> > > > --- a/drivers/ntb/ntb_hw.c
> > > > +++ b/drivers/ntb/ntb_hw.c
> > > > @@ -45,6 +45,7 @@
> > > >   * Contact Information:
> > > >   * Jon Mason <jon.mason@intel.com>
> > > >   */
> > > > +#include <asm-generic/io-64-nonatomic-hi-lo.h>
> > > 
> > > Really?  This seems really odd.  Usually we just don't build the code
> > > for any platform that doesn't have readq/writeq.  Otherwise, shouldn't
> > > those arches just include this file themselves to keep everything
> > > working?  Individual drivers shouldn't have to do this.
> > 
> > There is no readq/writeq for 32bit x86.  I was using this header file
> > to get around that.  I freely admit that I have done 0 testing on
> > 32bit, but it should work.  If you prefer I modify the Kconfig to only
> > enable this for x86_64 until such time as I test on x86_32, I will
> > happily submit that patch.
> 
> No, other drivers on 32bit x86 also use readq,

I don't think so, because it's not defined for CONFIG_X86_32.

> and do not include this
> asm header file.  So there is a proper way to do this, just dig through
> the header file include mess to determine the proper one to include.
> You should never have to include asm-generic file directly, that's the
> issue here.

Different devices can have different requirements for the order of
access to 32-bit halves of a 64-bit register.  Only the driver knows
which is right.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

