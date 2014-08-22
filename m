Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbaHVAlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 20:41:50 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:55828 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbaHVAlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 20:41:45 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Hannes Reinecke <hare@suse.de>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [RFC PATCH -logging 00/10] scsi/constants: Output continuous
 error messages on trace
Thread-Topic: [RFC PATCH -logging 00/10] scsi/constants: Output continuous
 error messages on trace
Thread-Index: AQHPsv8DDp/7HOesqUm0wDKcjvfaUJvb1eAQ
Date: Fri, 22 Aug 2014 00:39:59 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C1A9E5@G9W0745.americas.hpqcorp.net>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
In-Reply-To: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7M0ftG4009811

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Yoshihiro YUNOMAE
> Sent: Friday, 08 August, 2014 6:50 AM
> Subject: [RFC PATCH -logging 00/10] scsi/constants: Output continuous
> error messages on trace
...
> 1) printk
> Keeps current implemntation of upstream kernel.
> The messages are divided and can be mixed, but all users can
> check the error messages without any settings.

scsi_io_completion ignore the scsi_logging_level and always calls
printk if it detects ACTION_FAIL, resulting in messages like:

    [10240.338600] sd 2:0:0:0: [sdr]
    [10240.339722] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
    [10240.341662] sd 2:0:0:0: [sdr]
    [10240.342792] Sense Key : Hardware Error [current]
    [10240.344575] sd 2:0:0:0: [sdr]
    [10240.345653] Add. Sense: Logical unit failure
    [10240.347138] sd 2:0:0:0: [sdr] CDB:
    [10240.348309] Read(10): 28 00 00 00 00 80 00 00 08 00

If you trigger hundreds of errors (e.g., hot remove a device
during heavy IO), then all the prints to the linux serial console
bog down the system, causing timeouts in commands to other
devices and soft lockups for applications.

Some changes that would help are:
1. Put them under SCSI logging level control
2. Use printk_ratelimited so an excessive number are trimmed

Would you like to include something like this in your
patch set?

This is an example patch that only prints them if the MLCOMPLETE 
logging level is nonzero.
Off: scsi_logging_level --set --mlcomplete=0
On: scsi_logging_level --set --mlcomplete=1

Some other loglevel (e.g., ERROR_RECOVERY) could be used.

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d6b4ea8..dbb601f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1037,7 +1037,9 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 	switch (action) {
 	case ACTION_FAIL:
 		/* Give up and fail the remainder of the request */
-		if (!(req->cmd_flags & REQ_QUIET)) {
+		if (!(req->cmd_flags & REQ_QUIET) &&
+		    SCSI_LOG_LEVEL(SCSI_LOG_MLCOMPLETE_SHIFT,
+		    SCSI_LOG_MLCOMPLETE_BITS)) {
 			scsi_print_result(cmd);
 			if (driver_byte(result) & DRIVER_SENSE)
 				scsi_print_sense("", cmd);

Converting to printk_ratelimited is harder since the prints
are spread out over three functions (and as your patch
series notes, many individual printk calls).  The rates
for the printk calls might not match, which would lead to
even more confusing output.

---
Rob Elliott    HP Server Storage



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
