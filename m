Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbaB0X1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:27:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaB0X1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:27:54 -0500
Date: Thu, 27 Feb 2014 15:27:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv8 5/6] zram: add set_max_streams knob
Message-Id: <20140227152752.add72f47d6a90c1e208c9edd@linux-foundation.org>
In-Reply-To: <1393417679-13657-6-git-send-email-sergey.senozhatsky@gmail.com>
References: <1393417679-13657-1-git-send-email-sergey.senozhatsky@gmail.com>
	<1393417679-13657-6-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 15:27:58 +0300 Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> This patch allows to change max_comp_streams on initialised zcomp.
> 
> Introduce zcomp set_max_streams() knob, zcomp_strm_multi_set_max_streams()
> and zcomp_strm_single_set_max_streams() callbacks to change streams limit
> for zcomp_strm_multi and zcomp_strm_single, accordingly. set_max_streams
> for single steam zcomp does nothing.
> 
> If user has lowered the limit, then zcomp_strm_multi_set_max_streams()
> attempts to immediately free extra streams (as much as it can, depending
> on idle streams availability).
> 
> Note, this patch does not allow to change stream 'policy' from single to
> multi stream (or vice versa) on already initialised compression backend.
> 
> ...
>
> @@ -137,6 +137,28 @@ static void zcomp_strm_multi_put(struct zcomp *comp, struct zcomp_strm *zstrm)
>  	zcomp_strm_free(comp, zstrm);
>  }
>  
> +/* change max_strm limit */
> +static int zcomp_strm_multi_set_max_streams(struct zcomp *comp, int num_strm)
> +{
> +	struct zcomp_strm_multi *zs = comp->stream;
> +
> +	spin_lock(&zs->strm_lock);
> +	zs->max_strm = num_strm;
> +	/*
> +	 * if user has lowered the limit and there are idle streams,
> +	 * immediately free as much streams (and memory) as we can.
> +	 */
> +	while (zs->avail_strm > num_strm && !list_empty(&zs->idle_strm)) {
> +		struct zcomp_strm *zstrm = list_entry(zs->idle_strm.next,
> +				struct zcomp_strm, list);

		struct zcomp_strm *zstrm;

		zstrm = list_entry(zs->idle_strm.next, struct zcomp_strm, list);

will avoid the coding-style mess.

> +		list_del(&zstrm->list);
> +		zcomp_strm_free(comp, zstrm);
> +		zs->avail_strm--;
> +	}
> +	spin_unlock(&zs->strm_lock);
> +	return 0;
> +}

