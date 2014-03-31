Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbaCaUdZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 16:33:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49534 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857AbaCaUdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 16:33:23 -0400
Date: Mon, 31 Mar 2014 16:33:13 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Ian.Campbell@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        boris.ostrovsky@oracle.com
Subject: Re: [Xen-devel] [PATCH 4/4] xen/xenbus: Avoid synchronous wait on
 XenBus stalling shutdown/restart.
Message-ID: <20140331203313.GA6756@phenom.dumpdata.com>
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>
 <1383932286-25080-5-git-send-email-konrad.wilk@oracle.com>
 <528E485C.5030906@citrix.com>
 <20131126165016.GH2959@phenom.dumpdata.com>
 <529C7205.3060406@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <529C7205.3060406@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 11:41:57AM +0000, David Vrabel wrote:
> On 26/11/13 16:50, Konrad Rzeszutek Wilk wrote:
> > On Thu, Nov 21, 2013 at 05:52:28PM +0000, David Vrabel wrote:
> >> On 08/11/13 17:38, Konrad Rzeszutek Wilk wrote:
> >>> The 'read_reply' works with 'process_msg' to read of a reply in XenBus.
> >>> 'process_msg' is running from within the 'xenbus' thread. Whenever
> >>> a message shows up in XenBus it is put on a xs_state.reply_list list
> >>> and 'read_reply' picks it up.
> >>>
> >>> The problem is if the backend domain or the xenstored process is killed.
> >>> In which case 'xenbus' is still awaiting - and 'read_reply' if called -
> >>> stuck forever waiting for the reply_list to have some contents.
> >>>
> >>> This is normally not a problem - as the backend domain can come back
> >>> or the xenstored process can be restarted. However if the domain
> >>> is in process of being powered off/restarted/halted - there is no
> >>> point of waiting on it coming back - as we are effectively being
> >>> terminated and should not impede the progress.
> >>>
> >>> This patch solves this problem by checking the 'system_state' value
> >>> to see if we are in heading towards death. We also make the wait
> >>> mechanism a bit more asynchronous.
> >>
> >> This seems to be checking the wrong thing conceptually.  We should abort
> >> the wait if xenstored is dead not if our domain is dying.
> >>
> >> I think you can consider xenstored as dead if:
> >>
> >> a) it's local and we're dying.
> > 
> > OK. Not sure exactly how to do that but that should be possible.
> 
> xen_store_domain_type == XS_LOCAL and looking at system_state?
> 
> >> b) it's remote and the remote domain is dead.
> > 
> > OK, any idea how to do that? As in check if a remote domain is dead?
> 
> Let someone who cares about xenstore domains fix this -- this is not the
> most common use case.
> 
> I'd be happy to have some thing like:
> 
> bool xenbus_ok(void)
> {
>     switch (xen_store_domain_type) {
>     case XS_LOCAL:
>          return system_state != dying;
>     case XS_PV:
>     case XS_HVM;
>          /* FIXME: could check remote domain is alive, but it's
>             normally dom0. */
>          return true;
>     // ...
>     default:
>          return true;
>     }
> }

>From 227d72806311694ced6cdedfd61a05f5bb1893f7 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 8 Nov 2013 10:48:58 -0500
Subject: [PATCH] xen/xenbus: Avoid synchronous wait on XenBus stalling
 shutdown/restart.

The 'read_reply' works with 'process_msg' to read of a reply in XenBus.
'process_msg' is running from within the 'xenbus' thread. Whenever
a message shows up in XenBus it is put on a xs_state.reply_list list
and 'read_reply' picks it up.

The problem is if the backend domain or the xenstored process is killed.
In which case 'xenbus' is still awaiting - and 'read_reply' if called -
stuck forever waiting for the reply_list to have some contents.

This is normally not a problem - as the backend domain can come back
or the xenstored process can be restarted. However if the domain
is in process of being powered off/restarted/halted - there is no
point of waiting on it coming back - as we are effectively being
terminated and should not impede the progress.

This patch solves this problem by checking whether the guest is
the right domain. If it is an initial domain and hurtling towards
death - there is no point of continuing the wait. All other type
of guests continue with their behavior.
mechanism a bit more asynchronous.

Fixes-Bug: http://bugs.xenproject.org/xen/bug/8
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[v2: Fixed it up per David's suggestions]
---
 drivers/xen/xenbus/xenbus_xs.c | 44 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 41 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
index b6d5fff..ba804f3 100644
--- a/drivers/xen/xenbus/xenbus_xs.c
+++ b/drivers/xen/xenbus/xenbus_xs.c
@@ -50,6 +50,7 @@
 #include <xen/xenbus.h>
 #include <xen/xen.h>
 #include "xenbus_comms.h"
+#include "xenbus_probe.h"
 
 struct xs_stored_msg {
 	struct list_head list;
@@ -139,6 +140,29 @@ static int get_error(const char *errorstring)
 	return xsd_errors[i].errnum;
 }
 
+static bool xenbus_ok(void)
+{
+	switch (xen_store_domain_type) {
+	case XS_LOCAL:
+		switch (system_state) {
+		case SYSTEM_POWER_OFF:
+		case SYSTEM_RESTART:
+		case SYSTEM_HALT:
+			return false;
+		default:
+			break;
+		}
+		return true;
+	case XS_PV:
+	case XS_HVM:
+		/* FIXME: Could check that the remote domain is alive,
+		 * but it is normally initial domain. */
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
 static void *read_reply(enum xsd_sockmsg_type *type, unsigned int *len)
 {
 	struct xs_stored_msg *msg;
@@ -148,9 +172,20 @@ static void *read_reply(enum xsd_sockmsg_type *type, unsigned int *len)
 
 	while (list_empty(&xs_state.reply_list)) {
 		spin_unlock(&xs_state.reply_lock);
-		/* XXX FIXME: Avoid synchronous wait for response here. */
-		wait_event(xs_state.reply_waitq,
-			   !list_empty(&xs_state.reply_list));
+		if (xenbus_ok())
+			/* XXX FIXME: Avoid synchronous wait for response here. */
+			wait_event_timeout(xs_state.reply_waitq,
+					   !list_empty(&xs_state.reply_list),
+					   msecs_to_jiffies(500));
+		else {
+			/*
+			 * If we are in the process of being shut-down there is
+			 * no point of trying to contact XenBus - it is either
+			 * killed (xenstored application) or the other domain
+			 * has been killed or is unreachable.
+			 */
+			return ERR_PTR(-EIO);
+		}
 		spin_lock(&xs_state.reply_lock);
 	}
 
@@ -215,6 +250,9 @@ void *xenbus_dev_request_and_reply(struct xsd_sockmsg *msg)
 
 	mutex_unlock(&xs_state.request_mutex);
 
+	if (IS_ERR(ret))
+		return ret;
+
 	if ((msg->type == XS_TRANSACTION_END) ||
 	    ((req_msg.type == XS_TRANSACTION_START) &&
 	     (msg->type == XS_ERROR)))
-- 
1.8.5.3

