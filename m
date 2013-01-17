Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3AQOjZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 09:39:25 -0500
Received: from mga06.intel.com ([134.134.136.21]:55417 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753083Ab3AQOjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 09:39:24 -0500
MIME-Version: 1.0
In-Reply-To: <20130116182146.GE29845@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	<1358285695-26173-3-git-send-email-vgoyal@redhat.com>
	<871udloiku.fsf@xmission.com>
	<1358312159.4593.37.camel@falcor1>
	<87wqvdli1o.fsf@xmission.com>
	<1358344859.4593.66.camel@falcor1>
	<20130116144836.GB29845@redhat.com>
	<1358350391.4593.112.camel@falcor1>
	<20130116155406.GC29845@redhat.com>
	<1358357079.4593.135.camel@falcor1>
	<20130116182146.GE29845@redhat.com>
Date: Thu, 17 Jan 2013 16:39:21 +0200
Message-ID: <CALLzPKaB6rmNCeKJmHOSNgV2G9CDyhpXCmPaNtGYBRxniwMGKg@mail.gmail.com>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 8:21 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Jan 16, 2013 at 12:24:39PM -0500, Mimi Zohar wrote:
>> On Wed, 2013-01-16 at 10:54 -0500, Vivek Goyal wrote:
>> > On Wed, Jan 16, 2013 at 10:33:11AM -0500, Mimi Zohar wrote:
>> >
>> > [..]
>> > > > - Also I really could not figure out where does the private signing key
>> > > >   lives. I got the impression that we need to trust installer and
>> > > >   signing somehow happens at installation time. And we wanted signing
>> > > >   to happen at build server and could not trust installer for that.
>> > >
>> > > Dmitry's ima-evm-utils package signs files.  Depending on the options,
>> > > both the EVM and IMA extended attributes are created.
>> >
>> > I was going through following presentation.
>> >
>> > http://selinuxproject.org/~jmorris/lss2011_slides/IMA_EVM_Digital_Signature_Support.pdf
>> >
>> > On slide 8, it mentons signing.
>> >
>> >     evmctl sign --imahash /path/to/file
>> >     evmctl sign --imasig /path/to/file
>> >
>> > Can't figure out where does the key for signing come from? Is it already
>> > loaded in any of kernel keyrings.
>> >
>> > If yes, I think this is non-starter. One can not distribute the private
>> > key.
>>
>> No, the default key location is /etc/keys/privkey_evm.pem, but can be
>> specified.  Prior to Dmitry's updating the package yesterday, the last
>> parameter was the key pathname.  After the update, you can specify the
>> key location with the new --key option.
>>
>> > Also I am assuming that this is done at installation time? If yes, then
>> > again it does not work as installer does not have private key.
>>
>> Not necessarily.  The original use case scenario was creating an image
>> with both EVM and IMA digital signatures and then flashing the image.
>
> But distributions don't ship pre-setup root file system. It is created
> and labeled at installation time. So if we want to use IMA, we need to
> sign files at installation time. That means private keys need to be
> accessible to installer (using --key option). And that does not work for
> this use case.
>
>>

This wrong again.. Private should be used during installation time at all...


>> > On slide 11, it talks about importing public keys in kernel keyring from
>> > initramfs. As we discussed this will need modification as these keys
>> > need to be signed and signing public key should already be part of
>> > kernel keyring.
>>
>> It's been a long process upstreaming all the different pieces involved.
>> The initial design/step was to load the public key on a keyring.  Since
>> then we've added support for multiple keyrings(eg. EVM, IMA, etc).  The
>> next step is to tie this in with secure boot.
>>
>> > So looking at the signing process, it really does not look like that
>> > I can sign the executable at build server. It looks it needs to be
>> > signed by installer at install time and private key needs to be available
>> > to installer?
>>
>> No, the build server can sign the files, so the private key is not
>> required on the target.  These signatures need to be included in the
>> package.  Elena Reshetova gave a talk at the last LSS
>> (http://lwn.net/Articles/518265/), describing changes to RPM to write
>> the security extended attributes.
>
> Following is from article.
>
> "The other hooks that Reshetova proposed are associated with the individual
> files in a package. Those would allow things like security labeling or
> calculating hashes on the file contents (for integrity purposes)."
>
> IIUC, these hooks will execute on the target. So hash and all signatures
> should still be generated on target and not build server?
>
> Given the fact that signatures are stored in extended attributes, to me
> the only way to sign executables in current IMA framework would to be
> prepare file system image at build server and ship that image. And
> then installer simply mounts that image (after making sure that proper
> verification keys have been loaded in kernel).
>
> And this image will pretty much be static. As you don't have private key
> you can't install more packages and sign these.
>
> So it will be something like one image per signed package (in worst case).
>
> I don't think starting to ship signed file system images as compared
> to signed files is a better idea.
>
> Thanks
> Vivek
