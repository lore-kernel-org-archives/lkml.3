Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbaJLTMo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 15:12:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35902 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbaJLTMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 15:12:43 -0400
Date: Sun, 12 Oct 2014 20:12:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, mina86@mina86.com,
        r.baldyga@samsung.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: Re: [PATCH v2] usb: ffs: fix regression when
 quirk_ep_out_aligned_size flag is set
Message-ID: <20141012191228.GR7996@ZenIV.linux.org.uk>
References: <1412727486-479-1-git-send-email-david.a.cohen@linux.intel.com>
 <1412802738-28839-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412802738-28839-1-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 02:12:18PM -0700, David Cohen wrote:
>  		use_mm(io_data->mm);
>  		for (i = 0; i < io_data->nr_segs; i++) {
> +			size_t len = min_t(size_t, ret - pos,
> +					io_data->iovec[i].iov_len);
> +			if (!len)
> +				break;
>  			if (unlikely(copy_to_user(io_data->iovec[i].iov_base,
> -						 &io_data->buf[pos],
> -						 io_data->iovec[i].iov_len))) {
> +						 &io_data->buf[pos], len))) {
>  				ret = -EFAULT;
>  				break;
>  			}
> -			pos += io_data->iovec[i].iov_len;
> +			pos += len;

Hmm...  This is really asking for something like
	if (copy_to_iter(io_data->buf, ret, <something>) != ret)
		ret = -EFAULT;
with <something> being an iov_iter instead of iovec.  It would be really
nice to have that thing switched to ->read_iter/->write_iter, dropping
->read/->write/->aio_read/->aio_write; I'm not familiar enough with that
code to do it on my own, though, so it would require some help from
maintainers...
