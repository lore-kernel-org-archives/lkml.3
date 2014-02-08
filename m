Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaBHIdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 03:33:33 -0500
Received: from mail-ob0-f177.google.com ([209.85.214.177]:41140 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbaBHIdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 03:33:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAMVG2suzT1vphjHAUFCsbVBsd22U69jzQaKVwnEyGLBu6eGOSw@mail.gmail.com>
References: <CAMVG2suzT1vphjHAUFCsbVBsd22U69jzQaKVwnEyGLBu6eGOSw@mail.gmail.com>
Date: Sat, 8 Feb 2014 03:33:31 -0500
X-Google-Sender-Auth: KlfC24sDMJjDPMFvkrz72QUpiYY
Message-ID: <CAKb7Uvh8jPNcXAfVYkdC3y0wQ7icc52Cid_fN5bpvdBf12KPag@mail.gmail.com>
Subject: Re: nouveau graphical corruption in 3.13.2
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Daniel J Blueman <daniel@quora.org>
Cc: "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 8, 2014 at 2:58 AM, Daniel J Blueman <daniel@quora.org> wrote:
> Hi guys,
>
> With a GeForce 320M GPU running linux 3.13.2 and Xorg 1.15.0, I'm
> seeing significant graphical corruption and later unrecoverable GPU
> lockup, accompanied by thousands of ILLEGAL_MTHD or related kernel
> messages [1]. I see similar issues on 3.12 also.
>
> Is there any debugging or testing I can do to help diagnose this?

Is this new? i.e. was there a kernel where it all worked well?

You get caught by the new disable logic in 3.13 that looks at a
register to figure out what engines have been disabled:

[    6.306005] nouveau W[    PCE0][0000:04:00.0] disabled, PCE0=1 to enable

Perhaps it's actually there and we have incorrect information about
the feature disable register -- you can force-enable it with
nouveau.config=PCE0=1 if you like. Although this logic is new in 3.13,
so if you also saw the issue in 3.12, that's probably not the cause.
(Also, the in-kernel logic falls back to M2MF, and so does the DDX,
and I don't see any usage in mesa, so even _if_ it's incorrectly
disabled, I doubt this would be your issue.)

Another thing that's new in 3.13 is MSI -- you can disable it with
nouveau.config=NvMSI=0.

There's only one currently-open bug about NVAF:
https://bugs.freedesktop.org/show_bug.cgi?id=60150 -- unfortunately
the bug filer wasn't very specific about the issues. But it might be
worth trying an ancient kernel (e.g. pre-3.7 -- there was a big
rewrite in 3.7, or even one of those 3.2-based franken-kernels that
distros maintained.) I suppose if you were to boot with
nouveau.noaccel=1 your problems would go away, but so would any 2d/3d
accel.

[   85.751375] nouveau E[   PFIFO][0000:04:00.0] DMA_PUSHER - ch 3
[Xorg[919]] get 0x0020022a4c put 0x0020023140 ib_get 0x00000391 ib_put
0x000003c2 state 0x8000e6a8 (err: INVALID_CMD) push 0x00400040

I've seen this kind of error before, on many different card types, and
have _no clue_ how it happens -- at no point is that command actually
written to the ring (I think). After that happens, it looks like
things get a little upset, and basically nothing works again. When
I've seen it before things tend to recover, but I guess they don't
have to.

I wouldn't be surprised if this was some sort of issue in the fifo
context switch code (which I'm most unfamiliar with, but others know
more). It has all sorts of chipset-specific stuff, and chances are
nvaf wasn't well-represented when all those were made. Assuming there
isn't an earlier working version of nouveau, one avenue is to do a
mmiotrace (https://wiki.ubuntu.com/X/MMIOTracing) of the blob starting
X and running e.g. glxgears. Then one would have to look at what
ctxprog it uploads and reconcile that with nouveau's somehow. (But
perhaps this is entirely wrong and nouveau's ctxprogs are fine.)

 -ilia
