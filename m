Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbaHNWVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 18:21:24 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:37663 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601AbaHNWVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 18:21:23 -0400
Date: Thu, 14 Aug 2014 15:21:19 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-kbuild@vger.kernel.org, Brian Norris <computersforpeace@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Overriding -Werror
Message-ID: <20140814222119.GD18411@ld-irv-0074>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm interested in being able to build-test kernels on various
architectures while enabling extra warnings (make W=[123]). I'd like to
be able to finish the builds and see all warnings, rather than seeing a
failed build. However, GCC's -Werror is incompatible with this. There is
plenty of code that will produce at least one warning, when warning
verbosity is turned up. And GCC's -Werror is not guaranteed to remain
stable over time; new versions may develop new warnings that may or may
not be legitimate.

It seems that there are a few problem ARCHes that enable -Werror by
default: SuperH (orphaned), SPARC, and MIPS. There are also a few
scattered Makefiles throughout the build tree. Developers have
previously tried to remove some of the worst offenders [1], but were
mostly rejected [2]. It doesn't seem like we can fully prevent
maintainers from enabling -Werror on their code--or even on their entire
ARCH build, as with MIPS--for better or worse, so I look to other
alternatives.

For the easiest approach, I considered how one might add -Wno-error to
the CFLAGS. 'make KCFLAGS=-Wno-error' looked promising, but
KBUILD_CFLAGS is applied before the sub-directory Makefiles add their
own options to ccflags-y. So it seems like others have come to the same
conclusion as me: that Kbuild doesn't seem to provide a way to override
the -Werror behvaior from the top level. [3][4]

So, how can we fix this? -Werror may be useful in some cases to
encourage developers to fix up their code immediately, but it is
decidedly unhelpful when running code through analysis tools.

Possibilities include:

1. make -Werror be applied only when we do not have W=[123]. [5]

2. develop a top-level override for CFLAGS that is applied *after* all
   sub-directory modifications

3. make -Werror opt-in / configurable, like PPC's CONFIG_PPC_WERROR
   (maybe make it a generic CONFIG_WERROR?), and prevent its
   unconditional use in Makefiles

4. better ideas?

Regards,
Brian

[1] http://www.linux-mips.org/archives/linux-mips/2012-04/msg00179.html
    http://patchwork.ozlabs.org/patch/146297/

[2] http://www.linux-mips.org/archives/linux-mips/2012-05/msg00064.html

[3] http://lists.linaro.org/pipermail/linaro-toolchain/2011-November/001869.html

[4] http://lists.linaro.org/pipermail/linaro-dev/2011-December/008880.html

[5] http://www.linux-mips.org/archives/linux-mips/2012-05/msg00070.html
