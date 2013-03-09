Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab3CINbH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Mar 2013 08:31:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41337 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756478Ab3CINbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Mar 2013 08:31:03 -0500
Date: Sat, 9 Mar 2013 08:30:14 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 8250.nr_uarts broken in 3.7
Message-ID: <20130309133014.GQ13719@hansolo.jdub.homelinux.org>
References: <20130308013923.GA12474@kroah.com>
 <20130308212722.GL13719@hansolo.jdub.homelinux.org>
 <513A6A65.9050706@suse.cz>
 <20130308224950.GM13719@hansolo.jdub.homelinux.org>
 <513A6D1F.5000202@suse.cz>
 <513A6FD4.7000506@suse.cz>
 <513A70CF.9010800@suse.cz>
 <20130308232809.GO13719@hansolo.jdub.homelinux.org>
 <20130308234404.GP13719@hansolo.jdub.homelinux.org>
 <513AFD66.3030404@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513AFD66.3030404@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 09, 2013 at 10:14:14AM +0100, Jiri Slaby wrote:
> On 03/09/2013 12:44 AM, Josh Boyer wrote:
> > On Fri, Mar 08, 2013 at 06:28:09PM -0500, Josh Boyer wrote:
> >> On Sat, Mar 09, 2013 at 12:14:23AM +0100, Jiri Slaby wrote:
> >>> On 03/09/2013 12:10 AM, Jiri Slaby wrote:
> >>>> On 03/08/2013 11:58 PM, Jiri Slaby wrote:
> >>>>> On 03/08/2013 11:49 PM, Josh Boyer wrote:
> >>>>>> On Fri, Mar 08, 2013 at 11:47:01PM +0100, Jiri Slaby wrote:
> >>>>>>> Yeah, I agree this is ugly. Just re-definining MODULE_PARAM_PREFIX at
> >>>>>>> the end of the file should do the trick (followed by
> >>>>>>> "module_param(nr_uarts, uint, 0644)").
> >>>>>>
> >>>>>> For some reason, I thought I had tried that.  Maybe I didn't.  I'll look
> >>>>>> into it again.
> >>>>>
> >>>>> I see. Because we would re-define some global variables. What if we put
> >>>>> module_param into a function?
> >>>>
> >>>> Something like this?
> >>>> #ifdef MODULE
> >>
> >> I don't think you want this surrounded in #ifdef MODULE, do you?  That
> >> won't let people building the driver into the kernel continue to use
> >> 8250.<whatever> on the kernel command line.
> 
> Yes, you're right. I sort of thought the prefix is not used for
> non-modules. But it is.

Right.  It's used when built-in, and it's used by modprobe if it's a module
but the user passed the parameters on the kernel command line.

We actually need the opposite #ifndef MODULE in place, otherwise the .ko
winds up with e.g. "nr_uarts" and "8250.nr_uarts".  That is a module
option named that, not something that would parse as expected.

> >>>> static void __unused splat(void) {
> >>>
> >>> I meant __used. It should make no difference though.
> >>>
> >>>> #       undef MODULE_PARAM_PREFIX
> >>>> #       define MODULE_PARAM_PREFIX "8250."
> >>>>         module_param_cb(nr_uarts, &param_ops_uint, &nr_uarts, 0644);
> >>>>         ...
> >>>> }
> >>>> #endif
> >>>>
> >>>> Not nice, but should work. The other way is to have those in a separate
> >>>> file linked to 8250 (to avoid re-definition errors).
> >>
> >> Ew.  I'll try the function first.
> > 
> > OK, the function (without the surrounding ifdef) seems to be working OK.
> > I'll do a bit more testing and send out a v2 in a bit.
> > 
> > Thanks for the tip.  It's still not pretty, but at least I don't feel
> > ashamed about it.
> 
> I'm thinking about deprecating the 8250_core.* in some way. Better
> sooner than later. The view of having both of them with that hack in the
> kernel forever drives me bananas.

I don't disagree.  I did finish up the patch, and this is what I came up
with.

josh

From: Josh Boyer <jwboyer@redhat.com>
Date: Fri, 8 Mar 2013 21:13:52 -0500
Subject: [PATCH] serial: 8250: Keep 8250.<xxxx> module options functional
 after driver rename

With commit 835d844d1 (8250_pnp: do pnp probe before legacy probe), the
8250 driver was renamed to 8250_core.  This means any existing usage of
the 8259.<xxxx> module parameters or as a kernel command line switch is
now broken, as the 8250_core driver doesn't parse options belonging to
something called "8250".

To solve this, we redefine the module options in a dummy function using
a redefined MODULE_PARAM_PREFX when built into the kernel.  In the case
where we're building as a module, we provide an alias to the old 8250
name.  The dummy function prevents compiler errors due to global variable
redefinitions that happen as part of the module_param_ macro expansions.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 drivers/tty/serial/8250/8250.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 0efc815..446beb7 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -3396,3 +3396,34 @@ module_param_array(probe_rsa, ulong, &probe_rsa_count, 0444);
 MODULE_PARM_DESC(probe_rsa, "Probe I/O ports for RSA");
 #endif
 MODULE_ALIAS_CHARDEV_MAJOR(TTY_MAJOR);
+
+#ifndef MODULE
+/* This module was renamed to 8250_core in 3.7.  Keep the old "8250" name
+ * working as well for the module options so we don't break people.  We
+ * need to keep the names identical and the convenient macros will happily
+ * refuse to let us do that by failing the build with redefinition errors
+ * of global variables.  So we stick them inside a dummy function to avoid
+ * those conflicts.  The options still get parsed, and the redefined
+ * MODULE_PARAM_PREFIX lets us keep the "8250." syntax alive.  We redefine
+ * __param_check to a throw away value to avoid type conflicts from the
+ * expansion that would happen otherwise.
+ *
+ * This is hacky.  I'm sorry.
+ */
+static void __used s8250_options(void)
+{
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX "8250."
+
+	module_param_cb(share_irqs, &param_ops_uint, &share_irqs, 0644);
+	module_param_cb(nr_uarts, &param_ops_uint, &nr_uarts, 0644);
+	module_param_cb(skip_txen_test, &param_ops_uint, &skip_txen_test, 0644);
+#ifdef CONFIG_SERIAL_8250_RSA
+#undef __param_check
+#define __param_check(name, p, type) int __attribute((unused)) tmp
+	module_param_array(probe_rsa, ulong, &probe_rsa_count, 0444);
+#endif
+}
+#else
+MODULE_ALIAS("8250");
+#endif
-- 
1.8.1.2

