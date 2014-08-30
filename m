Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaH3Rtj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 13:49:39 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:38013 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427AbaH3Rth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 13:49:37 -0400
Date: Sat, 30 Aug 2014 11:49:21 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v4] tpm_tis: verify interrupt during init
Message-ID: <20140830174920.GA26218@obsidianresearch.com>
References: <20140822203241.GB1733@obsidianresearch.com>
 <alpine.LNX.2.11.1408250629110.1207@localhost.localdomain>
 <20140825182414.GB1298@obsidianresearch.com>
 <alpine.LNX.2.11.1408270410190.701@localhost.localdomain>
 <20140827173142.GA11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408271755470.4371@localhost.localdomain>
 <20140827214743.GC11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408280017420.1064@localhost.localdomain>
 <20140828165348.GE11183@obsidianresearch.com>
 <alpine.LNX.2.11.1408290234060.1020@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.11.1408290234060.1020@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 11:59:32PM +0000, Scot Doyle wrote:

> (current->pending.signal.sig[0] == 0x00000100 == SIGKILL?) about 30 
> seconds after module load begins. wait_for_tpm_stat sees that the return 
> value from wait_event_interruptible_timeout is positive and returns 0. 
> tpm_tis_send thinks everything is fine and continues. However, since a 
> signal was received, but not cleared, then the next time 
> wait_event_interruptible_timeout is used within wait_for_tpm_stat it 
> returns with -ERESTARTSYS, and continues doing so until tpm_send_data 
> returns -ETIME.

Oh, I see. That is another bug you've found - ERESTARTSYS should not
be translated into ETIME!

It is also not exciting that udev is overriding the driver timeouts. :(

> [    1.536850] tpm_tis 00:08: 1.2 TPM (device-id 0xB, rev-id 16)
> [    7.650172] tpm_tis 00:08: [Firmware Bug]: TPM interrupt not working, polling instead
> 
> I tried calling tpm_get_timeouts only during the interrupt test, but again 
> was timed out after 30 seconds. The interrupt wait in tis_send calls 
> tpm_calc_ordinal_duration, which uses a default timeout of two minutes 
> when chip->vendor.duration[duration_idx] hasn't been set. Thus the second 
> call to tpm_get_timeouts in tpm_tis_init.

So the strategy is to read the timeouts and hope that the chip reports
something small and reasonable, then do a second read?

Seems reasonable, but with this new arrangement we could also use an
alternate polling logic for 'testing_int' that did the normal polling
loop unconditionally and then checked if the interrupt was
delivered. This would give a minimal dealy.

> What do you think about the guard logic? My intent is to prevent a signal 
> received after the test period from causing a fallback to polling mode. 
> Plus, it seems good to preserve the current logic where practical.

I think this is looking very reasonable now, I'll have to read it
closer next week!

> +	if (priv->testing_int)
> +		priv->int_received = true;

This could just be a simple counter, if the counter is 0 then test
the interrupt otherwise proceed normally.

Jason
