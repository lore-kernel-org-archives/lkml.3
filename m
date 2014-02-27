Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbaB0XUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:20:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbaB0XUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:20:04 -0500
Date: Thu, 27 Feb 2014 15:20:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv8 3/6] zram: factor out single stream compression
Message-Id: <20140227152002.ac7c384798b0c915a079ae42@linux-foundation.org>
In-Reply-To: <1393417679-13657-4-git-send-email-sergey.senozhatsky@gmail.com>
References: <1393417679-13657-1-git-send-email-sergey.senozhatsky@gmail.com>
	<1393417679-13657-4-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 15:27:56 +0300 Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> This is preparation patch to add multi stream support to zcomp.
> 
> Introduce struct zcomp_strm_single and a set of functions to manage zcomp_strm
> stream access. zcomp_strm_single implements single compession stream, same way
> as current zcomp implementation. This moves zcomp_strm stream control and
> locking from zcomp, so compressing backend zcomp is not aware of required
> locking.
> 
> Single and multi streams require different locking schemes. Minchan Kim
> reported that spinlock-based locking scheme (which is used in multi stream
> implementation) has demonstrated a severe perfomance regression for single
> compression stream case, comparing to mutex-based.
> see https://lkml.org/lkml/2014/2/18/16
> 
> The following set of functions added:
> - zcomp_strm_single_get()/zcomp_strm_single_put()
>   get and put compression stream, implement required locking
> - zcomp_strm_single_create()/zcomp_strm_single_destroy()
>   create and destroy zcomp_strm_single
> 
> New ->strm_get() and ->strm_put() callbacks added to zcomp, which are set to
> zcomp_strm_single_get() and zcomp_strm_single_put() during initialisation.
> Instead of direct locking and zcomp_strm access from zcomp_strm_get() and
> zcomp_strm_put(), zcomp now calls ->strm_get() and ->strm_put()
> correspondingly.
> 
> ...
>
> +static struct zcomp_strm *zcomp_strm_single_get(struct zcomp *comp)
> +{
> +	struct zcomp_strm_single *zs = comp->stream;
> +	mutex_lock(&zs->strm_lock);
> +	return zs->zstrm;
> +}
> +
> +static void zcomp_strm_single_put(struct zcomp *comp, struct zcomp_strm *zstrm)
> +{
> +	struct zcomp_strm_single *zs = comp->stream;
> +	mutex_unlock(&zs->strm_lock);
> +}

Again, these are not "get" and "put" operations.

> 
> ...
>

