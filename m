Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab3LMLDC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 06:03:02 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:30162 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3LMLC7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 06:02:59 -0500
X-IronPort-AV: E=Sophos;i="4.95,478,1384300800"; 
   d="scan'208";a="81938633"
Message-ID: <52AAE94C.7040702@citrix.com>
Date: Fri, 13 Dec 2013 11:02:36 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <george.dunlap@eu.citrix.com>, <ian.jackson@eu.citrix.com>,
        <mukesh.rathor@oracle.com>, <tim@xen.org>, <jbeulich@suse.com>,
        <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <stefano.stabellini@eu.citrix.com>
Subject: Re: [PATCH V10 05/14] xen/pvh: balloon and grant changes.
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com> <1386900621-27528-6-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1386900621-27528-6-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/13 02:10, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> For balloon changes we skip setting of local P2M as it's updated
> in Xen. For grant, the shared grant frame is the PFN and not MFN,
> hence its mapped via the same code path as HVM.

It's difficult to see how these are related.  Please split.

I also think Stefano recently submitted an equivalent fix for the
balloon driver.

> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -1056,14 +1056,20 @@ static void gnttab_unmap_frames_v2(void)
>  static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
>  {
>  	struct gnttab_setup_table setup;
> +	unsigned long start_gpfn;
>  	xen_pfn_t *frames;
>  	unsigned int nr_gframes = end_idx + 1;
>  	int rc;
>  
> -	if (xen_hvm_domain()) {
> +	if (xen_hvm_domain() || xen_feature(XENFEAT_auto_translated_physmap)) {
>  		struct xen_add_to_physmap xatp;
>  		unsigned int i = end_idx;
>  		rc = 0;
> +
> +		if (xen_hvm_domain())
> +			start_gpfn = xen_hvm_resume_frames >> PAGE_SHIFT;
> +		else
> +			start_gpfn = virt_to_pfn(gnttab_shared.addr);

Not really clear why PVH diverges from HVM here.

> @@ -1135,7 +1141,7 @@ static void gnttab_request_version(void)
>  	int rc;
>  	struct gnttab_set_version gsv;
>  
> -	if (xen_hvm_domain())
> +	if (xen_hvm_domain() || xen_feature(XENFEAT_auto_translated_physmap))
>  		gsv.version = 1;
>  	else
>  		gsv.version = 2;

Why is PVH limited to version 1?

David
