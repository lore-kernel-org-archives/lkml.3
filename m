Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab3HUHTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:19:19 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:49692 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341Ab3HUHTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:19:17 -0400
Message-ID: <1377069964.32763.21.camel@haakon3.risingtidesystems.com>
Subject: Re: [PATCH 6/9] target: Allow sbc_ops->execute_rw() to accept SGLs
 + data_direction
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>,
        target-devel <target-devel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Martin Petersen <martin.petersen@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>,
        James Bottomley <JBottomley@Parallels.com>
Date: Wed, 21 Aug 2013 00:26:04 -0700
In-Reply-To: <20130821063524.GH25506@infradead.org>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
	 <1377029280-19144-7-git-send-email-nab@daterainc.com>
	 <20130821063524.GH25506@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 23:35 -0700, Christoph Hellwig wrote:
> On Tue, Aug 20, 2013 at 08:07:57PM +0000, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@daterainc.com>
> > 
> > COMPARE_AND_WRITE expects to be able to send down a DMA_FROM_DEVICE
> > to obtain the necessary READ payload for comparision against the
> > first half of the WRITE payload containing the verify user data.
> > 
> > Currently virtual backends expect to internally reference SGLs,
> > SGL nents, and data_direction, so change IBLOCK, FILEIO and RD
> > sbc_ops->execute_rw() to accept this values as function parameters.
> > 
> > Also add the sbc_execute_rw() wrapper to handle the special case
> > for the initial COMPARE_AND_WRITE DMA_FROM_DEVICE -> READ I/O
> > submission.
> 
> I don't like the way this is structured with the new method.  It seems
> like we should just pass the sgl and associated data to execute_cmd
> and have the read vs write logic driven by command code, using generic
> flags instead of specificly checking for compare and write.

I considered that approach as well, but in the end all of the non
sbc_ops->execute_rw() users of se_cmd->execute_cmd() will never make use
of a passed *sgl, sgl_nents, or data_direction that is different than
se_cmd assignments.

So in the end, the approach of changing all se_cmd->execute_cmd() users
to accommodate COMPARE_AND_WRITE did not end up making sense outside of
this particular special case..

--nab

