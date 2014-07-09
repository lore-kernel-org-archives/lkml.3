Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaGIGk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:40:27 -0400
Received: from verein.lst.de ([213.95.11.211]:52696 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbaGIGk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:40:26 -0400
Date: Wed, 9 Jul 2014 08:40:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        Bart Van Assche <bvanassche@fusionio.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/14] scsi: centralize command re-queueing in
	scsi_dispatch_fn
Message-ID: <20140709064022.GA29443@lst.de>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <1403715121-1201-4-git-send-email-hch@lst.de> <94D0CD8314A33A4D9D801C0FE68B402958B922D2@G9W0745.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958B922D2@G9W0745.americas.hpqcorp.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 08:51:30PM +0000, Elliott, Robert (Server Storage) wrote:
> In scsi_lib.c, both scsi_done() and scsi_mq_done() always call
> trace_scsi_dispatch_cmd_done(), so trace_scsi_dispatch_cmd_start()
> should be called before scsi_done() is called.  That way the
> trace will always have a submission to match each completion.
> 
> That means trace should be called before the sdev_state check 
> (which calls scsi_done()).  
>
> I don't know about the scsi_device_blocked check (which just 
> returns).  Should the trace record multiple submissions with 
> one completion?  Maybe both trace_scsi_dispatch_cmd_start() 
> and trace_scsi_dispatch_cmd_done() should both be called?

trace_scsi_dispatch_cmd_start is maybe a little misnamed as it traces
the command submission to the driver.  So getting a done trace without
this one sounds perfectly fine.  Adding another trace for an error
before submission could be done if you care about pairing.  The *_BUSY
returns don't fit this scheme at all.

But none of this really is in this patch.  Hannes has some plans to clean
up the logging and tracing mess in scsi, and it might be a good idea
to incorporate it there.

