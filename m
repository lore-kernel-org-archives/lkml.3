Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab3COPma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 11:42:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6743 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab3COPm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 11:42:28 -0400
Date: Fri, 15 Mar 2013 11:41:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH] integrity: Use a new type for asymmetric signature
Message-ID: <20130315154151.GA3887@redhat.com>
References: <20130314182815.GB24238@redhat.com>
 <CALLzPKZgSjtodeikffsRyZrq5eS92ziLm3NdjWmD878xL_kFVw@mail.gmail.com>
 <20130314203028.GE24238@redhat.com>
 <20130314203703.GF24238@redhat.com>
 <CALLzPKb646eXYCLrgtuNFYx_Y6dWdwNWZM1whJPR1wZBxbVY6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKb646eXYCLrgtuNFYx_Y6dWdwNWZM1whJPR1wZBxbVY6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 11:08:45PM +0200, Kasatkin, Dmitry wrote:
> On Thu, Mar 14, 2013 at 10:37 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Thu, Mar 14, 2013 at 04:30:28PM -0400, Vivek Goyal wrote:
> >
> > [..]
> >> I thought explicitly using signature format is more intutive. Exporting
> >> signature version is not. I personally associate versioning with minor
> >> changes like addition of some fields etc.
> >
> > For instance, you might want to add some fields to  signature_v2_hdr down
> > the line. I think even after that change, it still remains "asymmetric
> > signature" just that structure size changes and there is additional
> > info. If there is versioning info assciated with signature type
> > ASYMMETRIC, we could simple bump it to 1.1 or whatever and keep the
> > version detail internal to ima/integrity subsystem.
> >
> 
> Yes, it will make some things cleaner.

So do you agree that every new signature format should have a new entry
and we can introduce new signature type for asymmetric signature.

> We recently discussed with Mimi how to extend IMA with memory locking and
> one of the ideas was to use a flag in the signature header to indicate
> that we need
> require memory locking. There we need new subversion of the asymmetric
> signature type.

I have few concerns here.

- Whether a file should be mem locked or not is not file property. It
  should not be stored in the file signature when file is being signed.
  Whether file should be locked or not depends on the caller and that
  in turn depends on the system environment.

  For example, one can create a system where whole of the user space is
  signed. (Extending secureboot fully to the user space). I think in that
  system one might not need to lock executables/files in memory.

- IMA should not be mmaping files in process address space. IMA does not
  know what should be mapped where. For example, executable files.
  Respective binary loader knows what sections of the file should be
  mapped at what address.

  IIUC, do_mmap_pgoff() will map file at first suitable available address.

  Secondly will IMA return with file mapped and locked or will unmap file
  before returning. If it does not unmap then it can conflict with binary
  loader who wants to map a section of file on a particular address which
  is already used. And if IMA unmaps the file before returning to caller,
  then mapping and mlocking has no benefit.

- Special hardcoded handling of BPRM_CHECK hook sounds like a kludge.

+	if (function == BPRM_CHECK && (iint->flags & IMA_DIGSIG))
+		iint->flags &= ~IMA_DONE_MASK;

  IMA in general has the issue of direct writes to disk. If we want to solve
  the caching issues, these should be solved in general and not be made hook
  specific.

  Even with ima_appraise_tcb policy in effect, there are vulnerabilities.
  ima_appraise_tcb will appraise only root files and a member of group
  "disk" can directly write to disk without being appraised and bypass all
  the caching logic.

- Memory locking will not solve the problem of knowing what did successful
  appraisal mean. User needs to know whether its rule got executed or not
  and based on that it can make a decision.

I really think that it is caller who should decide whether a file should
be locked or not. If there is a need, caller should first map full or part
file at appropriate address range and lock mapped pages in memory and
then call into IMA for signature verification.

> 
> Please have a look to 3 top patches.
> 
> http://git.kernel.org/cgit/linux/kernel/git/kasatkin/linux-digsig.git/log/?h=working
> 
> It is a prototype to verify signature with arbitrary hash algorithm.

Thanks. I had a quick look. Hash related improvements look fine to me.

> Top patch also locks the memory if executable is verified and it has
> asymmetric signature type.

I have concerned with ima memory locking as mentioned above. We need to
have some discussion here first w.r.t what problem we are solving by
locking files on bprm_check hook and whether it is appropriate to do
it in IMA or not.

> This unconditional locking is just for development and we might use
> mlock bit from signature header.

As mentioned above, I have concerns here. Whether a file should be
memlocked or not is not a property of file or file signature.

> Notice, that patch reset appraisal status when we get BPRM check and
> there is a signature.

This is also shouds like a kludge. Why BPRM_CHECK only is special. Same
problem will exist with any other measurement hook, isn't it.

> 
> BTW, do you have a kernel repository somewhere.
> It is often easier to understand and discuss when seeing "complete"
> set of commits.

No, I don't have yet. The moment I have something (even in raw form), I 
will post patches as RFC. If things still don't work, I will setup a 
repository somewhere.

Thanks
Vivek
