Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaKMCwt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:52:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:32116 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753813AbaKMCwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:52:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,373,1413270000"; 
   d="scan'208";a="636129486"
From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ming Lei <ming.lei@canonical.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "Sam Protsenko" <semen.protsenko@linaro.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH v2 1/3] firmware loader: Introduce new API -
 request_firmware_abort()
Thread-Topic: [PATCH v2 1/3] firmware loader: Introduce new API -
 request_firmware_abort()
Thread-Index: AQHP+4de++OfUYhRjkKfGs6CqwuvNJxZipnA
Date: Thu, 13 Nov 2014 02:51:28 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B8529E3@PGSMSX102.gar.corp.intel.com>
References: <1414984030-13859-1-git-send-email-hock.leong.kweh@intel.com>
 <1414984030-13859-2-git-send-email-hock.leong.kweh@intel.com>
 <20141108190655.GA2638@kroah.com>
In-Reply-To: <20141108190655.GA2638@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.205]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> Sent: Sunday, November 09, 2014 3:07 AM
>
> >
> > Besides aborting through user helper interface, a new API
> > request_firmware_abort() allows kernel driver module to abort the
> > request_firmware() / request_firmware_nowait() when they are no longer
> > needed. It is useful for cancelling an outstanding firmware load if
> > initiated from inside a module where that module is in the process of
> > being unloaded, since the unload function may not have a handle to the
> > struct firmware_buf.
> >
> > Note for people who use request_firmware_nowait():
> > You are required to do your own synchronization after you call
> > request_firmware_abort() in order to continue unloading the module.
> > The example synchronization code shows below:
> >
> > while (THIS_MODULE && module_refcount(THIS_MODULE))
> > 	msleep(20);
> 
> As others have pointed out, this isn't ok, and is totally racy and should never
> end up in a driver.  Never mess with THIS_MODULE from within the same
> module, otherwise it's racy and broken code.
> 
> So can you please rework this to not require this?
> 
> thanks,
> 
> greg k-h

Hi everyone,

First of all, I would like to apologize if my commit message gives you guys an impression
that to use request_firmware_abort(), you guys MUST do the synchronization on your own. 
But the fact is, it is not a MUST. Below will provide more detail.

Regarding this synchronization topic, I would like to open a discussion to get a
better approach to handle this problem. Before jumping onto the design, I would
like to give a background of why I am doing in this way.

- Only doing module unload is required to be aware of this synchronization
	-> Ensuring the call back does not fall into unloaded code which may cause
	     undefined behavior.
	-> Ensuring the put_device() & module_put() code have finished in firmware_class.c
	     function request_firmware_work_func() before the device is unregistered
	     and module unloaded happen.

- Not all the situations are required to do this synchronization:
	-> Implementation that use request_firmware() do not need this synchronization
	     due to it will get synced by returning at the same place the caller call
	     request_firmware().
	-> Implementation that will not unload the call back code and without relying
	     device refcount / module refcount do not need this synchronization (for e.g.
	     calling the request_firmware_nowait() without passing the MODULE and DEVICE
	     parameters as showed below:
	     request_firmware_nowait(NULL, FW_ACTION_NOHOTPLUG, "xxx", NULL,
				             GFP_KERNEL, NULL, callbackfn);).

- Following the original request_firmware_nowait() design thought
	-> Strongly believe the original design of request_firmware_nowait() that using the get_device(),
	     put_device(), try_get_module() & module_put() also expect the caller side to do the
	     synchronization themselves if they have relying on these counter to continue their works.

	     Let's take out this newly introduce API (request_firmware_abort()) and focus only on the
	     original design (request_firmware_nowait()). If there is a caller design that after the callback
	     happen and it need to do platform_device_unregister(), the original design also expect the
	    caller do its own synchronization before it can do the device unregister.

- Use cases that do not need the synchronization:
	-> Depend on a volatile condition in order to expose firmware upload interface: Like a design
	      only in a particular window period then open the interface, when outside of the window
	      then it need to disable the interface. This design also does not need the synchronization
	      as it do not unload the callback module code and not relying on the device refcount or
	      module refcount to do it stuff.
	-> System reboot: When system reboot, the system would not unload the module code and
	      also would not unregister the device. So it does not meet the conditions (unload call back
	      code and have dependency on device refcount / module refcount). This does not need
	      the synchronization.

Due to the above reasons, in summary, I think the caller has the responsibility to take care of this
synchronization whenever needed on the caller side. What do you guys think?


Come back to the design if really need to implement it in firmware_class. Below shows some design
thought:

- Complexity of implementing the synchronization inside firmware_class
	-> Cannot use module refcount or device refcount to be the synchronization method
	     due to:
	     (1) firmware_work data struct will get freed  at request_firmware_work_func()
	            after calling the __fw_load_abort() just before you could do the synchronization
	            at the end of request_firmware_abort().
	     (2) each different caller may have different refcount number in their device/module
	            data struct where it is impossible for firmware_class to take a number and wait
	            for it. Only caller know better what is the number they should wait for.
	      (3) As mentioned above, caller who use request_firmware_nowait() may not passing
	             the module or device parameters.
	-> firmware_buf data struct also will get freed after calling the __fw_load_abort() just
                     before you could do the synchronization at the end of request_firmware_abort().
	-> If implement wait completion for the synchronization, below are something we need
	     to watch out/take care:
	     (1) completion struct cannot tight to firmware_buf & firmware_work data structs as they
	            are freed before you can use it.
	     (2) one global completion struct may not work due to request_firmware_nowait() can
	            be called multiple time.
	     (3) it may have chances to race with userland issuing "echo 0 > loading" which eventually
	            happened in such scenario that complete_all() being called before wait_for_completion()
	            being called.

I am thinking that I will stick back with wait completion method for the synchronization instead of using
semaphore. Trying to overcome the above complexity, I need to introduce another struct that won't be
freed and must able to link with firmware_buf data struct. And I also need to implement some kind of
lock to prevent race condition. 

Do you guys think this is feasible? Or the most easiest way to do the synchronization is at the
platform_device_unregister() or module unload code which before they unregister/unload, they need
to wait until refcount = 0 then they can do their job.

Looking forward to hear from you guys. Thanks. :-)


Regards,
Wilson

