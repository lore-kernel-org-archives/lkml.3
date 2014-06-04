Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303AbaFDRCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 13:02:19 -0400
Received: from mx2.parallels.com ([199.115.105.18]:48543 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbaFDRCQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 13:02:16 -0400
From: James Bottomley <jbottomley@parallels.com>
To: "kys@microsoft.com" <kys@microsoft.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "apw@canonical.com" <apw@canonical.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "ohering@suse.com" <ohering@suse.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT from
 the basic I/O timeout
Thread-Topic: [PATCH 1/1] [SCSI] Fix a bug in deriving the FLUSH_TIMEOUT
 from the basic I/O timeout
Thread-Index: AQHPgAuS4RnOBmJ/q0aQf1y8l+Zt2ZthoquA
Date: Wed, 4 Jun 2014 17:02:03 +0000
Message-ID: <1401901323.17510.23.camel@dabdike>
References: <1401899623-24194-1-git-send-email-kys@microsoft.com>
In-Reply-To: <1401899623-24194-1-git-send-email-kys@microsoft.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [50.46.103.107]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <ED224F46310D33429CDF39B8786CD8CF@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-04 at 09:33 -0700, K. Y. Srinivasan wrote:
> Commit ID: 7e660100d85af860e7ad763202fff717adcdaacd added code to derive the
> FLUSH_TIMEOUT from the basic I/O timeout. However, this patch did not use the
> basic I/O timeout of the device. Fix this bug.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/scsi/sd.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index e9689d5..54150b1 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -832,7 +832,9 @@ static int sd_setup_write_same_cmnd(struct scsi_device *sdp, struct request *rq)
>  
>  static int scsi_setup_flush_cmnd(struct scsi_device *sdp, struct request *rq)
>  {
> -	rq->timeout *= SD_FLUSH_TIMEOUT_MULTIPLIER;
> +	int timeout = sdp->request_queue->rq_timeout;
> +
> +	rq->timeout = (timeout * SD_FLUSH_TIMEOUT_MULTIPLIER);

Could you share where you found this to be a problem?  It looks like a
bug in block because all inbound requests being prepared should have a
timeout set, so block would be the place to fix it.

I can't see how this can happen because we definitely add the timer
after the request is prepared in my reading of the block code, unless
I'm missing some path in block that violates this.

James

