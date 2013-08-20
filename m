Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3HTVSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:18:16 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55455 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3HTVSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:18:15 -0400
Date: Tue, 20 Aug 2013 22:18:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] vfio-pci: Use fdget() rather than eventfd_fget()
Message-ID: <20130820211814.GM27005@ZenIV.linux.org.uk>
References: <20130820191712.9006.4890.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130820191712.9006.4890.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 01:18:07PM -0600, Alex Williamson wrote:
> eventfd_fget() tests to see whether the file is an eventfd file, which
> we then immediately pass to eventfd_ctx_fileget(), which again tests
> whether the file is an eventfd file.  Simplify slightly by using
> fdget() so that we only test that we're looking at an eventfd once.
> fget() could also be used, but fdget() makes use of fget_light() for
> another slight optimization.

Umm...

> @@ -210,8 +210,8 @@ fail:
>  	if (ctx && !IS_ERR(ctx))
>  		eventfd_ctx_put(ctx);
>  
> -	if (file && !IS_ERR(file))
> -		fput(file);
> +	if (irqfd.file)
> +		fdput(irqfd);
>  
>  	kfree(virqfd);

IMO it's a bad style; you have three failure exits leading here, and those
ifs are nothing but "how far did we get before we'd failed".

fail3:
	eventfd_ctx_put(ctx);
fail2:
	fdput(irqfd);
fail1:
  	kfree(virqfd);

is much easier to analyse.  It's a very common pattern and IME it's more
robust than this kind of "flexibility"...
