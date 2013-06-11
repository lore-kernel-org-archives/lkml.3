Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3FKCRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 22:17:18 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:47801 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348Ab3FKCRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 22:17:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130611015149.GB4165@ZenIV.linux.org.uk>
References: <Pine.LNX.4.64.1306102137560.3200@boston.corp.fedex.com>
	<20130611015149.GB4165@ZenIV.linux.org.uk>
Date: Tue, 11 Jun 2013 10:17:16 +0800
Message-ID: <CAAJw_ZtqZrS8jVAiCTUc4GjXE0H1jghhM2K2QfN-WVORfpDwHg@mail.gmail.com>
Subject: Re: binfmt_misc broken
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 11, 2013 at 9:51 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:


> Patch is complete BS and I really wonder what kernel have you observed that bug on -
> with mainline on amd64 your example yields
> root@kvm-amd64:~# cat /proc/sys/fs/binfmt_misc/arm
> enabled
> interpreter /usr/bin/qemu-arm-static
> flags:
> offset 0
> magic 7f454c4601010100000000000000000002002800
> mask ffffffffffffff00fffffffffffffffffeffffff
>
> A reproducer, please...  As for the memcmp() Linus has suggested - it's !Magic case, i.e.
> what we are comparing there is not the file contents, it's the extension.  IOW, strcmp()
> is the right thing to use there - pathnames do not contain NULs in the middle...

BS ... yes, after testing it again, you may be right. Not intented, sorry.

I did another test with bash.

# bash -version
GNU bash, version 4.2.45(2)-release (x86_64-unknown-linux-gnu)

# echo ':arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-static:'
:arm:M::ELF(:ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿþÿÿÿ:/usr/bin/qemu-arm-static:

# echo ':arm:M::\\x7fELF\\x01\\x01\\x01\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x00\\x02\\x00\\x28\\x00:\\xff\\xff\\xff\\xff\\xff\\xff\\xff\\x00\\xff\\xff\\xff\\xff\\xff\\xff\\xff\\xff\\xfe\\xff\\xff\\xff:/usr/bin/qemu-arm-static:'
:arm:M::\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:/usr/bin/qemu-arm-static:

I supposed it's my bash configured with opt_xpg_echo=yes that's
sending in different data to the kernel.

Sending in the double-escape solved the problem. BS totally! My fault.

Thanks,
Jeff
