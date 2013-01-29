Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab3A2AOo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 19:14:44 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:36176 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3A2AOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 19:14:42 -0500
Message-ID: <1359418442.3906.188.camel@falcor1>
Subject: Re: [RFC 1/1] ima: digital signature verification using asymmetric
 keys
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>, dhowells@redhat.com,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 28 Jan 2013 19:14:02 -0500
In-Reply-To: <20130128201316.GA14405@redhat.com>
References: <cover.1358246017.git.dmitry.kasatkin@intel.com>
	 <53febcf9f13e59a1ddd8f8c9826cadbe663f2295.1358246017.git.dmitry.kasatkin@intel.com>
	 <1358895228.2408.14.camel@falcor1>
	 <CALLzPKbNVV+iWzUcsxq0Lk-Hz2BVpCBsEbjHdnRAyjDsF5___g@mail.gmail.com>
	 <20130125210157.GA13152@redhat.com>
	 <CALLzPKY9E8VaFf1GUstTnCeYwLOTm6ozdjJFDwSKWk_JR6QF5w@mail.gmail.com>
	 <20130128151527.GA5868@redhat.com>
	 <CALLzPKbjmoLGMVgY-GygZ9ScV1GNHKaKHGYsHc4=CeoYPL4rmw@mail.gmail.com>
	 <20130128185242.GB5868@redhat.com> <1359402694.3906.53.camel@falcor1>
	 <20130128201316.GA14405@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012900-5518-0000-0000-00000B1568CB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-28 at 15:13 -0500, Vivek Goyal wrote:
> On Mon, Jan 28, 2013 at 02:51:34PM -0500, Mimi Zohar wrote:
> > On Mon, 2013-01-28 at 13:52 -0500, Vivek Goyal wrote:
> > > On Mon, Jan 28, 2013 at 05:20:20PM +0200, Kasatkin, Dmitry wrote:
> > > 
> > > [..]
> > > > > Ok. I am hoping that it will be more than the kernel command line we
> > > > > support. In the sense that for digital signatures one needs to parse
> > > > > the signature, look at what hash algorithm has been used  and then
> > > > > collect the hash accordingly. It is little different then IMA requirement
> > > > > of calculating one pre-determine hash for all files.
> > > > 
> > > > Yes... It is obvious. It's coming.
> > > > But in general, signer should be aware of requirements and limitation
> > > > of the platform.
> > > > It is not really a problem...
> > > 
> > > Ok, I have another question. I was looking at your slide deck here.
> > > 
> > > http://selinuxproject.org/~jmorris/lss2011_slides/IMA_EVM_Digital_Signature_Support.pdf
> > > 
> > > Slide 12 mentions that keys are loaded into the kernel from initramfs. If
> > > "root" can load any key, what are we protecting against.
> > > 
> > > IOW, what good ima_appraise_tcb policy, which tries to appraise any root
> > > owned file.  A root can sign all the files using its own key and load its
> > > public key in IMA keyring and then integrity check should pass on all
> > > root files.
> > 
> > > So what's the idea behind digital signature appraisal? By allowing root to
> > > unconditionally load the keys in IMA keyring, it seems to circumvent the
> > > appraisal mechanism.
> > 
> > Vivek, you're asking obvious questions, without understanding that what
> > you want to do is only now possible because of the work that has gone
> > into upstreaming the different components of the linux-integrity
> > subsystem (eg. IMA, trusted/encrypted keys, EVM, (MPI library), and now
> > IMA-appraisal).  In case you weren't aware, Dmitry made the necessary
> > changes so that the MPI library could be upstreamed for
> > EVM/IMA-appraisal digital signature support.
> 
> Hi Mimi,
> 
> Sure. I am just trying to understand that where are we and how can I 
> help improve things so that I can achieve my objectives.

The slides from the LSS 2012 linux-integrity subsystem status update,
are a bit dated, but at least shows where we're headed.

> The problem I am running into is that I can't find a single good 
> documentation here which explains how to use things. There is no
> single .txt file in Documentation/ directory which explains current
> state of affiars or which explains how to use any of the IMA/EVM
> functionality. 

Sorry, I've been lax in updating the linux-ima sourceforge website.
Usage questions should be posted on the linux-ima-user mailing list.

> So I have no way left but to read code and ask obivious questions
> on mailing list to figure out what components are working, what
> components are work in progress or what's the intent of components
> and how they are supposed to be used.

> So are we saying that all the appraisal and digital signature stuff
> is not useful till we figure a way out to lock down IMA keyring. Or
> it is useful only when root can load the keyring but we are trying
> to appraise only non-root files.

The IMA-appraisal hash was originally protected by EVM and the hmac key,
which was loaded once at boot time, from a TPM based trusted key or
initrd entered passphrase.  With IMA-appraisal digital signature
support, a new keyring for the IMA public keys was added, but without
the needed protection.  David Howell's new 'trusted' keyring would be an
excellent solution to control adding public keys.  (Using the term
'trusted' for both a key type and asymmetric keyring is confusing.)

> > I'm pretty sure that keyrings can be locked, preventing additional keys
> > from being added.  (If it isn't currently supported, it needs to be.)
> > The _evm and _ima keyrings should definitely be locked.  When/how this
> > is done, is yet to be defined.  I'm pretty sure there are a number of
> > people thinking about this, including David Howells, Dmitry Kataskin,
> > David Safford and myself.
> > 
> > As I previously said, the next steps are to integrate the
> > EVM/IMA-appraisal public keys in a safe and trusted manner, without
> > breaking the secure boot signature chain.
> 
> In a private conversation David howells mentioned that IMA keyring
> should allow loading only if new key is trusted by an already loaded
> key. He has already posted some patches for marking a keyring trusted
> and loading keys only if it is signed by a trusted key.

Please feel free to post patches for IMA-appraisal to use the new
'trusted' keyring.

> We were wondring that what use case is served by allowing the root
> to load keys unconditionally. By understanding the use case, atleast
> one can try not to break it.

At some point, there was a discussion on adding a new integrity
capability, with making the package installer a guard process.  With the
new 'trusted' keyring type, this probably isn't necessary.  

The 'trusted' keyring is a solution for installing only distro or third
party signed packages.  How would a developer, for instance, create,
sign, and install his own package and add his public key safely?

thanks,

Mimi

