Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030617Ab3HIO0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:26:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39129 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967879Ab3HIO0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:26:04 -0400
Message-ID: <5204FBA6.6040001@kernel.dk>
Date: Fri, 09 Aug 2013 08:24:38 -0600
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alexander Gordeev <agordeev@redhat.com>
CC: Tejun Heo <tj@kernel.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michaelc@cs.wisc.edu>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
References: <1374248000.2266.20.camel@dabdike> <1374267684.7397.1058.camel@haakon3.risingtidesystems.com> <1374296162.7397.1098.camel@haakon3.risingtidesystems.com> <20130722150359.GA16564@dhcp-26-207.brq.redhat.com> <1374527436.7397.1145.camel@haakon3.risingtidesystems.com> <20130725101641.GB31994@dhcp-26-207.brq.redhat.com> <1374790082.7397.1411.camel@haakon3.risingtidesystems.com> <20130726020928.GL29296@kernel.dk> <1374873276.7397.1512.camel@haakon3.risingtidesystems.com> <20130729114653.GB20951@mtj.dyndns.org> <20130809082335.GA25306@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20130809082335.GA25306@dhcp-26-207.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 02:23 AM, Alexander Gordeev wrote:
> On Mon, Jul 29, 2013 at 07:46:53AM -0400, Tejun Heo wrote:
>> One thing which would probably be worthwhile tho is getting rid of the
>> bitmap based qc tag allocator in libata.  That one is just borderline
>> stupid to keep around on any setup which is supposed to be scalable.
> 
> Hi Tejun,
> 
> How about this approach?
> 
> @@ -5639,6 +5627,12 @@ struct ata_port *ata_port_alloc(struct ata_host *host)
>  	if (!ap)
>  		return NULL;
>  
> +	ap->qc_tags = blk_mq_init_tags(ATA_MAX_QUEUE, 1, NUMA_NO_NODE);
> +	if (!ap->qc_tags) {
> +		kfree(ap);
> +		return NULL;
> +	}

This should be blk_mq_init_tags(ATA_MAX_QUEUE - 1, 1, ...) since the
total depth is normal_tags + reserved_tags. Apart from that, I think it
looks alright based on a cursory look.

-- 
Jens Axboe

