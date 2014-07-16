Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaGPU0w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:26:52 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:63489 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaGPU0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:26:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140715143315.eef78daf3eb41ef0d61f30d1@linux-foundation.org>
References: <cover.1405428802.git.d.kasatkin@samsung.com>
	<20140715143315.eef78daf3eb41ef0d61f30d1@linux-foundation.org>
Date: Wed, 16 Jul 2014 23:26:46 +0300
Message-ID: <CACE9dm-FdxDb5ifFfOfQUbU=j7A81NBYWhHJu8LmyCMdD2==5g@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] ima: require signed user-space initialization
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


On Wed, Jul 16, 2014 at 12:33 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 15 Jul 2014 15:54:19 +0300 Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>
>> Currently secure IMA/EVM initialization has to be done from the initramfs,
>> embedded in the signed kernel image. Many systems do not want to use
>> initramfs or usage of embedded initramfs makes it difficult to have
>> multi-target kernels.
>>
>> This is a very simple patchset which makes it possible to perform secure
>> initialization by requiring initial user-space to be signed.
>>
>> It does it by:
>> - introducing IMA public keys loading hook
>> - loading IMA trusted public key into .ima trusted keyring
>> - making default IMA appraisal policy to require everything to be signed
>>
>> When builtin initramfs is not in use, keys cannot be read from initcalls,
>> because root filesystem is not yet mounted. In order to read keys before
>> executing init process, ima_prepare_keys() hook is introduced. Reading
>> public keys from the kernel is justified because signature verification
>> key is needed in order to verify anything else which is read from the
>> file system. Public keys are X509 certificates and itself signed by the
>> trusted key from the .system keyring. Kernel BIG KEYS support is an example
>> of reading keys directly by the kernel.
>>
>> CONFIG_IMA_APPRAISE_SIGNED_INIT kernel option is provided to make the IMA
>> default appraisal policy to required signature validation. Signed init
>> process need to initialize EVM key and load appropriate IMA policy which
>> would not require everything to be signed.
>>
>> Unless real '/sbin/init' is signed, a simple and practical way is to place
>> all signed programs, libraries, scripts and configuration files under
>> dedicated directory, for example '/ima', and run signed init process by
>> providing a kernel command line parameter 'init=/ima/init'
>
> The kernel may already have loaded kernel modules before it gets around
> to mounting rootfs and running /sbin/init.  How does that fit into the
> overall signing scheme?  And how did /sbin/modprobe get its signature
> checked?
>
>

If kernel embedded initramfs is in use then it is signed together with kernel,
and this functionality is not needed and no need to enable it with
kernel configuration.

As it is IMA extensions and it is entirely based on IMA functionality
it requires
extended attribute support.

If externally loaded initramfs is used, then that one uses cpio based
archive that
does not support extended attributes and thus external initramfs cannot be used
for secure initialization.

This functionality is targeted to be used without initramfs on normal
filesystems
supporting xattrs. In such case, modprobe cannot be loaded before
rootfs is mounted.
Any filesystems and block device drivers obviously need to be embedded
into the kernel.
In the place where ima_prepare_keys() hooks is called, we have

   ima_prepare_keys();
   load_default_modules();

So we load keys after mounting rootfs and before calling load_default_modules().
So if anything useful kernel loads with load_default_modules, will be
loaded after
IMA key is available and thus modprobe will be verified.


> The proposed interface and implementation look reasonable to me.
> Opening and reading a file from the root fs is a bit unusual, but we
> already do something similar with "/sbin/init" and the reasoning here
> is similar.
>
> The only alternative I can immediately think of is to bundle the public
> keys into a kernel module and load them into the kernel that way but
>
> - if/when we implement module signing, we have a chicken-and-egg problem
>
> - doing it via a kernel module seems a bit fake - a bit of trickery
>   to reduce code duplication.  Better to do it explicitly.
>

This was the idea. Kernel has embedded certificate signing key on the
.system keyring. Filesystem image/package can come with own signing key
and that one is loaded and verified by existing KEY infrastructure.
Entire signed init code can come as rpm or deb package with its own key.
That is benefit of loading key.

>
> One thing I'm wondering: integrity_read_file() is a very simple
> open-file-and-slurp-it-into-memory.  Have you checked whether other
> code sites are doing the same thing?  Perhaps integrity_read_file()
> should be in ./lib/ and other callsites can be converted to share it?
>

Yes, indeed, I saw. For code cleanness for posting I thought to have
it all belonging to integrity subsystem. I can make it as additional patch
for the next post to show how to "refactor" common code and if needed to
squash it.

> That comment in integrity_read_file() is completely useless :(
>
>

Ough, you mean /* should be ima_kernel_read */ ??

The thing is that ima_kernel_read which is used to read file for hashing
does not honor security checks.. Indeed, kernel must read it regardless
any obstacles. The same is here with keys...
I worked on this patch in parallel I introduced ima_kernel_read.

So if ima_kernel_read would be used, then we cannot share integrity_read_file
as they other code uses kernel_read and honors security checks.

We had discussion with Mimi on list to move and rename ima_kernel_read
as "kernel_read_nosec" or something like that. It was once suggested
by Eric Biederman.
So then we could have such "helper" function.

Let us think about it.

Thank you for commenting.

-Dmitry
