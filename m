Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116AbaGKJw7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 05:52:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbaGKJw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 05:52:57 -0400
Message-ID: <53BFB3F7.7010304@suse.de>
Date: Fri, 11 Jul 2014 11:52:55 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>, Christoph Hellwig <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "apw@canonical.com" <apw@canonical.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
References: <1404866789-26910-1-git-send-email-kys@microsoft.com> <1404866812-26950-1-git-send-email-kys@microsoft.com> <1404866812-26950-6-git-send-email-kys@microsoft.com> <20140709084415.GF6012@infradead.org> <9b76360fb30745d3941b6d56bdae268f@BY2PR03MB299.namprd03.prod.outlook.com> <20140710101320.GB1151@infradead.org> <f662b500fada4fbca75c55089d3f8ee4@BY2PR03MB299.namprd03.prod.outlook.com>
In-Reply-To: <f662b500fada4fbca75c55089d3f8ee4@BY2PR03MB299.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 12:26 AM, KY Srinivasan wrote:
>
>
>> -----Original Message-----
>> From: Christoph Hellwig [mailto:hch@infradead.org]
>> Sent: Thursday, July 10, 2014 3:13 AM
>> To: KY Srinivasan
>> Cc: Christoph Hellwig; linux-kernel@vger.kernel.org;
>> devel@linuxdriverproject.org; ohering@suse.com;
>> jbottomley@parallels.com; jasowang@redhat.com; apw@canonical.com;
>> linux-scsi@vger.kernel.org
>> Subject: Re: [PATCH 6/8] Drivers: scsi: storvsc: Implement an abort handler
>>
>>
>> Note that you could increase the timeout and/or implement an
>> eh_timed_out handler that just returns BLK_EH_RESET_TIMER, but if the
>> completion takes too long the expectation is that a command will eventually
>> finish instead of beeing delayed by an unmound amount.
>
> I like this idea; I will implement a eh_timed_out_handler.
>
Something like this should be sufficient:

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index e71a0d7..630ae81 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1468,6 +1468,12 @@ static int storvsc_get_chs(struct scsi_device 
*sdev, stru
ct block_device * bdev,
         return 0;
  }

+static enum blk_eh_timer_return
+storvsc_timed_out_handler(struct scsi_cmnd *scmd)
+{
+       return BLK_EH_RESET_TIMER;
+}
+
  static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
  {
         struct hv_host_device *host_dev = 
shost_priv(scmnd->device->host);
@@ -1687,6 +1693,7 @@ static struct scsi_host_template scsi_driver = {
         .name =                 "storvsc_host_t",
         .bios_param =           storvsc_get_chs,
         .queuecommand =         storvsc_queuecommand,
+       .eh_timed_out =         storvsc_timed_out_handler,
         .eh_host_reset_handler =        storvsc_host_reset_handler,
         .slave_alloc =          storvsc_device_alloc,
         .slave_destroy =        storvsc_device_destroy,

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
