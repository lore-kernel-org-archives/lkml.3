Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab3IZRIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 13:08:17 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:9445 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab3IZRIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 13:08:14 -0400
X-AuditID: cbfec372-b7fe76d000003347-ce-524469fd5485
Date: Thu, 26 Sep 2013 14:08:08 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] [media] dvb_demux: fix deadlock in
 dmx_section_feed_release_filter()
Message-id: <20130926140808.729bad49@samsung.com>
In-reply-to: <1376772531-8963-1-git-send-email-khoroshilov@ispras.ru>
References: <1376772531-8963-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsVy+t/hYN2/mS5BBh+Pc1jsWLeT3WJ5dxeL
	xeVdc9gsejZsZXVg8Zjxbyqjx53Xf1k9Pm+SC2CO4rJJSc3JLEst0rdL4Mp4/qWHsWCSQMXP
	I1MZGxhX8nYxcnJICJhIbN/SyAZhi0lcuLceyObiEBJYwihxYl8PK0hCSKCHSaLhWziIzSKg
	KrHyeQMziM0mYCTxqrEFrEZEQE/i46utTF2MHBzMArESfc90QcLCAtESrd+/M4LYvAKGEv83
	rWACsTkFXCXaT19ghhjvItGw+TgjSKuEgJPE1qm+EOWCEj8m32MBsZkFtCQ2b2tihbDlJTav
	ecs8gVFgFpKyWUjKZiEpW8DIvIpRtLQ4uaA4KT3XUK84Mbe4NC9dLzk/dxMjJFyLdjA+22B1
	iFGAg1GJh1cgwyVIiDWxrLgy9xCjBAezkgjv+ligEG9KYmVValF+fFFpTmrxIUYmDk6pBkb5
	sJfyulmiX/QkYo0C/6/Zeee98AzTs59LehiWrZrwq+Kp6JzFc+/vPntai2eq3GnvlZxHpl3b
	oBG/SWuZ5+T3gT4MZ7tKTDcc3cyy9DH35BvaGj07W8u1be83fYzdL3fq01uDF/dLp61gW6yi
	k/jcdK/r982+Iqc838S8f+qlL9W+h0Xm/oS3SizFGYmGWsxFxYkAF/jBITUCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, 17 Aug 2013 23:48:51 +0300
Alexey Khoroshilov <khoroshilov@ispras.ru> escreveu:

> dmx_section_feed_release_filter() locks dvbdmx->mutex and
> if the feed is still filtering, it calls feed->stop_filtering(feed).
> stop_filtering() is implemented by dmx_section_feed_stop_filtering()
> that first of all try to lock the same mutex: dvbdmx->mutex.
> That leads to a deadlock.
> 
> It does not happen often in practice because all callers of
> release_filter() stop filtering by themselves.
> So the problem can happen in case of race condition only.
> 
> The patch proposes to unlock dvbdmx->mutex before call feed->stop_filtering(feed)
> and recheck feed->is_filtering after reacquiring mutex.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/media/dvb-core/dvb_demux.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/dvb-core/dvb_demux.c b/drivers/media/dvb-core/dvb_demux.c
> index 3485655..9d517af 100644
> --- a/drivers/media/dvb-core/dvb_demux.c
> +++ b/drivers/media/dvb-core/dvb_demux.c
> @@ -1027,8 +1027,11 @@ static int dmx_section_feed_release_filter(struct dmx_section_feed *feed,
>  		return -EINVAL;
>  	}
>  
> -	if (feed->is_filtering)
> +	while (feed->is_filtering) {

Changing from if to while here can cause a dead lock, as, if the device
got removed, dmx_section_feed_stop_filtering() won't touch
feed->is_filtering. So, the loop will happen forever.

Except for that the patch looks correct on my eyes.

> +		mutex_unlock(&dvbdmx->mutex);

Please add a small comment about why the mutex needs to be unlocked
there, as this looks ugly, and likely deserve some cleanups in the future
(as both the spinclock and the mutex are taken on both callback and at
the release filter function).

>  		feed->stop_filtering(feed);
> +		mutex_lock(&dvbdmx->mutex);
> +	}
>  
>  	spin_lock_irq(&dvbdmx->lock);
>  	f = dvbdmxfeed->filter;


Thanks!
Mauro
