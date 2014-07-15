Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbaGOVdX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:33:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44110 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932952AbaGOVdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:33:16 -0400
Date: Tue, 15 Jul 2014 14:33:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, dmitry.kasatkin@gmail.com
Subject: Re: [PATCH v1 0/4] ima: require signed user-space initialization
Message-Id: <20140715143315.eef78daf3eb41ef0d61f30d1@linux-foundation.org>
In-Reply-To: <cover.1405428802.git.d.kasatkin@samsung.com>
References: <cover.1405428802.git.d.kasatkin@samsung.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2014 15:54:19 +0300 Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:

> Currently secure IMA/EVM initialization has to be done from the initramfs,
> embedded in the signed kernel image. Many systems do not want to use
> initramfs or usage of embedded initramfs makes it difficult to have
> multi-target kernels.
> 
> This is a very simple patchset which makes it possible to perform secure
> initialization by requiring initial user-space to be signed.
> 
> It does it by:
> - introducing IMA public keys loading hook
> - loading IMA trusted public key into .ima trusted keyring
> - making default IMA appraisal policy to require everything to be signed
> 
> When builtin initramfs is not in use, keys cannot be read from initcalls,
> because root filesystem is not yet mounted. In order to read keys before
> executing init process, ima_prepare_keys() hook is introduced. Reading
> public keys from the kernel is justified because signature verification
> key is needed in order to verify anything else which is read from the
> file system. Public keys are X509 certificates and itself signed by the
> trusted key from the .system keyring. Kernel BIG KEYS support is an example
> of reading keys directly by the kernel.
> 
> CONFIG_IMA_APPRAISE_SIGNED_INIT kernel option is provided to make the IMA
> default appraisal policy to required signature validation. Signed init
> process need to initialize EVM key and load appropriate IMA policy which
> would not require everything to be signed.
> 
> Unless real '/sbin/init' is signed, a simple and practical way is to place
> all signed programs, libraries, scripts and configuration files under
> dedicated directory, for example '/ima', and run signed init process by
> providing a kernel command line parameter 'init=/ima/init'

The kernel may already have loaded kernel modules before it gets around
to mounting rootfs and running /sbin/init.  How does that fit into the
overall signing scheme?  And how did /sbin/modprobe get its signature
checked?


The proposed interface and implementation look reasonable to me. 
Opening and reading a file from the root fs is a bit unusual, but we
already do something similar with "/sbin/init" and the reasoning here
is similar.

The only alternative I can immediately think of is to bundle the public
keys into a kernel module and load them into the kernel that way but

- if/when we implement module signing, we have a chicken-and-egg problem

- doing it via a kernel module seems a bit fake - a bit of trickery
  to reduce code duplication.  Better to do it explicitly.


One thing I'm wondering: integrity_read_file() is a very simple
open-file-and-slurp-it-into-memory.  Have you checked whether other
code sites are doing the same thing?  Perhaps integrity_read_file()
should be in ./lib/ and other callsites can be converted to share it?

That comment in integrity_read_file() is completely useless :(


