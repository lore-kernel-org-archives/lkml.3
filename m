Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaAGOUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 09:20:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaAGOUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 09:20:33 -0500
Date: Tue, 7 Jan 2014 06:20:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Lars Poeschel <poeschel@lemonage.de>
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org, xiaojin <jin.xiao@intel.com>,
        Ken Mills <ken.k.mills@intel.com>, Alan Cox <alan@linux.intel.com>,
        Dirkjan Bussink <d.bussink@gmail.com>
Subject: Re: [RFC DO NOT MERGE] tty: n_gsm: support buggy modem
Message-ID: <20140107142050.GB32491@kroah.com>
References: <4386658.RncifLMAGy@lem-wkst-02>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4386658.RncifLMAGy@lem-wkst-02>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 02:05:26PM +0100, Lars Poeschel wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> This is obiviously a bad patch. Do not merge it!
> I have a GSM Modem (Quectel M95 Revision: M95AR01A11) that I have a problem
> with when using the n_gsm mux line discipline. After attaching the line
> discipline and opening a muxed channel, the open never returns. The
> problem is that the tty code waits for the TIOCM_CD flag to be set. According
> to the 3GPP TS 07.10 specification the modem can set this virtual flag by
> setting the DV bit in it's modem status control message. My modem sends the
> modem status command, but this DV bit is not set. With this patch the modem
> and the whole mux is working fine. Another way makeing all this work is
> setting the carrier_raised function to NULL. The tty code assumes that
> everything is alright then.
> My question is: What could be the best way to support this modem in mailine
> kernel ? I do not see a way to detect this buggy modem inside the line
> discipline and use this patch's method as a work around then. But the
> detection would only be possible using AT command before the line discipline
> is attached or using the muxed channel after the mux is set up.

Adding some n_gsm.c authors to the cc:

Also, what kernel version are you using?

thanks,

greg k-h

> 
> Thanks,
> Lars
> ---
> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
> index c0f76da..a1a6f57 100644
> --- a/drivers/tty/n_gsm.c
> +++ b/drivers/tty/n_gsm.c
> @@ -1061,6 +1061,7 @@ static void gsm_process_modem(struct tty_struct *tty, struct gsm_dlci *dlci,
>  		mlines |= TIOCM_RI;
>  	if (modem & MDM_DV)
>  		mlines |= TIOCM_CD;
> +	mlines |= TIOCM_CD;
>  
>  	/* Carrier drop -> hangup */
>  	if (tty) {
