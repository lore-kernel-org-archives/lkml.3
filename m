Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751961AbaETHD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:03:29 -0400
Received: from mxout2.netvision.net.il ([194.90.9.21]:54194 "EHLO
	mxout2.netvision.net.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaETHD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:03:28 -0400
X-Greylist: delayed 2168 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2014 03:03:27 EDT
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII; format=flowed
Message-id: <537AEE01.20602@gmail.com>
Date: Tue, 20 May 2014 08:54:09 +0300
From: Eli Billauer <eli.billauer@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12)
 Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] dma-mapping: Add devm_ interface for dma_map_single()
References: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
 <1400228799-8832-3-git-send-email-eli.billauer@gmail.com>
 <20140516210805.GO5379@htj.dyndns.org> <537753C9.3060101@gmail.com>
 <20140519201712.GD27506@mtj.dyndns.org>
In-reply-to: <20140519201712.GD27506@mtj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Tejun.

On 19/05/14 23:17, Tejun Heo wrote:
>
> What can't it just do the following?
>
> 	if (dma_mapping_error(dev, dma_handle)) {
> 		devres_free(dr);
> 		return dma_handle;
> 	}
>
> The caller would have to invoke dma_mapping_error() again but is that
> a problem?
>    
That seems OK to me, but the problem I'm concerned with is this: In 
devm_get_free_pages() it says

     devres = devres_alloc(devm_pages_release,
                   sizeof(struct pages_devres), GFP_KERNEL);
     if (unlikely(!devres)) {
         free_pages(addr, order);
         return 0;
     }

What should I put instead of this "return 0" to conform with the current 
API?

And to make things even worse, on some architectures, 
dma_mapping_error() always returns success, regardless of dma_handle. So 
if we stick to the current API, the caller of devm_get_free_pages() will 
never know it failed on these architectures.

So my conclusion was that the caller must be aware that if 
devm_get_free_pages() returns zero it's an error, regardless of 
dma_mapping_error(). That breaks the API. Once it's broken, why not 
return zero on all possible errors?

Maybe I didn't understand what you suggested.

Regards,
    Eli


> Thanks.
>
>    


