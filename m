Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab3KQDvm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 22:51:42 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:50096 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031Ab3KQDve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 22:51:34 -0500
Message-ID: <1384660289.5181.8.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 9/9] KEYS: Fix encrypted key type update method
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: d.kasatkin@samsung.com, zohar@us.ibm.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 16 Nov 2013 22:51:29 -0500
In-Reply-To: <29885.1384451991@warthog.procyon.org.uk>
References: <1384368349.2550.17.camel@dhcp-9-2-203-236.watson.ibm.com>
	 <20131104162216.10177.98067.stgit@warthog.procyon.org.uk>
	 <20131104162321.10177.34033.stgit@warthog.procyon.org.uk>
	 <29885.1384451991@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111703-0928-0000-0000-000003C2F7FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-11-14 at 17:59 +0000, David Howells wrote:
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > Is there a keyutils git repo with a version of keyctl that supports the
> > control option?
> 
> http://git.kernel.org/cgit/linux/kernel/git/dhowells/keyutils.git/log/?h=development

Thanks!

> > - type size_t is unsigned, no need to verify that it is negative.
> 
> It doesn't hurt either...
> 
> > - missing Documentation/security/keys-trusted-encrypted.txt updates
> 
> Fixed (see diff below), but I suspect trusted_update() also needs scrutiny.
> 
> > - the encrypted_preparse() comment still says 'encrypted_instantiate'
> 
> Fixed.
> 
> David
> ---
> diff --git a/Documentation/security/keys-trusted-encrypted.txt b/Documentation/security/keys-trusted-encrypted.txt
> index e105ae97a4f5..78794adf445d 100644
> --- a/Documentation/security/keys-trusted-encrypted.txt
> +++ b/Documentation/security/keys-trusted-encrypted.txt
> @@ -61,7 +61,7 @@ Usage:
>      keyctl add encrypted name "new [format] key-type:master-key-name keylen"
>          ring
>      keyctl add encrypted name "load hex_blob" ring
> -    keyctl update keyid "update key-type:master-key-name"
> +    keyctl control keyid encrypted change-master-key "key-type:master-key-name"
> 
>  format:= 'default | ecryptfs'
>  key-type:= 'trusted' | 'user'

The command has remained the same as before: "update key-type:master-key-name".

diff --git a/Documentation/security/keys-trusted-encrypted.txt b/Documentation/security/keys-trusted-encrypted.txt
index e105ae9..6610be4 100644
--- a/Documentation/security/keys-trusted-encrypted.txt
+++ b/Documentation/security/keys-trusted-encrypted.txt
@@ -61,12 +61,12 @@ Usage:
     keyctl add encrypted name "new [format] key-type:master-key-name keylen"
         ring
     keyctl add encrypted name "load hex_blob" ring
-    keyctl update keyid "update key-type:master-key-name"
+    keyctl control <keyid> encrypted change-master-key \
+		"update key-type:master-key-name"
 
 format:= 'default | ecryptfs'
 key-type:= 'trusted' | 'user'
 
-
 Examples of trusted and encrypted key usage:
 
 Create and save a trusted key named "kmk" of length 32 bytes:
@@ -153,6 +153,12 @@ Load an encrypted key "evm" from saved blob:
     82dbbc55be2a44616e4959430436dc4f2a7a9659aa60bb4652aeb2120f149ed197c564e0
     24717c64 5972dcb82ab2dde83376d82b2e3c09ffc
 
+Encrypt the "evm" key with a new master key kmk-new:
+
+    $ keyctl add trusted kmk-new "new 32" @u
+    $ keyctl control 831684262 encrypted change-master-key \
+	"update trusted:kmk-new"
+
 Other uses for trusted and encrypted keys, such as for disk and file encryption
 are anticipated.  In particular the new format 'ecryptfs' has been defined in
 in order to use encrypted keys to mount an eCryptfs filesystem.  More details


thanks,

Mimi



