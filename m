Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817Ab3BLXQD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:16:03 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:40697 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813Ab3BLXQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:16:01 -0500
Message-ID: <1360699536.3524.302.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 15:05:36 -0500
In-Reply-To: <20130212185203.GA29958@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
	 <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
	 <1360620614.3524.223.camel@falcor1.watson.ibm.com>
	 <20130212142636.GA23410@redhat.com>
	 <1360689247.3524.275.camel@falcor1.watson.ibm.com>
	 <20130212185203.GA29958@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021223-2876-0000-0000-00000538706B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 13:52 -0500, Vivek Goyal wrote:
> On Tue, Feb 12, 2013 at 12:14:07PM -0500, Mimi Zohar wrote:
> 
> [..]
> > > > > --- a/security/integrity/ima/ima_appraise.c
> > > > > +++ b/security/integrity/ima/ima_appraise.c
> > > > > @@ -124,19 +124,26 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
> > > > >  	enum integrity_status status = INTEGRITY_UNKNOWN;
> > > > >  	const char *op = "appraise_data";
> > > > >  	char *cause = "unknown";
> > > > > -	int rc;
> > > > > +	int rc, audit_info = 0;
> > > > > 
> > > > >  	if (!ima_appraise)
> > > > >  		return 0;
> > > > > -	if (!inode->i_op->getxattr)
> > > > > +	if (!inode->i_op->getxattr) {
> > > > > +		/* getxattr not supported. file couldn't have been signed */
> > > > > +		if (iint->flags & IMA_DIGSIG_OPTIONAL)
> > > > > +			return INTEGRITY_PASS;
> > > > >  		return INTEGRITY_UNKNOWN;
> > > > > +	}
> > > > > 
> > > > 
> > > > Please don't change the result of the appraisal like this.  A single
> > > > change can be made towards the bottom of process_measurement().
> > > 
> > > I don't want to pass integrity in all cases of INTEGRITY_UNKNOWN. So
> > > I can probably maintain a bool variable, say pass_appraisal, and set
> > > that here and at the end of function, parse that variable and change
> > > the status accordingly.
> > 
> > process_measurement() is the only caller of ima_appraise_measurement().
> > Leave the results of ima_appraise_measurement() alone.  There's already
> > code at the end of process_measurement() which decides what to return.
> > Just modify it based on the appraisal results.
> 
> Ok, I can do that. There is a small concern though. That is what to do
> when rc = INTEGRITY_UKNOWN and IMA_DIGSIG_OPTIONAL flag is set.
> 
> ima_appraise_measurement() returns INTEGRITY_UKNOWN when file system
> does not support xattrs or if security xattr is not enabled. In this
> case it is desirable to allow access if IMA_DIGSIG_OPTIONAL flag is
> set.

Right, 'INTEGRITY_UNKNOWN' means that we can't reason, for whatever
reason, about the integrity of the file.

> But INTEGRITY_UNKNOWN is also also returned when integrity_digsig_verify()
> fails and returns -EOPNOTSUPP. 

In this case, it is Kconfig based. 

> I feel that in this case it is not very appropriate to pass appraisal and
> let executable run. If digital signatures are present but we can't verify
> those (Say some algorithm is not supported in kernel). In that case I
> think it makes sense to fail the signature. 
> 
>                rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
>                                              xattr_value->digest, rc - 1,
>                                              iint->ima_xattr.digest,
>                                              IMA_DIGEST_SIZE);
>                 if (rc == -EOPNOTSUPP) {
>                         status = INTEGRITY_UNKNOWN;
> 
> 
> So how to handle this case.
> 
> I am wondering why do we reutrn INTEGRITY_UNKNOWN above and not
> INTEGRITY_FAIL.

We still can't reason about the integrity of the file.  For all we know,
it could be a validly signed file, just verification wasn't enabled.

> Will it make sense to fail signature in case of -EOPNOTSUPP.
>                rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
>                                              xattr_value->digest, rc - 1,
>                                              iint->ima_xattr.digest,
>                                              IMA_DIGEST_SIZE);
> 		if (rc)
> 			status = INTEGRITY_FAIL;
> 		else
> 			status = INTEGRITY_PASS;
> 
> 

Please don't.

Mimi

