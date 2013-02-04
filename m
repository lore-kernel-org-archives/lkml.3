Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3BDS5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 13:57:39 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:56898 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab3BDS5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 13:57:38 -0500
Date: Mon, 4 Feb 2013 10:57:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, Michal Marek <mmarek@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] config: fix make kvmconfig
In-Reply-To: <20130204184436.GA13256@gmail.com>
Message-ID: <alpine.DEB.2.02.1302041053330.6063@chino.kir.corp.google.com>
References: <1356040315.3198.51.camel@shinybook.infradead.org> <tip-ffee0de411fd4f74f3b788892eeb075abbf26c52@git.kernel.org> <alpine.DEB.2.00.1212252222450.24528@chino.kir.corp.google.com> <1356564746.7010.56.camel@shinybook.infradead.org> <50DB9FA5.6070704@infradead.org>
 <alpine.DEB.2.02.1302041002430.6063@chino.kir.corp.google.com> <20130204184436.GA13256@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2013, Ingo Molnar wrote:

> >  arch/x86/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 6979498..f9459b3 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -606,6 +606,7 @@ config KVMTOOL_TEST_ENABLE
> >  	select NETWORK_FILESYSTEMS
> >  	select INET
> >  	select EXPERIMENTAL
> > +	select TTY
> >  	select SERIAL_8250
> >  	select SERIAL_8250_CONSOLE
> >  	select IP_PNP
> 
> There's no 'config TTY' in the kernel AFAICS.
> 

It's added in linux-next by 4f73bc4dd3e8 ("tty: Added a CONFIG_TTY option 
to allow removal of TTY").

Adding Greg to the cc to figure out which tree this should be merged 
through.  Greg, please find the patch inline.

The better alternative would be to remove KVMTOOL_TEST_ENABLE entirely 
since it has been sitting in linux-next for over a year, Linus has said he 
won't pull it, and it consistently needs updates both inside and outside 
of Pekka's tree.

-----o<-----

config: fix make kvmconfig

make kvmconfig selects CONFIG_SERIAL_8250 without selecting its 
dependencies causing some configs to fail:

drivers/tty/serial/8250/8250.c:57:32: error: 'CONFIG_SERIAL_8250_RUNTIME_UARTS' undeclared here (not in a function)
drivers/tty/serial/8250/8250.c:2712:47: error: 'CONFIG_SERIAL_8250_NR_UARTS' undeclared here (not in a function)
drivers/tty/serial/8250/8250.c: In function 'serial8250_console_write':
drivers/tty/serial/8250/8250.c:2843:10: error: 'struct uart_port' has no member named 'sysrq'
drivers/tty/serial/8250/8250.c: In function 'early_serial_setup':
drivers/tty/serial/8250/8250.c:2971:20: error: negative width in bit-field '<anonymous>'
drivers/tty/serial/8250/8250.c: At top level:
drivers/tty/serial/8250/8250.c:2712:30: warning: 'serial8250_ports' defined but not used [-Wunused-variable]

Fix this by selecting CONFIG_TTY as well, which CONFIG_SERIAL_8250 
requires.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6979498..f9459b3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -606,6 +606,7 @@ config KVMTOOL_TEST_ENABLE
 	select NETWORK_FILESYSTEMS
 	select INET
 	select EXPERIMENTAL
+	select TTY
 	select SERIAL_8250
 	select SERIAL_8250_CONSOLE
 	select IP_PNP
