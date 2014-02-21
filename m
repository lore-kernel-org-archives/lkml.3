Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbaBUWLS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:11:18 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:43873 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802AbaBUWLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:11:11 -0500
Date: Fri, 21 Feb 2014 23:09:53 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: =?utf-8?B?6buD5riF6ZqG?= <ching2048@areca.com.tw>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        fengguang.wu@intel.com, Tomas Henzl <thenzl@redhat.com>,
        =?utf-8?B?5ZCz56Kn5ra8?= <billion.wu@areca.com.tw>
Subject: Re: [PATCH v1.3 11/11] arcmsr: Adding support Areca
 ARC1214/1224/1264/1284 SATA 6Gb raid controllers
Message-ID: <20140221220953.GA14729@electric-eye.fr.zoreil.com>
References: <CAKiknE-7TOGtN01xsXyay2gv69ruVvAEq22ozu=vTzh_R=SxuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKiknE-7TOGtN01xsXyay2gv69ruVvAEq22ozu=vTzh_R=SxuQ@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

黃清隆 <ching2048@areca.com.tw> :
[...]
> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> --- a/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-20 19:11:05.000000000 +0800
> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c  2014-02-21 01:47:26.000000000 +0800
[...]
> @@ -2894,6 +3372,89 @@ polling_hbc_ccb_retry:
>  }
> 
>  static int
> +arcmsr_hbaD_polling_ccbdone(struct AdapterControlBlock *acb,
> +                               struct CommandControlBlock *poll_ccb)
> +{
> +       bool error;
> +       uint32_t poll_ccb_done = 0, poll_count = 0, flag_ccb, ccb_cdb_phy;
> +       int rtn, doneq_index, index_stripped, outbound_write_pointer;
> +       unsigned long flags;
> +       struct ARCMSR_CDB *arcmsr_cdb;
> +       struct CommandControlBlock *pCCB;
> +       struct MessageUnit_D *pmu = acb->pmuD;
> +
> +       spin_lock_irqsave(&acb->doneq_lock, flags);
> +polling_hbaD_ccb_retry:
> +       poll_count++;
> +       while (1) {
> +               outbound_write_pointer = pmu->done_qbuffer[0].addressLow + 1;
> +               doneq_index = pmu->doneq_index;
> +               if ((outbound_write_pointer & 0xFFF) == (doneq_index & 0xFFF)) {
> +                       if (poll_ccb_done) {
> +                               rtn = SUCCESS;
> +                               break;
> +                       } else {
> +                               msleep(25);

msleep with spinlock held.

-- 
Ueimor
