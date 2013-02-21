Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab3BUSOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:14:39 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:37059 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756628Ab3BUSOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:14:36 -0500
Message-ID: <1361469979.29360.75.camel@falcor1>
Subject: Re: [GIT] Security subsystem updates for 3.9
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Date: Thu, 21 Feb 2013 13:06:19 -0500
In-Reply-To: <CA+55aFzkBA6bdLe73PKBaQNfV1m-JqSddF24-F-s1rX3oRE2Lg@mail.gmail.com>
References: <alpine.LRH.2.02.1302220058500.18199@tundra.namei.org>
	 <CA+55aFzkBA6bdLe73PKBaQNfV1m-JqSddF24-F-s1rX3oRE2Lg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13022118-5806-0000-0000-000020003FA6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-21 at 08:26 -0800, Linus Torvalds wrote:
> On Thu, Feb 21, 2013 at 6:03 AM, James Morris <jmorris@namei.org> wrote:
> > This is basically a maintenance update for the TPM driver and EVM/IMA.
> 
> Hmm. There were conflicts in lib/digsig.c and ima_main.c. The digsig
> one was pretty trivial, but I'd like people to take a look at the IMA
> one.
> 
> And that's not because the conflict itself was all that complex - I'm
> pretty sure I resolved it correctly. But I do want to make sure that
> everybody agrees on the whole module integrity checking thing. I
> resolved it to be like the semantics in Mimi's commit a7f2a366f623,
> which means that for non-file modules, IMA does:
> 
> Only fail the non-file module if
>    (a) IMA_APPRAISE_MODULES was set

Almost, and enforcing file integrity is enabled.  The merged result
should look like what's contained in
linux-integrity/next-upstreamed-patches:

int ima_module_check(struct file *file)
{
        if (!file) {
                if ((ima_appraise & IMA_APPRAISE_MODULES) &&
                    (ima_appraise & IMA_APPRAISE_ENFORCE)) {
#ifndef CONFIG_MODULE_SIG_FORCE
                        return -EACCES; /* INTEGRITY_UNKNOWN */
#endif
                }
                return 0;
        }
        return process_measurement(file, file->f_dentry->d_name.name,
                                   MAY_EXEC, MODULE_CHECK);
}

thanks,

Mimi

> *and*
>    (b) CONFIG_MODULE_SIG_FORCE is not set.

> If CONFIG_MODULE_SIG_FORCE it ignores IMA_APPRAISE_MODULES entirely,
> and the module signature checking overrides everything. And if
> IMA_APPRAISE_MODULES is not set, we say "whatever". So it makes sense,
> but I wanted people to just be aware of it and agree on it, since the
> security tree modified this part without apparently being aware of the
> changed semantics.


