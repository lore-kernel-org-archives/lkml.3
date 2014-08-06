Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaHFUsh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 16:48:37 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:33877 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151AbaHFUsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 16:48:35 -0400
MIME-Version: 1.0
Reply-To: kerolasa@gmail.com
In-Reply-To: <20140806121954.GA902@swordfish>
References: <1407107290-5806-1-git-send-email-kerolasa@iki.fi>
	<20140804115556.GA6923@x2.net.home>
	<CAG27Bk29oWnsjQDHJJmvENsr9ghcnq0soOFCx3fzEJ1SYMmfFQ@mail.gmail.com>
	<20140806121954.GA902@swordfish>
Date: Wed, 6 Aug 2014 21:48:34 +0100
X-Google-Sender-Auth: rkU26P9RZfDFVO3t0MnmQikbXYo
Message-ID: <CAG27Bk24sUMQiL653y-HML7eBTdUBqSOPgT7t2MHFurqfeYpjQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] zramctl: allow use of --algorithm and --streams alone
From: Sami Kerola <kerolasa@iki.fi>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Karel Zak <kzak@redhat.com>, util-linux <util-linux@vger.kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 August 2014 13:19, Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> Cc Minchan Kim, Jerome Marchand, Nitin Gupta, linux-kernel
>
> On (08/05/14 23:36), Sami Kerola wrote:
>> On 4 August 2014 12:55, Karel Zak <kzak@redhat.com> wrote:
>> > On Mon, Aug 04, 2014 at 12:08:10AM +0100, Sami Kerola wrote:
>> >> Earlier the --algorithm and --streams had to be combined with --size.  To
>> >> user requirement to combine with --size was indirectly told using
>> >> following message.
>> >
>> > And is it really supported by kernel? I see in
>> > Documentation/blockdev/zram.txt:
>> >
>> >  In order to enable compression backend's multi stream support
>> >  max_comp_streams must be initially set to desired concurrency
>> >  level before ZRAM device initialisation.
>> >
>> > I guess that when you set disksize the zram device is "locked" for
>> > setting changes. It means that modify already initialized (created)
>> > zram devices is impossible. You have to reset the device to "unlock"
>> > the device setting.
>>
>> After playing with zramctl I found out --algorithm must be set before
>> --size
>
> yes. historically, storing the `size' == full device initialisation.
> I believe, it used to be so since the beginning of zram. compression
> algorithm selection was just plugged in into the existing scheme of
> things.
>
>> The --streams can be set after --size, but not if device is in use.
>> When device is in use none of the settings are allowed.
>
> you can't change compression algorithm on initialised/being used
> device. obviously. if zram has X pages compressed with lz0 then
> zram is supposed to use lz0 for decompression.

Hi Sergey, and the others,

I expected this to be the case.

> 'streams' options is a little bit tricky. we have two different
> implementations for a single and multi stream backends. and there are
> reasons for that, to keep it short.
>
> if you create device with a single stream backend -- you can't change
> it any more.
> if you create device with a multi stream backend -- you can change the
> number of streams (though, it doesn't make a lot of sense to set streams
> to 1 in that case).
>
> iow, you can downgrade from multi stream to a multi stream device with
> only 1 stream (which is not identical to a single stream), but you can't
> upgrade a single stream device to a multi stream device.

Thank you for explanation, I understand.  But as Karel mentioned in the
previous message the zramctl will be kept simple, at least for now, which
means support to change number of streams in cases when device is multi
streaming capable will not be present.  At least for now.

Secondly the few updates to zramctl I wrote couple days ago are now ready
for final review.  Most importantly the last one of the changes is
modified to be a message change.  It was earlier the patch 8/8 in first
message of this thread, that allowed algorithm and streams changes
without reset.  Now it this modest improvement.

https://github.com/kerolasa/lelux-utiliteetit/commit/ba7340bd093828feac127c09e8c36e01640f6dcb

And here are there reset.

The following changes since commit cd8414f7a13aca0b3ea150b473b83f00819b312f:

  cfdisk: move curs_set(1) to ui_end() (2014-08-06 15:39:27 +0200)

are available in the git repository at:

  git://github.com/kerolasa/lelux-utiliteetit.git zram

for you to fetch changes up to ba7340bd093828feac127c09e8c36e01640f6dcb:

  zramctl: improve option combination error messaging (2014-08-06
20:46:23 +0100)

----------------------------------------------------------------
Sami Kerola (7):
      docs: add details to zramctl --size option documentation
      zramctl: mark --reset mutually exclusive with --algorithm and --streams
      zramctl: fail status printout when device does not exist
      zramctl: improve error message
      zramctl: fix mount point printout
      zramctl: add bash completion script
      zramctl: improve option combination error messaging

 bash-completion/Makemodule.am |  3 +++
 bash-completion/zramctl       | 51
+++++++++++++++++++++++++++++++++++++++++++++++++++
 sys-utils/zramctl.8           | 11 +++++++++--
 sys-utils/zramctl.c           | 37 +++++++++++++++++++++++--------------
 4 files changed, 86 insertions(+), 16 deletions(-)
 create mode 100644 bash-completion/zramctl

>> $ ./zramctl
>> NAME       ALGORITHM DISKSIZE DATA COMPR TOTAL STREAMS MOUNTPOINT
>> /dev/zram0 lzo           100K   4K   76B    4K       2 [SWAP]
>> /dev/zram2 lzo            44K   0B    0B    0B       1
>> /dev/zram3 lzo             1M  40K  796B   40K       1 /mnt
>> $ ./zramctl zram1
>> NAME  ALGORITHM DISKSIZE DATA COMPR TOTAL STREAMS MOUNTPOINT
>> zram1 lzo             0B   0B    0B    0B       1
>>
>> $ ./zramctl --algorithm lz4 zram1 ; echo $?
>> 0
>> $ ./zramctl --algorithm lz4 zram2 ; echo $?
>> zramctl: zram2: failed to set algorithm: Device or resource busy
>> 1
>> $ ./zramctl --algorithm lz4 zram3 ; echo $?
>> zramctl: zram3: failed to set algorithm: Device or resource busy
>> 1
>>
>> $ ./zramctl --stream 2 zram1 ; echo $?
>> 0
>> $ ./zramctl --stream 2 zram2 ; echo $?
>> 0
>> $ ./zramctl --stream 2 zram3 ; echo $?
>> zramctl: zram3: failed to set number of streams: Invalid argument
>> 1
>>
>> Whether the case --streams 2 zram2 in above example is correct or a
>> bug is a question to kernel developers (Sergey is CC'd). Looking the
>> commit message
>>
>> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=fe8eb122c82b2049c460fc6df6e8583a2f935cff
>>
>> the device behavior might be bug.
>
> where?

Reading your earlier message it is now clear to me the there never was
a bug, but just lack of understanding how the zram is meant to work.

-- 
Sami Kerola
http://www.iki.fi/kerolasa/
