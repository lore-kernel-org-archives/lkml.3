Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaFLTPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:15:23 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:54057 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbaFLTPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:15:14 -0400
MIME-Version: 1.0
In-Reply-To: <20140612190509.GM9578@redhat.com>
References: <cover.1402387862.git.d.kasatkin@samsung.com>
	<ef22f2630a2545bd7c3bf2c9e730a842835cf6c4.1402387862.git.d.kasatkin@samsung.com>
	<20140612160346.GG9578@redhat.com>
	<5399E22D.9070205@samsung.com>
	<20140612173236.GK9578@redhat.com>
	<CACE9dm9UHixujYR==_ybKZr2gvEFm+gmRMaD-V2aeNQ7J6jQ8w@mail.gmail.com>
	<20140612190154.GL9578@redhat.com>
	<20140612190509.GM9578@redhat.com>
Date: Thu, 12 Jun 2014 22:15:11 +0300
Message-ID: <CACE9dm9CgJWQVWSi4Zgty5s6hdzOwwjX_nEeG9v5JK=wrLN-ng@mail.gmail.com>
Subject: Re: [PATCH 3/4] KEYS: validate key trust only with selected owner key
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        keyrings <keyrings@linux-nfs.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 June 2014 22:05, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Jun 12, 2014 at 03:01:54PM -0400, Vivek Goyal wrote:
>> On Thu, Jun 12, 2014 at 09:36:46PM +0300, Dmitry Kasatkin wrote:
>> > On 12 June 2014 20:32, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > > On Thu, Jun 12, 2014 at 08:23:57PM +0300, Dmitry Kasatkin wrote:
>> > >> On 12/06/14 19:03, Vivek Goyal wrote:
>> > >> > On Tue, Jun 10, 2014 at 11:48:17AM +0300, Dmitry Kasatkin wrote:
>> > >> >> This patch provides kernel parameter to specify owner's key id which
>> > >> >> must be used for trust validate of keys. Keys signed with other keys
>> > >> >> are not trusted.
>> > >> >>
>> > >> >> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
>> > >> > Hi,
>> > >> >
>> > >> > I am continuing to work on verifying kernel signature for kexec/kdump. I
>> > >> > am planning to take david howell's patches for pkcs7 signature
>> > >> > verification and verify bzImage signature.
>> > >> >
>> > >> > Part of that process will boil down to verifying a certificate in
>> > >> > pkcs7 x509 cert chain using a key in system_trusted_keyring.
>> > >> >
>> > >> > I think the OS vendor key which signs the kernel signing key propagates to
>> > >> > system_trusted_keyring. (shim has that and I am not sure how shim makes
>> > >> > it propogate all they way to system_trusted_keyring).
>> > >> >
>> > >> > So I was planning to use same functionality where I look for any key
>> > >> > which can verify the signing cert of kernel. As OS vendor key will be
>> > >> > in system_trusted_keyring, it should work.
>> > >> >
>> > >> > Now with this change where you will trust only one selected owner key.
>> > >> > That means you will not even trust the OS vendor key which signs kernel
>> > >> > signing key. I think this will stop working with  keys_ownerid=<....>
>> > >> >
>> > >> > As I am doing that work in parallel and I saw these patches, I thought
>> > >> > I will bring it up.
>> > >>
>> > >> Hi Vivek,
>> > >>
>> > >> All keys stays in the keyring. Usage of owner_keyid is limited to
>> > >> validate the trust of the loaded keys.
>> > >
>> > > Hi Dmitry,
>> > >
>> > > If owner_keyid scope is just limited to loading extra keys, then it
>> > > should be fine as I don't want to load extra keys. I just want to
>> > > verify already signed image whose key is supposed to be in
>> > > system_trusted_keyring.
>> > >
>> > >>
>> > >>
>> > >> Do you really see OS verndor key (Fedora) on the system keyring?
>> > >> shim is UEFI binary and can add it to the MOK database..
>> > >
>> > > I have been told that mechanism to propagate they key in shim which is
>> > > used to verify kernel signature is in place and that key should show
>> > > up in system_trusted_keyring. I have never verified it though. I will
>> > > check it out.
>> > >
>> > > Thanks
>> > > Vivek
>> >
>> >
>> > Hi Vivek,
>> >
>> > The easiest way to get OS Vendor ker/certificate is just embed it into
>> > the kernel along with
>> > ephemeral (or not) module signing key... They all appears on .system keyring...
>>
>> I think it will be tricky as in current setup, signing happens on a different
>> server and build server does not have access to keys.
>
> Apart from this, all the builds might not signed. And at build time it is
> might not known if a particular build will be signed with final keys or not.
> One might decide to sign kernel based on testing results post build. So
> embedding the kernel signing key in the kernel during build is little
> tricky from process point of view.
>
> Thanks
> Vivek


Please note, kernel signing key is not embedded to the kernel..
It is certificate/public key.

bootloader has embedded OS vendor certificate.
It is "well known" and public.

Distro might have multiple kernels installed and all of them must boot.
Kernel updates will come signed with the same key...
So all kernels probably signed with the same distro private key or
multiple public keys need to be embedded into the bootloader.

So kernel signing key is not ephemeral but managed and stored
somewhere secretly.

There is no problem to distribute public key...

-- 
Thanks,
Dmitry
