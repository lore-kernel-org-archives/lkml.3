Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaKYO4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:56:21 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:48150 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaKYO4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:56:18 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: support passing console options with stdout-path
To: Ian Campbell <ijc@debian.org>, Leif Lindholm <leif.lindholm@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>
In-Reply-To: <1416917249.32327.15.camel@debian.org>
References: <1416867838-18652-1-git-send-email-leif.lindholm@linaro.org>
	<20141125103504.GA21525@leverpostej>
	<20141125111724.GC2361@bivouac.eciton.net>
	<1416917249.32327.15.camel@debian.org>
Date: Tue, 25 Nov 2014 14:55:37 +0000
Message-Id: <20141125145537.36A71C44343@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 12:07:29 +0000
, Ian Campbell <ijc@debian.org>
 wrote:
> On Tue, 2014-11-25 at 11:17 +0000, Leif Lindholm wrote:
> > On Tue, Nov 25, 2014 at 10:35:04AM +0000, Mark Rutland wrote:
> > > On Mon, Nov 24, 2014 at 10:23:58PM +0000, Leif Lindholm wrote:
> > > > Support specifying console options (like with console=ttyXN,<options>)
> > > > by appending them to the stdout-path property after a separating ':'.
> > > > 
> > > > Example:
> > > > 	stdout-path = "uart0:115200";
> > > 
> > > I would very much like to be able to use this -- it will allow
> > > distributions to boot on a board without having to know _anything_ about
> > > the console UART until userspace is up, which would make it possible to
> > > have a completely generic installer image, without requiring the
> > > platform to provide bootargs.
> > > 
> > > My only concern is that this conflates the set of kernel command line
> > > options for the UART wit the DT binding for it. I don't know how good
> > > people are at keeping those options stable, and I know they are
> > > currently not documented -- we would need to add a stdout-path options
> > > section to relevant UART bindings.
> > 
> > I don't disagree.
> > 
> > Current options are fairly well defined and stable, at least for any
> > driver that uses uart_parse_options() (documented in
> > Documentation/serial/driver).
> 
> My concern is that this is Linux specific, other OSes may have different
> ideas about how stdout options should be formatted within this property.
> (At least I don't know of any standardisation of the 115200n8 thing --
> I'd love to be corrected!)
> 
> If I were a firmware author I'd be wary of specifying a stdout-path with
> a Linux specific suffix.
> 
> Search ePAPR for baud it seems that the generic serial binding includes
> a current-speed property in 6.2.1.2. It then goes on a bit ambiguously
> to talk about the NS16550 in 6.2.2 but I think 6.2.1.2 was intended to
> be generic. No mention of stop-bits/parity etc though, they are assumed
> to be set already I think
> 
> One thought I had was to define a dt-stdout "pseudo-console" so that
> console=dt-stdout,115200n8 or something could be used.
> 
> Anyway I applied your patch to v3.18-rc5 and ran it on a Mustang and it
> didn't work for some reason. I'm using:
> 
>         fdt set /chosen stdout-path "/soc/serial@1c020000:115200"
>         setenv bootargs "earlycon=uart8250,mmio32,0x1c020000 root=/dev/sda3 rw debug"
> 
> So I get earlycon but then no proper console. Removing earlycon just
> makes that stop working.
> 
> With:
> 
> diff --git a/drivers/of/base.c b/drivers/of/base.c
> index 89c6b33..5dc1718 100644
> --- a/drivers/of/base.c
> +++ b/drivers/of/base.c
> @@ -1840,6 +1840,8 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
>  			of_stdout_options = strchr(name, ':');
>  			if (of_stdout_options != NULL)
>  				of_stdout_options++;
> +			printk(KERN_CRIT "%s: name=%s of_stdout=%p options=%s\n",
> +			       __func__, name, of_stdout, of_stdout_options);
>  		}
>  	}
>  
> 
> I can see in dmesg:
> [    0.000000] of_alias_scan: name=/soc/serial@1c020000:115200 of_stdout=          (null) options=115200
> 
> So it seems like of_find_node_by_path() is confused by the ":".

That would be a bug in of_find_node_by_path(). Should add a test case
for that because ':' is supposed to terminate path parsing.

> I've not tried it but I'd have expected something more like:
> 		if (name) {
> 			of_stdout_options = strchr(name, ':');
> 			if (of_stdout_options != NULL) {
> 				*of_stdout_options = '0';
> 				of_stdout_options++;
> 			}
> 			of_stdout = of_find_node_by_path(name);
> 		}

This isn't really right because it modifies the property data which is
supposed to be const. of_find_node_by_path() already does the search
piecewise, so it should be fairly straightforward to add a test for the
':'. Anyone care to take a look? If I need to do it then it will take a couple
of weeks before I've got some free time. :-/

> 
> i.e. strip the options then do the patch lookup. name is const so this
> won't actually work, but something like it...
> 
> Ian.
> 

