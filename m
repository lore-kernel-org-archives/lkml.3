Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaKMFfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 00:35:13 -0500
Received: from g4t3425.houston.hp.com ([15.201.208.53]:57205 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaKMFfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 00:35:11 -0500
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Barto <mister.freeman@laposte.net>, Guenter Roeck <linux@roeck-us.net>,
        Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: RE: BUG in scsi_lib.c due to a bad commit
Thread-Topic: BUG in scsi_lib.c due to a bad commit
Thread-Index: AQHP/gfw5DnDInPNbkurae5DQHjb7pxcH/iAgAArhgCAAZwZgIAAFbvw
Date: Thu, 13 Nov 2014 05:33:06 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593A1880@G9W0745.americas.hpqcorp.net>
References: <54629CAE.2000207@laposte.net>
 <CAErSpo6FFK6zMOWSK9=dOOMKjWd1soAyj9r73yP8Z_U4F9ygAA@mail.gmail.com>
 <5462CB90.1080303@roeck-us.net> <54642541.9080302@laposte.net>
In-Reply-To: <54642541.9080302@laposte.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.192.240]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sAD5ZNTX021689



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Barto
> Sent: Wednesday, November 12, 2014 9:28 PM
> To: Guenter Roeck; Bjorn Helgaas
> Cc: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Joe
> Perches
> Subject: Re: BUG in scsi_lib.c due to a bad commit
> 
> reverting your commit 045065d8a300a37218c is a solution, but it's just a
> temporary solution,
> 
> it's better to search why your commit can create a random hang on boot
> on some PC configurations,
> 
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1774,7 +1774,7 @@ static void scsi_request_fn(struct request_queue
> *q)
> blk_requeue_request(q, req);
> atomic_dec(&sdev->device_busy);
> out_delay:
> - if (atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
> + if (!atomic_read(&sdev->device_busy) && !scsi_device_blocked(sdev))
> blk_delay_queue(q, SCSI_QUEUE_DELAY);
> }
> 
> perhaps the atomic_read() function doesn't make the expected job on some
> rare circonstances, I have the same doubts about the blk_delay_queue()
> function

Were you running with scsi_mod.use_blk_mq=Y or =N?

device_busy is the active queue depth for the device (e.g.
5 means there are 5 commands submitted but not yet completed).

The function reaches this code if it has run out of tags, the host
has reached its limit of outstanding commands, or the target has
reached its limit.  It requeus the request:
* with delay if device_busy is zero
* without delay if device_busy is non_zero

I think this is the reasoning:
If device_busy is zero, trying to process the request again will
probably run into the same problem; a delay gives time for the
situation to change.  If device_busy is non-zero, then the 
requeued command goes behind others and might get a different
result.

With the polarity backwards, the lack of delay hung PA-RISC 
and SPARC64 systems), not just QEMU.  So, I don't think reverting
the fix is good.

Changing it to an unconditional delay might be safe - delay
regardless of device_busy (until the root cause is understood).

Also, SCSI_QUEUE_DELAY seems like an arbitrary magic number; 
maybe that value isn't working correctly anymore?


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
