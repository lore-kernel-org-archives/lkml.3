Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932477AbaAHODr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:03:47 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60062 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307AbaAHODp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:03:45 -0500
Date: Wed, 8 Jan 2014 06:03:43 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
        Sergey Meirovich <rathamahata@gmail.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gluk <git.user@gmail.com>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Message-ID: <20140108140343.GB588@infradead.org>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz>
 <20140107155830.GA28395@infradead.org>
 <20140108011713.GA5212@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140108011713.GA5212@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 08, 2014 at 02:17:13AM +0100, Jan Kara wrote:
>   Well, I was specifically worried about i_mutex locking. In particular:
> Before we report appending IO completion we need to update i_size.
> To update i_size we need to grab i_mutex.
> 
> Now this is unpleasant because inode_dio_wait() happens under i_mutex so
> the above would create lock inversion. And we cannot really do
> inode_dio_done() before grabbing i_mutex as that would open interesting
> races between truncate decreasing i_size and DIO increasing it.

Yeah, XFS splits this between the ilock and iolock, which just makes
life in this area a whole lot easier.

