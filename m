Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597AbaLKByX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:54:23 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:50033 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933565AbaLKByT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:54:19 -0500
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "jejb@kernel.org" <jejb@kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "JBottomley@Parallels.com" <JBottomley@Parallels.com>,
        "Sathya.Prakash@avagotech.com" <Sathya.Prakash@avagotech.com>,
        "Nagalakshmi.Nandigama@avagotech.com" 
	<Nagalakshmi.Nandigama@avagotech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 09/22] [SCSI] mpt2sas, mpt3sas: Added a support to set
 cpu affinity for each MSIX vector enabled by the HBA
Thread-Topic: [PATCH 09/22] [SCSI] mpt2sas, mpt3sas: Added a support to set
 cpu affinity for each MSIX vector enabled by the HBA
Thread-Index: AQHQE6oQmXPP1IV5ykebP2va30Knq5yJoRyQ
Date: Thu, 11 Dec 2014 01:53:02 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402959408BB5@G4W3202.americas.hpqcorp.net>
References: <1418127401-10090-1-git-send-email-Sreekanth.Reddy@avagotech.com>
In-Reply-To: <1418127401-10090-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Sreekanth Reddy
> Sent: Tuesday, 09 December, 2014 6:17 AM
> To: martin.petersen@oracle.com; jejb@kernel.org; hch@infradead.org
...
> Change_set:
> 1. Added affinity_hint varable of type cpumask_var_t in adapter_reply_queue
>    structure. And allocated a memory for this varable by calling
> zalloc_cpumask_var.
> 2. Call the API irq_set_affinity_hint for each MSIx vector to affiniate it
>    with calculated cpus at driver inilization time.
> 3. While freeing the MSIX vector, call this same API to release the cpu
> affinity mask
>    for each MSIx vector by providing the NULL value in cpumask argument.
> 4. then call the free_cpumask_var API to free the memory allocated in step 2.
> 
...

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c
> b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 1560115..f0f8ba0 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
...
> @@ -1609,6 +1611,10 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8
> index, u32 vector)
>  	reply_q->ioc = ioc;
>  	reply_q->msix_index = index;
>  	reply_q->vector = vector;
> +
> +	if (!zalloc_cpumask_var(&reply_q->affinity_hint, GFP_KERNEL))
> +		return -ENOMEM;

I think this will create the problem Alex Thorlton just reported
with lpfc on a system with a huge number (6144) of CPUs.

See this thread:
	[BUG] kzalloc overflow in lpfc driver on 6k core system

---
Rob Elliott    HP Server Storage



