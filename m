Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3GXTnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:43:22 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36758 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752364Ab3GXTnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:43:20 -0400
Message-ID: <1374694998.7382.33.camel@dabdike>
Subject: Re: scsi scan: INQUIRY result too short (5), using 36
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 24 Jul 2013 12:43:18 -0700
In-Reply-To: <CA+8MBb+pSmRPqV-5xsEwBM_23sGaci5T6vka1LgTD5aiEoHCbg@mail.gmail.com>
References: <CA+8MBb+pSmRPqV-5xsEwBM_23sGaci5T6vka1LgTD5aiEoHCbg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-24 at 11:53 -0700, Tony Luck wrote:
> v3.10 used to boot on this machine, linus latest doesn't.  git bisect
> points to this commit.
> 
> commit e73823f7a2c921dcf068d34ea03bd682498d9e42
> Author: James Bottomley <JBottomley@Parallels.com>
> Date:   Tue May 7 15:38:18 2013 -0700
> 
>     [SCSI] libsas: implement > 16 byte CDB support
> 
> See attached console log for all the gory details.
> 
> Let me know if you need any other information about
> this machine or its config that isn't easily deducible
> from the console log.

Oops, apparently no-one I cc'd at intel actually bothered to check the
patch for the isci driver.  The looks to be that sci_swab32_cpy needs
multiples of four, so for commands that aren't that, it's rounding the
wrong way.  Does this fix it?

James

---

diff --git a/drivers/scsi/isci/request.c b/drivers/scsi/isci/request.c
index 7b08215..99d2930 100644
--- a/drivers/scsi/isci/request.c
+++ b/drivers/scsi/isci/request.c
@@ -185,7 +185,7 @@ static void sci_io_request_build_ssp_command_iu(struct isci_request *ireq)
 	cmd_iu->_r_c = 0;
 
 	sci_swab32_cpy(&cmd_iu->cdb, task->ssp_task.cmd->cmnd,
-		       task->ssp_task.cmd->cmd_len / sizeof(u32));
+		       (task->ssp_task.cmd->cmd_len+3) / sizeof(u32));
 }
 
 static void sci_task_request_build_ssp_task_iu(struct isci_request *ireq)


