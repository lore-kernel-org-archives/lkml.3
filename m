Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab3IMPmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:42:44 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:59094 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756618Ab3IMPml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:42:41 -0400
X-Nat-Received: from [202.181.97.72]:55883 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1379086952.2164
To: khalid.aziz@oracle.com
Cc: jbottomley@parallels.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] SCSI: buslogic: Added check for DMA mapping errors (was Re:[BusLogic] DMA-API: device driver failed to check map error)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201309101503.ECC18788.SOOVOJLFtQHMFF@I-love.SAKURA.ne.jp>
	<1378816604.6973.53.camel@dabdike.int.hansenpartnership.com>
	<1379004807.10738.3.camel@concerto>
In-Reply-To: <1379004807.10738.3.camel@concerto>
Message-Id: <201309140042.GEI73439.QHSJtOFFVFOLOM@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 14 Sep 2013 00:42:19 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 13092013 #11048058, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Khalid Aziz wrote:
> Added check for DMA mapping errors for request sense data
> buffer. Checking for mapping error can avoid potential wild
> writes. This patch was prompted by the warning from
> dma_unmap when kernel is compiled with CONFIG_DMA_API_DEBUG.

This patch fixes CONFIG_DMA_API_DEBUG warning.
But excuse me, is this error path correct?

> @@ -309,16 +309,17 @@ static struct blogic_ccb *blogic_alloc_ccb(struct blogic_adapter *adapter)
>    blogic_dealloc_ccb deallocates a CCB, returning it to the Host Adapter's
>    free list.  The Host Adapter's Lock should already have been acquired by the
>    caller.
>  */
> 
> -static void blogic_dealloc_ccb(struct blogic_ccb *ccb)
> +static void blogic_dealloc_ccb(struct blogic_ccb *ccb, int dma_unmap)
>  {
>         struct blogic_adapter *adapter = ccb->adapter;
> 
>         scsi_dma_unmap(ccb->command);

blogic_dealloc_ccb() uses "ccb->command". But

> -       pci_unmap_single(adapter->pci_device, ccb->sensedata,
> +       if (dma_unmap)
> +               pci_unmap_single(adapter->pci_device, ccb->sensedata,
>                          ccb->sense_datalen, PCI_DMA_FROMDEVICE);
> 
>         ccb->command = NULL;
>         ccb->status = BLOGIC_CCB_FREE;
>         ccb->next = adapter->free_ccbs;
> @@ -3177,13 +3179,21 @@ static int blogic_qcmd_lck(struct scsi_cmnd *command,
>                         ccb->legacy_tag = queuetag;
>                 }
>         }
>         memcpy(ccb->cdb, cdb, cdblen);
>         ccb->sense_datalen = SCSI_SENSE_BUFFERSIZE;
> -       ccb->sensedata = pci_map_single(adapter->pci_device,
> +       sense_buf = pci_map_single(adapter->pci_device,
>                                 command->sense_buffer, ccb->sense_datalen,
>                                 PCI_DMA_FROMDEVICE);
> +       if (dma_mapping_error(&adapter->pci_device->dev, sense_buf)) {
> +               blogic_err("DMA mapping for sense data buffer failed\n",
> +                               adapter);
> +               scsi_dma_map(command);
> +               blogic_dealloc_ccb(ccb, 0);

when was "ccb->command = command;" called before calling blogic_dealloc_ccb()?

> +               return SCSI_MLQUEUE_HOST_BUSY;
> +       }
> +       ccb->sensedata = sense_buf;
>         ccb->command = command;
>         command->scsi_done = comp_cb;
>         if (blogic_multimaster_type(adapter)) {
>                 /*
>                    Place the CCB in an Outgoing Mailbox. The higher levels

Also, what happens if "scsi_dma_map(command);" returned -ENOMEM ?
If you are calling scsi_dma_map() because blogic_dealloc_ccb() calls
scsi_dma_unmap(), why can't we do like

  {
          struct blogic_adapter *adapter = ccb->adapter;
          ccb->command = NULL;
          ccb->status = BLOGIC_CCB_FREE;
          ccb->next = adapter->free_ccbs;
          adapter->free_ccbs = ccb;
  }

instead of

  scsi_dma_map(command);
  blogic_dealloc_ccb(ccb);

?
