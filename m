Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325AbaGYSmu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 14:42:50 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:55618 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaGYSmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 14:42:49 -0400
Date: Fri, 25 Jul 2014 14:42:49 -0400 (EDT)
From: Bob Peterson <rpeterso@redhat.com>
To: Abhi Das <adas@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Message-ID: <742068374.13487420.1406313769169.JavaMail.zimbra@redhat.com>
In-Reply-To: <1406309888-10749-4-git-send-email-adas@redhat.com>
References: <1406309888-10749-1-git-send-email-adas@redhat.com> <1406309888-10749-4-git-send-email-adas@redhat.com>
Subject: Re: [Cluster-devel] [RFC PATCH 3/5] gfs2: Add a dynamic buffer
 backed	by a vector of pages
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.82.6]
X-Mailer: Zimbra 8.0.6_GA_5922 (ZimbraWebClient - FF30 (Linux)/8.0.6_GA_5922)
Thread-Topic: gfs2: Add a dynamic buffer backed by a vector of pages
Thread-Index: RCwgqhpbeBve+wZOJBjX2oH8m4BA3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> +static int vp_alloc_pages(struct vp_ctx *vpx, int start, int end)
> +{
> +	int i;
> +
> +	for (i = start; i < end; i++) {
> +		vpx->vp_pages[i] = alloc_page(GFP_KERNEL | GFP_NOFS);
> +		if (vpx->vp_pages[i] == NULL)
> +			goto free;
> +	}
> +	return 0;
> +free:
> +	for (i = start; i < end; i++)
> +		if (vpx->vp_pages[i]) {
> +			__free_page(vpx->vp_pages[i]);
> +			vpx->vp_pages[i] = NULL;
> +		}
> +	return -ENOMEM;
> +}

I'm concerned that if we have a value for vpx->vp_pages[i] that is
nonzero (uninitialized) _after_ an element in which we couldn't
allocate a page, we could try to free the nonzero value. For that
reason, I always prefer to do something like this instead:

free:
     while (i > start) {
          i--;
          __free_page(vpx->vp_pages[i]);
          vpx->vp_pages[i] = NULL;
     }
     return -ENOMEM;

(snip)
> +struct vp_ctx* vp_get_vpx(struct vbuf *vb)
> +{
> +	struct vp_ctx *vpx = NULL;
> +
> +	if (!vb || !vb->v_opaque)
> +		goto out;
> +
> +	vpx = vb->v_opaque;
> +	if (vpx->vp_magic != VP_MAGIC) {
> +		vpx = NULL;
> +		goto out;

This goto is unnecessary, and if you eliminate it, you don't need the brackets.

> +	}
> +out:
> +	return vpx;
> +}

Regards,

Bob Peterson
Red Hat File Systems
