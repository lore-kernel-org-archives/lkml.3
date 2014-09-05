Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523AbaIENql (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:46:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44150 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932298AbaIENqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:46:39 -0400
Date: Fri, 5 Sep 2014 14:45:42 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sebastian Reichel <sre@debian.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Pavel Machek <pavel@ucw.cz>, Fabio Estevam <festevam@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Message-ID: <20140905134542.GD20164@leverpostej>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <201409051338.40988@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201409051338.40988@pali>
Thread-Topic: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 12:38:40PM +0100, Pali Rohár wrote:
> On Wednesday 18 June 2014 18:54:24 Pali Rohár wrote:
> > Machine name from board description is some generic name on DT
> > kernel. DT provides machine name property which is specific
> > for board, so use it instead generic one when possible.
> > 
> > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > ---
> >  arch/arm/kernel/setup.c |    7 +++++--
> >  1 file changed, 5 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
> > index 8a16ee5..fbc7b4f 100644
> > --- a/arch/arm/kernel/setup.c
> > +++ b/arch/arm/kernel/setup.c
> > @@ -875,10 +875,13 @@ void __init setup_arch(char **cmdline_p)
> > 
> >  	setup_processor();
> >  	mdesc = setup_machine_fdt(__atags_pointer);
> > -	if (!mdesc)
> > +	if (mdesc)
> > +		machine_name = of_flat_dt_get_machine_name();
> > +	else
> >  		mdesc = setup_machine_tags(__atags_pointer,
> > __machine_arch_type); machine_desc = mdesc;
> > -	machine_name = mdesc->name;
> > +	if (!machine_name)
> > +		machine_name = mdesc->name;
> > 
> >  	if (mdesc->reboot_mode != REBOOT_HARD)
> >  		reboot_mode = mdesc->reboot_mode;
> 
> So, do you really want to break userspace which reading file 
> /proc/cpuinfo (after migration from boardcode --> DT)?

You have no guarantee model name in the DT == the name in a board file
anyhow, and trying to force that is wrong. So further to Russell's
reply, I must NAK this from a DT perspective.

Realistically your userspace is already broken if relying on such
things. You built something that only ever worked for a particular
arbitrary string. So it was already broken for every other board, and
there was never any guarantee that new boards where your userspace could
have worked would share the same name.

You're trying to fix the wrong side of the equation.

Mark.
