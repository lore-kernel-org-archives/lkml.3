Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933908Ab3BLS53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:57:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933865Ab3BLS51 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:57:27 -0500
Date: Tue, 12 Feb 2013 13:57:25 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
Message-ID: <20130212185725.GC23410@redhat.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
 <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
 <1360620614.3524.223.camel@falcor1.watson.ibm.com>
 <20130212142636.GA23410@redhat.com>
 <1360689247.3524.275.camel@falcor1.watson.ibm.com>
 <20130212185203.GA29958@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212185203.GA29958@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 01:52:03PM -0500, Vivek Goyal wrote:
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

If we do this, audit logs will be filled with integrity unknown failures.
As each unsigned executable file will fail appraisal with INTEGRITY_UNKNOWN
and an audit message will be logged.

Thanks
Vivek
