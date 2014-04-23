Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbaDWK4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:56:43 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40442 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332AbaDWK4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:56:40 -0400
Date: Wed, 23 Apr 2014 11:56:33 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, "Yan, Zheng" <zheng.z.yan@intel.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: Re: [PATCH 3.8 110/133] nfsd4: fix memory leak in
 nfsd4_encode_fattr()
Message-ID: <20140423105633.GB3572@hercules>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
 <1398197671-12786-111-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1398197671-12786-111-git-send-email-kamal@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamal,

On Tue, Apr 22, 2014 at 01:14:08PM -0700, Kamal Mostafa wrote:
> 3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: "Yan, Zheng" <zheng.z.yan@intel.com>
> 
> commit 18df11d0eacf67bbcd8dda755b568bbbd7264735 upstream.
> 
> fh_put() does not free the temporary file handle.
> 
> Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> Signed-off-by: J. Bruce Fields <bfields@redhat.com>
> [ kamal: backport to 3.8 (context) ]
> Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> ---
>  fs/nfsd/nfs4xdr.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> index dc12d02..1418028 100644
> --- a/fs/nfsd/nfs4xdr.c
> +++ b/fs/nfsd/nfs4xdr.c
> @@ -2430,8 +2430,10 @@ out_acl:
>  
>  out:
>  	kfree(acl);
> -	if (fhp == &tempfh)
> +	if (fhp == &tempfh) {
>  		fh_put(&tempfh);
> +		kfree(tempfh);

This doesn't look correct to me as in 3.8 kernel the tempfh variable
is a 'struct svc_fh' and not a dynamically allocated structure.

This has changed only with commit d50e613 "nfsd4: decrease
nfsd4_encode_fattr stack usage", where tempfh was converted into a
'struct svc_fh *'.

So, I believe you should drop this patch from 3.8.

Cheers,
--
Luís

> +	}
>  	return status;
>  out_nfserr:
>  	status = nfserrno(err);
> -- 
> 1.9.1
> 
> 
> -- 
> kernel-team mailing list
> kernel-team@lists.ubuntu.com
> https://lists.ubuntu.com/mailman/listinfo/kernel-team
