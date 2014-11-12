Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068AbaKLQBG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 11:01:06 -0500
Received: from smtp81.iad3a.emailsrvr.com ([173.203.187.81]:35139 "EHLO
	smtp81.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752620AbaKLQBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 11:01:04 -0500
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: fix scan_end_arg == chanlist_len assumption
Date: Wed, 12 Nov 2014 16:00:48 +0000
Message-Id: <1415808048-2506-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some comedi drivers allow the `scan_end_arg` value of an asynchronous
command to be a multiple (> 1) of the `chanlist_len` although most
require them to be the same value.

`comedi_bytes_per_scan()` is incorrectly using `chanlist_len` as the
length of the scan.  Change it to use `scan_end_arg`.

`comedi_nsamples_left()` is incorrectly using `cur_chan` as the current
sample position in the scan (it is actually the current position in the
channel list).  Change it to use the actual sample position in the scan.
(Unfortunately we only have the current scan position in bytes currently,
so convert that to a sample position.)

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
index 82ac845..e516ed9 100644
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -317,10 +317,10 @@ unsigned int comedi_bytes_per_scan(struct comedi_subdevice *s)
 	case COMEDI_SUBD_DO:
 	case COMEDI_SUBD_DIO:
 		bits_per_sample = 8 * comedi_bytes_per_sample(s);
-		num_samples = DIV_ROUND_UP(cmd->chanlist_len, bits_per_sample);
+		num_samples = DIV_ROUND_UP(cmd->scan_end_arg, bits_per_sample);
 		break;
 	default:
-		num_samples = cmd->chanlist_len;
+		num_samples = cmd->scan_end_arg;
 		break;
 	}
 	return comedi_samples_to_bytes(s, num_samples);
@@ -384,11 +384,13 @@ unsigned int comedi_nsamples_left(struct comedi_subdevice *s,
 		/* +1 to force comedi_nscans_left() to return the scans left */
 		unsigned int nscans = (nsamples / cmd->scan_end_arg) + 1;
 		unsigned int scans_left = comedi_nscans_left(s, nscans);
+		unsigned int scan_pos =
+		    comedi_bytes_to_samples(s, async->scan_progress);
 		unsigned long long samples_left = 0;
 
 		if (scans_left) {
 			samples_left = ((unsigned long long)scans_left *
-				       cmd->scan_end_arg) - async->cur_chan;
+					cmd->scan_end_arg) - scan_pos;
 		}
 
 		if (samples_left < nsamples)
-- 
2.1.1

