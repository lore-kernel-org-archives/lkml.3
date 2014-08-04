Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316AbaHDLHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:07:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44386 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaHDLHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:07:48 -0400
Date: Mon, 4 Aug 2014 04:07:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, jgross@suse.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Save command pool address of Scsi_Host
Message-ID: <20140804110747.GB19109@infradead.org>
References: <1406874425-3528-1-git-send-email-jgross@suse.com>
 <20140801120301.GA27198@infradead.org>
 <1406924674.2654.19.camel@jarvis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406924674.2654.19.camel@jarvis>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 12:24:34AM +0400, James Bottomley wrote:
> Wait, that's not right at all.  There looks to be a thinko in the
> command pool handling code.  We have both a cmd_pool in the host
> structure and in the host template structure, but there's confusion
> about which one we're supposed to be using.

For anything in the I/O path: shost->cmd_pool, for finding a pool
created for a specific host template: template->cmd_pool.

> The origin of confusion seems to be the reference counting in the pool
> itself ... you want the same pool for all hosts, since they can only
> have one cmd_size, but you want it created on first host use and
> destroyed again on the last one.
> 
> If you take this patch, a host that attached, detaches and then attaches
> a host will panic because it will use a freed pool structure.

Yes, it also needs to set hostt->cmd_pool to NULL when the last
reference goes away.

