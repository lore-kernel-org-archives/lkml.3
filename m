Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaIJPpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 11:45:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54901 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaIJPpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 11:45:36 -0400
Date: Wed, 10 Sep 2014 08:45:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: linux-usb <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION 3.17] scsi (uas) disks no longer using tagged
 command queuing
Message-ID: <20140910154535.GA5102@infradead.org>
References: <540EC52C.3000804@redhat.com>
 <20140909152730.GA17882@infradead.org>
 <540FFBF4.9090001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540FFBF4.9090001@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 09:21:24AM +0200, Hans de Goede wrote:
> I've applied the patch, this results in the following new dmesg output
> when using uas:
> 
> [  120.602632] initialized host-wide tag map!
> 
> Thank you for looking into this.

So we're initializing the tag map, but scsi_activate_tcq doesn't pick it
up.  I can't really come up with a good explanation for it, but there
even without that there is an elephant in the room:  as part of the
scsi-mq series I moved the bqt field used for this into a union with the
new blk_mq_tag_set.  Below is a patch to get rid of that union, can you
try if that fixes it?


diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index d0f69a3..bcffff2 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -584,10 +584,8 @@ struct Scsi_Host {
 	 * Area to keep a shared tag map (if needed, will be
 	 * NULL if not).
 	 */
-	union {
-		struct blk_queue_tag	*bqt;
-		struct blk_mq_tag_set	tag_set;
-	};
+	struct blk_queue_tag	*bqt;
+	struct blk_mq_tag_set	tag_set;
 
 	atomic_t host_busy;		   /* commands actually active on low-level */
 	atomic_t host_blocked;
