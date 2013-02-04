Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab3BDBDH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 20:03:07 -0500
Received: from science.horizon.com ([71.41.210.146]:59087 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753623Ab3BDBDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 20:03:05 -0500
Date: 3 Feb 2013 20:03:03 -0500
Message-ID: <20130204010303.24971.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: jslaby@suse.cz, linux-serial@vger.kernel.org
Subject: 3.8-rc regression with pps-ldisc due to 70ece7a731
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"TTY: n_tty, add ldisc data to n_tty"

The PPS line discipline has incestuous relations with the n_tty line
discipline, using some hooks to call internal routines.

However, I started noticing violent kernel explosions when testing 3.8-rc,
and after a bit of digging, I think it's due to the fact that the PPS code
assumes that the ->ldisc pointer is available to hold a pointer to a "pps"
structure, but this commit started using it in the core n_tty discipline.

If you look at pps_tty_open in drivers/pps/clients/pps-ldisc.c, you can
see it does:

	pps = pps_register_source(&info, PPS_CAPTUREBOTH | \
				PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
	if (pps == NULL) {
		pr_err("cannot register PPS source \"%s\"\n", info.path);
		return -ENOMEM;
	}
	tty->disc_data = pps;

        /* Should open N_TTY ldisc too */
        ret = alias_n_tty_open(tty);

Where "alias_n_tty_open" is filled in by n_tty_inherit_ops() to be
n_tty_open().  However, in this commit, n_tty_open() now allocates
its own structure and overwrites the disc_data pointer, leading to an
earth-shattering kaboom as NULL pointers are dereferenced in interrupt
handlers.


My first thought is to reserve a pointer in n_tty_data for the
pps structure and update the pps code to chase pointers one more
level.  But I wanted to solicit opinions.
