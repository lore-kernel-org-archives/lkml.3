Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625Ab3B1TYI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 14:24:08 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:60611 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757222Ab3B1TYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 14:24:06 -0500
Message-ID: <1362079419.2908.390.camel@falcor1.watson.ibm.com>
Subject: Re: IMA: How to manage user space signing policy with others
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Date: Thu, 28 Feb 2013 14:23:39 -0500
In-Reply-To: <20130228151333.GB11360@redhat.com>
References: <20130228151333.GB11360@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022819-7182-0000-0000-000005961F76
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 10:13 -0500, Vivek Goyal wrote:
> Hi Mimi,
> 
> I am running into issues w.r.t IMA policy management and user space
> signing. So thought of dropping a mail and gather some ideas.
> 
> Currently IMA seems to able to one policy only which does not contain
> conflicting rules. We have tcb policies in-built and they don't have
> conflicting rules. User can put its own policy and that will replace
> kernel policy (default policy). And then user is responsible for making
> sure conflicting rules are not present.

The default integrity policy is a null policy, which can be replaced by
specifying a boot command line option(s).  The integrity policy can be
replaced once, with a policy of your choice.  Normally this would be
done in the initramfs, before pivoting root.

> Now with user space signing and secureboot, I have another set of rules
> which are not compatible with existing tcb policies. 

I know.  We've already discussed this
http://marc.info/?l=linux-security-module&m=136131183031527&w=2.

> This is how my
> rules look like as of today. These can change based on config options.
> 
> appraise func=BPRM_CHECK appraise_type=optional
> appraise func=BPRM_POST_LOAD appraise_type=optional
> 
> These rules are not compatible with tcp appraise rule.
> 
> .action = APPRAISE,.fowner = GLOBAL_ROOT_UID,.flags = IMA_FOWNER
> 
> That means in current scheme of things, multiple policies can't co-exist
> together. It has few  disadvantages.

No, it just means the merged policy needs to make sense.  The example you give
doesn't.

I've already suggested that you define a builtin secureboot integrity
policy, which is a subset of the ima_appraise_tcb policy.  If secureboot
is enabled, then the secureboot integrity policy would be enabled by
default, in lieu of the default null policy.

I would suggest that the ima_appraise_tcb, which is more restrictive, be
permitted to replace the secureboot policy.

> - If we want IMA to be central point for all integrity measurement
>   needs, then having one policy only is very limiting.

So far, you haven't made a convincing case for supporting more than one
policy.  If anything, you've made it very clear that merging policies
needs to be well thought out.

>   The fact that
>   user can overirde that policy makes it worse as then kernel can
>   not impose any policy at all.

The kernel IS enforcing the specified integrity policy.

>   IOW, if user enables user space signign in kernel, say CONFIG_BIN_SIGN=y,
>   then I need a way so that kernel can make sure IMA rules needed to
>   ensure integrity of binaries are present and can not be overruled.

If you want to prohibit userspace from replacing the builtin policy, then
provide a Kconfig option based on secureboot.

> - Disabling policy can disable certain features in kernel. So in this
>   case if user overides default policy, it will disable binary signing
>   feature also (that too in a very unintutive way).

Or, you can look at Kconfig options as a way of defining what is
included in the build.  The policy defines what is enabled.
 
> One possible way could be that we allow execution of all the relevant
> rules in a policy and return the ANDed results of all the rules. But
> this does not go well with the result caching. Atleast current IMA
> infrastructure does not allow it and might require overhaul.

> In general I am concerned about increased performance overhead if we
> allow multiple policies to co-exist. 
> 
> Performance overhead is a concern even without multiple policies. For
> user space signing, IMA hooks will be called for file operations like
> open(), mmap() etc and we don't require those to be called. I am not
> sure if performance overhead is significant or not. Once things start
> working, I will do some benchmarking.
> 
> But coming back to the point, how to go about making sure user space
> signing policies can't be overridden if user has enabled user space
> signing feature in kernel.

Vivek, there are multiple concurrent threads to this discussion.  One
thread discusses adding the 'optional' flag.  The other thread discusses
defining a new hook to appraise the kernel image being loaded.  If the
decision is to go forward with the latter, then this thread, using the
'optional' flag, becomes moot.

With a new hook to verify kernel images, you would be able to define a
single integrity rule, lets call the hook
security/ima_kexec_image_check(), that would appraise the integrity of
kernel images being loaded.  There wouldn't be a convoluted policy that
verifies the signature of binaries, if it exists, yet permits all
binaries to execute, except those that failed signature verification.
You wouldn't need a new capability, nor rely on the signed binary to
appraise the images being loaded.  If secureboot is enabled, the single
secureboot integrity rule could be merged safely with other policies.

thanks,

Mimi

