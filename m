Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3AQM1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:27:23 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.189.228]:63614 "EHLO
	smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3AQM1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:27:21 -0500
X-IronPort-AV: E=Sophos;i="4.84,486,1355097600"; 
   d="scan'208";a="443425046"
Date: Thu, 17 Jan 2013 13:22:47 +0100
From: Matt Wilson <msw@amazon.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <annie.li@oracle.com>
Subject: Re: [PATCH] xen/grant-table: Force to use v1 of grants.
Message-ID: <20130117110829.GA21859@u109add4315675089e695.ant.amazon.com>
References: <1358371369-19089-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1358371369-19089-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 04:22:49PM -0500, Konrad Rzeszutek Wilk wrote:
> We have the framework to use v2, but there are no backends that
> actually use it. The end result is that on PV we use v2 grants
> and on PVHVM v1. The v1 has a capacity of 512 grants per page while
> the v2 has 256 grants per page. This means we lose about 50%
> capacity - and if we want more than 16 VIFs (each VIF takes
> 512 grants), then we are hitting the max per guest of 32.
> 
> Note: The hypervisor provides an over-ride for the default
> of 32 frames (pages) per guest: gnttab_max_nr_frames=X

I think it would be better if the dom0/service domain and hypervisor
prevent the guest from setting the version to 2 if the backend isn't
going to make use of them. In the short term, we could add a Xen
option to limit the supported version to 1.

Matt

> Oracle-bug: 16039922
> CC: annie.li@oracle.com
> CC: msw@amazon.com
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/grant-table.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 95ce9d0..568fd8f 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -1108,10 +1108,8 @@ static void gnttab_request_version(void)
>  	int rc;
>  	struct gnttab_set_version gsv;
>  
> -	if (xen_hvm_domain())
> -		gsv.version = 1;
> -	else
> -		gsv.version = 2;
> +	gsv.version = 1;
> +
>  	rc = HYPERVISOR_grant_table_op(GNTTABOP_set_version, &gsv, 1);
>  	if (rc == 0 && gsv.version == 2) {
>  		grant_table_version = 2;
> -- 
> 1.8.0.2
