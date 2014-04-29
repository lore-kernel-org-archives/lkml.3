Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbaD2JI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:08:26 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34317 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaD2JIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:08:24 -0400
Date: Tue, 29 Apr 2014 12:08:10 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Oleg Drokin <oleg.drokin@intel.com>,
        James Nunez <james.a.nunez@intel.com>
Subject: Re: [PATCH 18/47] staging/lustre/hsm: HSM requests not delivered
Message-ID: <20140429090810.GY26890@mwanda>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
 <1398618431-29757-19-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398618431-29757-19-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 01:06:42PM -0400, Oleg Drokin wrote:
> diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
> index 7fbc18e..c391b60 100644
> --- a/drivers/staging/lustre/lustre/llite/dir.c
> +++ b/drivers/staging/lustre/lustre/llite/dir.c
> @@ -1804,6 +1804,11 @@ out_rmdir:
>  		/* Compute the whole struct size */
>  		totalsize = hur_len(hur);

hur_len() has an integer overflow bug.

>  		OBD_FREE_PTR(hur);
> +
> +		/* Final size will be more than double totalsize */
> +		if (totalsize >= MDS_MAXREQSIZE / 3)
> +			return -E2BIG;

"totalsize" is signed and this condition doesn't take negatives into
consideration.  Make totalsize unsigned.

> +
>  		OBD_ALLOC_LARGE(hur, totalsize);

How do we know that "totalsize" is more than sizeof(*hur)?  If we fixed
the overflow bug then maybe this isn't a problem.  I haven't looked.

>  		if (hur == NULL)
>  			return -ENOMEM;

regards,
dan carpenter
