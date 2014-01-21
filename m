Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbaAUWqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 17:46:10 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:55629 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbaAUWqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 17:46:08 -0500
Message-ID: <1390344494.5567.792.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH-v2 03/17] target/sbc: Add DIF setup in sbc_check_prot +
 sbc_parse_cdb
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>,
        Roland Dreier <roland@kernel.org>
Date: Tue, 21 Jan 2014 14:48:14 -0800
In-Reply-To: <52DBBA69.4040800@dev.mellanox.co.il>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com>
	 <1390099480-29013-4-git-send-email-nab@daterainc.com>
	 <52DBBA69.4040800@dev.mellanox.co.il>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-01-19 at 13:43 +0200, Sagi Grimberg wrote:
> On 1/19/2014 4:44 AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> >
> > This patch adds sbc_check_prot() for performing various DIF
> > related CDB sanity checks, along with setting cmd->prot_type
> > once sanity checks have passed.
> >
> > Also, add calls in sbc_parse_cdb() for READ_[10,12,16] +
> > WRITE_[10,12,16] to perform DIF sanity checking.
> >
> > v2 changes:
> >    - Make sbc_check_prot defined as static (Fengguang + Wei)
> >    - Remove unprotected READ/WRITE warning (mkp)
> >    - Populate cmd->prot_type + friends (Sagi)
> >    - Drop SCF_PROT usage
> >
> > Cc: Martin K. Petersen <martin.petersen@oracle.com>
> > Cc: Christoph Hellwig <hch@lst.de>
> > Cc: Hannes Reinecke <hare@suse.de>
> > Cc: Sagi Grimberg <sagig@mellanox.com>
> > Cc: Or Gerlitz <ogerlitz@mellanox.com>
> > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > ---
> >   drivers/target/target_core_sbc.c |   62 ++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 62 insertions(+)
> >
> > diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> > index 6863dbe..91a92f3 100644
> > --- a/drivers/target/target_core_sbc.c
> > +++ b/drivers/target/target_core_sbc.c
> > @@ -563,6 +563,44 @@ sbc_compare_and_write(struct se_cmd *cmd)
> >   	return TCM_NO_SENSE;
> >   }
> >   
> > +static bool
> > +sbc_check_prot(struct se_device *dev, struct se_cmd *cmd, unsigned char *cdb,
> > +	       u32 sectors)
> > +{
> > +	if (!cmd->t_prot_sg || !cmd->t_prot_nents)
> > +		return true;
> > +
> > +	switch (dev->dev_attrib.pi_prot_type) {
> > +	case TARGET_DIF_TYPE3_PROT:
> > +		if (!(cdb[1] & 0xe0))
> > +			return true;
> > +
> > +		cmd->reftag_seed = 0xffffffff;
> > +		break;
> > +	case TARGET_DIF_TYPE2_PROT:
> > +		if (cdb[1] & 0xe0)
> > +			return false;
> > +
> > +		cmd->reftag_seed = cmd->t_task_lba;
> > +		break;
> > +	case TARGET_DIF_TYPE1_PROT:
> > +		if (!(cdb[1] & 0xe0))
> > +			return true;
> > +
> > +		cmd->reftag_seed = cmd->t_task_lba;
> > +		break;
> > +	case TARGET_DIF_TYPE0_PROT:
> > +	default:
> > +		return true;
> > +	}
> > +
> > +	cmd->prot_type = dev->dev_attrib.pi_prot_type;
> > +	cmd->prot_length = dev->prot_length * sectors;
> > +	cmd->prot_handover = PROT_SEPERATED;
> 
> I know that we are not planning to support interleaved mode at the 
> moment, But I think
> that the protection handover type is the backstore preference and should 
> be taken from se_dev.
> But it is not that important for now...
> 

Yeah, I figured since the RDMA pieces needed the handover type defined
in some form, it made sense to include PROT_SEPERATED hardcoded here,
but stopped short of adding se_dev->prot_handler for the first round
merge.

--nab

