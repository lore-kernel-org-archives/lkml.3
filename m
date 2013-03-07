Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933494Ab3CGV4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 16:56:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822Ab3CGV4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 16:56:36 -0500
Date: Thu, 7 Mar 2013 16:56:21 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: IMA: How to manage user space signing policy with others
Message-ID: <20130307215620.GA2159@redhat.com>
References: <20130305151829.GB4519@redhat.com>
 <1362516018.4392.233.camel@falcor1>
 <20130305215300.GE4519@redhat.com>
 <1362584551.4392.291.camel@falcor1>
 <20130306235525.GB29229@redhat.com>
 <1362620348.4392.408.camel@falcor1>
 <20130307143643.GA2790@redhat.com>
 <1362670833.4392.438.camel@falcor1>
 <20130307155343.GD2790@redhat.com>
 <CALLzPKYTmD2AUm1k7JEzXupRjOUPgkQ0LRpuT7b5P1yNpLQOxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKYTmD2AUm1k7JEzXupRjOUPgkQ0LRpuT7b5P1yNpLQOxg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 07:53:50PM +0200, Kasatkin, Dmitry wrote:

[..]

Hi Dmitry,

> Sorry if missed something from this lengthy thread and I repeat something.
> 
> I have not noticed what functions you propose to export.

Actually I have not come up with functions yet. I have yet to write
the code. But I was thinking something along the lines of
verify_signature().

> 
> But for your use case you need to know if file was signed and
> signature was fine, right?

Right.

> So you want to export a function which returns, for example
> "iint->flags & IMA_DIGSIG".

Not sure about that but I think you are referring to your patch
of also exporting the iint->DIGSIG by setting a security flag
LSM_UNSAFE_DIGSIG in bprm->unsafe. That helps but then more
issues start cropping up. I will explain issues in detail below.

> If it was no xattr or no signature, then this flag will not be set.

- if iint->DIGSIG is not set then it could mean few things.
	- There is no xattr or digital signature
	- Or there is signature but ima is disabled or there is no
	  appraise rule configured.

Now second point can create confusion. It means that a signed file will
be treated as unsigned and any functionality dependent on file being
signed will fail. I think it is uintutive. 

If there is no xattr or signature, IMA hook can return failure if appraise
policy is configured. I can't ignore the return code of security hook. So
I need a separate function just to tell me whether file is signed or
not. 

> If signature verification failed, then hook returns EPERM anyway.

There are few issues here.

- iint->DIGSIG will be set only if ima is enabled and some appraise
  rule/policy has been enabled. Otherwise it will not be set. It might
  not be too huge a issue because it just means that a signed file will
  be treated unsigned and any functionality dependent on file being
  signed will fail. I think it is uintutive. 

- iint->DIGSIG could be set even if file is not signed. How?
	- Assume system has booted with ima_appraise_tcb policy.
	- A binary executes. bprm_check() is called and it will
	  set iint->DIGSIG.
	- root does a direct write to disk blocks where file signature
	  are stored.
	- File executes again. This time iint->DIGSIG is set but there
	  are no signature on the file.

- File could have invalid signature still iint->DIGSIG could be set and
  security hook will return success. 
	- Assume system has booted with ima_appraise_tcb policy.
	- A binary executes. bprm_check() is called and it will
	  set iint->DIGSIG.
	- User goes ahead and replaces appraise policy with some
	  other policy so no appraisal rule will match for same file.
	- User does a direct write to disk on file blocks.
	- File executes again. This time iint->DIGSIG is set, and
 	  IMA hook will return success (as there is no matching appraise
	  rule) and making caller believe file is validly signed.

If we don't cache iint->DIGSIG, I think couple of above issues could be
solved. But then we also need to make sure digest of file and appraisal
results not cached either. Caching of everything is in general a issue
with IMA usage in my scenario. I am not sure why IMA did not address the
issue of somebody writing directly to disk bypassing file system.

If we figure a way out to disable caching of everything, then we also
need to figure out a way to export iint->DIGSIG to callers. Current
security hooks don't allow returning anything other than success/fail
status, that means we probably need to create a new function. Seeting
it in bprm->unsafe alone is not sufficient as I might have to do file
verification in non executable file code also.

In summary, we can still solve the problem we can do few things.

- Provide a reliable way to disable caching of iint->DIGSIG, digest
  and appraisal results.

- Provide functions to access iint->DIGSIG after every file execution.

- Create a separate callable IMA function which tells whether file is
  signed or not.

- Provide a way to caller to ensure whether caching is disabled or not
  in IMA. So that caller can interpret what does result mean.

Thanks
Vivek
