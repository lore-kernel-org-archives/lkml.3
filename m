Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbaG2VhJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 17:37:09 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:54191 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbaG2VhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 17:37:06 -0400
MIME-Version: 1.0
In-Reply-To: <1406142529.14764.63.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <cover.1405428802.git.d.kasatkin@samsung.com>
	<20140715143315.eef78daf3eb41ef0d61f30d1@linux-foundation.org>
	<CACE9dm-FdxDb5ifFfOfQUbU=j7A81NBYWhHJu8LmyCMdD2==5g@mail.gmail.com>
	<1406142529.14764.63.camel@dhcp-9-2-203-236.watson.ibm.com>
Date: Tue, 29 Jul 2014 23:37:04 +0200
Message-ID: <CACE9dm_gvLJG05D+siBS-dV1CtQU2Pj6gQZv1Q7uN88YK5QO3A@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] ima: require signed user-space initialization
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-ima-devel@lists.sourceforge.net,
        linux-security-module <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sergey Poznyakoff <gray@gnu.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 9:08 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Wed, 2014-07-16 at 23:26 +0300, Dmitry Kasatkin wrote:
>> Hello,
>>
>>
>> On Wed, Jul 16, 2014 at 12:33 AM, Andrew Morton
>> <akpm@linux-foundation.org> wrote:
>> > On Tue, 15 Jul 2014 15:54:19 +0300 Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>> >
>> >> Currently secure IMA/EVM initialization has to be done from the initramfs,
>> >> embedded in the signed kernel image. Many systems do not want to use
>> >> initramfs or usage of embedded initramfs makes it difficult to have
>> >> multi-target kernels.
>> >>
>> >> This is a very simple patchset which makes it possible to perform secure
>> >> initialization by requiring initial user-space to be signed.
>> >>
>> >> It does it by:
>> >> - introducing IMA public keys loading hook
>> >> - loading IMA trusted public key into .ima trusted keyring
>> >> - making default IMA appraisal policy to require everything to be signed
>> >>
>> >> When builtin initramfs is not in use, keys cannot be read from initcalls,
>> >> because root filesystem is not yet mounted. In order to read keys before
>> >> executing init process, ima_prepare_keys() hook is introduced. Reading
>> >> public keys from the kernel is justified because signature verification
>> >> key is needed in order to verify anything else which is read from the
>> >> file system. Public keys are X509 certificates and itself signed by the
>> >> trusted key from the .system keyring. Kernel BIG KEYS support is an example
>> >> of reading keys directly by the kernel.
>> >>
>> >> CONFIG_IMA_APPRAISE_SIGNED_INIT kernel option is provided to make the IMA
>> >> default appraisal policy to required signature validation. Signed init
>> >> process need to initialize EVM key and load appropriate IMA policy which
>> >> would not require everything to be signed.
>> >>
>> >> Unless real '/sbin/init' is signed, a simple and practical way is to place
>> >> all signed programs, libraries, scripts and configuration files under
>> >> dedicated directory, for example '/ima', and run signed init process by
>> >> providing a kernel command line parameter 'init=/ima/init'
>> >
>> > The kernel may already have loaded kernel modules before it gets around
>> > to mounting rootfs and running /sbin/init.  How does that fit into the
>> > overall signing scheme?  And how did /sbin/modprobe get its signature
>> > checked?
>> >
>> >
>>
>> If kernel embedded initramfs is in use then it is signed together with kernel,
>> and this functionality is not needed and no need to enable it with
>> kernel configuration.
>>
>> As it is IMA extensions and it is entirely based on IMA functionality
>> it requires extended attribute support.
>>
>> If externally loaded initramfs is used, then that one uses cpio based
>> archive that does not support extended attributes and thus external
>> initramfs cannot be used for secure initialization.
>
> Right, but GNU tar version 1.27.1 supports Posix.1 (ustar) format, which
> has xattr support.  GNU CPIO supports the Posix.1 tar format.  The
> question is whether CPIO supports the included xattrs.
>
>> This functionality is targeted to be used without initramfs on normal
>> filesystems supporting xattrs. In such case, modprobe cannot be loaded before
>> rootfs is mounted. Any filesystems and block device drivers obviously
>> need to be embedded into the kernel. In the place where
>> ima_prepare_keys() hooks is called, we have
>>
>>    ima_prepare_keys();
>>    load_default_modules();
>>
>> So we load keys after mounting rootfs and before calling load_default_modules().
>> So if anything useful kernel loads with load_default_modules, will be
>> loaded after IMA key is available and thus modprobe will be verified.
>>
>>
>> > The proposed interface and implementation look reasonable to me.
>> > Opening and reading a file from the root fs is a bit unusual, but we
>> > already do something similar with "/sbin/init" and the reasoning here
>> > is similar.
>> >
>> > The only alternative I can immediately think of is to bundle the public
>> > keys into a kernel module and load them into the kernel that way but
>> >
>> > - if/when we implement module signing, we have a chicken-and-egg problem
>> >
>> > - doing it via a kernel module seems a bit fake - a bit of trickery
>> >   to reduce code duplication.  Better to do it explicitly.
>> >
>>
>> This was the idea. Kernel has embedded certificate signing key on the
>> .system keyring. Filesystem image/package can come with own signing key
>> and that one is loaded and verified by existing KEY infrastructure.
>> Entire signed init code can come as rpm or deb package with its own key.
>> That is benefit of loading key.
>
> Ok, this type of solution addresses the concerns of devices, but we also
> need a viable solution for systems with an initramfs.
>
> Mimi
>

Sorry for the late reply. I am on holidays at the moment.

Offered solution is simple one to work without initramfs.

When using initramfs, one approach is that it can be be embedded into
the kernel.

When initramfs is separate, offered solution would work as well, but
it would require initramfs container, which is 'cpio' would support
extended attributes. cpio does not support them. 'cpio' maintainer
Sergey Poznyakoff replied in my email to him that it would require
standardization work. He suggested that it is better to use 'tar'
archive which supports xattrs. Using tar for initramfs would require
initramfs tool changes across all distros and kernel. As I said above
offered solution would work as well for initramfs without any changes
if initramfs container would support xattrs... So further extensions
are not related to this patchset.

Thanks,
Dmitry
