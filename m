Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaJKRP6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 13:15:58 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60639 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751075AbaJKRPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 13:15:53 -0400
Date: Sat, 11 Oct 2014 18:15:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Greg KH <gregkh@linuxfoundation.org>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@systeme.lip6.fr
Subject: Re: [RFC] drop owner assignment from platform_drivers
Message-ID: <20141011171538.GB27405@n2100.arm.linux.org.uk>
References: <20141010072439.GA1741@katana>
 <20141010083627.GL5182@n2100.arm.linux.org.uk>
 <20141010182604.GC6075@katana>
 <2769473.KEN6DZKnT7@wuerfel>
 <20141011165650.GA1263@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141011165650.GA1263@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 06:56:51PM +0200, Wolfram Sang wrote:
> 
> > > You got me wondering, though, that it could not be correct to call
> > > platform_driver_register() from the platform core instead of module
> > > init. I will check tomorrow. Still, this would be a bug independent of
> > > my series. Although I'd need to respin it if platform_driver_probe()
> > > needed a fix.
> > 
> > Right, this seems to be a preexisting bug. platform_create_bundle 
> > and platform_driver_probe will both overwrite the .owner field with
> > NULL since they live in builtin code. They need to be replaced with
> > __platform_driver_probe and __platform_driver_register that both
> > take an extra owner argument passed down from the caller in the driver
> > module.
> 
> Yeah, that would be one solution. However, my personal favourite would
> meanwhile be to revert the commit that Russell mentioned. I think it is
> cleaner to have the owner explicitly set in the module rather than
> hidden away by a function call. However, grepping through include/linux,
> there are a few subsystems hiding it this way. So, it is a pattern
> somewhow. Oh well...

It really /ought/ to be consistent, because inconsistencies like that
will be a never-ending source of subtle mistakes.

Imagine what it would be like if the kernel was a complete mess of
functions with return type "int" where there was no predominant
pattern of returning negative errno numbers - where it was random
whether int-returning functions returned zero for failure, others
returned zero for success.  We would have to look up every single
function to check it's return style, and it would be a bigger problem
when reviewing code.

There is a lot of value for saving time and reducing errors to have a
consistent, simple and obvious methodology.

(That's not to say that it should be enforced draconian style - but
there'd better be a good reason to be different, rather than "I think
it's better this way" or "my personal style is different".)

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
