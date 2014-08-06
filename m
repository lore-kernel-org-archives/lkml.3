Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbaHFMVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:21:10 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52755 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637AbaHFMVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:21:07 -0400
Date: Wed, 6 Aug 2014 21:19:55 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: kerolasa@gmail.com
Cc: Karel Zak <kzak@redhat.com>, util-linux <util-linux@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] zramctl: allow use of --algorithm and --streams alone
Message-ID: <20140806121954.GA902@swordfish>
References: <1407107290-5806-1-git-send-email-kerolasa@iki.fi>
 <20140804115556.GA6923@x2.net.home>
 <CAG27Bk29oWnsjQDHJJmvENsr9ghcnq0soOFCx3fzEJ1SYMmfFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG27Bk29oWnsjQDHJJmvENsr9ghcnq0soOFCx3fzEJ1SYMmfFQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc Minchan Kim, Jerome Marchand, Nitin Gupta, linux-kernel

On (08/05/14 23:36), Sami Kerola wrote:
> On 4 August 2014 12:55, Karel Zak <kzak@redhat.com> wrote:
> > On Mon, Aug 04, 2014 at 12:08:10AM +0100, Sami Kerola wrote:
> >> Earlier the --algorithm and --streams had to be combined with --size.  To
> >> user requirement to combine with --size was indirectly told using
> >> following message.
> >
> > And is it really supported by kernel? I see in
> > Documentation/blockdev/zram.txt:
> >
> >  In order to enable compression backend's multi stream support
> >  max_comp_streams must be initially set to desired concurrency
> >  level before ZRAM device initialisation.
> >
> > I guess that when you set disksize the zram device is "locked" for
> > setting changes. It means that modify already initialized (created)
> > zram devices is impossible. You have to reset the device to "unlock"
> > the device setting.
> 
> After playing with zramctl I found out --algorithm must be set before
> --size

yes. historically, storing the `size' == full device initialisation.
I believe, it used to be so since the beginning of zram. compression
algorithm selection was just plugged in into the existing scheme of
things.

> The --streams can be set after --size, but not if device is in use.
> When device is in use none of the settings are allowed.

you can't change compression algorithm on initialised/being used
device. obviously. if zram has X pages compressed with lz0 then
zram is supposed to use lz0 for decompression.

'streams' options is a little bit tricky. we have two different
implementations for a single and multi stream backends. and there are
reasons for that, to keep it short.

if you create device with a single stream backend -- you can't change
it any more.
if you create device with a multi stream backend -- you can change the
number of streams (though, it doesn't make a lot of sense to set streams
to 1 in that case).

iow, you can downgrade from multi stream to a multi stream device with
only 1 stream (which is not identical to a single stream), but you can't
upgrade a single stream device to a multi stream device.

> $ ./zramctl
> NAME       ALGORITHM DISKSIZE DATA COMPR TOTAL STREAMS MOUNTPOINT
> /dev/zram0 lzo           100K   4K   76B    4K       2 [SWAP]
> /dev/zram2 lzo            44K   0B    0B    0B       1
> /dev/zram3 lzo             1M  40K  796B   40K       1 /mnt
> $ ./zramctl zram1
> NAME  ALGORITHM DISKSIZE DATA COMPR TOTAL STREAMS MOUNTPOINT
> zram1 lzo             0B   0B    0B    0B       1
> 
> $ ./zramctl --algorithm lz4 zram1 ; echo $?
> 0
> $ ./zramctl --algorithm lz4 zram2 ; echo $?
> zramctl: zram2: failed to set algorithm: Device or resource busy
> 1
> $ ./zramctl --algorithm lz4 zram3 ; echo $?
> zramctl: zram3: failed to set algorithm: Device or resource busy
> 1
> 
> $ ./zramctl --stream 2 zram1 ; echo $?
> 0
> $ ./zramctl --stream 2 zram2 ; echo $?
> 0
> $ ./zramctl --stream 2 zram3 ; echo $?
> zramctl: zram3: failed to set number of streams: Invalid argument
> 1
> 
> Whether the case --streams 2 zram2 in above example is correct or a
> bug is a question to kernel developers (Sergey is CC'd). Looking the
> commit message
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=fe8eb122c82b2049c460fc6df6e8583a2f935cff
> 
> the device behavior might be bug.
>

where?

	-ss
