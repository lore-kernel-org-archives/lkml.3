Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbaKKVbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 16:31:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbaKKVbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 16:31:21 -0500
Date: Tue, 11 Nov 2014 16:30:37 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        kexec@lists.infradead.org, Andy Lutomirski <luto@amacapital.net>,
        Dave Young <dyoung@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Borislav Petkov <bp@alien8.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: Edited kexec_load(2) [kexec_file_load()] man page for review
Message-ID: <20141111213037.GA31445@redhat.com>
References: <545FBDDD.9060801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545FBDDD.9060801@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 08:17:49PM +0100, Michael Kerrisk (man-pages) wrote:
> Hello Vivek (and all),
> 
> Thanks for the kexec_file_load() patch [for the kexec_load(2) man page]
> that you quite some time ago sent. I have merged it and done some
> substantial editing as well. Could you please take a look at the 
> draft below, and check that the kexec_file_load() material is okay.
> Please could you especially pay attention to the pieces marked
> "FIXME(kexec_file_load)", since those are pieces about which i
> had questions or doubts.
> 

Hi Michael,

Thanks for editing this man page. I have some thoughts inline.

[..]
> .B #include <linux/kexec.h>
> 
> .BI "long kexec_load(unsigned long " entry ", unsigned long " nr_segments ","
> .BI "                struct kexec_segment *" segments \
> ", unsigned long " flags ");"
> 
> .\" FIXME(kexec_file_load):
> .\"     Why are the return types of kexec_load() and kexec_file_load()
> .\"     different?
> .BI "int kexec_file_load(int " kernel_fd ", int " initrd_fd ","

I think this is ignorance on my part. It probably should be "long" as
SYSCALL_DEFINE() seems to expand to.

asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));


> .br
> .BI "                    unsigned long " cmdline_len  \
> ", const char *" cmdline ","
> .BI "                    unsigned long " flags ");"
> 
> .fi
> .IR Note :
> There are no glibc wrappers for these system calls; see NOTES.
> .SH DESCRIPTION
> The
> .BR kexec_load ()
> system call loads a new kernel that can be executed later by
> .BR reboot (2).
> .PP
> The
> .I flags
> argument is a bit mask that controls the operation of the call.
> The following values can be specified in
> .IR flags :
> .TP
> .BR KEXEC_ON_CRASH " (since Linux 2.6.13)"
> Execute the new kernel automatically on a system crash.
> .\" FIXME Explain in more detail how KEXEC_ON_CRASH is actually used

Upon boot first kernel reserves a chunk of contiguous memory (if
crashkernel=<> command line paramter is passed). This memory is
is used to load the crash kernel (Kernel which will be booted into
if first kernel crashes).

Location of this reserved memory is exported to user space through
/proc/iomem file. User space can parse it and prepare list of segments
specifying this reserved memory as destination.

Once kernel sees the flag KEXEC_ON_CRASH, it makes sure that all the
segments are destined for reserved memory otherwise kernel load operation
fails.

[..]
> struct kexec_segment {
>     void   *buf;        /* Buffer in user space */
>     size_t  bufsz;      /* Buffer length in user space */
>     void   *mem;        /* Physical address of kernel */
>     size_t  memsz;      /* Physical address length */
> };
> .fi
> .in
> .PP
> .\" FIXME Explain the details of how the kernel image defined by segments
> .\" is copied from the calling process into previously reserved memory.

Kernel image defined by segments is copied into kernel either in regular
memory or in reserved memory (if KEXEC_ON_CRASH is set). Kernel first
copies list of segments in kernel memory and then goes does various
sanity checks on the segments. If everything looks line, kernel copies
segment data to kernel memory.

In case of normal kexec, segment data is loaded in any available memory
and segment data is moved to final destination at the kexec reboot time.

In case of kexec on panic (KEXEC_ON_CRASH flag set), segment data is
directly loaded to reserved memory and after crash kexec simply jumps
to starting point.

[..]
> .\" FIXME(kexec_file_load):
> .\" Is the following rationale accurate? Does it need expanding?
> The
> .BR kexec_file_load ()
> .\" See also http://lwn.net/Articles/603116/
> system call was added to provide support for systems
> where "kexec" loading should be restricted to
> only kernels that are signed.

Yes, this rationale looks good.

> 
> The
> .BR kexec_load ()
> system call is available only if the kernel was configured with
> .BR CONFIG_KEXEC .
> The
> .BR kexec_file_load ()
> system call is available only if the kernel was configured with
> .BR CONFIG_KEXEC_FILE .
> .\" FIXME(kexec_file_load):
> .\"     Does kexec_file_load() need any other CONFIG_* options to be defined?

Yes, it requires some other config options too.

depends on KEXEC
depends on X86_64
depends on CRYPTO=y
depends on CRYPTO_SHA256=y

CONFIG_KEXEC_VERIFY_SIG=y
CONFIG_KEXEC_BZIMAGE_VERIFY_SIG=y
CONFIG_SIGNED_PE_FILE_VERIFICATION=y
CONFIG_PKCS7_MESSAGE_PARSER=y
CONFIG_X509_CERTIFICATE_PARSER=y
CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y

So dependency list seems pretty long. Not sure how many of these should
we specify in man page.

Thanks
Vivek
