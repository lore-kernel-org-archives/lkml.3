Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab3CAVMf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 16:12:35 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:54006 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752387Ab3CAVMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 16:12:33 -0500
Message-ID: <1362172344.20156.15.camel@x61.thuisdomein>
Subject: Re: [ 34/77] xen/blkback: Dont trust the handle from the frontend.
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jan Beulich <jbeulich@suse.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 01 Mar 2013 22:12:24 +0100
In-Reply-To: <20130301194355.578429064@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
	 <20130301194355.578429064@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Mar 2013 21:12:24.0034 (UTC) FILETIME=[78225C20:01CE16C1]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-01 at 11:44 -0800, Greg Kroah-Hartman wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> commit 01c681d4c70d64cb72142a2823f27c4146a02e63 upstream.
> 
> The 'handle' is the device that the request is from. For the life-time
> of the ring we copy it from a request to a response so that the frontend
> is not surprised by it. But we do not need it - when we start processing
> I/Os we have our own 'struct phys_req' which has only most essential
> information about the request. In fact the 'vbd_translate' ends up
> over-writing the preq.dev with a value from the backend.

Unless that call to vb_translate() fails, doesn't it? Wouldn't preq.dev
still contain random data in that case?

> This assignment of preq.dev with the 'handle' value is superfluous
> so lets not do it.
> 
> Acked-by: Jan Beulich <jbeulich@suse.com>
> Acked-by: Ian Campbell <ian.campbell@citrix.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/block/xen-blkback/blkback.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -879,7 +879,6 @@ static int dispatch_rw_block_io(struct x
>  		goto fail_response;
>  	}
>  
> -	preq.dev           = req->u.rw.handle;
>  	preq.sector_number = req->u.rw.sector_number;
>  	preq.nr_sects      = 0;
>  

This introduces a new GCC warning in the stable 3.8.y tree:
    drivers/block/xen-blkback/blkback.c: In function 'dispatch_rw_block_io':
    drivers/block/xen-blkback/blkback.c:904:3: warning: 'preq.dev' may be used uninitialized in this function [-Wuninitialized]

It does look GCC is right here. But I'm totally new to the code in
question, so I'll just ask whether this can really go in stable as is.


Paul Bolle

