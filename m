Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaGKOmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:42:25 -0400
Received: from imap.thunk.org ([74.207.234.97]:58259 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbaGKOmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:42:23 -0400
Date: Fri, 11 Jul 2014 10:42:15 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>
Cc: Torsten Duwe <duwe@suse.de>, linux-kernel@vger.kernel.org,
        geralds@linux.vnet.ibm.com, heicars2@linux.vnet.ibm.com,
        mschwid2@linux.vnet.ibm.com, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harald Freudenberger <FREUDE@de.ibm.com>
Subject: Re: [Patch v5.1 03/03]: hwrng: khwrngd derating per device
Message-ID: <20140711144215.GA26426@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
	Torsten Duwe <duwe@suse.de>, linux-kernel@vger.kernel.org,
	geralds@linux.vnet.ibm.com, heicars2@linux.vnet.ibm.com,
	mschwid2@linux.vnet.ibm.com, Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Harald Freudenberger <FREUDE@de.ibm.com>
References: <53990165.3070505@zytor.com>
 <20140612100954.GA26943@lst.de>
 <20140614024050.GA6447@thunk.org>
 <26a6d3cf-d327-4089-bdef-f48d3163e3bc@email.android.com>
 <20140615051146.GA2180@thunk.org>
 <20140616073108.GA28232@suse.de>
 <20140616112207.GB4887@thunk.org>
 <20140616141444.GB1744@suse.de>
 <20140616142812.GB19387@thunk.org>
 <OF8E5D9F84.46724386-ONC1257D12.00431C2E-C1257D12.004B5DCC@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OF8E5D9F84.46724386-ONC1257D12.00431C2E-C1257D12.004B5DCC@de.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 03:43:24PM +0200, Ingo Tuchscherer wrote:
> At this point in time the zcrypt hw device is not registered completely in
> the internal zcrypt device list (ap_device_list). The crypto card itself is
> initialized and ready to receive and service requests, but the tasklet that
> retrieve the card response is not able to find the device because it's not
> yet in the list. Finally the response would not be received and the thread
> is still waiting for completion, hence the probing/registering procedure
> for all the other crypto devices is blocked. No further devices could be
> scanned, initialized and registered.
> Therefore I would not recommend to trigger a hw device request before the
> device register process has completed.

Is there any chance that you could change the zcrypt driver so that it
doesn't call hwrng_register() until and the tasklet that can receive
the request has been fully registered?  It sounds like that should
just be a matter of reordering a few lines of code, no?

> Anyway, when the kernel thread (hwrng_fillfn) starts, it take care about
> the initial call to the zcrypt rng device to be triggered. Therefore I
> don't see any reason to manually call rng_get_data() during the
> registration or did I missed something?

The basic idea was described in the commit that added this:

commit d9e79726193346569af7953369a638ee2275ade5
Author: Kees Cook <keescook@chromium.org>
Date:   Mon Mar 3 15:51:48 2014 -0800

    hwrng: add randomness to system from rng sources
    
    When bringing a new RNG source online, it seems like it would make sense
    to use some of its bytes to make the system entropy pool more random,
    as done with all sorts of other devices that contain per-device or
    per-boot differences.
    
    Signed-off-by: Kees Cook <keescook@chromium.org>
    Reviewed-by: Jason Cooper <jason@lakedaemon.net>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Cheers,

						- Ted
