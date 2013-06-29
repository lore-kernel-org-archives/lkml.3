Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab3F2XPK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 19:15:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35130 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab3F2XPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 19:15:09 -0400
Date: Sun, 30 Jun 2013 00:14:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Olof Johansson <olof@lixom.net>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Emilio Lopez <emilio@elopez.com.ar>, torvalds@linux-foundation.org
Subject: Re: [PATCH 0/2] ARM: sunxi: Convert DTSI to new CPU bindings
Message-ID: <20130629231425.GG3353@n2100.arm.linux.org.uk>
References: <1372437844-16325-1-git-send-email-maxime.ripard@free-electrons.com> <20130628171532.GD30603@e102568-lin.cambridge.arm.com> <20130628200333.GA2756@lukather> <CAOesGMgsD+tK4+ywvLzsWd+mngrP7zGgSFn0naWjSsQLGaUn2Q@mail.gmail.com> <20130629193819.GD3353@n2100.arm.linux.org.uk> <20130629225426.GA12221@quad.lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130629225426.GA12221@quad.lixom.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 03:54:26PM -0700, Olof Johansson wrote:
> Most of this ruffle seems to be about the fact that booting a kernel
> with a device tree that doesn't conform to the brand spanking new,
> and never previously enforced, binding for the cpu nodes will produce
> a WARN_ON(). Lots of our in-tree device trees fall into this category.
> 
> And while I think it was a bad idea for Lorenzo to ask for this to be
> merged as a fix this late (and most in particular for stable), as far
> as I can tell nothing (new) is broken by it -- just the alarming warning
> is being printed.
> 
> I think it probably makes sense to downgrade the WARN to just a printk, and
> people will be a lot less worried. How about the below?
> 
> If you're OK with it, Russell, can we get your ack so Linus can apply
> directly given the imminence of final 3.10? Or, if you prefer, you can of
> course apply and send it on instead.

You can have my usual rmk+kernel ack for it with one change...

> +	if (!bootcpu_valid) {
> +		pr_warn("DT missing boot CPU MPIDR[23:0], fall back to "
> +			"default cpu_logical_map\n");

Don't wrap messages kernel messages inspite of what checkpatch says.
Always keep messages like that on a single line so they're greppable.
Checkpatch is far from perfect and does get stuff wrong, and this is
one of its common mistakes.

Incidentally, here's a few of fun ones I found today which illustrates
why checkpatch can be bad news if everything it spits out is believed
by the user:

WARNING: simple_strtoul is obsolete, use kstrtoul instead
#1424: FILE: drivers/gpu/drm/armada/armada_debugfs.c:90:
+       reg = simple_strtoul(buf, &p, 16);

Umm yes, and to use kstrtoul(), I'd have to:
- copy the string _safely_ to avoid any buffer overflow
- find the first non-value character
- terminate the string with a \0 or a \n\0
- remember where in the string I'd got to to parse the next argument
And pushing that complexity into drivers, which if it's wrong causes
security problems, is better than using simple_strtoul() because ...?

ERROR: Macros with multiple statements should be enclosed in a do - while loop
#2122: FILE: drivers/gpu/drm/armada/armada_fb.c:45:
+#define FMT(drm, fmt, mod)             \
+       case DRM_FORMAT_##drm:          \
+               format = CFG_##fmt;     \
+               config = mod;           \
+               break

Oh yea, that's really going to work for that isn't it!

WARNING: externs should be avoided in .c files
#2126: FILE: drivers/gpu/drm/armada/armada_fb.c:49:
+               break

Err, what extern? :)
