Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab3AQQWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 11:22:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:15808 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757108Ab3AQQWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 11:22:50 -0500
MIME-Version: 1.0
In-Reply-To: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
Date: Thu, 17 Jan 2013 18:22:47 +0200
Message-ID: <CALLzPKZgVUF4_ovyR48BddF33w0pBPvdhxtTQ5bk3M1H1N2LWA@mail.gmail.com>
Subject: Re: [PATCH 0/3] ELF executable signing and verification
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        zohar@linux.vnet.ibm.com, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 11:34 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi,
>
> This is a very crude RFC for ELF executable signing and verification. This
> has been done along the lines of module signature verification.
>
> Why do we need it
> =================
> With arrival of secureboot, sys_kexec() is deemed dangerous. One can
> effectively bypass the secureboot feature and run its own kernel. So
> matthew garret proposed disabling sys_kexec() in secureboot mode.
>
> https://lkml.org/lkml/2012/9/4/225
>
> Later in a separate thread it was discussed how to handle the issue
> of sys_kexec() with secureboot.
>
> https://lkml.org/lkml/2012/10/24/451
>
> My takeaway from discussion was that we need to sign /sbin/kexec. Signed
> executable can get extra capability and we can allow/disallow access to
> sys_kexec() based on that capability (Thanks to Eric Biederman for the
> idea).
>
> So that's my motivation to make user space signing work so that I can
> get kdump working with secureboot enabled. There might be other people
> who might find it useful in general.
>
> What does it do
> ===============
> I have written a utility "signelf" which can take a private key and
> an x509 certificate and sign an ELF executable. This is very much done
> along the lines of module signing. There are two major differences.
> Signature are put in a section ".signature" instead of being appended
> to executable. And we calculate digest of only PT_LOAD segments and not
> the whole executable file.
>
> Upon exec(), we determine if executable is signed. If it is, then locks
> down the pages in memory (using MAP_LOCKED) and verfies the signature.
> If signature does not match, process is killed. Unsigned processes
> don't get affected at all.
>
> Currently it is expected to use these patches only for statically linked
> executables. No dynamic linking. In fact patches specifically disable
> calling interpreter. This does not prevent against somebody using dlopen()
> sutff. So don't sign binaries which do that.

How dynamic linking and interpreter are related together?

This is rather policy than enforcement.
Protection works only for statically linked binaries, because dynamic
libraries are not verified.

- Dmitry

>
> HOWTO
> =====
> Currently module signing keys are automatically loaded in module keyring
> so it is easiest to sign executable using the keys generated for module
> signing.
>
> - Compile and boot into kernel with following options enabled.
>         - CONFIG_MODULE_SIG=y
>         - CONFIG_BINFMT_ELF_SIGNATURE=y
>         - CONFIG_CRYPTO_SHA256=y
>
> - Compile "signelf" utility (Attached in a patch)
>
> - Install glibc-static
>
> - Compile a test program (say hello-world.c). Link statically with glibc
>         gcc hello-world.c -o hello-world -static
>
> - Sign hello_world using keys generated during kernel build.
>         signelf -i hello-world -o hello-world.signed -p linux-2.6/signing_key.priv -c linux-2.6/signing_key.x509
>
> - Run signed executable
>         ./hello-world.signed
>
> This should run successfully. Now one can generate another pair of keys
> and certificate and sign same binary using new keys. This new binary should
> fail to execute as corresponding keys are not loaded in kernel.
>
>         openssl req -new -nodes -utf8 -sha256 -days 36500 -batch -x509 -config linux-2.6/x509.genkey -outform DER -out new_signing_key.x509 -keyout new_signing_key.priv
>
>         signelf -i hello-world -o hello-world.signed.new -p new_signing_key.priv -c new_signing_key.x509
>
> - Run this signed executable
>         ./hello-world.signed.new
>         Killed
>
> TODO
> ====
> - kexec related patches are yet to be done.
> - Disable ptrace to signed processes so that one can not modify code/data
>   of signed process.
> - Sort out issues related to how key used for user space signing is loaded
>   in kernel keyring.
> - Sort out issues related to sharing keyring with modules.
>
> Thanks
> Vivek
> Vivek Goyal (3):
>   module: export couple of functions for use in process signature
>     verification
>   binfmt_elf: Verify signature of signed elf binary
>   binfmt_elf: Do not allow exec() if signed binary has intepreter
>
>  fs/Kconfig.binfmt       |    7 +
>  fs/binfmt_elf.c         |  465 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/module.h  |    8 +
>  kernel/module_signing.c |    4 +-
>  4 files changed, 482 insertions(+), 2 deletions(-)
>
> --
> 1.7.7.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
