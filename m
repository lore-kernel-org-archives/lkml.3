Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3GBPHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:07:38 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:56044 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab3GBPHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:07:35 -0400
From: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
To: benh@kernel.crashing.org, jslaby@suse.cz, gregkh@linuxfoundation.org
Cc: brueckner@linux.vnet.com, heiko.carstens@de.ibm.com,
        schwidefsky@de.ibm.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: [PATCH 0/2] hvc_console: Add DTR/RTS callbacks to handle HUPCL conditions
Date: Tue,  2 Jul 2013 17:07:13 +0200
Message-Id: <1372777635-10423-1-git-send-email-brueckner@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13070215-0542-0000-0000-000005B360A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

this series resolves an issue for hvc back-ends that transfer
terminal data over an established communication path.

The current implementation of the hvc_console layer notifies its
back-ends for tty open, close, and hangups.  However, there are
conditions where the hangup-on-close (HUPCL) termios flag must be
considered, for example, when doing a vhangup().

For the hvc_iucv back-end, users perceives disconnects at their
login which are triggered by a modified vhangup() invocation as
described in https://lkml.org/lkml/2012/6/5/145.
(The kernel change implied also a change in the login program).

However, this also necessitates to inform back-ends about changes
in the DTR/RTS control lines which actually depend on the setting
of the HUPCL termios flag.  Like in the old days for modems,
network-based back-ends need to know when to hang-up and drop off
an established communication path.  Without this new notification,
back-ends can only use the tty open, close, hangup notifiers to
decide whether to disconnect.  This is not sufficient because the
HUPCL flag can be cleared (i.e. not to hang-up a connection) when
last tty file descriptor is closed.

This series adds the dtr_rts() callback to the hvc_console layer
and modifies the hvc_iucv device driver to disconnect an established
IUCV connection only when the DTR/RTS is lowered.


Feedback is very welcome.  Thanks in advance!

Kind regards,
  Hendrik

