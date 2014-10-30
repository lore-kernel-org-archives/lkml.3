Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759818AbaJ3Mmy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:42:54 -0400
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:46563 "EHLO
	smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759792AbaJ3Mmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:42:52 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] staging: comedi: enforce data transfer direction
Date: Thu, 30 Oct 2014 12:42:25 +0000
Message-Id: <1414672952-1587-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most comedi subdevices that support asynchronous data acquisition
commands only support data transfer in a single direction, as indicated
by the `SDF_CMD_READ` and `SDF_CMD_WRITE` subdevice flags.  A few allow
data transfer in either direction, but only a single direction at a
time, as indicated by the `CMDF_WRITE` command flag in the `flags`
member of the `struct comedi_cmd` from user-space used to set up the
asynchronous command.  The `CMDF_WRITE` flag isn't commonly set for
"write" commands if that is the only direction the subdevice supports.

Since it would be useful for comedi to have a clear indication of which
data transfer direction is being used, patch 1 forces the `CMDF_WRITE`
command flag to the correct state if only one direction is supported.
The flag can then be checked by comedi in the subdevice's local copy of
the current command (in `s->async->cmd`) to determine the data transfer
direction unambiguously.

Patch 2 stops the "me4000" driver clobbering the command flags.

Patch 3 removes some now redundant modification of the `CMDF_WRITE` flag
in "ni_mio_common.c" (used by the "ni_pcimio", "ni_atmio" and
"ni_mio_cs" drivers).

Patches 4 and 5 disallow the read() and write() file operations if the
subdevice has been set up with a command in the "write" or "read" data
transfer direction respectively.

Patch 6 changes the readable/writeable checks for the poll() file
operation.  It already considers the file readable/writeable if
read()/write() would fail with an error, so change it to check for
"wrong direction" as one of the possible failures.

Patch 7 makes the direction test in the handling of the `COMEDI_BUFINFO`
ioctl (used to update buffer positions for mmapped buffers) less
ambiguous.  The current test used the `SDF_CMD_READ` and `SDF_CMD_WRITE`
subdevice flags to check the direction, which is ambiguous if both flags
are set.  Update it to use the `CMDF_WRITE` command flag instead.

1) staging: comedi: maybe force CMDF_WRITE command flag
2) staging: comedi: me4000: don't clobber command flags
3) staging: comedi: ni_mio_common: don't change CMDF_WRITE flag
4) staging: comedi: don't allow read() on async command set up for "write"
5) staging: comedi: don't allow write() on async command set up for "read"
6) staging: comedi: check command direction in poll() file operation
7) staging: comedi: check actual data direction for COMEDI_BUFINFO ioctl

 drivers/staging/comedi/comedi_fops.c           | 37 ++++++++++++++++++++++++--
 drivers/staging/comedi/drivers/me4000.c        |  3 ---
 drivers/staging/comedi/drivers/ni_mio_common.c |  6 -----
 3 files changed, 35 insertions(+), 11 deletions(-)
