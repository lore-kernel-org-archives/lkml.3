Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab3AaT0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 14:26:06 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:35026 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294Ab3AaT0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 14:26:03 -0500
Message-ID: <1359660311.816.173.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH v2 1/4] ima: added policy support for 'security.ima' type
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-security-module@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        James Morris <jmorris@namei.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 31 Jan 2013 14:25:11 -0500
In-Reply-To: <20130131184144.GC2580@redhat.com>
References: <1358892454-25045-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <1358892454-25045-2-git-send-email-zohar@linux.vnet.ibm.com>
	 <20130130215340.GA4918@redhat.com>
	 <1359585759.816.127.camel@falcor1.watson.ibm.com>
	 <20130131184144.GC2580@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13013119-5806-0000-0000-00001EFEA418
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-31 at 13:41 -0500, Vivek Goyal wrote:
> On Wed, Jan 30, 2013 at 05:42:39PM -0500, Mimi Zohar wrote:
> > On Wed, 2013-01-30 at 16:53 -0500, Vivek Goyal wrote:
> > > On Tue, Jan 22, 2013 at 05:07:31PM -0500, Mimi Zohar wrote:
> > > 
> > > [..]
> > > >  /* iint cache flags */
> > > > +#define IMA_ACTION_FLAGS	0xff00
> > > >  #define IMA_DIGSIG		0x0100
> > > > +#define IMA_DIGSIG_REQUIRED	0x0200
> > > 
> > > Hi Mimi,
> > > 
> > > IMA_DIGSIG_REQUIRED state does not really have to be stored in iint I guess.
> > > This is needed only if we go on to appraise and then we want to make
> > > sure digital signatures are present. Once appraisal is done, IMG_DIGSIG
> > > will be set and saved in iint->flags but looks like we don't require
> > > IMA_DIGSIG_REQUIRED to be saved.
> > > 
> > > If yes, will it make sense to not save it in iint. There are still 8
> > > bits left unused. We can mark these 8 bits for temporary flags like
> > > IMA_DIGSIG_REQUIRED. If that works, I can use same space for defining
> > > additional temporary flags like IMA_DIGSIG_SIGNED_ONLY to handle the
> > > case of appraise_type=imasig,signed_only. That flag also does not have
> > > to be persistent in iint.
> > 
> > Interesting idea.  My only concern would be that we're not leaving room
> > for additional hooks (eg. firmware).
> 
> Ok. May be we can employ another 32bit variable and put both of them in
> a structure to expand it, when firmware hooks come along.
> 
> Or I can do that right now, if you like it that way.
> 
> I need to move out non-persistent flags from iint flags, otherwise it
> can happen that conflicting flag might be set from different hooks.
> 
> For example, say hypothetically there are too hooks.
> 
> appraise fowner=0 func=mmap appraise_type=imasig
> appraise fowner=0 func=BPRM_CHECK appraise_type=imasig_signed_only
> 
> Now this will lead to setting of both IMA_DISGIG_REQUIRED and
> IMA_DIGSIG_SIGNED_ONLY in iint->flags and that does not mean much in
> the context of iint.
> 
> So by keeping them temporary, these flags become kind of hook specific
> and then two appraise hook don't conflict with each other.

With the following patches, which James pulled earlier this week, each
hook can have a different appraise status.

5a73fcf ima: differentiate appraise status only for hook specific rules
d79d72e ima: per hook cache integrity appraisal status
f578c08 ima: increase iint flag size
0e5a247 ima: added policy support for 'security.ima' type

thanks,

Mimi

