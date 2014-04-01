Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaDAPnm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 11:43:42 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:51222 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189AbaDAPnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 11:43:40 -0400
Date: Tue, 1 Apr 2014 11:43:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Ian.Campbell@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        boris.ostrovsky@oracle.com
Subject: Re: [PATCH 2/4] xen/manage: Poweroff forcefully if user-space is not
 yet up.
Message-ID: <20140401154330.GA9253@phenom.dumpdata.com>
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>
 <1383932286-25080-3-git-send-email-konrad.wilk@oracle.com>
 <528DEF9D.4070003@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528DEF9D.4070003@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 11:33:49AM +0000, David Vrabel wrote:
> On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
> > The user can launch the guest in this sequence:
> > 
> > xl create -p /vm.cfg	[launch, but pause it]
> > xl shutdown latest	[sets control/shutdown=poweroff]
> > xl unpause latest
> > xl console latest	[and see that the guest has completely
> > ignored the shutdown request]
> > 
> > In reality the guest hasn't ignored it. It registers a watch
> > and gets a notification that there is value. It then calls
> > the shutdown_handler which ends up calling orderly_shutdown.
> 
> Is this really a bug?.
> 
> >From the xl(1) man page.
> 
>   shutdown [OPTIONS] -a|domain-id
>      Gracefully shuts down a domain.  This coordinates with the
>      domain OS to perform graceful shutdown, so there is no guarantee
>      that it will succeed, and may take a variable length of time
>      depending on what services must be shutdown in the domain.
> 
> Seems like ignoring a shutdown request when the guest cannot yet
> shutdown gracefully is the expected behaviour.
> 
> This also doesn't seem sufficient.  SYSTEM_RUNNING is set prior to
> starting init in an initramfs and orderly_power_off(false) will still
> likely fail at this point.

And I found out that there is not much I can do about it. I tried
setting up workqueues, using usermodehelper_read_trylock - none
of those helped when SYSTEM_RUNNING is set and prior to /sbin/init
being started.

The best I could do was relax the gate - meaning that the
  system_state = SYSTEM_RUNNING

we set unconditionally is removed. Instead we only set that when
the shutdown process is actually in progress.

This patch does this:

>From cc3c611cf30f30d435bd5ea80649aae53e490175 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Wed, 6 Nov 2013 10:57:56 -0500
Subject: [PATCH] xen/manage: Poweroff forcefully if user-space is not yet up.

The user can launch the guest in this sequence:

xl create -p /vm.cfg	[launch, but pause it]
xl shutdown latest	[sets control/shutdown=poweroff]
xl unpause latest
xl console latest	[and see that the guest has completely
ignored the shutdown request]

In reality the guest hasn't ignored it. It registers a watch
and gets a notification that there is value. It then calls
the shutdown_handler which ends up calling orderly_shutdown.

Unfortunately that is so early in the bootup that there
are no user-space. Which means that the orderly_shutdown fails.
But since the force flag was set to false it continues on without
reporting.

What we really want to is to use the force when we are in the
SYSTEM_BOOTING state and not use the 'force' when SYSTEM_RUNNING.

However, if we are in the running state - and the shutdown command
has been given before the user-space has been setup, there is nothing
we can do. Worst yet, we stop ignoring the 'xl shutdown' requests!

As such, the other part of this patch is to only stop ignoring
the 'xl shutdown' when we are truly in the power off sequence.

That means the user can do multiple 'xl shutdown' and we will try
to act on them instead of ignoring them.

Fixes-Bug: http://bugs.xenproject.org/xen/bug/6
Reported-by:  Alex Bligh <alex@alex.org.uk>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[v2: Add switch statement]
[v3: Add a reboot notifier]
---
 drivers/xen/manage.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 624e8dc..0cf7fe1 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -182,10 +182,32 @@ struct shutdown_handler {
 	void (*cb)(void);
 };
 
+static int poweroff_nb(struct notifier_block *cb, unsigned long code, void *unused)
+{
+	switch (code) {
+	case SYS_DOWN:
+	case SYS_HALT:
+	case SYS_POWER_OFF:
+		shutting_down = SHUTDOWN_POWEROFF;
+	default:
+		break;
+	}
+	return NOTIFY_DONE;
+}
 static void do_poweroff(void)
 {
-	shutting_down = SHUTDOWN_POWEROFF;
-	orderly_poweroff(false);
+	switch (system_state) {
+	case SYSTEM_BOOTING:
+		orderly_poweroff(true);
+		break;
+	case SYSTEM_RUNNING:
+		orderly_poweroff(false);
+		break;
+	default:
+		/* Don't do it when we are halting/rebooting. */
+		pr_info("Ignoring Xen toolstack shutdown.\n");
+		break;
+	}
 }
 
 static void do_reboot(void)
@@ -291,6 +313,10 @@ static struct xenbus_watch shutdown_watch = {
 	.callback = shutdown_handler
 };
 
+static struct notifier_block xen_reboot_nb = {
+	.notifier_call = poweroff_nb,
+};
+
 static int setup_shutdown_watcher(void)
 {
 	int err;
@@ -301,6 +327,7 @@ static int setup_shutdown_watcher(void)
 		return err;
 	}
 
+
 #ifdef CONFIG_MAGIC_SYSRQ
 	err = register_xenbus_watch(&sysrq_watch);
 	if (err) {
@@ -329,6 +356,7 @@ int xen_setup_shutdown_event(void)
 	if (!xen_domain())
 		return -ENODEV;
 	register_xenstore_notifier(&xenstore_notifier);
+	register_reboot_notifier(&xen_reboot_nb);
 
 	return 0;
 }
-- 
1.8.5.3

