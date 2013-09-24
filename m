Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754096Ab3IXTmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 15:42:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091Ab3IXTmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 15:42:09 -0400
Date: Wed, 25 Sep 2013 01:11:54 +0530 (IST)
From: P J P <ppandit@redhat.com>
X-X-Sender: pjp@dhcp193-39.pnq.redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Export initial ramdisk compression config
In-Reply-To: <20130923125256.e53b51a137a19a972c6026a2@linux-foundation.org>
Message-ID: <alpine.LFD.2.03.1309250035480.5312@erqung.pbz>
References: <alpine.LFD.2.03.1309151434580.7830@erqung.pbz> <20130923125256.e53b51a137a19a972c6026a2@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

   Hello Andrew,

Thank you so much for reviewing these patches.

+-- On Mon, 23 Sep 2013, Andrew Morton wrote --+
| It's a bit confusing whether all this appiles to initrd, to initramfs
| or to both.  Can you please clarify all this and be sure that it's all
| consistent?

  IIUC, we no longer use initrd block device images. Instead we use initramfs 
which is a cpio(1) archive image. Both mkinitrd(8) & dracut(8) are invoked 
from /sbin/new-kernel-pkg tool. And mkinitrd(8) is nothing but a wrapper 
around dracut(8) these days.
===
  $ man mkinitrd
       mkinitrd - is a compat wrapper, which calls dracut to generate an
       initramfs

  $ less /sbin/new-kernel-pkg     # my local patched version
...
doMkinitrd() {
    if [ -n "$dracut" ]; then
+       if [ -n "$INITRD_COMPRESS" ]; then
+           dracutcompress=--$INITRD_COMPRESS
+       fi
+       tool="dracut $dracuthostonly -f $dracutcompress $initrdfile $version"
    else
        tool="mkinitrd --allow-missing -f $initrdfile $version"
    fi
    [ -n "$verbose" ] && echo "creating initrd: $tool"
    $tool
    rc=$?
    if [ $rc != 0 ]; then
        echo "mkinitrd failed" >&2
        exit 1
    fi
}
===

Because mkinitrd(8) does not support passing of compression argument to 
dracut(8), it must use the default compression, ie. gzip(1).


| A few things...
| - Why is it specific to x86?  Other architcetures use initramfs?

  No, it is not specific to x86, most likely all architecturess' Makefile 
would need similar patch. But I haven't looked into those yet.
 
| - People add new compression schemes fairly regularly.  We should add
|   a code comment somewhere in a place where such people are sure to
|   find it.  That comment should explain what's going on, remind them to
|   update this environment varlaible and should explain to them the
|   process by which they get dracut(8) updated if needed.

  True. Maybe user/Kconfig could have a note about updating INITRD_COMPRESS 
environment variable through a relevant $arch/Makefile ? 

Looking at the dracut(8) tool, it seems it can easily support any number of 
compression tools, for it already has options --gzip, --bzip2, --xz & --lzma.
Adding --lzo, --lz4 etc won't be much difficult.

| - Can we avoid having to update dracut each time a new compression
|   scheme is added?  I assume your dracut changes will just exec
|   "$INITRD_COMPRESS -d", so as long as any new decompression
|   application uses the expected -d argument in the expected way, it
|   should work seamlessly?

  Yes, dracut(8) has | --compress=$INITRD_COMPRESS | option which could be 
used to pass compression program to dracut(8). Not sure if dracut(8) expects 
an absolute path or just the program name. But to use this option, we'll need 
to patch /sbin/new-kernel-pkg tool.

Alternatively, dracut(8) could be patched to recognise and read 
$INITRD_COMPRESS variable and internally it can define precedence order 
between environment variable, command-line options and default fall-back 
option.


Thank you.
--
Prasad J Pandit / Red Hat Security Response Team
DB7A 84C5 D3F9 7CD1 B5EB  C939 D048 7860 3655 602B
