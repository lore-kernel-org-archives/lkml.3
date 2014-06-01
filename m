Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaFAT5t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 15:57:49 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:61968 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217AbaFAT5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 15:57:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        joseph@codesourcery.com, john.stultz@linaro.org, hch@infradead.org,
        tglx@linutronix.de, geert@linux-m68k.org, lftan@altera.com,
        linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [RFC 11/32] xfs: convert to struct inode_time
Date: Sun, 01 Jun 2014 21:56:52 +0200
Message-ID: <8618458.1EVJCoVbkH@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <alpine.LFD.2.11.1405311055410.17310@knanqh.ubzr>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de> <538995D4.9050702@zytor.com> <alpine.LFD.2.11.1405311055410.17310@knanqh.ubzr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:4EClS3nPPd0d++b1ODxeO+nue5a4n8U2xcvaEsTpM51
 NNbYoUfHVjRI6n4HBWZqxU9H//A6zAFdkYD2eKWYx2Dax/tymJ
 Kzze8TDMyf1leACVKpS0iONSBU6cAjlM7l2wxv/9iV+KfBlc6F
 xuJ5mCmCYaLyAEtpBO4LGdzEsFFPPFf0nGKcrp8sksRP5ILUnX
 aBtQxbqN7Aq5wK4tSn7w7379PkbWh0C5KuQ6VpmFi0RTGgQ3QD
 2grRWjtH/IWVcrdqniFi9jH5Mw6oHw7tPfBvleJSkjgGRn9Sil
 r5+0GS2uNXIhe8qAwbshMOSVjnvwTg7l0+QUXBsqO9ukleQT4A
 uAjckdDxmUoLUe6/1yMo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 31 May 2014 11:46:16 Nicolas Pitre wrote:
> > readonly if not in reality than in practice.
> 
> For those (legacy) filesystems with a signed 32-bit timestamps, any 
> attempt to create a timestamp past Jan 19 03:14:06 2038 UTC should be 
> (silently) clamped to 0x7fffffff and that value (the last representable 
> time) used as an overflow indicator.  The filesystem driver should 
> convert that value into a corresponding overflow value for whatever 
> kernel internal time representation being used when read back, and this 
> should be propagated up to user space.  It should not be a hard error 
> otherwise, as you rightfully stated, everything non read-only would come 
> to a halt on that day.

I don't think there is much of a difference between not being able to
write at all and all newly written files having the same timestamp,
causing random things to break differently.

The clamp to the maximum supported time stamp sounds like a reasonable
choice for 'utimens' and related syscalls for the case of someone
setting an arbitrary future date beyond what the file system can
represent. Then again, I don't see a reason why that shouldn't just
cause an error to be returned.

For actually running kernels beyond 2038, the best idea I've seen so
far is to disallow all broken code at compile time. I don't see
a choice but to audit the entire kernel for invalid uses on both
32 and 64 bit in the next few years. A lot of code will get changed
in the process so we can actually keep running 32-bit kernels and
file systems, but other code will likely go away:

* any system calls that pass a time_t, timeval or timespec on
  32-bit systems return -ENOSYS, to ensure all user land uses
  the replacements we will put into place
* The definition of 'time_t', 'timval' and 'timespec' can be hidden
  from the kernel, and all code using it left out.
* ext2 and ext3 file system code will have to be disabled, but that's
  file since ext4 can mount old file systems.
* until xfs gets extended, we can also disiable it at build time.

For most users, we probably want to leave all that enabled by
default until we get much closer to 2038, but a compile time
option should allow us to test what works or doesn't, and it
can be set by embedded developers that want to ensure their
code keeps running for the next few decades.

	Arnd


