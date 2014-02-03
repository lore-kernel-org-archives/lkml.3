Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333AbaBCNdy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 08:33:54 -0500
Received: from eurynome.mirbsd.org ([81.169.181.30]:10047 "EHLO
	eurynome.mirbsd.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaBCNdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 08:33:53 -0500
X-Greylist: delayed 1757 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Feb 2014 08:33:52 EST
Date: Mon, 3 Feb 2014 12:54:02 +0000 (UTC)
From: Thorsten Glaser <tg@mirbsd.de>
X-X-Sender: tg@herc.mirbsd.org
To: "Theodore Ts'o" <tytso@mit.edu>
cc: Stephan Mueller <smueller@chronox.de>,
        =?utf-8?Q?J=EF=BF=BDrn_Engel?= <joern@logfs.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        macro@linux-mips.org, ralf@linux-mips.org, dave.taht@gmail.com,
        blogic@openwrt.org, andrewmcgr@gmail.com, geert@linux-m68k.org
Subject: Re: [PATCH,RFC] random: collect cpu randomness
In-Reply-To: <20140203013922.GB6264@thunk.org>
Message-ID: <Pine.BSM.4.64L.1402031249130.25530@herc.mirbsd.org>
References: <20140202203617.GA9499@logfs.org> <16782692.5vMS7Bhbvf@myon.chronox.de>
 <20140203013922.GB6264@thunk.org>
X-Message-Flag: Your mailer is broken. Get an update at http://www.washington.edu/pine/getpine/pcpine.html for free.
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Ts'o dixit:

>I really like Jvrn's tests doing repeated boot testing and observing
>on a SMP system, the slab allocation pattern is quite deterministic.
>So even though the numbers might *look* random, an attacker with deep
>knowledge of how the kernel was compiled and what memory allocations

For this reason, we pre-initialise (one of) the RNG during kernel
compile time, using host randomness, in MirBSD. We’re also considering
pushing some additional seed using the bootloader, that can be mixed
in very very early. As an added benefit, everything in the kernel can
call arc4random(), arc4random_buf() and arc4random_uniform() without
worrying about initialisation, at all times. (This is mostly for the
places where it replaced random(), or which explicitly waited for the
regular RNG initialisation to be done, or which reseeded after that.)

In GNU/Linux, this could work like, GRUB will offer the contents of
/boot/grub/randseed.bin to the Linux kernel, which will add it into
the pool using the normal mechanisms, and (very?) early userspace
will then recreate that file (to prevent seed reuse, just like the
normal /var/db/host.random or /var/lib/urandom/random-seed processing
is done). Downside: write access to the boot medium needed. (No GRUB
modification needed, this could be passed as “faux kernel module”.)
Upside: this is way earlier than anything user space can do, and
e.g. early enough to affect things like kernel memory management.

bye,
//mirabilos
-- 
<Natureshadow> Ach, mach doch was du willst, du hast doch eh immer Recht!
<mirabilos> jupp ~/.etc/sig………
<Natureshadow> unfaßbar…
<Natureshadow> Mit Eszett sogar, unfaßbar!
