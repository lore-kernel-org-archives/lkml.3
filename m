Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494AbaBUU3F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 15:29:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58138 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaBUU3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 15:29:03 -0500
Date: Fri, 21 Feb 2014 12:30:32 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Compostella, Jeremy" <jeremy.compostella@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Gross, Mark" <mark.gross@intel.com>,
        "Ernst, Eric" <eric.ernst@intel.com>, Arve <arve@android.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Mirsal Ennaime <mirsal@mirsal.fr>
Subject: Re: [PATCH] Android / binder: Fix broken walk in
 binder_node_release()
Message-ID: <20140221203032.GA29596@kroah.com>
References: <87ob21x6j6.fsf@tldlab276.tl.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob21x6j6.fsf@tldlab276.tl.intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 02:22:53PM +0100, Compostella, Jeremy wrote:
> From: "Compostella, Jeremy" <jeremy.compostella@intel.com>
> 
> This bug can manifest itself in several situations, here is the one that made me
> hunt it last week:
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
> Signed-off-by: Jeremy Compostella <jeremy.compostella@intel.com>
> ---
>  drivers/staging/android/binder.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Thanks, but this fix has already been submitted, and has been part of
the Android kernel git tree for a while with the authorship of someone
else, so I'll use that patch instead when applying it.

greg k-h
