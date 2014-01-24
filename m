Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbaAXSrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 13:47:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23109 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbaAXSrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 13:47:04 -0500
Date: Fri, 24 Jan 2014 13:46:55 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xensource.com
Subject: Re: Fix misplaced kfree from xlated_setup_gnttab_pages
Message-ID: <20140124184655.GC16410@phenom.dumpdata.com>
References: <20140123064242.09E68660D05@gitolite.kernel.org>
 <20140124183114.GA31844@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140124183114.GA31844@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 24, 2014 at 01:31:14PM -0500, Dave Jones wrote:
> Passing a freed 'pages' to free_xenballooned_pages will end badly
> on kernels with slub debug enabled.

Ouch.
> 
> This looks out of place between the rc assign and the check, and
> was likely a cut-and-paste error.
> 
> Signed-off-by: Dave Jones <davej@fedoraproject.org>
> 
> diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
> index 103c93f874b2..28990cc97304 100644
> --- a/arch/x86/xen/grant-table.c
> +++ b/arch/x86/xen/grant-table.c
> @@ -161,12 +161,11 @@ static int __init xlated_setup_gnttab_pages(void)
>  
>  	rc = arch_gnttab_map_shared(pfns, nr_grant_frames, nr_grant_frames,
>  				    &xen_auto_xlat_grant_frames.vaddr);
> -
> -	kfree(pages);
>  	if (rc) {
>  		pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
>  			nr_grant_frames, rc);
>  		free_xenballooned_pages(nr_grant_frames, pages);
> +		kfree(pages);
>  		kfree(pfns);
>  		return rc;
>  	}

Actually it should also be freed on the success path, as so:


I can squash it in, if you are OK with that?

diff --git a/arch/x86/xen/grant-table.c b/arch/x86/xen/grant-table.c
index 103c93f..c985835 100644
--- a/arch/x86/xen/grant-table.c
+++ b/arch/x86/xen/grant-table.c
@@ -162,14 +162,15 @@ static int __init xlated_setup_gnttab_pages(void)
 	rc = arch_gnttab_map_shared(pfns, nr_grant_frames, nr_grant_frames,
 				    &xen_auto_xlat_grant_frames.vaddr);
 
-	kfree(pages);
 	if (rc) {
 		pr_warn("%s Couldn't map %ld pfns rc:%d\n", __func__,
 			nr_grant_frames, rc);
 		free_xenballooned_pages(nr_grant_frames, pages);
+		kfree(pages);
 		kfree(pfns);
 		return rc;
 	}
+	kfree(pages);
 
 	xen_auto_xlat_grant_frames.pfn = pfns;
 	xen_auto_xlat_grant_frames.count = nr_grant_frames;
