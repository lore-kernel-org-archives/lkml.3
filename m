Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaCMC6Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 22:58:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaCMC6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 22:58:24 -0400
Date: Wed, 12 Mar 2014 20:03:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH v3] zram: support REQ_DISCARD
Message-Id: <20140312200303.7abc49b0.akpm@linux-foundation.org>
In-Reply-To: <20140313024617.GA4900@lge.com>
References: <1394611269-7582-1-git-send-email-iamjoonsoo.kim@lge.com>
	<20140312133318.60c5e63ba26e9bf71098cc6e@linux-foundation.org>
	<20140313024617.GA4900@lge.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014 11:46:17 +0900 Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:

> +	while (n >= PAGE_SIZE) {
> +		/*
> +		 * discard request can be too large so that the zram can
> +		 * be stucked for a long time if we handle the request
> +		 * at once. So handle the request by PAGE_SIZE unit at a time.
> +		 */
> +		write_lock(&zram->meta->tb_lock);
> +		zram_free_page(zram, index);
> +		write_unlock(&zram->meta->tb_lock);
> +		index++;
> +		n -= PAGE_SIZE;
> +	}

Well, you could use something like

	if (need_resched()) {
		unlock()
		schedule()
		lock()
	}

here, or free 100 pages at a time or something silly like that.  I
guess we retain these as options if/when that lock turns out to be
contended.

		
