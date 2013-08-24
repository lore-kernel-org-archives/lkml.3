Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab3HXPSY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 11:18:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56015 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab3HXPSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 11:18:22 -0400
Date: Sat, 24 Aug 2013 08:18:17 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Martin Petersen <martin.petersen@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Roland Dreier <roland@purestorage.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 06/12] target: Add memory allocation for bidirectional
 commands
Message-ID: <20130824151817.GA15588@infradead.org>
References: <1377147250-10125-1-git-send-email-nab@daterainc.com>
 <1377147250-10125-7-git-send-email-nab@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377147250-10125-7-git-send-email-nab@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static int
> +transport_generic_get_mem_bidi(struct se_cmd *cmd)

Except for the fields touched in struct se_cmd this is a duplication
of transport_generic_get_mem.  I'd suggest to factor that one into
a new helper:

static int
target_alloc_sgl(struct scatterlist **sgl, unsigned int **nents,
		u32 length, gfp_t gfp_mask)
{
	..
}

and then call that one from transport_generic_new_cmd directly,
including opencoding the actual BIDI case there as a first step.

If we go down your proposed route for COMPARE and WRITE we'd also
allocate that buffer there, although I think there is a more elegant
way to do that, but more on that later.

