Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309AbaFHDLS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 23:11:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45666 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbaFHDLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 23:11:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAOHikRCYF3ManA-YqCddXdRyD=pqwO_=oSnw2qZtGEnd+wvjaw@mail.gmail.com>
References: <CACVXFVMnM6w5ZLX=S8fJHeVoEqxH2JG3Wg=GPMeoVnOpAjsvAA@mail.gmail.com>
	<CAPcyv4icNZU9s7zLYYcrFrNA_9qk4W1je42KKG+ETWqdoQu_kg@mail.gmail.com>
	<CACVXFVPHfP1VXujLx9sGt3c7ptdG1JvBQkw2JiJQsU1KwJ1zog@mail.gmail.com>
	<20140605134120.GA21607@htj.dyndns.org>
	<CACVXFVNUp3jfb1TVo7H7TNm4r2RaqDU0GDaMRq-DtB8ZEXaC+Q@mail.gmail.com>
	<1402023429.30026.4.camel@dwillia2-mobl2.amr.corp.intel.com>
	<CACVXFVPmc=1-oWL=bq9GH5BnJf4VBWoZEXkkLWBP_N3HbJrZkQ@mail.gmail.com>
	<CAOHikRCYF3ManA-YqCddXdRyD=pqwO_=oSnw2qZtGEnd+wvjaw@mail.gmail.com>
Date: Sun, 8 Jun 2014 11:11:14 +0800
Message-ID: <CACVXFVPnpwTLw2dBgJsCQNWGYJmjb4oe2=FnyK2cixGiXxJePw@mail.gmail.com>
Subject: Re: [Regression] commit 8a4aeec8d(libata/ahci: accommodate tag
 ordered controllers)
From: Ming Lei <ming.lei@canonical.com>
To: Suman Tripathi <stripathi@apm.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Loc Ho <lho@apm.com>, Tuan Phan <tphan@apm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Suman,

Could you forward the patches to me so that I can give a test?

I don't subscribe to linux-ide list.

Thanks,
--
Ming Lei

