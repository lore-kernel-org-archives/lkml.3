Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936120Ab3DPUAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:00:39 -0400
Received: from mail-vb0-f42.google.com ([209.85.212.42]:38963 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935189Ab3DPUAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:00:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAJfpegt53MRwiMgZTW2DogMWAR54vrPMG=D5Yqs_vpfccPi_5Q@mail.gmail.com>
References: <1366058481-21033-1-git-send-email-ccross@android.com>
	<CAMbhsRT08Li=P0GnbW-XdwyDSFtOfbr2MiTLeh-DduMOx-g=zw@mail.gmail.com>
	<CAJfpegtJW+k6gLZ+jxJKp3Zj0UhCst3WD7N_xrybD59_0o7h5Q@mail.gmail.com>
	<CA+55aFzUFMOAfxBpsGLYW3R5NA+f+LWCcKoGdizh_PAhQiXDvg@mail.gmail.com>
	<CAJfpegtJrkii6LRxfoywyXsVtnBAgO4ZzBZOPd71BMz7evhPcQ@mail.gmail.com>
	<CA+55aFzA66RHjB2KsdCCbEf2NNBnO=-o_rAJ-xZ3sqY1mHoCRA@mail.gmail.com>
	<CAMbhsRSsd_zRApscGK5cUqR=ykuvEWA-DCMAXC1raWPtcuk4Dw@mail.gmail.com>
	<CAJfpegt53MRwiMgZTW2DogMWAR54vrPMG=D5Yqs_vpfccPi_5Q@mail.gmail.com>
Date: Tue, 16 Apr 2013 13:00:37 -0700
X-Google-Sender-Auth: PPBgEPuMn_mhZ3s-jvyL7jhtJ6c
Message-ID: <CAMbhsRR7iWabAgMqJ8g6FJK+SMAf_s0Rrz+wHiODzoB6joAzCw@mail.gmail.com>
Subject: Re: [PATCH] fuse: use kernel headers when __KERNEL__ is set
From: Colin Cross <ccross@android.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "open list:FUSE: FILESYSTEM..." <fuse-devel@lists.sourceforge.net>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 12:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Tue, Apr 16, 2013 at 8:29 PM, Colin Cross <ccross@android.com> wrote:
>> Dropping __linux__ causes a make headers_check warning, which the
>> kbuild test robot reported this morning:
>> usr/include/linux/fuse.h:99: found __[us]{8,16,32,64} type without
>> #include <linux/types.h>
>> Using my patch without modification does not cause that warning.
>>
>> linux/types.h defines the types that are used to communicate between
>> the kernel and userspace.  Redefining those in each header makes no
>> sense, and will probably cause redefined types warnings if you compile
>> a userspace file that includes fuse.h and another uapi header that
>> properly includes linux/types.h.
>
> <linux/types.h> is linux specific while the fuse API is cross
> platform.  So the userspace header obviously has to use some cross
> platform type definitions.  Making the type definitions depend on
> __linux__ is probably just as unreliable in userspace as it is in the
> kernel, so why complicate things with that?

I'm not sure what you mean by __linux__ being unreliable, it is set by
any toolchain that is compield with linux as its target.  It should be
very reliable in userspace, its only unreliable in the kernel because
the kernel doesn't rely on any specific os target in the toolchain, it
is self contained.

With your change, compiling a program that includes linux/fuse.h and
linux/icmp.h against the headers installed by make headers_installed
results in some strange preprocessor results.  The lines in
int-ll64.h, which is what normally defines the userspace types, are:
typedef __signed__ char __s8;
typedef unsigned char __u8;

typedef __signed__ short __s16;
typedef unsigned short __u16;

typedef __signed__ int __s32;
typedef unsigned int __u32;

After preprocessing with your fuse.h included before icmp.h (which
includes linux/types.h, which eventually includes
asm-generic/int-ll64.h):
typedef __signed__ char __s8;
typedef unsigned char __u8;

typedef __signed__ short __s16;
typedef unsigned short uint16_t;

typedef __signed__ int int32_t;
typedef unsigned int uint32_t;

The first three lines are the kernel headers providing typedefs for
the types that are not used in fuse.h, and therefore not covered by
the #define hacks there.  The last three lines are a problem: now you
have redefined the stdint types to match the kernel's types, better
hope they match the host's stdint definitions or you'll get redefined
type warnings.

Every other uapi header includes linux/types.h to get its type
definitions, and fuse.h should do the same when compiling for
userspace targeting linux or when compiling the kernel.
