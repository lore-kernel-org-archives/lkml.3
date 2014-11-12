Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaKLNlJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:41:09 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49944 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaKLNlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:41:07 -0500
Date: Wed, 12 Nov 2014 14:41:04 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Paul Burton <paul.burton@imgtec.com>, linux-mips@linux-mips.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] binfmt_elf: allow arch code to examine PT_LOPROC
 ... PT_HIPROC headers
Message-ID: <20141112134059.GA12619@ulmo>
References: <1410420623-11691-1-git-send-email-paul.burton@imgtec.com>
 <1410420623-11691-4-git-send-email-paul.burton@imgtec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <1410420623-11691-4-git-send-email-paul.burton@imgtec.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2014 at 08:30:16AM +0100, Paul Burton wrote:
> MIPS is introducing new variants of its O32 ABI which differ in their
> handling of floating point, in order to enable a gradual transition
> towards a world where mips32 binaries can take advantage of new hardware
> features only available when configured for certain FP modes. In order
> to do this ELF binaries are being augmented with a new section that
> indicates, amongst other things, the FP mode requirements of the binary.
> The presence & location of such a section is indicated by a program
> header in the PT_LOPROC ... PT_HIPROC range.
>=20
> In order to allow the MIPS architecture code to examine the program
> header & section in question, pass all program headers in this range
> to an architecture-specific arch_elf_pt_proc function. This function
> may return an error if the header is deemed invalid or unsuitable for
> the system, in which case that error will be returned from
> load_elf_binary and upwards through the execve syscall.
>=20
> A means is required for the architecture code to make a decision once
> it is known that all such headers have been seen, but before it is too
> late to return from an execve syscall. For this purpose the
> arch_check_elf function is added, and called once, after all PT_LOPROC
> to PT_HIPROC headers have been passed to arch_elf_pt_proc but before
> the code which invoked execve has been lost. This enables the
> architecture code to make a decision based upon all the headers present
> in an ELF binary and its interpreter, as is required to forbid
> conflicting FP ABI requirements between an ELF & its interpreter.
>=20
> In order to allow data to be stored throughout the calls to the above
> functions, struct arch_elf_state is introduced.
>=20
> Finally a variant of the SET_PERSONALITY macro is introduced which
> accepts a pointer to the struct arch_elf_state, allowing it to act
> based upon state observed from the architecture specific program
> headers.
>=20
> Signed-off-by: Paul Burton <paul.burton@imgtec.com>
> ---
>  fs/Kconfig.binfmt   |  3 +++
>  fs/binfmt_elf.c     | 36 ++++++++++++++++++++++++--
>  include/linux/elf.h | 73 +++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  3 files changed, 110 insertions(+), 2 deletions(-)

Hi Ralf,

This commit showed up in linux-next and causes a warning in linux/elf.h
because it doesn't know struct file. I've fixed it locally with this:

---
diff --git a/include/linux/elf.h b/include/linux/elf.h
index 6bd15043a585..dac5caaa3509 100644
--- a/include/linux/elf.h
+++ b/include/linux/elf.h
@@ -4,6 +4,8 @@
 #include <asm/elf.h>
 #include <uapi/linux/elf.h>
=20
+struct file;
+
 #ifndef elf_read_implies_exec
   /* Executables for which elf_read_implies_exec() returns TRUE will
      have the READ_IMPLIES_EXEC personality flag set automatically.
---

Would you mind squashing that into the above commit to get rid of the
warning?

Thierry

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUY2NrAAoJEN0jrNd/PrOhMZAP/ip2wx0tCBbkgiDNfM9HOXxN
GZ0klGP3rHX4XS5YDPySPCW+y78I37vmm8p0yAduAXxoDeN6keLnfYPHHSiqV4yM
lmJTZKIcC19TmYGlMQHjNFJRFoVpiRDqHtin6Jq21nCdP/qp/28WxTos8oTpwrA1
ILHSFa71C04EYbyX1DQjYaOt2miHRLnFQNfR1t75lG7tGel1HQbyLRyTiAHHUncZ
KH7Xwojt9RZQKn9MvCMBtVK86KRYFjuRP8UIaKtktfiw5rGfFFXB7M+enJQVnVsy
MQpg2bC3uUlT9E9KVxUjRX4h4IXc5UYiqEDObAUZ6q/8mICVNS4pNYy4khP0I9hj
fShM4S2bUeDfB48FDEiwyqvFdvfFC3Bl91ajYTYld2B2D9EiecrFU5ze5onrMW0A
fkeXCZA4Yn/POHSio3JYFvMAOBDa8XDZ3TgmcYPqfLpYB6Kej1d04ApO3S3klz09
71RCj27HiXBN1NCF+tH7NUsZkzkYTe+zJO2JXnHkK+rpSTISmhJxgJj+gbrrS5MS
iMcOhITSJ4tm0WX3viQmLsecXz/czy/L0P1kDkxdWS067uaRMJKHVDKuw5c/3GL1
tfP479DOsKezpAUfdZbQY6dWAlmoQqhIgC8UZxH2Km4lZRNQ1+8dAevKB896ivx1
CXROQdROu1FcBeNtkNa9
=kOJM
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
