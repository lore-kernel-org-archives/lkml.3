Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbaGDUH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 16:07:28 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:49622 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbaGDUH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 16:07:26 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Himangi Saraogi <himangi774@gmail.com>,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>,
        "iscsi-driver@qlogic.com" <iscsi-driver@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "julia.lawall@lip6.fr" <julia.lawall@lip6.fr>
Subject: RE: [PATCH] qla4xxx: Return -ENOMEM on memory allocation failure
Thread-Topic: [PATCH] qla4xxx: Return -ENOMEM on memory allocation failure
Thread-Index: AQHPl7XGXEIJ27fQbUK/xDipiXfD+JuQUUSA
Date: Fri, 4 Jul 2014 20:03:38 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B866EB@G9W0745.americas.hpqcorp.net>
References: <20140704182756.GA9319@himangi-Dell>
In-Reply-To: <20140704182756.GA9319@himangi-Dell>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.22]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Himangi Saraogi
> Sent: Friday, 04 July, 2014 1:28 PM
> To: Vikas Chaudhary; iscsi-driver@qlogic.com; James E.J. Bottomley; linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Cc: julia.lawall@lip6.fr
> Subject: [PATCH] qla4xxx: Return -ENOMEM on memory allocation failure
> 
> In this code, 0 is returned on memory allocation failure, even though
> other failures return -ENOMEM or other similar values.
> 
> A simplified version of the Coccinelle semantic match that finds this
> problem is as follows:
> 
> // <smpl>
> @@
> expression ret;
> expression x,e1,e2,e3;
> identifier alloc;
> @@
> 
> ret = 0
> ... when != ret = e1
> *x = alloc(...)
> ... when != ret = e2
> if (x == NULL) { ... when != ret = e3
>   return ret;
> }
> // </smpl>
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
> index c5d9564..72ba671 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -1050,6 +1050,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host
> *shost, char *buf, int len)
>  	if (!ql_iscsi_stats) {
>  		ql4_printk(KERN_ERR, ha,
>  			   "Unable to allocate memory for iscsi stats\n");
> +		ret = -ENOMEM;
>  		goto exit_host_stats;
>  	}
> 

Also, the only caller of this function doesn't use the return 
value - it's overwritten by another function call:

drivers/scsi/scsi_transport_iscsi.c:
                err = transport->get_host_stats(shost, buf, host_stats_size);

                actual_size = nlmsg_total_size(sizeof(*ev) + host_stats_size);
                skb_trim(skbhost_stats, NLMSG_ALIGN(actual_size));
                nlhhost_stats->nlmsg_len = actual_size;

                err = iscsi_multicast_skb(skbhost_stats, ISCSI_NL_GRP_ISCSID,
                                          GFP_KERNEL);


---
Rob Elliott    HP Server Storage



