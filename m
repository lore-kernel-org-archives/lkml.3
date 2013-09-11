Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab3IKSOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:14:52 -0400
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:31307 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab3IKSOu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:14:50 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: ISS StorageDev <iss_storagedev@hp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Moritz Muehlenhoff <jmm@debian.org>
Subject: RE: [patch -resend] cciss: info leak in cciss_ioctl32_passthru()
Thread-Topic: [patch -resend] cciss: info leak in cciss_ioctl32_passthru()
Thread-Index: AQHOrsH/MVwVPsZLhkiC38Pmqu8F95nA15ZA
Date: Wed, 11 Sep 2013 18:13:31 +0000
Message-ID: <48275AD710FCA34184C2B6186B4016B32D0FD7E5@G6W2491.americas.hpqcorp.net>
References: <20130603092645.GD16171@debian> <20130911073832.GB25349@mwanda>
In-Reply-To: <20130911073832.GB25349@mwanda>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.193.49.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Wednesday, September 11, 2013 2:39 AM
To: Miller, Mike (OS Dev); Andrew Morton
Cc: ISS StorageDev; linux-kernel@vger.kernel.org; kernel-janitors@vger.kernel.org; Moritz Muehlenhoff
Subject: [patch -resend] cciss: info leak in cciss_ioctl32_passthru()

The arg64 struct has a hole after ->buf_size which isn't cleared.
Or if any of the calls to copy_from_user() fail then that would cause an information leak as well.

This was assigned CVE-2013-2147.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Acked-by: Mike Miller <mike.miller@hp.com>

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c index 6374dc1..34971aa 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1189,6 +1189,7 @@ static int cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
 	int err;
 	u32 cp;
 
+	memset(&arg64, 0, sizeof(arg64));
 	err = 0;
 	err |=
 	    copy_from_user(&arg64.LUN_info, &arg32->LUN_info,
