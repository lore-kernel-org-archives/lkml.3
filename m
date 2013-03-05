Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab3CEPTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 10:19:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752713Ab3CEPTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 10:19:32 -0500
Date: Tue, 5 Mar 2013 10:18:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: IMA: How to manage user space signing policy with others
Message-ID: <20130305151829.GB4519@redhat.com>
References: <1362140107.9158.101.camel@falcor1>
 <20130301152839.GA3457@redhat.com>
 <20130301184027.GB3457@redhat.com>
 <1362166753.9158.169.camel@falcor1>
 <20130301213329.GC3457@redhat.com>
 <1362346944.18325.1.camel@falcor1>
 <20130304152919.GA15199@redhat.com>
 <1362423581.4392.46.camel@falcor1>
 <20130304191546.GF15199@redhat.com>
 <1362446491.4392.133.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362446491.4392.133.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 04, 2013 at 08:21:31PM -0500, Mimi Zohar wrote:
> On Mon, 2013-03-04 at 14:15 -0500, Vivek Goyal wrote:
> 
> > I am just brain storming and throwing some ideas and see if soemthing
> > makes sense. I agree that allowing one policy only makes it very
> > restrictive (while simplifying the implementation).
> 
> Agreed, lets try again ...  I think we are actually getting closer.
> 
> Without the memory locking or caching issues, would you agree that both
> the builtin 'secureboot' and the 'ima_appraise_tcb' policies meet the
> secure boot needs?

Hi Mimi,

I want to be little careful while calling it secureboot policy. Ideally
secureboot would want all the software running to be signed. But we are
not planning to go to that extent. We are not planning to sign whole
of the user space. So it is not exactly a "secureboot" policy. I am
not sure what to call it. Say "memlock_exec", which signifies that
verify signatures of memlocked executables.

Very fact that we are planning to sign only select executables, requires
us to lock them in memory and assign special capability. If we had signed
whole of the user space, then ideally no untrusted application should
run and no trusted entity will attack process address space in memory
or on swap disk. So we will not need to memlock executable and we will
not need to disable ptrace for signed executables.

So while ima_appraise_tcb might meet strict secureboot needs partially (it
appraises only root owned files), but it does not meet the requirements
of partially signed user space executables.

Though need of this arises because of secureboot feature in firmware, what
I am trying to implement is not exactly a secureboot policy. It is just
one policy which tries to memlock signed executables, verify signature
and assign them special capability upon successful signature verification.

And there can be multiple variation to this policy based on config
options. For example,

- Whether to appraise only root files or all the executables. I think this
  would be a config option.
- Provide config option so that verification is not optional. This will
  be needed if one is creating a fully signed user space.

So basically policy can vary depending on what user wants and what kind
of system it is creating (based on config options). So we need to keep
it in mind while coming up with a solution.

>  If both policies are acceptable, then we could
> define the builtin 'secureboot' policy as the default policy, which
> could be replaced with the 'ima_appraise_tcb' policy, if specified on
> the boot command line.  This would eliminate any need for merging of
> rules or rule flags.

Given the fact that a with the help of config options one might want to
appraise all executables, ima_appraise_tcb will not be exact replacement.

So for my specific use case of "kdump in secureboot" environment, it will
work as /sbin/kexec is root owned. But if somebody decides to extend the
policy a bit to also appraise non-root files, then ima_appraise_tcb will
not be a replacement.

> 
> To address the memory locking and caching issues, we could define a new
> extended attribute type called IMA_XATTR_SECURE_BOOT.
> 
> enum evm_ima_xattr_type {
>         IMA_XATTR_DIGEST = 0x01,
>         EVM_XATTR_HMAC,
>         EVM_IMA_XATTR_DIGSIG,
> };
> 
> and set a corresponding flag in iint->flags.  The flag could then be the
> bases for setting up any special secureboot requirements, like memory
> locking and no caching. 

I have few concerns here.

- I don't think secureboot mandates that executables should be locked in
  memory. It depends on whether all the user space is signed or not and
  that will depend on what distributions are shipping or what kind of
  image user has created. So hardcoding things behind IMA_XATTR_SECURE_BOOT
  might be odd.

- Also memory locking will be done by the caller as binary loader knows
  how to load file. IMA just needs to tell loader that this file is
  digitally signed (possibly in bprm_check). And then loader can load
  the binary, memlock it and can call into post_load hook and ask IMA if
  integrity is fine or not.

A pseudo code might look as follows.

	bprm_post_check();
	if (bprm->unsafe & LSM_UNSAFE_DIGSIG) {
		/* Executable is signed. Memlock it */
	}

	load_various_segemnts;
	retval = bprm_post_load();
	if (retval) {
		/* handle error */
	}

	/*
	 * Binary is signed. Signature verification done while locked in
	 * memory. Raise CAP_SIGNED capability.
	 */
	cap_raise(CAP_SIGNED);

And all this code can be under various config options. And same config
option will vary the IMA policy accordingly.

- xattr value seem to be reflecting type of signatures. And secureboot as
  such is not really a type of signature. So I find it odd to mark such
  files as secureboot. That means while signing also user will have to
  specify in evmctl that mark the signature as secureboot. And that will
  look very ugly. There is no such thing as secureboot signature.


Can we do following. (Just modifying your proposal little bit).

- Implement a new policy say ima_mem_exec. This policy can vary based on
  config options. This will be the default policy. 

- ima_mem_exec will be default policy and it can be disabled by passing
  a command line option ima_mem_exec_disable.

- If user wants to use ima_apprase_tcb policy, they can pass two command
  line option. (ima_mem_exec_disable  and ima_appraise_tcb).

- Similary if user wants to put its own policy using "policy" interface,
  they need to boot kernel with command line option "ima_mem_exec_disable".

In the end, this is again "either A or B"  mechanism. Both ima_mem_exec
and ima_appraise_tcb are not co-existing. Comand line option just enables
choosing one over other.

The fact that we are able to replace ima_mem_exec policy using command
line, binary loader will need a way to query IMA to find what's the
current policy. If ima_mem_exec has been replaced, then binary loader
will not memlock files and will not raise extra capability to binary. And
this will disable kdump functionality on secureboot platforms. (Something
which I don't like much).

Thanks
Vivek
 
> 
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index ddeadc7..6ec1575 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -172,6 +172,8 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
>  		}
>  		status = INTEGRITY_PASS;
>  		break;
> +	case IMA_XATTR_SECURE_BOOT:
> +		iint->flags |= IMA_SB;
>  	case EVM_IMA_XATTR_DIGSIG:
>  		iint->flags |= IMA_DIGSIG;
>  		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
> 
> As originally intended, the policy defines which files are appraised,
> not how they are appraised.  The extended attribute defines how the file
> is to be appraised.
> 
> thanks,
> 
> Mimi