On Sat, Jun 7, 2014 at 5:33 AM, Suman Tripathi <stripathi@apm.com> wrote:
> Hi ,
>
> I have  just posted 3 patches "ata: Fix the dma state machine lockup for APM
> X-Gene SoC SATA controller" . This patch set has fixed this tag ordering
> issue.
> Tested in apm  mustang board.
>
> Thanks,
> with regards,
> suman
>
>
> On Fri, Jun 6, 2014 at 11:41 AM, Ming Lei <ming.lei@canonical.com> wrote:
>>
>> On Fri, Jun 6, 2014 at 10:57 AM, Dan Williams <dan.j.williams@intel.com>
>> wrote:
>> > On Fri, 2014-06-06 at 09:47 +0800, Ming Lei wrote:
>> >> Hi Tejun,
>> >>
>> >> On Thu, Jun 5, 2014 at 9:41 PM, Tejun Heo <tj@kernel.org> wrote:
>> >> > Hello,
>> >> >
>> >> > (cc'ing ahci_xgene folks)
>> >> >
>> >> > On Thu, Jun 05, 2014 at 09:24:04PM +0800, Ming Lei wrote:
>> >> >> On Thu, Jun 5, 2014 at 9:12 PM, Dan Williams
>> >> >> <dan.j.williams@intel.com> wrote:
>> >> >> > On Thu, Jun 5, 2014 at 1:53 AM, Ming Lei <ming.lei@canonical.com>
>> >> >> > wrote:
>> >> >> >> Hi Dan and Tejun,
>> >> >> >>
>> >> >> >> Looks the commit 8a4aeec8d(libata/ahci: accommodate tag ordered
>> >> >> >> controllers) causes below sata failure[1] on APM AHCI controller.
>> >> >> >>
>> >> >> >> And the error does disappear after reverting the commit.
>> >> >> >
>> >> >> > Can you give some more details about the workload and the disk?
>> >> >> > What
>> >> >> > is the APM AHCI?
>> >> >>
>> >> >> The commit causes the APM arm64 based system not bootable, and not
>> >> >> special workload, just when mounting rootfs or reading init files.
>> >> >>
>> >> >> APM AHCI:
>> >> >>       drivers/ata/ahci_xgene.c
>> >> >
>> >> > Urgh... so, the controller can't handle tags allocated in round-robin
>> >> > instead of lowest-first?  Ming, can you please test with different
>> >> > controllers / disks / ssds and see whether the problem stays with the
>> >> > controller?  Loc, can you guys please look into it so that at least
>> >> > the next revision hardware can fix the issue?
>> >>
>> >> The problem has been observed on several apm arm64 boards
>> >> with different disks.
>> >>
>> >> >
>> >> > Provided that the tag allocation itself isn't broken, which isn't too
>> >> > likely given the lack of bug reports on other controllers, we'll need
>> >> > to blacklist ahci_xgene somehow.  Either disable NCQ support on it or
>> >> > implement an alternative lowest-first tag allocation for it.  If this
>> >> > actually is the controller freaking out about tags allocated in a
>> >> > different order, I'm not sure how much confidence we can put in its
>> >> > NCQ implementation tho and it might be a better idea to simply plug
>> >> > NCQ support on it until we understand the details of the problem.
>> >> >
>> >> > So, something like the following?  Ming, can you please verify
>> >> > whether
>> >> > the following makes the machine boot again?
>> >>
>> >> Looks the problem still persists after applying your patch of disabling
>> >> NCQ.
>> >
>> > How about the following patch?
>> >
>> > 8<---------
>> > libata: allow xgene-ahci to opt-out of tag ordered submission
>> >
>> > From: Dan Williams <dan.j.williams@intel.com>
>> >
>> > Ming Lei reports:
>> >   "Looks the commit 8a4aeec8d(libata/ahci: accommodate tag ordered
>> >    controllers) causes below sata failure[1] on APM AHCI controller.
>> >
>> >    And the error does disappear after reverting the commit.
>> >
>> >      ata4.00: exception Emask 0x40 SAct 0xff00 SErr 0x800 action 0x6
>> > frozen
>> >      ata4: SError: { HostInt }
>> >      ata4.00: failed command: READ FPDMA QUEUED
>> >      ata4.00: cmd 60/08:40:e0:a4:88/00:00:04:00:00/40 tag 8 ncq 4096 in
>> >               res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x44
>> > (timeout)"
>> >
>> > Maintain tag ordered submission as the default, but allow xgene-ahci to
>> > continue with the old behavior.
>> >
>> > Reported-by: Ming Lei <ming.lei@canonical.com>
>> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> > ---
>> >  drivers/ata/ahci_xgene.c  |    1 +
>> >  drivers/ata/libata-core.c |   42
>> > +++++++++++++++++++++++++++++++++++++++---
>> >  drivers/ata/libata.h      |    2 ++
>> >  include/linux/libata.h    |    1 +
>> >  4 files changed, 43 insertions(+), 3 deletions(-)
>> >
>> > diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
>> > index 77c89bf171f1..9be069f5f58a 100644
>> > --- a/drivers/ata/ahci_xgene.c
>> > +++ b/drivers/ata/ahci_xgene.c
>>
>> +#include "libata.h" is needed, otherwise build will fail.
>>
>> > @@ -300,6 +300,7 @@ static struct ata_port_operations xgene_ahci_ops = {
>> >         .host_stop = xgene_ahci_host_stop,
>> >         .hardreset = xgene_ahci_hardreset,
>> >         .read_id = xgene_ahci_read_id,
>> > +       .qc_new = ata_qc_new_fifo_order,
>> >  };
>> >
>> >  static const struct ata_port_info xgene_ahci_port_info = {
>> > diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> > index 943cc8b83e59..dd554354791f 100644
>> > --- a/drivers/ata/libata-core.c
>> > +++ b/drivers/ata/libata-core.c
>> > @@ -83,6 +83,7 @@ const struct ata_port_operations ata_base_port_ops = {
>> >         .error_handler          = ata_std_error_handler,
>> >         .sched_eh               = ata_std_sched_eh,
>> >         .end_eh                 = ata_std_end_eh,
>> > +       .qc_new                 = ata_qc_new_tag_order,
>> >  };
>> >
>> >  const struct ata_port_operations sata_port_ops = {
>> > @@ -4784,14 +4785,17 @@ void swap_buf_le16(u16 *buf, unsigned int
>> > buf_words)
>> >  }
>> >
>> >  /**
>> > - *     ata_qc_new - Request an available ATA command, for queueing
>> > + *     ata_qc_new_tag_order - Request an available ATA command, for
>> > queueing
>> >   *     @ap: target port
>> >   *
>> > + *     Accomodates controllers that issue commands in tag order rather
>> > + *     than FIFO order (Intel AHCI).
>> > + *
>> >   *     LOCKING:
>> >   *     None.
>> >   */
>> >
>> > -static struct ata_queued_cmd *ata_qc_new(struct ata_port *ap)
>> > +struct ata_queued_cmd *ata_qc_new_tag_order(struct ata_port *ap)
>> >  {
>> >         struct ata_queued_cmd *qc = NULL;
>> >         unsigned int i, tag;
>> > @@ -4819,6 +4823,38 @@ static struct ata_queued_cmd *ata_qc_new(struct
>> > ata_port *ap)
>> >  }
>> >
>> >  /**
>> > + *     ata_qc_new_fifo_order - Request an available ATA command, for
>> > queueing
>> > + *     @ap: target port
>> > + *
>> > + *     Allocate first available tag, for hosts that maintain fifo issue
>> > + *     order on the wire, or otherwise cannot handle tag order.
>> > + *
>> > + *     LOCKING:
>> > + *     None.
>> > + */
>> > +
>> > +struct ata_queued_cmd *ata_qc_new_fifo_order(struct ata_port *ap)
>> > +{
>> > +       struct ata_queued_cmd *qc = NULL;
>> > +       unsigned int i;
>> > +
>> > +       /* no command while frozen */
>> > +       if (unlikely(ap->pflags & ATA_PFLAG_FROZEN))
>> > +               return NULL;
>> > +
>> > +       /* the last tag is reserved for internal command. */
>> > +       for (i = 0; i < ATA_MAX_QUEUE - 1; i++)
>> > +               if (!test_and_set_bit(i, &ap->qc_allocated)) {
>> > +                       qc = __ata_qc_from_tag(ap, i);
>> > +                       qc->tag = i;
>> > +                       break;
>> > +               }
>> > +
>> > +       return qc;
>> > +}
>> > +EXPORT_SYMBOL_GPL(ata_qc_new_fifo_order);
>> > +
>> > +/**
>> >   *     ata_qc_new_init - Request an available ATA command, and
>> > initialize it
>> >   *     @dev: Device from whom we request an available command structure
>> >   *
>> > @@ -4831,7 +4867,7 @@ struct ata_queued_cmd *ata_qc_new_init(struct
>> > ata_device *dev)
>> >         struct ata_port *ap = dev->link->ap;
>> >         struct ata_queued_cmd *qc;
>> >
>> > -       qc = ata_qc_new(ap);
>> > +       qc = ap->ops->qc_new(ap);
>> >         if (qc) {
>> >                 qc->scsicmd = NULL;
>> >                 qc->ap = ap;
>> > diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
>> > index 45b5ab3a95d5..381ba41de464 100644
>> > --- a/drivers/ata/libata.h
>> > +++ b/drivers/ata/libata.h
>> > @@ -90,6 +90,8 @@ extern int ata_down_xfermask_limit(struct ata_device
>> > *dev, unsigned int sel);
>> >  extern unsigned int ata_dev_set_feature(struct ata_device *dev,
>> >                                         u8 enable, u8 feature);
>> >  extern void ata_sg_clean(struct ata_queued_cmd *qc);
>> > +extern struct ata_queued_cmd *ata_qc_new_tag_order(struct ata_port
>> > *ap);
>> > +extern struct ata_queued_cmd *ata_qc_new_fifo_order(struct ata_port
>> > *ap);
>> >  extern void ata_qc_free(struct ata_queued_cmd *qc);
>> >  extern void ata_qc_issue(struct ata_queued_cmd *qc);
>> >  extern void __ata_qc_complete(struct ata_queued_cmd *qc);
>> > diff --git a/include/linux/libata.h b/include/linux/libata.h
>> > index 5ab4e3a76721..852686837d1c 100644
>> > --- a/include/linux/libata.h
>> > +++ b/include/linux/libata.h
>> > @@ -880,6 +880,7 @@ struct ata_port_operations {
>> >         void (*qc_prep)(struct ata_queued_cmd *qc);
>> >         unsigned int (*qc_issue)(struct ata_queued_cmd *qc);
>> >         bool (*qc_fill_rtf)(struct ata_queued_cmd *qc);
>> > +       struct ata_queued_cmd *(*qc_new)(struct ata_port *ap);
>> >
>> >         /*
>> >          * Configuration and exception handling
>>
>> After applying this patch again -next tree, the apm mustang board
>> can boot again.
>>
>> Tested-by: Ming Lei <ming.lei@canonical.com>
>>
>> Thanks,
>> --
>> Ming Lei
>
>
> CONFIDENTIALITY NOTICE: This e-mail message, including any attachments,
> is for the sole use of the intended recipient(s) and contains information
> that is confidential and proprietary to Applied Micro Circuits Corporation
> or its subsidiaries.
> It is to be used solely for the purpose of furthering the parties' business
> relationship.
> All unauthorized review, use, disclosure or distribution is prohibited.
> If you are not the intended recipient, please contact the sender by reply
> e-mail
> and destroy all copies of the original message.
>
