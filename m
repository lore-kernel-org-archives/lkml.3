Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861Ab3BLSwJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:52:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308Ab3BLSwG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:52:06 -0500
Date: Tue, 12 Feb 2013 13:52:03 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
Message-ID: <20130212185203.GA29958@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
 <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
 <1360620614.3524.223.camel@falcor1.watson.ibm.com>
 <20130212142636.GA23410@redhat.com>
 <1360689247.3524.275.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360689247.3524.275.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 12:14:07PM -0500, Mimi Zohar wrote:

[..]
> > > > --- a/security/integrity/ima/ima_appraise.c
> > > > +++ b/security/integrity/ima/ima_appraise.c
> > > > @@ -124,19 +124,26 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
> > > >  	enum integrity_status status = INTEGRITY_UNKNOWN;
> > > >  	const char *op = "appraise_data";
> > > >  	char *cause = "unknown";
> > > > -	int rc;
> > > > +	int rc, audit_info = 0;
> > > > 
> > > >  	if (!ima_appraise)
> > > >  		return 0;
> > > > -	if (!inode->i_op->getxattr)
> > > > +	if (!inode->i_op->getxattr) {
> > > > +		/* getxattr not supported. file couldn't have been signed */
> > > > +		if (iint->flags & IMA_DIGSIG_OPTIONAL)
> > > > +			return INTEGRITY_PASS;
> > > >  		return INTEGRITY_UNKNOWN;
> > > > +	}
> > > > 
> > > 
> > > Please don't change the result of the appraisal like this.  A single
> > > change can be made towards the bottom of process_measurement().
> > 
> > I don't want to pass integrity in all cases of INTEGRITY_UNKNOWN. So
> > I can probably maintain a bool variable, say pass_appraisal, and set
> > that here and at the end of function, parse that variable and change
> > the status accordingly.
> 
> process_measurement() is the only caller of ima_appraise_measurement().
> Leave the results of ima_appraise_measurement() alone.  There's already
> code at the end of process_measurement() which decides what to return.
> Just modify it based on the appraisal results.

Ok, I can do that. There is a small concern though. That is what to do
when rc = INTEGRITY_UKNOWN and IMA_DIGSIG_OPTIONAL flag is set.

ima_appraise_measurement() returns INTEGRITY_UKNOWN when file system
does not support xattrs or if security xattr is not enabled. In this
case it is desirable to allow access if IMA_DIGSIG_OPTIONAL flag is
set.

But INTEGRITY_UNKNOWN is also also returned when integrity_digsig_verify()
fails and returns -EOPNOTSUPP. 

I feel that in this case it is not very appropriate to pass appraisal and
let executable run. If digital signatures are present but we can't verify
those (Say some algorithm is not supported in kernel). In that case I
think it makes sense to fail the signature. 

               rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
                                             xattr_value->digest, rc - 1,
                                             iint->ima_xattr.digest,
                                             IMA_DIGEST_SIZE);
                if (rc == -EOPNOTSUPP) {
                        status = INTEGRITY_UNKNOWN;


So how to handle this case.

I am wondering why do we reutrn INTEGRITY_UNKNOWN above and not
INTEGRITY_FAIL.

Will it make sense to fail signature in case of -EOPNOTSUPP.
               rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
                                             xattr_value->digest, rc - 1,
                                             iint->ima_xattr.digest,
                                             IMA_DIGEST_SIZE);
		if (rc)
			status = INTEGRITY_FAIL;
		else
			status = INTEGRITY_PASS;


[..]
> > > > --- a/security/integrity/ima/ima_policy.c
> > > > +++ b/security/integrity/ima/ima_policy.c
> > > > @@ -598,6 +598,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
> > > >  			ima_log_string(ab, "appraise_type", args[0].from);
> > > >  			if ((strcmp(args[0].from, "imasig")) == 0)
> > > >  				entry->flags |= IMA_DIGSIG_REQUIRED;
> > > > +			else if ((strcmp(args[0].from, "imasig_optional")) == 0)
> > > > +				entry->flags |= IMA_DIGSIG_OPTIONAL;
> > > 
> > > By setting IMA_DIGSIG_REQUIRED, here, as well, you'll be able to clean
> > > up the code a bit more.
> > 
> > I don't understand this part. So imasig_optional sets both 
> > IMA_DIGSIG_REQUIRED as well as IMA_DIGSIG_OPTIONAL? That seems to be
> > quite contradictory for a reader. 
> 
> > We only add one extra line and that is when "hash" is detected in
> > security.ima, we check for IMA_DIGSIG_OPTIONAL and return an error. So
> > we are probably not saving on code.
> > 
> > IMHO, not setting IMA_DIGSIG_REQUIRED makes sense in this context.
> 
> 'imasig_optional' does not only mean that the signature is optional, but
> also implies that it has to be a digital signature, not a hash.  This
> latter part is what IMA_DIGSIG_REQUIRED means.
> 
> Remember the rule 'action' determines whether or not the file needs to
> be appraised.

Ok, I will change it and set IMA_DIGSIG_REQUIRED flag too.

Thanks
Vivek
