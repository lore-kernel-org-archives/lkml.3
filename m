Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab3G2H2t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 03:28:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52867 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab3G2H2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 03:28:46 -0400
Message-ID: <51F619AA.1020704@suse.de>
Date: Mon, 29 Jul 2013 09:28:42 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Alexander Gordeev <agordeev@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michaelc@cs.wisc.edu>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH RESEND 0/1] AHCI: Optimize interrupt processing
References: <20130719003034.GG28005@kernel.dk> <1374195825.7397.997.camel@haakon3.risingtidesystems.com> <1374215660.7397.1041.camel@haakon3.risingtidesystems.com> <1374248000.2266.20.camel@dabdike> <1374267684.7397.1058.camel@haakon3.risingtidesystems.com> <1374296162.7397.1098.camel@haakon3.risingtidesystems.com> <20130722150359.GA16564@dhcp-26-207.brq.redhat.com> <1374527436.7397.1145.camel@haakon3.risingtidesystems.com> <20130725101641.GB31994@dhcp-26-207.brq.redhat.com> <1374790082.7397.1411.camel@haakon3.risingtidesystems.com> <20130726020928.GL29296@kernel.dk>
In-Reply-To: <20130726020928.GL29296@kernel.dk>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2013 04:09 AM, Jens Axboe wrote:
> On Thu, Jul 25 2013, Nicholas A. Bellinger wrote:
>> On Thu, 2013-07-25 at 12:16 +0200, Alexander Gordeev wrote:
>>> On Mon, Jul 22, 2013 at 02:10:36PM -0700, Nicholas A. Bellinger wrote:
>>>> Np.  FYI, you'll want to use the latest commit e7827b351 HEAD from
>>>> target-pending/scsi-mq, which now has functioning scsi-generic support.
>>>
>>> Survives a boot, a kernel build and the build's result :)
>>
>> Great.  Thanks for the feedback Alexander!
>>
>> So the next step on my end is to enable -mq for ahci, and verify initial
>> correctness using QEMU/KVM hardware emulation.
>>
>> Btw, I've been looking at enabling the SHT->cmd_size for struct
>> ata_queued_cmd descriptor pre-allocation, but AFAICT these descriptors
>> are already all pre-allocated by libata and obtained via ata_qc_new() ->
>> __ata_qc_from_tag() during ata_scsi_queuecmd().
> 
> Might still not be a bad idea to do it:
> 
> - Cleans up a driver, getting rid of the need to alloc, maintain, and
>   free those structures.
> 
> - Should be some cache locality benefits to having it all sequential.
> 
>> So that said, with the struct request + struct scsi_cmnd pre-allocations
>> already provided by blk-mq -> scsi-mq code, all memory allocations
>> should have already been eliminated from I/O fast path.
> 
> Nice!
> 
Hmm.

I'm trying to work out if it would be possible to move multipath
handling over to scsi-mq.
However, when doing so I would need to reconfigure 'nr_hw_queues' on
the fly. Now with all the static cmd preallocation going on this is
going to be tricky.

This leaves me with two choices:
- Tear down the command pool altogether whenever I need to
  reconfigure the device (which is going to be painful)
- Allocate some max nr_hw_queues, and mark the superfluous
  ones as 'unused' or something. Seeing the a sane max nr_hw_queues
  will be possibly the number of cpus this might end up hogging
  quite some memory.

Would you accept patches moving the static command allocation over
to pools or is this a desired feature?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
