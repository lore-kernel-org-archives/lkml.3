Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab3AQPv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:51:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755844Ab3AQPv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:51:56 -0500
Date: Thu, 17 Jan 2013 10:51:54 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com, pjones@redhat.com,
        hpa@zytor.com, dhowells@redhat.com, jwboyer@redhat.com
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
Message-ID: <20130117155154.GC12165@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
 <1358285695-26173-3-git-send-email-vgoyal@redhat.com>
 <1358437021.2689.52.camel@falcor1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358437021.2689.52.camel@falcor1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 10:37:01AM -0500, Mimi Zohar wrote:
> On Tue, 2013-01-15 at 16:34 -0500, Vivek Goyal wrote:
> > If a binary is signed, verify its signature. If signature is not valid, do
> > not allow execution. If binary is not signed, execution is allowed
> > unconditionally.
> > 
> > CONFIG_BINFMT_ELF_SIGNATURE controls whether elf binary signature support
> > is compiled in or not.
> > 
> > Signature are expected to be present in elf section ".section". This code
> > is written along the lines of module signature verification code. Just
> > that I have removed the magic string. It is not needed as signature is
> > expected to be present in a specific section.
> 
> Right, it's written along the lines of the original module signature
> verification code, where the signature was in the ELF header, not the
> version that was upstreamed, where the signature was appended.
> 
> > I put the signature into a section, instead of appending it so that
> > strip operation works fine.
> 
> Wouldn't the original reasons for not embedding the signature in the ELF
> header for modules apply here too?  

I think rusty wanted to append signatures. He thought it is much easier.
Adding a .signature section makes life easier for user space tools. One
can strip files even after signing.

Not that I am married to the idea of putting signature in a section. Just
that it sounded reasonable enough to do for an RFC. So if appending 
signature proves to be better, it is easy to implement that.
> 
> > One signs and verifies  all the areas mapped by PT_LOAD segments of elf
> > binary. Typically Elf header is mapped in first PT_LOAD segment. As adding
> > .signature section can change three elf header fields (e_shoff, e_shnum
> > and e_shstrndx), these fields are excluded from digest calculation
> > 
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> 
> At this point, why would you want yet another method for signing files?

Are you saying that append signature instead of putting them in a section
or are you saying that just use IMA.

- For the first, I am fine with appending too if that works better. So
  what's wrong with current implementation. Just because we append the
  signatures in case of modules, we should follow the same thing for
  executables too?

- If above comment is w.r.t use of IMA, then I have no issues in using
  IMA as long as it can meet all the requirements. Looks like there is
  a long TODO list before we get there. In fact for some things its not
  even clear whether they fit in IMA or somehwere else.

  - Make sure IMA/EVM stuff chains into secureboot chain of trust.

  - Sort out all the memory locking related issues I mentioned in
    other mail. You seemed to be of opinion that it is out of scope
    for IMA, but I think it probably is nice extenstion.

    Or somehow a way needs to be found to make sure nobody can modify
    process address space without processe's knowledge.

  - Once all this works, then one needs to figure out all the RPM stuff
    and plugins to make sure files can be singed on build server and
    installed properly on target system.

Thanks
Vivek
