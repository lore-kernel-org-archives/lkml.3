Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3KVS5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:57:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755773Ab3KVS5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:57:34 -0500
Date: Fri, 22 Nov 2013 13:57:06 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, ebiederm@xmission.com, hpa@zytor.com,
        Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 4/6] kexec: A new system call, kexec_file_load, for in
 kernel kexec
Message-ID: <20131122185706.GK4046@redhat.com>
References: <1384969851-7251-1-git-send-email-vgoyal@redhat.com>
 <1384969851-7251-5-git-send-email-vgoyal@redhat.com>
 <20131121190350.GC17070@kroah.com>
 <20131121190620.GA25951@srcf.ucam.org>
 <20131121191305.GK16208@redhat.com>
 <20131121191907.GA26366@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121191907.GA26366@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 07:19:07PM +0000, Matthew Garrett wrote:
> On Thu, Nov 21, 2013 at 02:13:05PM -0500, Vivek Goyal wrote:
> > On Thu, Nov 21, 2013 at 07:06:20PM +0000, Matthew Garrett wrote:
> > > That would require a certain degree of massaging from userspace if we 
> > > want to be able to use the existing Authenticode signatures. Otherwise 
> > > we need to sign kernels twice.
> > 
> > I was thinking oof signing the same kernel twice. Can I sign authenticode
> > signed kernel again (using RSA signature as we do for modules) and append
> > the signature to bzImage. 
> 
> No, you'd need to do it the other way around.

Hmm..., I am running out of ideas here. This is what I understand.

- If I sign the bzImage (using PKCS1.5 signature), and later it is signed
  with authenticode format signatures, then PKCS1.5 signatures will not be
  valid as PE/COFF signing will do some modification to PE/COFF header in
  bzImage. And another problem is that then I don't have a way to find
  PKCS1.5 signature.

- If bzImage is first signed with authenticode format signature and then
  signed using PKCS1.5 signature, then  authenticode format signature
  will become invalid as it will also hash the data appened at the end
  of file.

So looks like both signatures can't co-exist on same file. That means
one signature has to be detached.

I am beginning to think that create a kernel option which allows to choose
between attached and detached signatures. Extend kexec syscall to allow
a parameter to pass in detached signatures. If detached signatures are
not passed, then look for signatures at the end of file. That way, those
who are signing kernels using platform specific format (authenticode) in 
this case, they can generate detached signature while others can just
use attached signatures.

Any thoughts on how this should be handled?

Thanks
Vivek
