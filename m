Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab3BFPxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 10:53:53 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:34006 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756394Ab3BFPxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 10:53:51 -0500
Message-ID: <1360166020.3298.42.camel@thor.lan>
Subject: Re: 3.8-rc regression with pps-ldisc due to 70ece7a731
From: Peter Hurley <peter@hurleysoftware.com>
To: George Spelvin <linux@horizon.com>
Cc: jslaby@suse.cz, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 06 Feb 2013 10:53:40 -0500
In-Reply-To: <20130204010303.24971.qmail@science.horizon.com>
References: <20130204010303.24971.qmail@science.horizon.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi George,

On Sun, 2013-02-03 at 20:03 -0500, George Spelvin wrote:
> "TTY: n_tty, add ldisc data to n_tty"
> 
> The PPS line discipline has incestuous relations with the n_tty line
> discipline, using some hooks to call internal routines.
> 
> However, I started noticing violent kernel explosions when testing 3.8-rc,
> and after a bit of digging, I think it's due to the fact that the PPS code
> assumes that the ->ldisc pointer is available to hold a pointer to a "pps"
> structure, but this commit started using it in the core n_tty discipline.
> 
> If you look at pps_tty_open in drivers/pps/clients/pps-ldisc.c, you can
> see it does:
> 
> 	pps = pps_register_source(&info, PPS_CAPTUREBOTH | \
> 				PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
> 	if (pps == NULL) {
> 		pr_err("cannot register PPS source \"%s\"\n", info.path);
> 		return -ENOMEM;
> 	}
> 	tty->disc_data = pps;
> 
>         /* Should open N_TTY ldisc too */
>         ret = alias_n_tty_open(tty);
> 
> Where "alias_n_tty_open" is filled in by n_tty_inherit_ops() to be
> n_tty_open().  However, in this commit, n_tty_open() now allocates
> its own structure and overwrites the disc_data pointer, leading to an
> earth-shattering kaboom as NULL pointers are dereferenced in interrupt
> handlers.

Yuck. Little wonder it broke.

> My first thought is to reserve a pointer in n_tty_data for the
> pps structure and update the pps code to chase pointers one more
> level.  But I wanted to solicit opinions.

Tight coupling is what caused this to break in the first place -- I
don't think tighter coupling is the right answer.

Alternate coming...

Regards,
Peter Hurley


