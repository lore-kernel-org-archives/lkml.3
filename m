Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbaDWQf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:35:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42091 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaDWQfz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:35:55 -0400
Message-ID: <1398270945.4222.11.camel@fourier>
Subject: Re: [PATCH 3.8 110/133] nfsd4: fix memory leak in
 nfsd4_encode_fattr()
From: Kamal Mostafa <kamal@canonical.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, "Yan, Zheng" <zheng.z.yan@intel.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Date: Wed, 23 Apr 2014 09:35:45 -0700
In-Reply-To: <20140423105633.GB3572@hercules>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
	 <1398197671-12786-111-git-send-email-kamal@canonical.com>
	 <20140423105633.GB3572@hercules>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-23 at 11:56 +0100, Luis Henriques wrote:
> Hi Kamal,
> 
> On Tue, Apr 22, 2014 at 01:14:08PM -0700, Kamal Mostafa wrote:
> > 3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: "Yan, Zheng" <zheng.z.yan@intel.com>
> > 
> > commit 18df11d0eacf67bbcd8dda755b568bbbd7264735 upstream.
> > 
> > fh_put() does not free the temporary file handle.
> > 
> > Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
> > Signed-off-by: J. Bruce Fields <bfields@redhat.com>
> > [ kamal: backport to 3.8 (context) ]
> > Signed-off-by: Kamal Mostafa <kamal@canonical.com>
> > ---
> >  fs/nfsd/nfs4xdr.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
> > index dc12d02..1418028 100644
> > --- a/fs/nfsd/nfs4xdr.c
> > +++ b/fs/nfsd/nfs4xdr.c
> > @@ -2430,8 +2430,10 @@ out_acl:
> >  
> >  out:
> >  	kfree(acl);
> > -	if (fhp == &tempfh)
> > +	if (fhp == &tempfh) {
> >  		fh_put(&tempfh);
> > +		kfree(tempfh);
> 
> This doesn't look correct to me as in 3.8 kernel the tempfh variable
> is a 'struct svc_fh' and not a dynamically allocated structure.
> 
> This has changed only with commit d50e613 "nfsd4: decrease
> nfsd4_encode_fattr stack usage", where tempfh was converted into a
> 'struct svc_fh *'.
> 
> So, I believe you should drop this patch from 3.8.


Ouch!  Good catch, Luis.  I'll drop it from 3.8-stable.

Thanks for your review!

 -Kamal


> Cheers,
> --
> Luís
> 
> > +	}
> >  	return status;
> >  out_nfserr:
> >  	status = nfserrno(err);
> > -- 
> > 1.9.1
> > 
> > 
> > -- 
> > kernel-team mailing list
> > kernel-team@lists.ubuntu.com
> > https://lists.ubuntu.com/mailman/listinfo/kernel-team
> 


