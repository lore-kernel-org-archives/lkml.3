Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442Ab3APQfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:35:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758431Ab3APQf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:35:29 -0500
Date: Wed, 16 Jan 2013 11:34:53 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, hpa@zytor.com, dhowells@redhat.com,
        jwboyer@redhat.com, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
Message-ID: <20130116163453.GD29845@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
 <871udloiku.fsf@xmission.com>
 <1358312159.4593.37.camel@falcor1>
 <87wqvdli1o.fsf@xmission.com>
 <1358344859.4593.66.camel@falcor1>
 <20130116144836.GB29845@redhat.com>
 <1358350391.4593.112.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358350391.4593.112.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 10:33:11AM -0500, Mimi Zohar wrote:
> On Wed, 2013-01-16 at 09:48 -0500, Vivek Goyal wrote:
> > On Wed, Jan 16, 2013 at 09:00:59AM -0500, Mimi Zohar wrote:
> > > On Tue, 2013-01-15 at 23:10 -0800, Eric W. Biederman wrote:
> > > > Mimi Zohar <zohar@linux.vnet.ibm.com> writes:
> > > > 
> > > > > Please remind me why you can't use IMA-appraisal, which was upstreamed
> > > > > in Linux 3.7?  Why another method is needed?
> > > > 
> > > > Good question Vivek?  
> > 
> > - IMA did not have any method to lock down signed binary pages in memory.
> >   So while contents on disk could be verified, one could still modify
> >   process memory contents by modifying swap. And IMA does not seem to
> >   have any mechanism to protect against that.
> 
> The kernel itself protects executables from being modified by calling
> try_module_get().

try_module_get() just takes a reference on module, isn't it? So in this
case take reference on binary loader module.

> The call to security_bprm_check() is immediately before this call.

I read the comment in ima_bprm_check() being called from security_bprm_check(). 
It says that files already open for write can't executed and files already
open for exec can't be open for writes. That's fine. 

I was worried about anonymous pages being modified on swap and then
faulted back in. It is not necessarily signature verification but making
sure signed processes memory is not modified later by any unsigned process
in anyway. And that includes disabling ptrace too.

So IMA stuff does not do anything to protect against process memory being
modified using ptrace or by playing tricks with swap.

I am not sure what will happen if I can bypass the file system and directly
write on a disk block and modify executable. (Assuming one can get block
information somehow). Does anything protect such modification? Will IMA
detect it?

Thanks
Vivek
