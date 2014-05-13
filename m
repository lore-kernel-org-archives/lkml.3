Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbaEMQ1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 12:27:52 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:37577 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750739AbaEMQ1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 12:27:43 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+mZFR8zIUOZzL4ynAeHaYy
Date: Tue, 13 May 2014 09:27:33 -0700
From: Tony Lindgren <tony@atomide.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] bus/omap_l3: avoid sync initcall for modules
Message-ID: <20140513162731.GD16837@atomide.com>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de>
 <1399560990-1402858-6-git-send-email-arnd@arndb.de>
 <20140512222006.GI5668@atomide.com>
 <177753046.dmVvfiu3Rn@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177753046.dmVvfiu3Rn@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arnd Bergmann <arnd@arndb.de> [140513 08:13]:
> On Monday 12 May 2014 15:20:07 Tony Lindgren wrote:
> > 
> > How about instead let's add this into include/linux/module.h
> > like we have for other initcalls:

I mean include/linux/init.h naturally..
 
> > #define postcore_initcall(fn)           module_init(fn)
> > 
> > There may be others missing too from there. BTW, this driver
> > might be few of the drivers that actually might need to be
> > initialized early for debugging to catch bad access from
> > other drivers.
> 
> There is a comment above those defines saying:
> 
> /* Don't use these in loadable modules, but some people do... */
> 
> so I'm not sure if adding more would be appreciated.
> 
> 	Arnd

Well "some" in that comment is probably an understatement :)

$ git grep _initcall drivers/ | wc -l
737

I did not look what percentage has tristate in the Kconfig,
but that might keep some people from making loadable drivers.

Greg, is the following patch something you may want to
consider picking up?

Regards,

Tony


8< ---------------------------
From: Tony Lindgren <tony@atomide.com>
Date: Tue, 13 May 2014 09:05:26 -0700
Subject: [PATCH] init.h: Update initcall_sync variants to fix build errors

We are getting randconfig build errors on device drivers with
tristate Kconfig option if they are using custom initcall
levels. Rather than add ifdeffery into the drivers, let's add
the missing initcall_sync variants.

As the comment in init.h has kept people from updating the
list of initcalls that can be just module_init when the driver
is loaded as a loadable module, let's also update the comment
a bit to describe valid use cases custom initcall levels.

While most drivers should nowadays use just regular module_init
because of the deferred probe, we do have quite a few custom
initcall levels left that we cannot remove until tested properly.

There are also still few valid cases where a custom initcall
level might make sense that I'm aware of.

For example a bus snooping driver can provide information about
invalid bus access and is handy loader early when built in. But
there's no hard dependency to have it necessarily built in and
a loadable module is a valid option.

Another example is a driver implementing a Linux framework like
pinctrl framework. That driver may be needed early on some
platforms because of legacy reasons, while it can be just a
regular module_init on most platforms.

Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -297,16 +297,28 @@ void __init parse_early_options(char *cmdline);
 
 #else /* MODULE */
 
-/* Don't use these in loadable modules, but some people do... */
+/*
+ * In most cases loadable modules do not need custom
+ * initcall levels. There are still some valid cases where
+ * a driver may be needed early if built in, and does not
+ * matter when built as a loadable module. Like bus
+ * snooping debug drivers.
+ */
 #define early_initcall(fn)		module_init(fn)
 #define core_initcall(fn)		module_init(fn)
+#define core_initcall_sync(fn)		module_init(fn)
 #define postcore_initcall(fn)		module_init(fn)
+#define postcore_initcall_sync(fn)	module_init(fn)
 #define arch_initcall(fn)		module_init(fn)
 #define subsys_initcall(fn)		module_init(fn)
+#define subsys_initcall_sync(fn)	module_init(fn)
 #define fs_initcall(fn)			module_init(fn)
+#define fs_initcall_sync(fn)		module_init(fn)
 #define rootfs_initcall(fn)		module_init(fn)
 #define device_initcall(fn)		module_init(fn)
+#define device_initcall_sync(fn)	module_init(fn)
 #define late_initcall(fn)		module_init(fn)
+#define late_initcall_sync(fn)		module_init(fn)
 
 #define console_initcall(fn)		module_init(fn)
 #define security_initcall(fn)		module_init(fn)
