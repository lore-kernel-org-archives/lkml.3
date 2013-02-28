Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760212Ab3B1Uae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:30:34 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33229 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754355Ab3B1Uaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:30:30 -0500
Message-ID: <1362083401.2908.412.camel@falcor1.watson.ibm.com>
Subject: Re: IMA: How to manage user space signing policy with others
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Date: Thu, 28 Feb 2013 15:30:01 -0500
In-Reply-To: <20130228185155.GC11360@redhat.com>
References: <20130228151333.GB11360@redhat.com>
	 <20130228185155.GC11360@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022820-5806-0000-0000-000020262EFD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 13:51 -0500, Vivek Goyal wrote:
> On Thu, Feb 28, 2013 at 10:13:33AM -0500, Vivek Goyal wrote:
> > Hi Mimi,
> > 
> > I am running into issues w.r.t IMA policy management and user space
> > signing. So thought of dropping a mail and gather some ideas.
> > 
> > Currently IMA seems to able to one policy only which does not contain
> > conflicting rules. We have tcb policies in-built and they don't have
> > conflicting rules. User can put its own policy and that will replace
> > kernel policy (default policy). And then user is responsible for making
> > sure conflicting rules are not present.
> > 
> > Now with user space signing and secureboot, I have another set of rules
> > which are not compatible with existing tcb policies. This is how my
> > rules look like as of today. These can change based on config options.
> > 
> > appraise func=BPRM_CHECK appraise_type=optional
> > appraise func=BPRM_POST_LOAD appraise_type=optional
> > 
> > These rules are not compatible with tcp appraise rule.
> > 
> > .action = APPRAISE,.fowner = GLOBAL_ROOT_UID,.flags = IMA_FOWNER
> > 
> > That means in current scheme of things, multiple policies can't co-exist
> > together. It has few  disadvantages.
> > 
> > - If we want IMA to be central point for all integrity measurement
> >   needs, then having one policy only is very limiting. The fact that
> >   user can overirde that policy makes it worse as then kernel can
> >   not impose any policy at all.
> > 
> >   IOW, if user enables user space signign in kernel, say CONFIG_BIN_SIGN=y,
> >   then I need a way so that kernel can make sure IMA rules needed to
> >   ensure integrity of binaries are present and can not be overruled.
> > 
> > - Disabling policy can disable certain features in kernel. So in this
> >   case if user overides default policy, it will disable binary signing
> >   feature also (that too in a very unintutive way).
> > 
> > 
> > One possible way could be that we allow execution of all the relevant
> > rules in a policy and return the ANDed results of all the rules. But
> > this does not go well with the result caching. Atleast current IMA
> > infrastructure does not allow it and might require overhaul.
> > 
> > In general I am concerned about increased performance overhead if we
> > allow multiple policies to co-exist. 
> > 
> > Performance overhead is a concern even without multiple policies. For
> > user space signing, IMA hooks will be called for file operations like
> > open(), mmap() etc and we don't require those to be called. I am not
> > sure if performance overhead is significant or not. Once things start
> > working, I will do some benchmarking.
> > 
> > But coming back to the point, how to go about making sure user space
> > signing policies can't be overridden if user has enabled user space
> > signing feature in kernel.
> 
> Thinking more about it, even if something could be done where multiple
> rules (kernel and user specified one) could co-exist, I think there will
> be issues. One issue could override other in incompatible way.
> 
> For example, one of the limitations of current IMA infrastructures is
> that it does not cover the case of somebody writing to thd disk directly
> (by bypassing the filesystem). If IMA has cached previous appraisal
> result, next time IMA will simply say file integrity is fine. This
> probably worked so far, but certainly does not work for my case where
> I want to verify file signature everytime and no result caching.
> 
> I thought I could extend IMA rule syntax and mention that results of
> particular rule should not be cached. For example,
> 
> cache_result = no
> 
> So one could say
> 
> appraise bprm_check appraise_type=optional cache_result=no
> 
> But then an user space policy could overide it by specifying
> 
> appraise bprm_check appraise_type=optional 
> 
> Or something simlar. And results will be cached and calling code will
> assume that signatures of binary are fine. But that's not the case.
> 
> So we need few more things from IMA for it to support the case of user
> space signing.
> 
> - Ability to make sure kernel specified rules can not be overridden.

Our posts must have crossed -
http://marc.info/?l=linux-security-module&m=136207944823661&w=2

> - Ability to not cache results so that direct writes to disk could
>   be detected.

I'm not going to argue the futility of this argument.  I'll leave that
to others more qualified.  If you really are concerned, then be my guest
and define a general 'nocaching' option, not rule specific.  Replacing
the policy won't affect the option.

> Till then I can't see how can I use IMA to implement process signing.

Vivek, you continue to imply that IMA doesn't cut it for your use case,
yet ignore my suggestions.

Mimi


