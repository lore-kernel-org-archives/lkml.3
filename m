Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226AbbACPII (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2015 10:08:08 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:51288 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbbACPIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2015 10:08:04 -0500
MIME-Version: 1.0
In-Reply-To: <20141231194222.GB2897@blokker.redhat.com>
References: <54A22C76.9000403@gmail.com> <20141230084708.GG6081@sejong>
 <20141230090533.GH6081@sejong> <20141231194222.GB2897@blokker.redhat.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Sun, 4 Jan 2015 00:07:43 +0900
X-Google-Sender-Auth: yIJIqAUGj1DEiSOiCa-1RQ3Kj_w
Message-ID: <CAM9d7cjbMqC-f+f08wqatn__u9obXEdUyRRS9WYXrL0YA7to5Q@mail.gmail.com>
Subject: Re: perf-probe crash in dwarf_getcfi_elf
To: Mark Wielaard <mjw@redhat.com>
Cc: David Ahern <dsahern@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Thu, Jan 1, 2015 at 4:42 AM, Mark Wielaard <mjw@redhat.com> wrote:
> On Tue, Dec 30, 2014 at 06:05:33PM +0900, Namhyung Kim wrote:
>> And I found a related commit (5704c8c4fa71 "getcfi_scn_eh_frame: Don't
>> crash and burn when .eh_frame bits aren't there.") in elfutils that
>> can lead to a unexpected crash like this.  To safely use the function,
>> it needs to check the .eh_frame section is a PROGBITS type.
>
> Sorry about that bug. It was fixed in elfutils 0.156, released July 2013.
> Latest elfutils release is 0.161.
>
> Checking .eh_frame is SHT_PROGBITS (and not SHT_NOBITS) looks like the
> correct workaround if you have to deal with older elfutils releases.

Thanks for confirming this.

>
> Note that dwarf_getcfi_elf gets the CFI information from the .eh_frame
> section associated with the ELF file underlying the Dwarf dbg and needs
> to be released with a call to dwarf_cfi_end (). dwarf_getcfi () gets the
> CFI information from the .debug_frame section data of the Dwarf dbg
> and gets automatically releassed when dwarf_end () is called (you should
> not call dwarf_cfi_end () on the result).

Ah, it's good to know.  I have to check the code..

>
> If the Dwarf dbg handle is associated with a separate debuginfo file,
> then the .eh_frame section data will not be available (has SHT_NOBITS)
> and you can get the .eh_frame section (and call dwarf_getcfi_elf ()) on
> the original ELF file from which the Dwarf debuginfo file was split off.
>
> In your patch you call dwarf_getcfi () as backup to get some CFI
> information when you cannot call dwarf_getcfi_elf (). In general it
> might make sense to also do this when dwarf_getcfi_elf fails. Or try
> to get the CFI through both .eh_frame (from the executable ELF file)
> with dwarf_getcfi_elf () and .debug_frame (from the Dwarf dbg file)
> with dwarf_getcfi () and try to match an address in both tables
> if one or the other fails.

Thanks for your advice, I'll make a follow-up patch to address your comments.

Thanks,
Namhyung
