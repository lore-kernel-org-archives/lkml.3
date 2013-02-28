Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287Ab3B1PON (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 10:14:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47788 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758537Ab3B1POI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 10:14:08 -0500
Date: Thu, 28 Feb 2013 10:13:33 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Subject: IMA: How to manage user space signing policy with others
Message-ID: <20130228151333.GB11360@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mimi,

I am running into issues w.r.t IMA policy management and user space
signing. So thought of dropping a mail and gather some ideas.

Currently IMA seems to able to one policy only which does not contain
conflicting rules. We have tcb policies in-built and they don't have
conflicting rules. User can put its own policy and that will replace
kernel policy (default policy). And then user is responsible for making
sure conflicting rules are not present.

Now with user space signing and secureboot, I have another set of rules
which are not compatible with existing tcb policies. This is how my
rules look like as of today. These can change based on config options.

appraise func=BPRM_CHECK appraise_type=optional
appraise func=BPRM_POST_LOAD appraise_type=optional

These rules are not compatible with tcp appraise rule.

.action = APPRAISE,.fowner = GLOBAL_ROOT_UID,.flags = IMA_FOWNER

That means in current scheme of things, multiple policies can't co-exist
together. It has few  disadvantages.

- If we want IMA to be central point for all integrity measurement
  needs, then having one policy only is very limiting. The fact that
  user can overirde that policy makes it worse as then kernel can
  not impose any policy at all.

  IOW, if user enables user space signign in kernel, say CONFIG_BIN_SIGN=y,
  then I need a way so that kernel can make sure IMA rules needed to
  ensure integrity of binaries are present and can not be overruled.

- Disabling policy can disable certain features in kernel. So in this
  case if user overides default policy, it will disable binary signing
  feature also (that too in a very unintutive way).


One possible way could be that we allow execution of all the relevant
rules in a policy and return the ANDed results of all the rules. But
this does not go well with the result caching. Atleast current IMA
infrastructure does not allow it and might require overhaul.

In general I am concerned about increased performance overhead if we
allow multiple policies to co-exist. 

Performance overhead is a concern even without multiple policies. For
user space signing, IMA hooks will be called for file operations like
open(), mmap() etc and we don't require those to be called. I am not
sure if performance overhead is significant or not. Once things start
working, I will do some benchmarking.

But coming back to the point, how to go about making sure user space
signing policies can't be overridden if user has enabled user space
signing feature in kernel.

Thanks
Vivek
