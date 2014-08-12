Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834AbaHLOw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 10:52:27 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:22659 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaHLOw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 10:52:26 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Hannes Reinecke <hare@suse.de>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@lst.de>
Subject: RE: [RFC PATCH 01/10] scsi/constants: Cleanup printk message in
 __scsi_print_sense()
Thread-Topic: [RFC PATCH 01/10] scsi/constants: Cleanup printk message in
 __scsi_print_sense()
Thread-Index: AQHPswBZyo7pF8Tcvk+aemW20MEd4JvNDb2Q
Date: Tue, 12 Aug 2014 14:51:42 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958BE5A76@G9W0745.americas.hpqcorp.net>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
 <20140808115006.6768.5118.stgit@yuno-kbuild.novalocal>
In-Reply-To: <20140808115006.6768.5118.stgit@yuno-kbuild.novalocal>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s7CEqWPm014282



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Yoshihiro YUNOMAE
> Sent: Friday, 08 August, 2014 6:50 AM
...
> Subject: [RFC PATCH 01/10] scsi/constants: Cleanup printk message in
> __scsi_print_sense()
> 
> A device name is output like "sda: Sense Key : Medium Error [current]"
> in __scsi_print_sense(), but it should be "[sda] Sense Key : Medium Error
> [current]" because other printk messages output a device name like "[sda]
> foo."
> 
...
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index c6a7a4a..a0e8159 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -1470,7 +1470,7 @@ void __scsi_print_sense(struct scsi_device *sdev,
> const char *name,
>  		return;
>  	}
> 
> -	sdev_printk(KERN_INFO, sdev, "%s: Sense Key : %s %s%s\n", name,
> +	sdev_printk(KERN_INFO, sdev, "[%s] Sense Key : %s %s%s\n", name,
>  	       scsi_sense_key_string(sshdr.sense_key),
>  	       scsi_sense_type_string(&sshdr),
>  	       scsi_sense_format_string(&sshdr));
> 


The callers of __scsi_print_sense do not always pass in a name
like "sda".  In fact, sd.c doesn't even call that function; its
sd_print_sense_hdr calls sd_printk (which prints name as "[%s]")
and scsi_show_sense_hdr.

There are just 3 kernel files that call this function:
osst.c:                 __scsi_print_sense("osst ", SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
osst.c:                 __scsi_print_sense("osst ", SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
There is a separate call to printk just before each of those,
which prints out the name, without [].

sg.c:                   __scsi_print_sense(__func__, sense,
That's printing the C function name.

st.c:                    __scsi_print_sense(name, SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
st.c:                   __scsi_print_sense(name, SRpnt->sense, SCSI_SENSE_BUFFERSIZE);
This is more like what you have in mind.


---
Rob Elliott    HP Server Storage


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
