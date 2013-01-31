Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab3AaSlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:41:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab3AaSlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:41:49 -0500
Date: Thu, 31 Jan 2013 13:41:44 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-security-module@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] ima: added policy support for 'security.ima' type
Message-ID: <20130131184144.GC2580@redhat.com>
References: <1358892454-25045-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1358892454-25045-2-git-send-email-zohar@linux.vnet.ibm.com>
 <20130130215340.GA4918@redhat.com>
 <1359585759.816.127.camel@falcor1.watson.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359585759.816.127.camel@falcor1.watson.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 05:42:39PM -0500, Mimi Zohar wrote:
> On Wed, 2013-01-30 at 16:53 -0500, Vivek Goyal wrote:
> > On Tue, Jan 22, 2013 at 05:07:31PM -0500, Mimi Zohar wrote:
> > 
> > [..]
> > >  /* iint cache flags */
> > > +#define IMA_ACTION_FLAGS	0xff00
> > >  #define IMA_DIGSIG		0x0100
> > > +#define IMA_DIGSIG_REQUIRED	0x0200
> > 
> > Hi Mimi,
> > 
> > IMA_DIGSIG_REQUIRED state does not really have to be stored in iint I guess.
> > This is needed only if we go on to appraise and then we want to make
> > sure digital signatures are present. Once appraisal is done, IMG_DIGSIG
> > will be set and saved in iint->flags but looks like we don't require
> > IMA_DIGSIG_REQUIRED to be saved.
> > 
> > If yes, will it make sense to not save it in iint. There are still 8
> > bits left unused. We can mark these 8 bits for temporary flags like
> > IMA_DIGSIG_REQUIRED. If that works, I can use same space for defining
> > additional temporary flags like IMA_DIGSIG_SIGNED_ONLY to handle the
> > case of appraise_type=imasig,signed_only. That flag also does not have
> > to be persistent in iint.
> 
> Interesting idea.  My only concern would be that we're not leaving room
> for additional hooks (eg. firmware).

Ok. May be we can employ another 32bit variable and put both of them in
a structure to expand it, when firmware hooks come along.

Or I can do that right now, if you like it that way.

I need to move out non-persistent flags from iint flags, otherwise it
can happen that conflicting flag might be set from different hooks.

For example, say hypothetically there are too hooks.

appraise fowner=0 func=mmap appraise_type=imasig
appraise fowner=0 func=BPRM_CHECK appraise_type=imasig_signed_only

Now this will lead to setting of both IMA_DISGIG_REQUIRED and
IMA_DIGSIG_SIGNED_ONLY in iint->flags and that does not mean much in
the context of iint.

So by keeping them temporary, these flags become kind of hook specific
and then two appraise hook don't conflict with each other.

Thanks
Vivek

