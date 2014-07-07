Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaGGRs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:48:56 -0400
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:63193 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751281AbaGGRsy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:48:54 -0400
From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
To: Mike Christie <michaelc@cs.wisc.edu>, Julia Lawall <julia.lawall@lip6.fr>
CC: "Elliott, Robert (Server Storage)" <Elliott@hp.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] qla4xxx: Return -ENOMEM on memory allocation failure
Thread-Topic: [PATCH] qla4xxx: Return -ENOMEM on memory allocation failure
Thread-Index: AQHPl7Wwb31o/uIXRkONZQuENG7h+puQzAMAgAAJcgCABHIrAIAAcTsA
Date: Mon, 7 Jul 2014 17:46:24 +0000
Message-ID: <3FC4AB8B47ECD546BCD4B361A64BEACD8C6C0F7B@avmb3.qlogic.org>
References: <20140704182756.GA9319@himangi-Dell>
 <94D0CD8314A33A4D9D801C0FE68B402958B866EB@G9W0745.americas.hpqcorp.net>
 <alpine.DEB.2.02.1407042235390.1984@localhost6.localdomain6>
 <53BACB4A.7080706@cs.wisc.edu>
In-Reply-To: <53BACB4A.7080706@cs.wisc.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7F96774D0898E046A6B3971B49E12BA0@qlogic.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7492 signatures=670477
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1407070204
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/07/14 10:01 pm, "Mike Christie" <michaelc@cs.wisc.edu> wrote:

>On 07/04/2014 03:37 PM, Julia Lawall wrote:
>> 
>> 
>> On Fri, 4 Jul 2014, Elliott, Robert (Server Storage) wrote:
>> 
>>>
>>>
>>>> -----Original Message-----
>>>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>>>> owner@vger.kernel.org] On Behalf Of Himangi Saraogi
>>>> Sent: Friday, 04 July, 2014 1:28 PM
>>>> To: Vikas Chaudhary; iscsi-driver@qlogic.com; James E.J. Bottomley;
>>>>linux-
>>>> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
>>>> Cc: julia.lawall@lip6.fr
>>>> Subject: [PATCH] qla4xxx: Return -ENOMEM on memory allocation failure
>>>>
>>>> In this code, 0 is returned on memory allocation failure, even though
>>>> other failures return -ENOMEM or other similar values.
>>>>
>>>> A simplified version of the Coccinelle semantic match that finds this
>>>> problem is as follows:
>>>>
>>>> // <smpl>
>>>> @@
>>>> expression ret;
>>>> expression x,e1,e2,e3;
>>>> identifier alloc;
>>>> @@
>>>>
>>>> ret = 0
>>>> ... when != ret = e1
>>>> *x = alloc(...)
>>>> ... when != ret = e2
>>>> if (x == NULL) { ... when != ret = e3
>>>>   return ret;
>>>> }
>>>> // </smpl>
>>>>
>>>> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
>>>> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
>>>> ---
>>>>  drivers/scsi/qla4xxx/ql4_os.c | 1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/scsi/qla4xxx/ql4_os.c
>>>>b/drivers/scsi/qla4xxx/ql4_os.c
>>>> index c5d9564..72ba671 100644
>>>> --- a/drivers/scsi/qla4xxx/ql4_os.c
>>>> +++ b/drivers/scsi/qla4xxx/ql4_os.c
>>>> @@ -1050,6 +1050,7 @@ static int qla4xxx_get_host_stats(struct
>>>>Scsi_Host
>>>> *shost, char *buf, int len)
>>>>  	if (!ql_iscsi_stats) {
>>>>  		ql4_printk(KERN_ERR, ha,
>>>>  			   "Unable to allocate memory for iscsi stats\n");
>>>> +		ret = -ENOMEM;
>>>>  		goto exit_host_stats;
>>>>  	}
>>>>
>>>
>>> Also, the only caller of this function doesn't use the return
>>> value - it's overwritten by another function call:
>>>
>>> drivers/scsi/scsi_transport_iscsi.c:
>>>                 err = transport->get_host_stats(shost, buf,
>>>host_stats_size);
>>>
>>>                 actual_size = nlmsg_total_size(sizeof(*ev) +
>>>host_stats_size);
>>>                 skb_trim(skbhost_stats, NLMSG_ALIGN(actual_size));
>>>                 nlhhost_stats->nlmsg_len = actual_size;
>>>
>>>                 err = iscsi_multicast_skb(skbhost_stats,
>>>ISCSI_NL_GRP_ISCSID,
>>>                                           GFP_KERNEL);
>> 
>> Maybe that is intentional?
>
>I think it was a mistake. There is also one more issue in
>qla4xxx_get_host_stats where it is returning an internal qlogic
>specific error value. This patch should fix all issues.
>
>
>[PATCH] qla4xxx/iscsi: fix get_host_stats error propagation
>
>This patch fixes 2 bugs.
>
>1. qla4xxx was not always returning -EXYZ error codes when
>qla4xxx_get_host_stats failed.
>
>2. iscsi_get_host_stats was dropping the error code returned
>by drivers like qla4xxx.
>
>Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
>
>diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
>index 459b9f7..e4dc3e0 100644
>--- a/drivers/scsi/qla4xxx/ql4_os.c
>+++ b/drivers/scsi/qla4xxx/ql4_os.c
>@@ -1050,6 +1050,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host
>*shost, char *buf, int len)
> 	if (!ql_iscsi_stats) {
> 		ql4_printk(KERN_ERR, ha,
> 			   "Unable to allocate memory for iscsi stats\n");
>+		ret = -ENOMEM;
> 		goto exit_host_stats;
> 	}
> 
>@@ -1058,6 +1059,7 @@ static int qla4xxx_get_host_stats(struct Scsi_Host
>*shost, char *buf, int len)
> 	if (ret != QLA_SUCCESS) {
> 		ql4_printk(KERN_ERR, ha,
> 			   "Unable to retrieve iscsi stats\n");
>+		ret = -EIO;
> 		goto exit_host_stats;
> 	}
> 	host_stats->mactx_frames = le64_to_cpu(ql_iscsi_stats->mac_tx_frames);
>diff --git a/drivers/scsi/scsi_transport_iscsi.c
>b/drivers/scsi/scsi_transport_iscsi.c
>index 0102a2d..ea2996a 100644
>--- a/drivers/scsi/scsi_transport_iscsi.c
>+++ b/drivers/scsi/scsi_transport_iscsi.c
>@@ -3467,6 +3467,10 @@ iscsi_get_host_stats(struct iscsi_transport
>*transport, struct nlmsghdr *nlh)
> 		memset(buf, 0, host_stats_size);
> 
> 		err = transport->get_host_stats(shost, buf, host_stats_size);
>+		if (err) {
>+			kfree(skbhost_stats);
>+			goto exit_host_stats;
>+		}
> 
> 		actual_size = nlmsg_total_size(sizeof(*ev) + host_stats_size);
> 		skb_trim(skbhost_stats, NLMSG_ALIGN(actual_size));


Acked-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

