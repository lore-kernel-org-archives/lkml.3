Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaBTKrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:47:53 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27680 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbaBTKrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:47:52 -0500
Date: Thu, 20 Feb 2014 13:47:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Compostella, Jeremy" <jeremy.compostella@intel.com>
Cc: devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, "Ernst, Eric" <eric.ernst@intel.com>,
        "Gross, Mark" <mark.gross@intel.com>, Arve <arve@android.com>,
        Mirsal Ennaime <mirsal@mirsal.fr>
Subject: Re: [PATCH] Android / binder: Fix broken walk in
 binder_node_release()
Message-ID: <20140220104725.GY26722@mwanda>
References: <87eh2yxeav.fsf@tldlab276.tl.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87eh2yxeav.fsf@tldlab276.tl.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yeah.  Sorry about that.  Your fix is correct.

Is there any way you could resend it with the explanation from the email
in the changelog?  Remove the "confidential material" footer because
those are not allowed on the email list and conflict with the GPL.  Can
you use git send-email to send the patch inline?

For bug fixes like this then we try to be more flexible about dealing
with patches, so Greg may decide to take it as-is.  But if you are able
to send it in the normal way, that would help us.

regards,
dan carpenter

PS:  Sorry for top posting.  I just wanted to include the entire email
because Mirsal wasn't CC'd on the original.

On Thu, Feb 20, 2014 at 11:35:04AM +0100, Compostella, Jeremy wrote:
> Hi,
> 
> I've found a bug in the binder driver and I propose the attached patch to fix
> it.  This bug could manifest itself in several situations, here is the one that
> made me hunt it last week.
> 
> When an Android device is encrypted, Android starts all the init services of
> core and main levels, then it asks for the password and checks it trying to
> mount /data.  On success, it kills all the main services, mount /data and
> restart all the main services.
> 
> Unfortunately, on restart of those main services we observe :
> 
> DisplayManager       Could not get display information from display manager.
> DisplayManager       android.os.DeadObjectException
> DisplayManager       at android.os.BinderProxy.transact(Native Method)
> DisplayManager       at android.hardware.display.IDisplayManager$Stub$Proxy.getDisplayInfo(IDisplayManager.java:228)
> DisplayManager       at android.hardware.display.DisplayManagerGlobal.getDisplayInfo(DisplayManagerGlobal.java:117)
> DisplayManager       at android.hardware.display.DisplayManagerGlobal.getCompatibleDisplay(DisplayManagerGlobal.java:176)
> DisplayManager       at android.app.ResourcesManager.getDisplayMetricsLocked(ResourcesManager.java:96)
> DisplayManager       at android.app.ResourcesManager.getDisplayMetricsLocked(ResourcesManager.java:74)
> [...]
> 
> Which means that the 'display' service is registered into the service_manager
> but point to a dead object (understand died process).  This error is the first
> one of a chain of missing "remote" objects causing the death of processes until
> the system can recovery by itself a few seconds later.
> 
> The binder driver allows a "process" to ask a notification when a particular
> reference die.  In that case, the binder driver associate a death object to this
> reference.
> 
> When the system_server process died, the file descriptor to the binder driver is
> automatically released and the binder driver will walk all the references
> associated to this process to unallocate them.  When such a reference has a
> death object associated it will execute a task to notify the death to the
> previously register process usually the service_manager process.
> 
> The bug is that this walk on all the references is broken due to an
> unfornate refactoring made by the following patch :
> 
>         commit 008fa749e0fe5b2fffd20b7fe4891bb80d072c6a
>         Author: Mirsal Ennaime <mirsal@mirsal.fr>
>         Date:   Tue Mar 12 11:41:59 2013 +0100
> 
> which break the loop if the current reference does not have a death object
> instead of continuing to the next reference.  As a consequence all the next
> references will not be correctly unallocate and no death notification will be
> sent for them.
> 
> Thanks,
> 
> Jérémy
> -- 
> Sent from my Emacs
> ---------------------------------------------------------------------
> Intel Corporation SAS (French simplified joint stock company)
> Registered headquarters: "Les Montalets"- 2, rue de Paris, 
> 92196 Meudon Cedex, France
> Registration Number:  302 456 199 R.C.S. NANTERRE
> Capital: 4,572,000 Euros
> 
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.

> >From eaf6a8f28f02220ef2154c76a5345f6aa582e8f7 Mon Sep 17 00:00:00 2001
> From: Jeremy Compostella <jeremy.compostella@intel.com>
> Date: Tue, 11 Feb 2014 19:40:29 +0100
> Subject: [PATCH] Android / binder: Fix broken walk in binder_node_release()
> 
> Fix an issue introduced by commit
> 008fa749e0fe5b2fffd20b7fe4891bb80d072c6a ("drivers: android: binder:
> Move the node release code to a separate function") which move and
> rework some code from binder_deferred_release to the
> binder_node_release new function.  The rework introduced an
> unfortunate break of the loop that prevent some death notifications to
> be sent.
> 
> Signed-off-by: Jeremy Compostella <jeremy.compostella@intel.com>
> ---
>  drivers/staging/android/binder.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
> index eaec1da..1432d95 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -2904,7 +2904,7 @@ static int binder_node_release(struct binder_node *node, int refs)
>  		refs++;
>  
>  		if (!ref->death)
> -			goto out;
> +			continue;
>  
>  		death++;
>  
> @@ -2917,7 +2917,6 @@ static int binder_node_release(struct binder_node *node, int refs)
>  			BUG();
>  	}
>  
> -out:
>  	binder_debug(BINDER_DEBUG_DEAD_BINDER,
>  		     "node %d now dead, refs %d, death %d\n",
>  		     node->debug_id, refs, death);
> -- 
> 1.7.10.4
> 

> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel

